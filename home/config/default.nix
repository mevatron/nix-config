{ config, pkgs, ... }:

{
    home = {
        file = {
            ".ideavimrc" = {
                source = config.lib.file.mkOutOfStoreSymlink ./.ideavimrc;
            };
        };
    };
}