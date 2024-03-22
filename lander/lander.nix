{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
  h = "/home/geekodour";
  x = "/home/geekodour/x";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  services.emacs = {
    enable = true;
    package = pkgs.emacs29;
  };

  #services.openvpn.servers = {
  #  houseware_dev_vpn  = {
  #    config = '' config ${h}/infra/openvpn_configs/hw_dev.ovpn ''; 
  #    autoStart = false;
  #    #updateResolvConf = true;
  #  };
  #};

  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  security.wrappers.pmount = {
    setuid = true;
    setgid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.pmount}/bin/pmount";
  };
  security.wrappers.pumount = {
    setuid = true;
    setgid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.pmount}/bin/pumount";
  };
  programs.fish.enable = true; # need to enable it outside of hm aswell

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [pkgs.tridactyl-native];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.geekodour = {pkgs, ... }: {
      home.stateVersion = "23.11";

      # various configs from arch
      home.file.".config/git".source = "${x}/.config/git/";
      home.file.".config/waybar".source = "${x}/.config/waybar/";
      home.file.".config/sway/config".source = "${x}/.config/sway/config_for_lander";
      home.file.".config/alacritty".source = "${x}/.config/alacritty";
      home.file.".config/nvim".source = "${x}/.config/nvim";
      home.file.".config/wofi".source = "${x}/.config/wofi";
      home.file.".config/zoxide".source = "${x}/.config/zoxide";
      home.file.".config/nnn/init".source = "${x}/.config/nnn/init";
      home.file.".config/starship".source = "${x}/.config/starship";
      home.file.".config/doom".source = "${x}/.config/doom";
      home.file.".config/mpv".source = "${x}/.config/mpv";
      home.file.".config/swappy".source = "${x}/.config/swappy";
      home.file.".config/pypoetry/config.toml".source = "${x}/.config/pypoetry/config.toml";
      home.file.".tmux.conf".source = "${x}/.tmux.conf";
      home.file.".tridactylrc".source = "${x}/.tridactyl.rc";
      # security
      home.file.".ssh/config".source = "${x}/.ssh/config";

      # cursor
      home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

      # fish
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          source ~/.config/nnn/init # nnn
          source ~/.config/starship/init # starship
          source ~/.config/zoxide/init # zoxide
          alias cd z
          if test (tty) = /dev/tty1
              sway
          end
        ''; 
      };
      home.file.".config/fish/functions".source = "${x}/.config/fish/functions";
      home.file.".config/fish/conf.d/gitaliases.fish".source = "${x}/.config/fish/conf.d/gitaliases.fish";

      # NOTES about gpg
      # 1. Restore/Create GPG keys
      # 2. Make sure gpg-agent can access it
      # 3. Make sure keychain and gpg-agent are in the same page
      # 4. Make sure other programs are able to use gpg
      # Restoring notes
      # 1. Copy the private keys
      # 2. Copy pubring.kbx
      # 3. Remove cert key by running keygrip to see filename

      programs.keychain = {
        enable = true;
        enableFishIntegration = true;
        agents = ["ssh"];
        keys = [
          "${h}/.ssh/id_ed25519"
        ];
      };

      programs.chromium = {
        enable = true;
        package = pkgs.chromium.override {
          commandLineArgs = [ "--ozone-platform=wayland" "--enable-features=VaapiVideoDecoder" "--use-gl=egl"];
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
        package = pkgs.emacs29;
      };

      # packages
      home.packages = with pkgs; [
          hr
          tmux
          sway
          alacritty
          fzf
          tectonic
          gtk3
          zathura
          #ungoogled-chromium
          sfz
          nnn
          fd
          mpv
          gimp
          ispell
          yt-dlp
          wdisplays
          tree-sitter
          wl-mirror
          wtype
          vscode-fhs
          code-minimap

          # ops
          unstable.terraform

          # aws
          # see https://github.com/NixOS/nixpkgs/issues/218848
          awscli2
          nss.tools
          # unstable.awscli2
          # unstable.copilot-cli
          # unstable.ssm-session-manager-plugin
          nodePackages_latest.serve

          # misc
          bat
          unstable.ffmpeg
          parallel
          caddy
          unstable.swayosd # is not working as expected at the moment
          handbrake
          feh
          #thinkfan
          sqlite-interactive
          # act # gh actions local, installed docker for this
          #docker-compose
          discord
          slack
          element-desktop
          betterdiscordctl
          tesseract
          go
          # exa
          unstable.eza
          brightnessctl
          emscripten
          wlsunset
          zbar
          paperkey
          zotero
          handlr
          duckdb
          xdg-utils
          zoxide
          catimg
          zoom-us
          telegram-desktop
          thunderbird
          chafa
          glow
          google-chrome
          libtree
          nix-index
          dbeaver
          imv
          unstable.ollama
          krita
          unstable.cloudflared
          mediainfo
          losslesscut-bin
          grex
          neofetch
          #sniffnet
          # libcap
          pandoc
          onefetch
          lazydocker
          xfce.tumbler
          cpufetch
          obs-studio
          qbittorrent
          unstable.advcpmv
          gomi
          nix-tree # nice
          hyperfine
          pdfarranger
          ocrmypdf
          pgcli
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
          eva # calculator
          programmer-calculator # calc
          jq
          gfold
          hugo
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
          #nvtop
          man
          man-pages
          wev
          dua
          duf

          # editor
          nodePackages.bash-language-server
          nodePackages.svelte-language-server
          nodePackages.typescript-language-server
          nodePackages_latest.yaml-language-server
          pgformatter

          # following isn't even helping
          # ocamlPackages.ocaml-lsp
          # ocamlPackages.dune_3
          # ocamlPackages.merlin
          # ocamlPackages.ocp-indent
          # ocamlPackages.ocaml

          # llvmPackages_latest.llvm
          # llvmPackages.bintools
          clang-tools # clangd
          gopls
          delve
          gdb
          rr
          gotestsum
          gofumpt
          golangci-lint
          nodePackages.pyright
          isort
          shellcheck
          shfmt
          shellharden
          gnumake
          cmake
          nodejs
          gomodifytags
          visidata
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
          git-lfs
          python3
          # poetry

          # system tweaks
          earlyoom
          hunspellDicts.en-us
          #keychain
          # pinentry-curses
          libvterm
          libtool
          linux-firmware
          mako
          # pmount # nnn
          unstable.udisks # nnn
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
        # WLR_RENDERER = "vulkan";
        # xdg
        XDG_CACHE_HOME = "${h}/.cache";
        XDG_CONFIG_HOME = "${h}/.config";
        XDG_DATA_HOME = "${h}/.local/share";
        XDG_STATE_HOME = "${h}/.local/state";
        # misc
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        MANROFFOPT = "-c";
        # DOOMDIR = "${h}/.config/doom";
        EDITOR = "nvim";
        # idk wtf this is
        # MOZ_ENABLE_WAYLAND = "1";
        # WLR_BACKEND = "vulkan";
        # CLUTTER_BACKEND = "wayland";
      };
    };
  };
}
