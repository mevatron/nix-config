{ config, pkgs, ... }:

{
    home = {
        file = {
            ".ideavimrc" = {
                source = ./.ideavimrc;
                target = ".ideavimrc_source";
                onChange = ''cat ~/.ideavimrc_source > ~/.ideavimrc'';
            };

            # work around home-manager symlink bug inside of FHS environments
            ".ssh/config" = {
                target = ".ssh/config_source";
                text = ''
                  Host gitlab.com
                    IdentityFile ~/.ssh/id_gitlab
                    ForwardAgent no
                    AddKeysToAgent yes
                '';
                onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
            };
        };
    };
}