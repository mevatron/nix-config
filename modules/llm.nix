{config, lib, pkgs-unstable, pkgs-master, ...}:

{
    disabledModules = [
        "services/misc/ollama.nix"
        "services/misc/open-webui.nix"
    ];

    imports = [
        (import "${pkgs-master.path}/nixos/modules/services/misc/ollama.nix")
        (import "${pkgs-master.path}/nixos/modules/services/misc/open-webui.nix")
    ];

    services = {
        ollama = {
            enable = true;
            package = pkgs-master.ollama-cuda;
            host = "0.0.0.0";
            port = 11434;
            environmentVariables = {
                OLLAMA_DEBUG = "2";
                OLLAMA_FLASH_ATTENTION = "1";
                OLLAMA_KV_CACHE_TYPE = "q8_0";
            };
        };
        open-webui = {
            enable = true;
            package = pkgs-master.open-webui;
            host = "0.0.0.0";
            environment = {
                OLLAMA_API_BASE_URL = "http://localhost:11434";
                WEBUI_AUTH = "False";
                PYDANTIC_SKIP_VALIDATING_CORE_SCHEMAS = "True";
            };
        };
    };
}