{pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
        clang_17
        jetbrains.clion
        jetbrains.goland
        jetbrains.pycharm-professional
        jetbrains.rider
        jetbrains.webstorm
    ];
}