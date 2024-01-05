{ pkgs-unstable, config, lib, ... }:

(final: prev: {
    ollama = pkgs-unstable.ollama;
})