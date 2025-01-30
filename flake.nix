{
  description = "MaotseNyein NixOS-Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
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
    matugen = {
      url = "github:/InioX/Matugen";
    };

    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
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
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    hyprscroller = {
      url = "github:maotseantonio/hyprscroller-flake";
      inputs.hyprland.follows = "hyprland";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
    };
    textfox.url = "github:maotseantonio/textfox";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    stylix.url = "github:danth/stylix";
    wezterm.url = "github:wez/wezterm?dir=nix";
    # zen-browser.url = "github:MarceColl/zen-browser-flake";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nyxexprs.url = "github:notashelf/nyxexprs";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nvchad4nix = {
      url = "github:MOIS3Y/nvchad4nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad-on-steroids = {
      # <- here
      url = "github:maotseantonio/nvchad_config";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
    nh.url = "github:viperML/nh";
    nur.url = "github:nix-community/NUR";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darkmatter-grub-theme = {
      url = "gitlab:Felopater-Melika/darkmatter-grub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    hy3,
    chaotic,
    kubenix,
    darkmatter-grub-theme,
    treefmt-nix,
    git-hooks,
    for-all-systems,
    nix-github-actions,
    lix-module,
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
          ./hosts/${host}/config.nix
          inputs.spicetify-nix.nixosModules.default
          inputs.chaotic.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          darkmatter-grub-theme.nixosModule
          inputs.catppuccin.nixosModules.catppuccin
          lix-module.nixosModules.default
          {
            nixpkgs.overlays = [
              inputs.hyprpanel.overlay
              (final: prev: {
                nvchad = inputs.nvchad4nix.packages."${pkgs.system}".nvchad;
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
