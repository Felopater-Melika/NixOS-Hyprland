{
  description = "MaotseNyein NixOS-Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nix = {
      url = "github:NixOS/nix/2.28.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    anyrun.url = "github:fufexan/anyrun/launch-prefix";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm.url = "github:wezterm/wezterm?dir=nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin.url = "github:catppuccin/nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-anywhere = {
      url = "github:numtide/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi.url = "github:sxyazi/yazi";
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal-bar = {
      url = "github:linuxmobile/astal-bar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprland.url = "github:hyprwm/Hyprland?submodules=1";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh.url = "github:viperML/nh";
    nur.url = "github:nix-community/NUR";
    zjstatus = {
      url = "github:dj95/zjstatus";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    for-all-systems = {
      url = "github:Industrial/for-all-systems";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kubenix = {
      url = "github:hall/kubenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    chaotic,
    treefmt-nix,
    git-hooks,
    for-all-systems,
    nix-github-actions,
    zjstatus,
    nixos-hardware,
    ...
  }: let
    system = "x86_64-linux";
    host = "aetherion";
    username = "philo";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Helper function to apply configurations to all systems.
    systems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = inputs.for-all-systems.forAllSystems {
      nixpkgs = inputs.nixpkgs;
      inherit systems;
    };

    # Pre-commit configuration
    preCommitCheck = forAllSystems ({system, ...}:
      inputs.git-hooks.lib.${system}.run {
        src = ./..;
        hooks = {
          # Specific hooks for pre-commit
          check-toml.enable = true;
          taplo.enable = true;
          detect-aws-credentials.enable = true;
          trim-trailing-whitespace.enable = true;
          format-and-check = {
            enable = true;
            name = "Fmt and Check";
            entry = "nix fmt && nix flake check";
            pass_filenames = false;
            stages = ["pre-commit"];
          };
        };
      });

    treefmtEval = forAllSystems ({pkgs, ...}:
      inputs.treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          alejandra.enable = true;
          actionlint.enable = true;
          beautysh.enable = true;
          yamlfmt.enable = true;
        };
      });
  in {
    nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit username;
          inherit host;
          inherit chaotic;
        };
        modules = [
          inputs.disko.nixosModules.disko
          ./hosts/${host}/config.nix
          inputs.spicetify-nix.nixosModules.default
          inputs.chaotic.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.catppuccin.nixosModules.catppuccin
          {
            nixpkgs.overlays = [
              inputs.hyprpanel.overlay
              inputs.niri.overlays.niri
              inputs.nur.overlays.default
              (final: prev: {
                stable = import nixpkgs-stable {
                  config.allowUnfree = true;
                  config.nvidia.acceptLicense = true;
                };
                zjstatus = inputs.zjstatus.packages."${pkgs.system}".default;
              })
            ];
          }
        ];
      };
    };

    # Add devShells with pre-commit and treefmt setup
    devShells = forAllSystems ({
      pkgs,
      system,
      ...
    }: {
      default = pkgs.mkShell {
        shellHook = preCommitCheck.${system}.shellHook;
        buildInputs = preCommitCheck.${system}.enabledPackages;
        packages = with pkgs; [
          direnv
          jq
          pre-commit
        ];
      };
    });

    # Add formatter using treefmt
    formatter =
      forAllSystems ({system, ...}:
        treefmtEval.${system}.config.build.wrapper);

    # GitHub Actions (optional)
    githubActions = let
      supportedSystems = ["x86_64-linux"];
    in
      inputs.nix-github-actions.lib.mkGithubMatrix {
        checks = inputs.nixpkgs.lib.getAttrs supportedSystems self.checks;
      };

    # Add flake checks for formatting
    checks = forAllSystems ({system, ...}: {
      formatting = treefmtEval.${system}.config.build.check self;
    });
  };
}
