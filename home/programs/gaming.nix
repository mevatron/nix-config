{ pkgs, pkgs-unstable, ... }:

{
    home.packages = with pkgs; [
        pkgs-unstable.steam
        pkgs-unstable.moonlight-qt
    ];
}
