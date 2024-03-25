{pkgs-unstable, pkgs, ...}: {
    home.packages = with pkgs-unstable; [
        android-studio
        pkgs.awscli2

        cmake
        gnumake
        gcc13
        (jetbrains.plugins.addPlugins jetbrains.clion [
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
        ])

        python3
        (jetbrains.plugins.addPlugins jetbrains.pycharm-professional [
          "github-copilot"
          "ideavim"
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
        ])

        # Misc dev tools
        pkgs.nixpkgs-fmt
        pkgs.okteta
        pkgs.tcpdump
        pkgs.wireshark
    ];
}