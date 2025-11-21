{ pkgs, ... }:

{
    home.packages = with pkgs; [
        gimp-with-plugins
        inkscape-with-extensions
        kdePackages.kdenlive
        krita
        photocollage
    ];
}