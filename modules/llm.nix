{config, lib, pkgs-unstable, ...}:

{
    disabledModules = [
        "services/misc/ollama.nix"
        "services/misc/open-webui.nix"
    ];

    imports = [
        (import "${pkgs-unstable.path}/nixos/modules/services/misc/ollama.nix")
        (import "${pkgs-unstable.path}/nixos/modules/services/misc/open-webui.nix")
    ];

    services = {
        ollama = {
            enable = true;
            acceleration = "cuda";
            package = pkgs-unstable.ollama;
            host = "0.0.0.0";
            port = 11434;
            environmentVariables = {
              OLLAMA_FLASH_ATTENTION = "1";
              OLLAMA_KV_CACHE_TYPE = "q8_0";
            };
        };
        open-webui = {
            enable = true;
            package = pkgs-unstable.open-webui;
            host = "0.0.0.0";
            environment = {
                OLLAMA_API_BASE_URL = "http://localhost:11434";
                WEBUI_AUTH = "False";
                PYDANTIC_SKIP_VALIDATING_CORE_SCHEMAS = "True";
            };
        };
    };
}