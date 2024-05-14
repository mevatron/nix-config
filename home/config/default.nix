{ config, pkgs, ... }:

{
    home = {
        file = {
            ".ideavimrc" = {
                source = config.lib.file.mkOutOfStoreSymlink ./.ideavimrc;
            };

            # work around home-manager symlink bug inside of FHS environments
            ".ssh/config" = {
                target = ".ssh/config_source";
                onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
            };
        };
    };
}