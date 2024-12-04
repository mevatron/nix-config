{ pkgs, ... }:

{
    home.packages = with pkgs; [
      # Currently tries to install broken `python3.12-libarcus-4.12.0`
      # cura
    ];
}