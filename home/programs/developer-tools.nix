{pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
        clang_17
        jetbrains.clion
        jetbrains.goland
        jetbrains.idea-ultimate
        jetbrains.pycharm-professional
        jetbrains.rider
        jetbrains.webstorm
    ];
}