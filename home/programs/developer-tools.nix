{pkgs-unstable, pkgs-master, pkgs, ...}: {
    home.packages = with pkgs-unstable; [
        aider-chat
        android-studio
        awscli2

        cmake
        esphome
        gnumake
        gcc14
        insomnia
        jetbrains.clion

        jetbrains.datagrip

        go
        jetbrains.goland

        goose-cli

        jetbrains.idea

        (pkgs-master.llama-cpp.override { cudaSupport = true; })
        pkgs-master.mistral-vibe

        pkgs.poetry
        python3
        uv
        jetbrains.pycharm

        dotnet-sdk_8
        jetbrains.rider

        nodePackages.npm
        nodePackages.pnpm
        nodePackages.yarn
        jetbrains.webstorm

        # Misc dev tools
        pkgs.mitmproxy
        pkgs.nixpkgs-fmt
        pkgs.okteta
        pkgs.tcpdump
        pkgs.wireshark
    ];
}