{pkgs-unstable, pkgs, ...}: {
    home.packages = with pkgs-unstable; [
        clang_17
        cmake
        jetbrains.clion

        go
        jetbrains.goland

        jetbrains.idea-ultimate

        python3
        jetbrains.pycharm-professional

        dotnet-sdk_8
        jetbrains.rider

        pkgs.nodejs
        pkgs.nodePackages.npm
        pkgs.nodePackages.pnpm
        jetbrains.webstorm

        # Misc dev tools
        pkgs.nixpkgs-fmt
        pkgs.okteta
        pkgs.tcpdump
        pkgs.wireshark
    ];
}