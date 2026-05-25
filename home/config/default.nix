{ config, pkgs, ... }:

let
  install = "${pkgs.coreutils}/bin/install";

  zeroCost = {
    input = 0;
    output = 0;
    cacheRead = 0;
    cacheWrite = 0;
  };

  subagentRoutineModel = "llama-swap/qwen-3.6-27b-thinking-unsloth";
  subagentScoutModel = "llama-swap/qwen-3.6-35b-a3b-thinking-unsloth";
  subagentOracleModel = "openrouter/openai/gpt-5.5";

  piSettings = {
    defaultProvider = "llama-swap";
    defaultModel = "qwen-3.6-27b-thinking-unsloth";
    defaultThinkingLevel = "high";
    hideThinkingBlock = false;
    packages = [
      "npm:pi-subagents"
      "npm:pi-mcp-adapter"
      "npm:pi-guard-sandbox"
      "npm:pi-hermes-memory"
    ];
    enabledModels = [
      "qwen-3.6-*-thinking-unsloth"
      "anthropic/claude-*"
      "openai/gpt-*"
      "google/gemini-*"
      "qwen/qwen3-*"
      "deepseek/*"
    ];
    subagents = {
      agentOverrides = {
        scout = {
          model = subagentScoutModel;
          thinking = "low";
        };
        context-builder = {
          model = subagentRoutineModel;
          thinking = "medium";
        };
        planner = {
          model = subagentRoutineModel;
          thinking = "high";
        };
        worker = {
          model = subagentRoutineModel;
          thinking = "high";
        };
        reviewer = {
          model = subagentRoutineModel;
          thinking = "high";
        };
        delegate = {
          model = subagentRoutineModel;
          thinking = "medium";
        };
        researcher = {
          model = subagentRoutineModel;
          thinking = "medium";
        };
        oracle = {
          model = subagentOracleModel;
          thinking = "high";
        };
      };
    };
  };

  qwenThinkingModel = id: name: contextWindow: {
    inherit id name contextWindow;
    reasoning = true;
    input = [ "text" ];
    maxTokens = 32768;
    cost = zeroCost;
    thinkingLevelMap = {
      off = null;
    };
  };

  piModels = {
    providers = {
      "llama-swap" = {
        baseUrl = "http://127.0.0.1:11435/v1";
        api = "openai-completions";
        apiKey = "llama-swap";
        compat = {
          supportsDeveloperRole = false;
          supportsReasoningEffort = false;
          supportsUsageInStreaming = false;
          supportsStore = false;
          supportsStrictMode = false;
          maxTokensField = "max_tokens";
        };
        models = [
          (qwenThinkingModel "qwen-3.6-27b-thinking-unsloth" "Qwen 3.6 27B Thinking (llama-swap)" 120000)
          (qwenThinkingModel "qwen-3.6-35b-a3b-thinking-unsloth" "Qwen 3.6 35B A3B Thinking (llama-swap)" 180000)
        ];
      };

      openrouter = {
        baseUrl = "https://openrouter.ai/api/v1";
        api = "openai-completions";
        apiKey = "OPENROUTER_API_KEY";
      };
    };
  };
in
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

      ".pi/agent/settings.json" = {
        target = ".pi/agent/settings.json_source";
        text = builtins.toJSON piSettings;
        onChange = ''
          ${install} -D -m 0600 ~/.pi/agent/settings.json_source ~/.pi/agent/settings.json
        '';
      };

      ".pi/agent/models.json" = {
        target = ".pi/agent/models.json_source";
        text = builtins.toJSON piModels;
        onChange = ''
          ${install} -D -m 0600 ~/.pi/agent/models.json_source ~/.pi/agent/models.json
        '';
      };
    };
  };
}
