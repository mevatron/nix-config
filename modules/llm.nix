{config, lib, pkgs-unstable, pkgs-master, ...}:

{
    disabledModules = [
        "services/misc/open-webui.nix"
        "services/networking/llama-swap.nix"
    ];

    imports = [
        (import "${pkgs-master.path}/nixos/modules/services/misc/open-webui.nix")
        (import "${pkgs-master.path}/nixos/modules/services/networking/llama-swap.nix")
    ];

    services = {
        open-webui = {
            enable = true;
            package = pkgs-unstable.open-webui;
            host = "0.0.0.0";
            environment = {
                HOME = "/var/lib/open-webui";
                WEBUI_AUTH = "False";
                PYDANTIC_SKIP_VALIDATING_CORE_SCHEMAS = "True";
            };
        };

        llama-swap = {
            enable = true;
            port = 11435;
            listenAddress = "0.0.0.0";

            package = pkgs-master.llama-swap;

            settings = let
                llama-cpp = (pkgs-unstable.llama-cpp.override { cudaSupport = true; });
                llama-server = lib.getExe' llama-cpp "llama-server";
            in {
                logLevel = "debug";
                healthCheckTimeout = 300;
                models = {
                    "devstral-small-2-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/Devstral-Small-2-24B-Instruct-2512-GGUF:UD-Q4_K_XL \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --jinja \
                            -ngl 99 \
                            --threads -1 \
                            --ctx-size 75000 \
                            -b 4096 \
                            --temp 0.15 \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };

                    "glm-4.7-flash-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/GLM-4.7-Flash-REAP-23B-A3B-GGUF:Q5_K_XL \
                            --jinja \
                            -ngl 99 \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --ctx-size 65535 \
                            --temp 0.7 \
                            --top-p 1.0 \
                            --min-p 0.01 \
                            --fit on \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };

                    "qwen-3.5-27b-thinking-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/Qwen3.5-27B-GGUF:UD-Q4_K_XL \
                            --jinja \
                            -ngl 99 \
                            --flash-attn auto \
                            --swa-full \
                            -b 1024 \
                            -ub 512 \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --ctx-size 75000 \
                            --temp 0.6 \
                            --top-p 0.95 \
                            --top-k 20 \
                            --min-p 0 \
                            --chat-template-kwargs "{\"enable_thinking\": true}" \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };

                    "qwen-3.5-27b-instruct-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/Qwen3.5-27B-GGUF:UD-Q4_K_XL \
                            --jinja \
                            -ngl 99 \
                            --flash-attn auto \
                            --swa-full \
                            -b 1024 \
                            -ub 512 \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --ctx-size 75000 \
                            --temp 1.0 \
                            --top-p 0.95 \
                            --top-k 20 \
                            --min-p 0 \
                            --presence-penalty 1.5 \
                            --chat-template-kwargs "{\"enable_thinking\": false}" \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };

                    "gemma-4-26b-a4b-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/gemma-4-26B-A4B-it-GGUF:UD-Q4_K_XL \
                            --jinja \
                            -ngl 99 \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --ctx-size 75000 \
                            --temp 1.0 \
                            --top-p 0.95 \
                            --top-k 64 \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };

                    "qwen-3.5-35b-a3b-instruct-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/Qwen3.5-35B-A3B-GGUF:UD-IQ4_NL \
                            --jinja \
                            -ngl 99 \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --ctx-size 75000 \
                            --temp 1.0 \
                            --top-p 0.95 \
                            --top-k 20 \
                            --min-p 0 \
                            --presence-penalty 1.5 \
                            --chat-template-kwargs "{\"enable_thinking\": false}" \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };
                };
            };
        };

    };

    systemd.services.llama-swap.serviceConfig = {
        StateDirectory = "llama-swap";
        Environment = [
            "HOME=/var/lib/llama-swap"
            "XDG_CACHE_HOME=/var/lib/llama-swap/.cache"
            "HF_HOME=/var/lib/llama-swap/.cache/huggingface"
            "TRANSFORMERS_CACHE=/var/lib/llama-swap/.cache/huggingface/transformers"
        ];
    };
}