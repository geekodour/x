# Help
# - configuration.nix(5)
# - nixos-help
# - nixos-option
# - home-manager options: https://mipmip.github.io/home-manager-option-search/

{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = config.nixpkgs.config; };
in
{
  imports = [
      ./cachix.nix
      ./hardware-configuration.nix
      /home/zuck/x/pc/hq.nix
  ];

  virtualisation.docker.enable = true;
  # NOTE: not using rootless for the firewall issue debugging
  # TODO: Enable this and check if we can still access port on some service form container to host
  virtualisation.docker.rootless = {
	  enable = false;
	  setSocketVariable = false;
  };
  virtualisation.docker.storageDriver = "btrfs";


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  # see https://discourse.nixos.org/t/where-are-options-like-config-cudasupport-documented/17806/9
  # nixpkgs.config.cudaSupport = true; # ollama
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
  };
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  #nixpkgs.overlays = [
  #  (import (builtins.fetchTarball {
  #    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #  }))
  #];

  # postgres
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "zuckdb" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
    #driSupport = true;
    #driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"]; # needed for wayland too
  services.udisks2.enable = true;
  hardware.nvidia = {
     # powerManagement.enable = true; # hoping this fixes hibernation, conclusion: does not work
     # nvidiaPersistenced = true; # does not make any diff
     modesetting.enable = true;
     open = false; # open source kernel module 515.43.04+
     nvidiaSettings = true;
     package = config.boot.kernelPackages.nvidiaPackages.stable;
     # package = config.boot.kernelPackages.nvidiaPackages.beta;
   };

   # KDE
   #services.xserver.enable = true;
   #services.xserver.displayManager.sddm.enable = false;
   ## services.xserver.displayManager.sddm.enable = true;
   #services.xserver.displayManager.startx.enable = true;
   #services.xserver.desktopManager.plasma5.enable = true;
   #environment.plasma5.excludePackages = with pkgs.libsForQt5; [
   #  plasma-browser-integration
   #  konsole
   #  oxygen
   #];



  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.thunar.enable = true;

  # boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
  # boot.kernelModules = [ "v4l2loopback" "snd-aloop" ];

  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.extraModulePackages = [ pkgs.linuxKernel.packages.linux_zen.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
  # boot.extraModprobeConfig =
  #   ''
  #   options v4l2loopback nr_devices=2 exclusive_caps=1,1 video_nr=0,1 card_label=v4l2lo0,v4l2lo1
  #   '';

  networking.hostName = "hq";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.wireless.iwd.enable = true;  
  networking.wireless.userControlled.enable = true;
  networking.extraHosts = ''
    192.168.1.69 pi
    #23.137.249.79 archive.is
  '';
  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  time.timeZone = "Asia/Kolkata";

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # xdg portal is required for screenshare
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  xdg.portal.config.common.default = "*";

  users.users.zuck = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "docker" "postgres" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # system packages
  environment.systemPackages = with pkgs; [
      neovim
      wget
      pciutils
      ripgrep
      file
      exiftool
      zlib
      git
      htop
      gcc11
      stdenv
      pkg-config
      iwd
      #mesa
      #libGL
      #libGLU
      #libglvnd

      # nvidia
      # unstable.cachix
      # unstable.cudaPackages.cudatoolkit
      # unstable.cudaPackages.cudnn
      # unstable.cudaPackages.libcublas
      # unstable.cudaPackages.cuda_cudart

      cachix
      cudaPackages.cudatoolkit
      cudaPackages.cudnn
      cudaPackages.libcublas
      cudaPackages.cuda_cudart

      # cudaPackages.cutensor
  ];


  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    inter
    fira-code
    fira-code-symbols
    jetbrains-mono
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];



  services.interception-tools = {
    enable = true;
    udevmonConfig = let
      dfkconfig = builtins.toFile "ducky.yaml" ''
        TIMING:
          TAP_MILLISEC: 200
          DOUBLE_TAP_MILLISEC: 150
        MAPPINGS:
          - KEY: KEY_CAPSLOCK
            TAP: KEY_ESC
            HOLD: KEY_LEFTCTRL
      '';
    in ''
      - JOB: |
          ${pkgs.interception-tools}/bin/intercept -g $DEVNODE \
            | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${dfkconfig} \
            | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK]
    '';
  };

   environment.sessionVariables = rec {
    LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.cudaPackages.cudatoolkit}/lib64:${pkgs.cudaPackages.cudatoolkit}/include:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.cudaPackages.cudnn}/lib";
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    CUDART_PATH = "${pkgs.cudaPackages.cuda_cudart}";

    # LD_LIBRARY_PATH = "${pkgs.unstable.linuxPackages.nvidia_x11}/lib:${pkgs.unstable.cudaPackages.cudatoolkit}/lib64:${pkgs.unstable.cudaPackages.cudatoolkit}/include:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.unstable.cudaPackages.cudnn}/lib";
    # CUDA_PATH = "${pkgs.unstable.cudaPackages.cudatoolkit}";
    # CUDART_PATH = "${pkgs.unstable.cudaPackages.cuda_cudart}";

    #EXTRA_LDFLAGS = "-L${pkgs.linuxPackages.nvidia_x11}/lib";
    NIX_SHELL_PRESERVE_PROMPT = "1";
   };

  # NOTE: No longer needed as tailscale ssh
  # services.openssh = {
  #   enable = true;
  #   allowSFTP = true;
  #   ports = [22];
  #   settings.PermitRootLogin = "no";
  #   settings.PasswordAuthentication = false;
  # };

  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
    interfaceName = "tailscale";
    extraUpFlags = ["--ssh"];
  };

  networking.firewall = {
    enable = true;
    # NOTE: These are for docker to host communication
    # NOTE: Docker to host communication also needs docker to run as root at
    #       the moment  
    interfaces.docker0.allowedTCPPorts = [ 3000 53 ];
    interfaces.docker0.allowedUDPPorts = [ 3000 53 ];
    extraCommands = ''
      iptables -A INPUT -i docker0 -j ACCEPT
    '';
    # Debugging help
    # rejectPackets = true; # debug
    # logRefusedPackets = true; # debug
    # logReversePathDrops = true; # debug
  };

  system.stateVersion = "23.05";
}

