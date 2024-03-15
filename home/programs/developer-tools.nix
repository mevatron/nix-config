{pkgs-unstable, pkgs, ...}: {
    home.packages = with pkgs-unstable; [
        android-studio
        awscli2

        cmake
        gnumake
        gcc13
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