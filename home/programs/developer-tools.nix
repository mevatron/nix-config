{pkgs-unstable, pkgs-master, pkgs, llm-agents, ...}: {
    home.packages = with pkgs-unstable; [
        android-studio
        awscli2

        pkgs.code-review-graph
        cmake
        esphome
        gnumake
        gcc14
        insomnia
        jetbrains.clion

        jetbrains.datagrip

        go
        jetbrains.goland


        jetbrains.idea

        (llama-cpp.override { cudaSupport = true; })
        llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
        llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.mistral-vibe

        pkgs.poetry
        python3
        uv
        jetbrains.pycharm

        dotnet-sdk_8
        jetbrains.rider

        nodejs
        pnpm
        yarn
        jetbrains.webstorm

        # Misc dev tools
        pkgs.mitmproxy
        pkgs.nixpkgs-fmt
        pkgs.okteta
        pkgs.tcpdump
        pkgs.wireshark
    ];
}
