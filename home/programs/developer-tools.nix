{ pkgs-unstable, pkgs-master, pkgs, llm-agents, ... }:
let
  chrome-devtools-mcp = pkgs-unstable.writeShellApplication {
    name = "chrome-devtools-mcp";
    runtimeInputs = [ pkgs-unstable.nodejs ];
    text = ''
      exec npx --yes chrome-devtools-mcp@latest \
          --executable-path \
          ${pkgs-unstable.google-chrome}/bin/google-chrome-stable \
          --headless \
          "$@"
    '';
  };
in
{
  home.packages = with pkgs-unstable; [
    android-studio
    awscli2

    pkgs.code-review-graph
    cmake
    esphome
    gnumake
    gcc14
    (pkgs.lib.lowPrio handy)
    insomnia
    jetbrains.clion

    jetbrains.datagrip

    go
    jetbrains.goland

    jetbrains.idea

    (llama-cpp.override { cudaSupport = true; })
    pkgs.bubblewrap
    chrome-devtools-mcp
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.junie
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    pkgs.socat

    pkgs.poetry
    python3
    uv
    jetbrains.pycharm

    dotnet-sdk_8
    jetbrains.rider

    google-chrome
    nodejs
    pnpm
    yarn
    jetbrains.webstorm

    # Misc dev tools
    pkgs.mitmproxy
    pkgs.nixpkgs-fmt
    pkgs.okteta
    pkgs.tcpdump
    pkgs.wireshark
  ];
}
