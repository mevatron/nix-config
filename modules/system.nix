{
  pkgs,
  lib,
  ...
}: let
  username = "wlucas";
in {
  # ============================= User related =============================

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    initialPassword = "password";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnlJNB9dMn0q+IZEk2/r9LB3eyokMxTRJtQPbGweXy5yXgrDoNvfvQislsqRpI4eijS4i4hjvxNherUadAcNLHYXmrNzHv5q51LveRltYR8TtaedeCXNxt7fNJbn6FY6GDqWl9J/m6MsCI9r5x3eUnHUq9itYlC/tckuZhkqqj+koE7lqX6QIAXD+zH3rXrACdqrEK4VWjZ+mziK0EubysUSQC5i9CH08aqB9qhscFC7RXVFSOwA/KFNp0BeeexfzErqgEtiNz9UCTcaM/jk7byzLbJanpy4tH5yAhyYNfGA60dhnN0F+WovoL6GSzqWWgTBTXSr/V0gal2/4dRzW1KC8fETFcEuDBJd4z/D6NNte5uyz+bVpvG8XY66GzbNUD812y2HrqK4pzfsZg8Zo7UWGWV3leGzCzQGmmZzlJcr3ZydTPnFw/7ii8JD8BgarIuR++f1Wh2U5dBHYCaGSX4J1nHhq7k3doL6SlJSQjZ85OYO3Ru+10rbZZEjhA9Nc= wlucas@wlucas-ThinkPad-T480"
    ];
  };
  # given the users in this list the right to specify additional substituters via:
  #    1. `nixConfig.substituers` in `flake.nix`
  #    2. command line args `--options substituers http://xxx`
  nix.settings.trusted-users = [username];

  # customise /etc/nix/nix.conf declaratively via `nix.settings`
  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      # nerdfonts
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  programs.dconf.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    lm_sensors # for `sensors` command
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.power-profiles-daemon = {
    enable = true;
  };
  security.polkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}