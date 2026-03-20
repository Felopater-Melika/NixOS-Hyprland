# New Machine Install Guide

This repo is no longer in a state where `./install.sh` is the right way to install it on a fresh system. Use the steps below instead.

## What This Guide Assumes

- You are installing from a recent NixOS installer ISO with networking working.
- You want a single-disk GPT layout.
- You want EFI + Btrfs using the existing [`disko/aetherion-btrfs.nix`](/C:/Users/philo/Downloads/nix/disko/aetherion-btrfs.nix) layout.
- You are installing onto an Nvidia desktop, including RTX 5080-class hardware.

## Current Disk Layout

The active Btrfs disko layout creates:

- `ESP` mounted at `/boot`
- a Btrfs root filesystem labeled `nixos`
- subvolumes for `/`, `/home`, `/nix`, and `/var/log`

The disk device is not hardcoded in the disko file. It is passed in from [`hosts/aetherion/config.nix`](/C:/Users/philo/Downloads/nix/hosts/aetherion/config.nix) through [`hosts/aetherion/variables.nix`](/C:/Users/philo/Downloads/nix/hosts/aetherion/variables.nix), where `installDisk` is currently `"/dev/disk/by-id/CHANGE-ME"`.

## 1. Boot The Installer

Boot the NixOS installer in UEFI mode, get a shell, and make sure the network is up.

Useful checks:

```bash
ip a
ping -c 3 cache.nixos.org
ls /dev/disk/by-id
```

If your target drive is an NVMe disk, prefer its `/dev/disk/by-id/...` path instead of `/dev/nvme0n1`.

## 2. Clone The Repo Into The Live Environment

```bash
nix-shell -p git
git clone https://github.com/<your-user>/<your-repo>.git /tmp/nix-config
cd /tmp/nix-config
```

If this machine will replace `aetherion`, you can reuse that host directory.

If this machine should get a new hostname, copy the host first:

```bash
cp -r hosts/aetherion hosts/<new-hostname>
```

Then update `host = "aetherion";` in [`flake.nix`](/C:/Users/philo/Downloads/nix/flake.nix) to your new host name.

## 3. Update The Host Variables Before Formatting Anything

Edit [`hosts/aetherion/variables.nix`](/C:/Users/philo/Downloads/nix/hosts/aetherion/variables.nix) or the copied host equivalent and set:

- `hostname`
- `username`
- `installDisk`
- `configDirectory`
- `gitUsername`
- `gitEmail`

Minimum required change example:

```nix
rec {
  hostname = "newbox";
  username = "philo";
  configDirectory = "/home/${username}/nix";
  installDisk = "/dev/disk/by-id/nvme-SERIAL_HERE";
}
```

If you created a new host directory, also update the host import target in [`flake.nix`](/C:/Users/philo/Downloads/nix/flake.nix).

## 4. Generate Hardware Config For The New Machine

Generate a fresh hardware file for the target host before installation:

```bash
nixos-generate-config --show-hardware-config > hosts/aetherion/hardware.nix
```

If you made a new host:

```bash
nixos-generate-config --show-hardware-config > hosts/<new-hostname>/hardware.nix
```

Do not reuse the old machine’s hardware file on the new system.

## 5. Review The Disko Layout

The current Btrfs layout in [`disko/aetherion-btrfs.nix`](/C:/Users/philo/Downloads/nix/disko/aetherion-btrfs.nix) does this:

```text
disk
├─ ESP      1 MiB -> 1025 MiB   vfat   mounted at /boot
└─ root     rest of disk        btrfs  label=nixos
   ├─ /root     -> /
   ├─ /home     -> /home
   ├─ /nix      -> /nix
   └─ /var/log  -> /var/log
```

If you want extra subvolumes like `/persist`, `/var/lib`, or `/swap`, add them now before running disko.

## 6. Run Disko

This step destroys the target disk contents. Triple-check `installDisk` first.

The official disko quickstart supports running it directly from the upstream flake with:

```bash
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- \
  --mode destroy,format,mount ./disko/aetherion-btrfs.nix \
  --arg device '"/dev/disk/by-id/YOUR-DISK-ID"'
```

If you created a different disko file, substitute that path.

After it finishes:

```bash
mount | grep ' on /mnt'
findmnt /mnt
```

You should see `/mnt`, `/mnt/home`, `/mnt/nix`, `/mnt/var/log`, and `/mnt/boot`.

Source used for the command pattern: [nix-community/disko README](https://github.com/nix-community/disko).

## 7. Copy The Repo Into The Target System

```bash
mkdir -p /mnt/etc/nixos
cp -a /tmp/nix-config/. /mnt/etc/nixos/
cd /mnt/etc/nixos
```

If you prefer to install from a clean git checkout inside `/mnt/etc/nixos`, that works too.

## 8. Install NixOS From The Flake

If you are reusing `aetherion`:

```bash
nixos-install --root /mnt --flake .#aetherion
```

If you created a new host:

```bash
nixos-install --root /mnt --flake .#<new-hostname>
```

If the build is RAM-constrained, cap parallelism:

```bash
nixos-install --root /mnt --flake .#aetherion --option max-jobs 4
```

## 9. Reboot

```bash
reboot
```

Then pick the normal generated NixOS entry from GRUB. Do not rely on any custom fallback entry.

## 10. First Boot Checklist

- Log into SDDM
- Expect `xfce` to be the default session unless you change it
- Select `Hyprland` or `Niri` manually if you want to test those first
- Run `nixos-rebuild switch --flake /home/philo/nix#<host>` after any immediate fixes

## Compositor Notes For The New Nvidia Machine

- Hyprland now ships the repo’s `configs/hypr` directory through Home Manager, so a fresh install no longer depends on missing local files.
- The placeholder files `Monitors.conf`, `ENVariables.conf`, `WorkspaceRules.conf`, and `themes/mocha.conf` are intentionally present so Hyprland can start cleanly on a new machine.
- Niri no longer hardcodes the old laptop outputs (`eDP-1` and `HDMI-A-1`), so it will let the new machine’s outputs auto-detect.
- The shared Home Manager Wayland env no longer forces old wlroots Nvidia workarounds such as `WLR_DRM_NO_ATOMIC=1`.

## If You Want To Tune Btrfs Further

Common follow-up changes:

- Add a `/persist` subvolume if you want an impermanence-style layout
- Split `/var/lib` into its own subvolume if large services will live there
- Add `compress-force=zstd:3` if you want more aggressive compression
- Add a swap partition or swapfile if you want hibernation later

Right now your config explicitly disables hibernation in the kernel params, so the current Btrfs layout does not need swap to match the active boot configuration.
