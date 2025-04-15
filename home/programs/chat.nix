{ pkgs, pkgs-unstable, ... }:

{
    home.packages = with pkgs; [
        slack
        discord
        pkgs-unstable.element-desktop
        pkgs-unstable.signal-desktop-bin
        zoom-us
    ];
}