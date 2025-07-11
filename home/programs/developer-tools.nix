{pkgs-unstable, pkgs, ...}: {
    home.packages = with pkgs-unstable; [
        aider-chat
        android-studio
        pkgs.awscli2

        cmake
        pkgs.esphome
        gnumake
        gcc13
        insomnia
        (jetbrains.plugins.addPlugins jetbrains.clion [
          "ideavim"
        ])

        (jetbrains.plugins.addPlugins jetbrains.datagrip [
          "ideavim"
        ])

        go
        (jetbrains.plugins.addPlugins jetbrains.goland [
          "ideavim"
        ])

        (jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
          "ideavim"
          "nixidea"
        ])

        llama-cpp

        poetry
        python3
        uv
        (jetbrains.plugins.addPlugins jetbrains.pycharm-professional [
          "ideavim"
          "nixidea"
        ])

        dotnet-sdk_8
        (jetbrains.plugins.addPlugins jetbrains.rider [
          "ideavim"
        ])

        pkgs.nodejs
        pkgs.nodePackages.npm
        pkgs.nodePackages.pnpm
        pkgs.nodePackages.yarn
        (jetbrains.plugins.addPlugins jetbrains.webstorm [
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