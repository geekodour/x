{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
  h = "/home/zuck";
  x = "/home/zuck/x";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  programs.fish.enable = true; # need to enable it outside of hm aswell
  #xdg.portal.wlr.enable = true; # screen share, disabled for now because causes startup slow
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.zuck = {pkgs, ... }: {
      home.stateVersion = "23.05";

      # various configs from arch
      home.file.".config/git".source = "${x}/.config/git/";
      home.file.".config/waybar".source = "${x}/.config/waybar/";
      home.file.".config/sway/config".source = "${x}/.config/sway/config_for_hq";
      home.file.".config/alacritty".source = "${x}/.config/alacritty";
      home.file.".config/nvim".source = "${x}/.config/nvim";
      home.file.".config/wofi".source = "${x}/.config/wofi";
      home.file.".config/zoxide".source = "${x}/.config/zoxide";
      home.file.".config/nnn/init".source = "${x}/.config/nnn/init";
      home.file.".config/starship".source = "${x}/.config/starship";
      home.file.".config/doom".source = "${x}/.config/doom";
      home.file.".tmux.conf".source = "${x}/.tmux.conf";


      # cursor
      home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
      # home.pointerCursor = 
      #   let 
      #   getFrom = url: hash: name: {
      #     gtk.enable = true;
      #     x11.enable = true;
      #     name = name;
      #     size = 48;
      #     package = 
      #       pkgs.runCommand "moveUp" {} ''
      #       mkdir -p $out/share/icons
      #       ln -s ${pkgs.fetchzip {
      #         url = url;
      #       }} $out/share/icons/${name}
      #     '';
      #   };
      # in
      #   getFrom 
      #   "https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2"
      #   "Phinger";

      # fish
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          keychain --eval --quiet --quick --nogui ${h}/.ssh/id_ed25519 | source
          source ~/.config/nnn/init # nnn
          source ~/.config/starship/init # starship
          source ~/.config/zoxide/init # zoxide
          alias cd z
          if test (tty) = /dev/tty1
              sway --unsupported-gpu
          end
        ''; 
      };
      home.file.".config/fish/functions".source = "${x}/.config/fish/functions";
      home.file.".config/fish/conf.d/gitaliases.fish".source = "${x}/.config/fish/conf.d/gitaliases.fish";

      programs.firefox = {
        enable = true;
        package = pkgs.firefox.override {
          cfg = { enableTridactylNative = true; };
        };
      };

      programs.direnv = {
        enable = true;
        nix-direnv= {
          enable = true;
        };
      };

      programs.emacs = {
        enable = true;
      };

      # packages
      home.packages = with pkgs; [
          tmux
          sway
          alacritty
          fzf
          gtk3
          nnn
          fd
          mpv
          wdisplays

          # misc
          bat
          ffmpeg
          handbrake
          feh
          exa
          zoxide
          catimg
          telegram-desktop
          chafa
          glow
          imv
          mediainfo
          neofetch
          pandoc
          onefetch
          cpufetch
          gomi
          pdfarranger
          starship
          trash-cli
          sysz
          grim
          maim
          slurp
          swappy
          unzip
          anki-bin
          libsForQt5.okular
          eva
          gfold
          entr
          delta
          podman

          # inspection/debugging tools
          netcat-gnu
          lsof
          dig
          evtest
          iptables
          htop
          man
          man-pages
          wev
          dua
          duf

          # editor
          nodePackages.bash-language-server
          nodePackages.typescript-language-server
          gopls
          nodePackages.pyright
          isort
          shellcheck
          shfmt
          shellharden
          gnumake
          cmake
          nodejs
          gomodifytags
          gotests
          gore
          nixfmt
          graphviz
          ruby
          rust-analyzer
          cargo
          rustc
          zls
          zig
          python3
          poetry

          # system tweaks
          earlyoom
          hunspellDicts.en-us
          keychain
          linux-firmware
          mako
          pmount
          qemu
          virt-manager

          # display
          wl-clipboard
          clipman
          wofi
          wofi-emoji
          swayidle
          swaylock
          waybar

          # NOTE: Sway v/s Nvidia is a mess
          # WLR_RENDERER=vulkan helps, so we need vulkan related packages
          glslang
          vulkan-headers
          vulkan-loader
          vulkan-validation-layers
          ];

      home.sessionVariables = {
        # sway
        XWAYLAND_NO_GLAMOR = "1";
        XDG_SESSION_TYPE = "wayland";
        # sway and nvdia
        WLR_NO_HARDWARE_CURSORS = "1";
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm"; # remove if issue w ff
        __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # remove if issues w discord
        WLR_RENDERER = "vulkan";
        # xdg
        XDG_CACHE_HOME = "${h}/.cache";
        XDG_CONFIG_HOME = "${h}/.config";
        XDG_DATA_HOME = "${h}/.local/share";
        XDG_STATE_HOME = "${h}/.local/state";
        # misc
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        # DOOMDIR = "${h}/.config/doom";
        EDITOR = "nvim";
      };
    };
  };
}
