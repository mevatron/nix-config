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
        (jetbrains.plugins.addPlugins (jetbrains.clion.override {
          jdk = openjdk21;
        }) [
          "ideavim"
        ])

        (jetbrains.plugins.addPlugins (jetbrains.datagrip.override {
          jdk = openjdk21;
        }) [
          "ideavim"
        ])

        go
        (jetbrains.plugins.addPlugins (jetbrains.goland.override {
          jdk = openjdk21;
        }) [
          "ideavim"
        ])

        (jetbrains.plugins.addPlugins (jetbrains.idea-ultimate.override {
          jdk = openjdk21;
        }) [
          "ideavim"
          "nixidea"
        ])

        llama-cpp

        poetry
        python3
        uv
        (jetbrains.plugins.addPlugins (jetbrains.pycharm-professional.override {
          jdk = openjdk21;
        }) [
          "ideavim"
          "nixidea"
        ])

        dotnet-sdk_8
        (jetbrains.plugins.addPlugins (jetbrains.rider.override {
          jdk = openjdk21;
        }) [
          "ideavim"
        ])

        pkgs.nodejs
        pkgs.nodePackages.npm
        pkgs.nodePackages.pnpm
        pkgs.nodePackages.yarn
        (jetbrains.plugins.addPlugins (jetbrains.webstorm.override {
          jdk = openjdk21;
        }) [
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