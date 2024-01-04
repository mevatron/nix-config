{ pkgs, ... }:

{
    programs = {
        chromium = {
            enable = true;
            package = pkgs.brave;
        };

        firefox = {
            enable = true;
        };
    };
}