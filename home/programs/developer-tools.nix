{pkgs-unstable, pkgs, ...}: {
    home.packages = with pkgs-unstable; [
        clang_17
        jetbrains.clion

        go
        jetbrains.goland

        jetbrains.idea-ultimate

        jetbrains.pycharm-professional

        dotnet-sdk_8
        jetbrains.rider

        pkgs.nodejs_20
        pkgs.nodePackages.npm
        pkgs.nodePackages.pnpm
        jetbrains.webstorm

        # Misc dev tools
        pkgs.okteta
        pkgs.tcpdump
        pkgs.wireshark
    ];
}