{ config, pkgs, ... }:

let

  globalSettings = {
    email = "jacob@z-tech.org";
    username = "rizoid";
    systemUsername = "riz";
  };

in {

  nixpkgs.config.packageOverrides = {
    unstable = import <unstable> {};
  };

  users.users."${globalSettings.systemUsername}" = {
    uid          = 1337;
    isNormalUser = true;
    extraGroups  = [ "wheel" "docker" "systemd-journal" "audio" ];
    shell        = "/home/${globalSettings.systemUsername}/.nix-profile/bin/zsh";
  };

  home-manager = {
    useUserPackages = false;
    users."${globalSettings.systemUsername}" = { config, pkgs, ... }: {
      nixpkgs = {
        config.allowUnfree = true;
      };

      home = {
        extraOutputsToInstall = [ "doc" "info" "devdoc" ];
        username = globalSettings.systemUsername;
        packages = with pkgs; [
          # binutils
          fd
          wget
          curl
          gitAndTools.git-crypt
          neofetch
          gotop
          pciutils
          stress

          # net
          wavemon
          kismet

          # "system"
          htop
          gnome3.nautilus
          dmenu

          # media
          pavucontrol

          # fonts
          iosevka
          mononoki
          postgresql

          # theming
          pywal
          wpgtk
          dconf
          hicolor-icon-theme

          # graphics
          glxinfo
          lxappearance

          # for the lockscreen
          sox
          font-awesome_5
        ];

        sessionVariables = {
          EDITOR = "emacs";
          VISUAL = "emacs";
        };
      };

      # management of xdg base directories
      xdg = {
        enable = true;

        userDirs = {
          enable    = true;
          desktop   = "Desktop";
          documents = "Documents";
          download  = "Downloads";
          music     = "Music";
          pictures  = "Images";
          videos    = "Videos";
        };
      };

      manual = {
        html.enable     = true;
        manpages.enable = true;
        json.enable     = true;
      };

      news.display = "silent";

      gtk = {
        enable = true;

        theme = {
          name = "McMojave";
          package = pkgs.paper-gtk-theme;
        };

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.pantheon.elementary-icon-theme;
          # package = pkgs.mate.mate-icon-theme;
        };

        gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
      };

      programs = {
        bat.enable    = true;
        info.enable   = true;
        direnv.enable = true;
        feh.enable    = true;
        emacs.enable  = true;

        firefox = {
          enable = true;

          # to fix a issue where releasing mouse2 instantly clicks the context menu
          profiles."${globalSettings.systemUsername}".userChrome = ''
          #contentAreaContextMenu{ margin: 2px 0 0 2px }
          '';
        };

        kitty = {
          enable = true;
          font = {
            name = "PragmataPro Mono";
            # package = pkgs.iosevka;
          };

          settings = {
            window_padding_width = 12;
            font_size = "14.0";
            background_opacity = "0.75";
          };

          extraConfig = "include ~/.cache/wal/colors-kitty.conf";
        };

        command-not-found = { enable = true; };

        rofi = {
          enable = true;
          theme  = "~/.cache/wal/colors-rofi-dark.rasi";
          font   = "PragmataPro Mono 20";
        };

        keychain = {
          enable = true;
          keys   = [ "id_rsa" ];
          agents = [ "gpg" "ssh" ];
        };

        git = {
          package   = pkgs.gitAndTools.gitFull;
          enable    = true;
          userEmail = "jacob@z-tech.org";
          userName  = "riz0id";
        };

        gpg = { enable = true; };

        htop = {
          enable = true;
          hideThreads = true;
          hideUserlandThreads = true;
          highlightBaseName = true;
          showProgramPath = false;
          treeView = true;
          meters = {
            left = [ "Tasks" "LoadAverage" "Blank" "CPU" "Memory" "Swap" ];
            right = [ ];
          };
        };

        zsh = {
          enable       = true;

          history = {
            save = 100000;
            size = 100000;
          };

          oh-my-zsh = {
            enable  = true;
            plugins = [ "sudo" ];
            theme   = "steeef";
          };

          initExtra = ''
            source ~/.cache/wal/colors.sh
          '';
        };
      };

      services = {
        udiskie.enable = true;

        redshift = {
          enable    = true;
          latitude  = "32";
          longitude = "97";

          brightness = {
            day   = "0.5";
            night = "1.0";
          };
        };

        polybar = {
          enable = true;
          extraConfig = import ./apps/polybar.nix { inherit pkgs; };
          package = pkgs.polybar.override { mpdSupport = true; };
          script = ''
            source ~/.cache/wal/colors.sh
            export bg_opacity="bf"
            export border_opacity="22"
            export polybar_background="#''${bg_opacity}''${color0/'#'}"
            export polybar_border="#''${border_opacity}''${color0/'#'}"
            polybar top &
            polybar bottom &
          '';
        };

        picom = let
          shadowRadius = 15;
          shadowOffset = -1 * shadowRadius;
          picom-ibhagwan = pkgs.callPackage ../../overrides/picom-ibhagwan.nix { };
        in {
          enable = true;
          package = picom-ibhagwan;
          backend = "glx";
          experimentalBackends = true;
          extraOptions = ''
            blur: {
              method = "dual_kawase";
              strength = 8;
              background = false;
              background-frame = false;
              background-fixed = false;
            }
            shadow-radius: ${builtins.toString shadowRadius};
            # (disabled) slightly rounded corners
            # corner-radius: 10.0;
          '';
          fade = true;
          vSync = true;

          shadow = false;
          shadowOpacity = "0.6";
          noDNDShadow = true;
          noDockShadow = true;
          shadowOffsets = [ shadowOffset shadowOffset ];
          fadeDelta = 3;
          fadeSteps = [ "0.04" "0.04" ];
          # inactiveDim = "0.10";
        };

      };

      xsession = {
        enable         = true;
        numlock.enable = true;
        initExtra      = "wal -R";

        pointerCursor = {
          name    = "capitaine-cursors-white";
          package = pkgs.capitaine-cursors;
          size    = 24;
        };

        windowManager.xmonad = {
          enable                 = true;
          enableContribAndExtras = true;
        };
      };
    };
  };
}
