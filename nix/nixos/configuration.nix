# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: 

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot = {
  	supportedFilesystems = [ "ntfs" ];
	loader = {
		efi.canTouchEfiVariables = true;
		grub.enable = false;
		systemd-boot.enable = true;
	};
	kernelPackages = pkgs.linuxPackages_latest;
  };

  # boot.loader.refind.enable = true;
  # boot.loader.refind.package = pkgs.refind;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking

  networking = {
  	hostName = "nixpad";
	wireless.enable = true;
	networkmanager.enable = true;
	firewall.checkReversePath = false;
  };

  hardware = {
  	graphics = {
		enable = true;
		enable32Bit = true;
	};

	amdgpu = {
		initrd.enable = true;
		zluda.enable = true;
	};

	bluetooth = {
		enable = true;
		powerOnBoot = false;
	};
  };

  # Testing purposes only
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix = {
  	settings = {
		auto-optimise-store = true;
	};
	extraOptions = ''
		experimental-features = nix-command flakes
		'';
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    model = "pc105";     # Standard layout map that includes laptop keys
    variant = "";
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."caveman" = {
    isNormalUser = true;
    description = "caveman";
    extraGroups = [ "networkmanager" "wheel" "video" "render" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    	xwayland-satellite
	proton-vpn
	wireguard-tools
	btop
	fastfetch
	bluez
	bluetuith
	wireplumber
	nh
	unzip
	gnumake
	pipewire
	starship
	bat
	eza
	fzf
    ];
  };

  fonts.packages = with pkgs; [
  	nerd-fonts.jetbrains-mono
  	nerd-fonts.symbols-only  # General fallback icons set
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.niri.enable = true;
  programs.zsh.enable = true;

  services.tlp = {
  	enable = true;
	settings = {
		TLP_ENABLE = 1;
		TLP_DEFAULT_MODE = "BAL";
		TLP_PERSISTENT_DEFAULT=0;
		TLP_WARN_LEVEL=3;

		TLP_AUTO_SWITCH=2;

		TLP_PROFILE_AC="PRF";
		TLP_PROFILE_BAT="BAL";

		CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance";
		CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power";
		CPU_ENERGY_PERF_POLICY_ON_SAV="power";
		CPU_SCALING_GOVERNOR_ON_AC="performance";
		CPU_SCALING_GOVERNOR_ON_BAT="powersave";
		CPU_BOOST_ON_AC=1;
		CPU_BOOST_ON_BAT=1;
		CPU_BOOST_ON_SAV=0;
		
		START_CHARGE_THRESH_BAT0=0;
		STOP_CHARGE_THRESH_BAT0=1;

		RESTORE_THRESHOLDS_ON_BAT=1;

		RADEON_DPM_PERF_LEVEL_ON_AC="auto";
		RADEON_DPM_PERF_LEVEL_ON_SAV="low";
		# RADEON_DPM_PERF_LEVEL_ON_BAT="auto";

		AMDGPU_ABM_LEVEL_ON_AC=0;
		AMDGPU_ABM_LEVEL_ON_BAT=2;

		NMI_WATCHDOG=0;

		WOL_DISABLE="Y";

		PLATFORM_PROFILE_ON_AC="performance";
		PLATFORM_PROFILE_ON_BAT="balanced";
		PLATFORM_PROFILE_ON_SAV="low-power";

		MEM_SLEEP_ON_AC="s2idle";
		MEM_SLEEP_ON_BAT="s2idle";
		MEM_SLEEP_ON_SAV="deep";

		DEVICES_TO_ENABLE_ON_STARTUP="wifi";
		DEVICES_TO_ENABLE_ON_AC="wifi";

		RUNTIME_PM_ON_AC="on";
		RUNTIME_PM_ON_BAT="auto";
	};
  };

  # Display Manager Setup
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # System-wide qylock module configuration
  programs.qylock = {
    enable = true;
    theme = "sword";

    themeOptions = {
      terraria.backgroundMode = "time";
      Genshin.backgroundMode = "time";
      clockwork.orbital = { themeMode = "dark"; enableWindup = true; };
      osu.gameMode = "menu";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	kitty
	neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	vim
  ];

system.activationScripts.copyConfigToGit = {
  text = ''
    TARGET_DIR="/home/caveman/.config/nix/nixos"

    mkdir -p "$TARGET_DIR"
    find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -not -name '.git*' -exec rm -rf {} +
    cp -r --remove-destination /etc/nixos/. "$TARGET_DIR/"

    chown -R caveman:users "$TARGET_DIR"
  '';
  deps = [];
};


# virtualisation.docker.enable = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
