{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
  homedir = "/home/zuck";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.zuck = {pkgs, ... }: {
      home.stateVersion = "23.05";
      programs.fish.enable = true; # maybe remove this later

      home.file.".config/git".source = "/home/zuck/x/.config/git/";
      home.file.".config/sway/config".source = "/home/zuck/x/.config/sway/config_for_hq";
      home.file.".config/alacritty".source = "/home/zuck/x/.config/alacritty";
      #home.file.".tmux.conf".source = "/home/zuck/d/.tmux.conf";

      home.packages = with pkgs; [
        tmux
	sway
	firefox
        alacritty
	fzf

	# display
	wl-clipboard
	clipman
	wofi
	swayidle
	swaylock
	waybar
      ];
      home.sessionVariables = {
	XWAYLAND_NO_GLAMOR = "1";
  	WLR_NO_HARDWARE_CURSORS = "1";
        LIBVA_DRIVER_NAME = "nvidia";
        XDG_SESSION_TYPE = "wayland";
        GBM_BACKEND = "nvidia-drm"; # remove if issue w ff
        __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # remove if discord issues
	WLR_RENDERER = "vulkan";
      };
    };
  };
}
