# Help
# - configuration.nix(5)
# - nixos-help
# - nixos-option
# - home-manager options: https://mipmip.github.io/home-manager-option-search/

{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in
{
  imports = [
      ./cachix.nix
      ./hardware-configuration.nix
      /home/zuck/x/pc/hq.nix
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
	  enable = true;
	  setSocketVariable = true;
  };
  virtualisation.docker.storageDriver = "btrfs";


  nix.settings.experimental-features = [ "nix-command" ];
  nixpkgs.config.allowUnfree = true;
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
  

  hardware.opengl = {
    enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"]; # needed for wayland too
  services.udisks2.enable = true;
  hardware.nvidia = {
     # powerManagement.enable = true; # hoping this fixes hibernation, conclusion: does not work
     # nvidiaPersistenced = true; # does not make any diff
     modesetting.enable = true;
     open = true; # open source kernel module 515.43.04+
     nvidiaSettings = true;
     package = config.boot.kernelPackages.nvidiaPackages.stable;
   };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

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
  hardware.pulseaudio.enable = true;

  users.users.zuck = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "docker" ]; # Enable ‘sudo’ for the user.
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
      #tailscale
      unstable.tailscale
      zlib
      git
      htop
      gcc11
      stdenv
      pkgconfig
      iwd
      #mesa
      #libGL
      #libGLU
      #libglvnd
      # nvidia
      cachix
      cudaPackages.cudatoolkit
      cudaPackages.cudnn
      cudaPackages.libcublas
      cudaPackages.cuda_cudart
      #cudaPackages.cutensor
  ];


  fonts.fonts = with pkgs; [
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
    #LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.cudaPackages.cudatoolkit}/lib64:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.cudaPackages.cudnn}/lib:/run/opengl-driver/lib:/run/opengl-driver-32/lib";
    #LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.cudaPackages.cudatoolkit}/lib64:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.cudaPackages.cudnn}/lib:${pkgs.libglvnd}/lib";
    LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.cudaPackages.cudatoolkit}/lib64:${pkgs.cudaPackages.cudatoolkit}/include:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.cudaPackages.cudnn}/lib";
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    CUDART_PATH = "${pkgs.cudaPackages.cuda_cudart}";
    #EXTRA_LDFLAGS = "-L${pkgs.linuxPackages.nvidia_x11}/lib";
    NIX_SHELL_PRESERVE_PROMPT = "1";
   };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enabled services
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  services.tailscale.enable = true;
  services.tailscale.package = pkgs.unstable.tailscale;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 8384 22000 5000 7860 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.05";
}

