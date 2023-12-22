{ pkgs, ... }:

{
    home.packages = with pkgs; [
        inkscape-with-extensions
        gimp-with-plugins
    ];
}