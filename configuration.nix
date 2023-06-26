# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "es";
    xkbVariant = "";
  };

  # Update microcode for Intel CPUs
  hardware.cpu.intel.updateMicrocode = true;

  # Enable access to Intel SGX privisioning device
  hardware.cpu.intel.sgx.provision.enable = true;

  # Disable PulseAudio
  hardware.pulseaudio.enable = false;

  # Enable PipeWire
  services.pipewire.enable = true;

  # Set PipeWire as primary sound server
  services.pipewire.audio.enable = true;

  # Enable PipeWire's WirePlumber
  services.pipewire.wireplumber.enable = true;

  # Enable PipeWire PulseAudio emulation
  services.pipewire.pulse.enable = true;

  # Enable PipeWire JACK audio emulation
  services.pipewire.jack.enable = true;

  # Enable Pipewire ALSA support
  services.pipewire.alsa.enable = true;

  # Enable PipeWire's ALSA 32-bit support
  services.pipewire.alsa.support32Bit = true;

  # Enable X11 server
  services.xserver.enable = true;

  # Enable display manager to GNOME
  services.xserver.displayManager.gdm.enable = true;

  # Enable Wayland on GNOME
  services.xserver.displayManager.gdm.wayland = true;

  # Set desktop manager to GNOME
  services.xserver.desktopManager.gnome.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;

  # Enable libvirt
  virtualisation.libvirtd.enable = true;

  # Enable OMVF on libvirt
  virtualisation.libvirtd.qemu.ovmf.enable = true;

  # Enable SWTPM on libvirtd
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  # Enable KVMGT
  virtualisation.kvmgt.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mrkenhoo = {
    isNormalUser = true;
    description = "Ken Hoo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    sudo
    polkit
    qemu
    OVMF
    virt-manager
    papirus-icon-theme
    gnome-browser-connector
  ];

  # Exclude GNOME applications
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # old text editor
    epiphany
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game    
  ]);

  # Enable gnome-settings-daemon udev rules
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  # Enable dconf for GNOME
  programs.dconf.enable = true;

  # Enable Wayland for all apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
