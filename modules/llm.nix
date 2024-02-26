{config, lib, pkgs-unstable, ...}:

{
    disabledModules = [ "services/misc/ollama.nix" ];

    imports = [
        (import "${pkgs-unstable.path}/nixos/modules/services/misc/ollama.nix")
    ];

    services.ollama = {
        enable = true;
        package = (pkgs-unstable.ollama.override  {
            enableCuda = true;
            linuxPackages.nvidia_x11 = config.hardware.nvidia.package;
        });
    };
}