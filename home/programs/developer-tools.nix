{pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
        clang_17
        jetbrains.clion
        go
        jetbrains.goland
        jetbrains.idea-ultimate
        jetbrains.pycharm-professional
        dotnet-sdk_8
        jetbrains.rider
        jetbrains.webstorm
    ];
}