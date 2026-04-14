args:
final: prev: {
  code-review-graph = final.python3Packages.buildPythonApplication rec {
    pname = "code-review-graph";
    version = "2.3.1";
    pyproject = true;

    src = final.fetchFromGitHub {
      owner = "tirth8205";
      repo = "code-review-graph";
      tag = "v${version}";
      hash = "sha256-lUVXLI7A4vk59gw9dbpFYAZWCenMpghmTU+bd1m8uuU=";
    };

    build-system = with final.python3Packages; [
      hatchling
    ];

    dependencies = with final.python3Packages; [
      fastmcp
      mcp
      networkx
      tree-sitter
      tree-sitter-language-pack
      watchdog
    ];

    # Upstream's current bounds do not match this flake's pinned nixpkgs:
    # fastmcp is older than requested, while watchdog is newer.
    pythonRelaxDeps = [
      "fastmcp"
      "watchdog"
    ];

    pythonImportsCheck = [
      "code_review_graph"
    ];

    doCheck = false;

    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (final.lib.makeBinPath [ final.gitMinimal ])
    ];

    meta = with final.lib; {
      description = "Persistent incremental knowledge graph for token-efficient, context-aware code reviews";
      homepage = "https://github.com/tirth8205/code-review-graph";
      changelog = "https://github.com/tirth8205/code-review-graph/releases/tag/v${version}";
      license = licenses.mit;
      mainProgram = "code-review-graph";
    };
  };
}
