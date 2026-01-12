{pkgs-unstable, pkgs, ...}: {
    home.packages = with pkgs-unstable; [
        aider-chat
        android-studio
        pkgs.awscli2

        cmake
        pkgs.esphome
        gnumake
        gcc14
        insomnia
        jetbrains.clion

        jetbrains.datagrip

        go
        jetbrains.goland

        goose-cli

        jetbrains.idea-ultimate

        llama-cpp

        poetry
        python3
        uv
        jetbrains.pycharm-professional

        dotnet-sdk_8
        jetbrains.rider

        pkgs.nodejs
        pkgs.nodePackages.npm
        pkgs.nodePackages.pnpm
        pkgs.nodePackages.yarn
        jetbrains.webstorm

        # Misc dev tools
        pkgs.nixpkgs-fmt
        pkgs.okteta
        pkgs.tcpdump
        pkgs.wireshark
    ];
}