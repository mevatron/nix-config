{ config, pkgs, lib, ...}:

let
  sunshineOverride = pkgs.sunshine.override {
    cudaSupport = true;
    stdenv = pkgs.cudaPackages.backendStdenv;
  };
in

with lib;

{

  environment.systemPackages = with pkgs; [
    sunshineOverride
  ];

  services.sunshine = {
    package = sunshineOverride;
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}