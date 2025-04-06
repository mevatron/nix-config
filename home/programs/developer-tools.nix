{pkgs-unstable, pkgs, ...}: {
    home.packages = with pkgs-unstable; [
        aider-chat
        android-studio
        pkgs.awscli2

        cmake
        pkgs.esphome
        gnumake
        gcc13
        (jetbrains.plugins.addPlugins jetbrains.clion [
          "github-copilot"
          "ideavim"
        ])

        (jetbrains.plugins.addPlugins jetbrains.datagrip [
          "github-copilot"
          "ideavim"
        ])

        go
        (jetbrains.plugins.addPlugins jetbrains.goland [
          "github-copilot"
          "ideavim"
        ])

        (jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
          "github-copilot"
          "ideavim"
          "nixidea"
        ])

        poetry
        python3
        (jetbrains.plugins.addPlugins jetbrains.pycharm-professional [
          "github-copilot"
          "ideavim"
          "nixidea"
        ])

        dotnet-sdk_8
        (jetbrains.plugins.addPlugins jetbrains.rider [
          "github-copilot"
          "ideavim"
        ])

        pkgs.nodejs
        pkgs.nodePackages.npm
        pkgs.nodePackages.pnpm
        pkgs.nodePackages.yarn
        (jetbrains.plugins.addPlugins jetbrains.webstorm [
          "github-copilot"
          "ideavim"
          "nixidea"
        ])

        # Misc dev tools
        pkgs.nixpkgs-fmt
        pkgs.okteta
        pkgs.tcpdump
        pkgs.wireshark
    ];
}