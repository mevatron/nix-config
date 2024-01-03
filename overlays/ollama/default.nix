{ pkgs-unstable, config, lib, ... }:

(self: super: {
    ollama = pkgs-unstable.ollama;
})