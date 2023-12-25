{pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
        jetbrains.clion
        jetbrains.goland
        jetbrains.pycharm-professional
        jetbrains.rider
        jetbrains.webstorm
    ];
}