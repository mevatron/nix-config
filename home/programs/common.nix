{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # cloud native
    docker-compose
    kubectl

    nodejs
    nodePackages.npm
    nodePackages.pnpm
  ];

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };


    btop.enable = true; # replacement of htop/nmon
    jq.enable = true; # A lightweight and flexible command-line JSON processor
    ssh.enable = true;
    aria2.enable = true;
    kdeconnect.enable = true;
  };

  services = {
    # TODO: add more services
  };
}