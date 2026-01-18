# overlays/poetry/default.nix
args:
final: prev: {
  poetry = prev.poetry.overridePythonAttrs (oldAttrs: {
    # The error happens during pythonRuntimeDepsCheckHook.
    # Downgrading pbs-installer in the python environment used to build poetry.
    pythonPackagesExtensions = (oldAttrs.pythonPackagesExtensions or [ ]) ++ [
      (python-final: python-prev: {
        pbs-installer = python-prev.pbs-installer.overridePythonAttrs (oldAttrs: rec {
          version = "2025.12.17";
          src = final.fetchPypi {
            pname = "pbs-installer";
            inherit version;
            hash = "sha256-acw/q1uzbqxnivkii90oiiVhC8eq7ns/OwwxVi/iBtQ=";
          };
        });
      })
    ];
  });
}
