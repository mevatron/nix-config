{ pkgs, pkgs-unstable, ... }:

{
    home.packages = with pkgs; [
        slack
        discord
        pkgs-unstable.element-desktop
    ];
}