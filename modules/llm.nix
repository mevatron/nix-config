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
                    "qwen-3.6-27b-thinking-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/Qwen3.6-27B-GGUF:UD-Q4_K_XL \
                            --jinja \
                            -ngl 99 \
                            --flash-attn auto \
                            --swa-full \
                            -b 1024 \
                            -ub 512 \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --ctx-size 128000 \
                            --parallel 1 \
                            --temp 0.6 \
                            --top-p 0.95 \
                            --top-k 20 \
                            --min-p 0 \
                            --presence-penalty 0.0 \
                            --repeat-penalty 1.0 \
                            --chat-template-kwargs "{\"enable_thinking\": true, \"preserve_thinking\": true}" \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };

                    "qwen-3.6-27b-instruct-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/Qwen3.6-27B-GGUF:UD-Q4_K_XL \
                            --jinja \
                            -ngl 99 \
                            --flash-attn auto \
                            --swa-full \
                            -b 1024 \
                            -ub 512 \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --ctx-size 128000 \
                            --parallel 1 \
                            --temp 0.7 \
                            --top-p 0.80 \
                            --top-k 20 \
                            --min-p 0 \
                            --presence-penalty 1.5 \
                            --repeat-penalty 1.0 \
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
                            --parallel 1 \
                            --temp 1.0 \
                            --top-p 0.95 \
                            --top-k 64 \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };

                    "qwen-3-embedding-4b" = {
                        cmd = ''
                          ${llama-server} \
                            -hf Qwen/Qwen3-Embedding-4B-GGUF:Q8_0 \
                            -ngl 99 \
                            -np 32 \
                            --embedding \
                            --pooling last \
                            -ub 8192 \
                            --ctx-size 32768 \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };

                    "qwen-3.6-35b-a3b-thinking-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-IQ4_NL_XL \
                            --jinja \
                            -ngl 99 \
                            --flash-attn auto \
                            --swa-full \
                            -b 1024 \
                            -ub 512 \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --ctx-size 180000 \
                            --parallel 1 \
                            --temp 0.6 \
                            --top-p 0.95 \
                            --top-k 20 \
                            --min-p 0 \
                            --presence-penalty 0.0 \
                            --repeat-penalty 1.0 \
                            --chat-template-kwargs "{\"enable_thinking\": true, \"preserve_thinking\": true}" \
                            --host 127.0.0.1 \
                            --port ''${PORT}
                        '';
                    };

                    "qwen-3.6-35b-a3b-instruct-unsloth" = {
                        cmd = ''
                          ${llama-server} \
                            -hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-IQ4_NL_XL \
                            --jinja \
                            -ngl 99 \
                            --flash-attn auto \
                            --swa-full \
                            -b 1024 \
                            -ub 512 \
                            --cache-type-k q8_0 \
                            --cache-type-v q8_0 \
                            --ctx-size 180000 \
                            --parallel 1 \
                            --temp 1.0 \
                            --top-p 0.95 \
                            --top-k 20 \
                            --min-p 0 \
                            --presence-penalty 1.5 \
                            --repeat-penalty 1.0 \
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
