{ pkgs, ... }:

{
    home.packages = with pkgs; [
        gimp-with-plugins
        inkscape-with-extensions
        krita
        photocollage
    ];
}