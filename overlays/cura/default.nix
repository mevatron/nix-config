# overlays/cura/default.nix
args:
final: prev: {
  cura = let
    cura5 = final.appimageTools.wrapType2 rec {
      pname = "cura5";
      version = "5.9.0";
      src = final.fetchurl {
        url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
        hash = "sha256-STtVeM4Zs+PVSRO3cI0LxnjRDhOxSlttZF+2RIXnAp4=";
      };
      extraPkgs = pkgs: with pkgs; [ ];
    };
  in final.writeScriptBin "cura" ''
    #! ${final.bash}/bin/bash
    # AppImage version of Cura loses current working directory and treats all paths relative to $HOME.
    # So we convert each of the files passed as argument to an absolute path.
    # This fixes use cases like `cd /path/to/my/files; cura mymodel.stl anothermodel.stl`.
    args=()
    for a in "$@"; do
      if [ -e "$a" ]; then
        a="$(realpath "$a")"
      fi
      args+=("$a")
    done
    exec "${cura5}/bin/cura5" "''${args[@]}"
  '';
}
