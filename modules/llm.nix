{config, lib, pkgs-unstable, ...}:

{
    disabledModules = [ "services/misc/ollama.nix" ];

    imports = [
        (import "${pkgs-unstable.path}/nixos/modules/services/misc/ollama.nix")
    ];

    services.ollama = {
        enable = true;
        acceleration = "cuda";
        package = pkgs-unstable.ollama;
    };
}