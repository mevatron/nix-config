args: final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyFinal: pyPrev: {
      chromadb = pyPrev.chromadb.overridePythonAttrs (old: {
        doCheck = false;
      });
    })
  ];
}