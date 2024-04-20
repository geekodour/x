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
      ./hardware-configuration.nix
     /home/geekodour/x/lander/lander.nix
  ];

   virtualisation.docker.enable = true;
   virtualisation.docker.rootless = {
           enable = false;
           setSocketVariable = false;
   };
   #virtualisation.docker.storageDriver = "ext4";


  #hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.tlp.enable = true;
  services.pipewire = {
    package = unstable.pipewire;
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  # see https://discourse.nixos.org/t/where-are-options-like-config-cudasupport-documented/17806/9
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
  };
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  # postgres
  #services.postgresql = {
  #  enable = true;
  #  ensureDatabases = [ "geekodourdb" ];
  #  authentication = pkgs.lib.mkOverride 10 ''
  #    #type database  DBuser  auth-method
  #    local all       all     trust
  #  '';
  #};

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
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
  services.udisks2.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.thunar.enable = true;
  programs.fish.enable = true;

  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];

  networking.hostName = "lander";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.wireless.iwd.enable = true;  
  networking.wireless.userControlled.enable = true;
  networking.extraHosts = ''
    #192.168.1.69 pi
    #23.137.249.79 archive.is
  '';
  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  time.timeZone = "Asia/Kolkata";

  # Enable sound.
  sound.enable = true;

  # xdg portal is required for screenshare
  xdg.portal.config.common.default = "*";
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  users.users.geekodour = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" "input" ]; # Enable ‘sudo’ for the user
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
      # we're using pulseaudio compatibility layer via pipewire
      pulseaudio
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
    NIX_SHELL_PRESERVE_PROMPT = "1";
   };

  # Enabled services
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
    interfaceName = "tailscale";
    # NOTE: The --ssh flag doesn't seem to work as expected, so we manually do tailscale up --ssh now
    # extraUpFlags = ["--ssh"];
    # extraDaemonFlags = [];
    # NOTE: Think we need to allow this if we want inbound traffic
    #openFirewall = true;
  };

  # Open ports in the firewall.
  networking.firewall = {
    # NOTE: Unsure if we need to enable this if we have the openFirewall thing set
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedTCPPorts = [22];
    allowedUDPPorts = [ config.services.tailscale.port ];
    extraCommands = ''
      iptables -A INPUT -i docker0 -j ACCEPT
    '';
  };

  system.stateVersion = "23.11";
}

