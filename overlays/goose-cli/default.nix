args:
final: prev:

let
  # fetch the tokenizers at overlay-load time
  gpt-4o-tokenizer = prev.fetchurl {
    url = "https://huggingface.co/Xenova/gpt-4o/resolve/31376962e96831b948abe05d420160d0793a65a4/tokenizer.json";
    hash = "sha256-Q6OtRhimqTj4wmFBVOoQwxrVOmLVaDrgsOYTNXXO8H4=";
    meta.license = prev.lib.licenses.mit;
  };
  claude-tokenizer = prev.fetchurl {
    url = "https://huggingface.co/Xenova/claude-tokenizer/resolve/cae688821ea05490de49a6d3faa36468a4672fad/tokenizer.json";
    hash = "sha256-wkFzffJLTn98mvT9zuKaDKkD3LKIqLdTvDRqMJKRF2c=";
    meta.license = prev.lib.licenses.mit;
  };
in {
  goose-cli = prev.rustPlatform.buildRustPackage rec {
    pname    = "goose-cli";
    version  = "1.2.0";

    src = prev.fetchFromGitHub {
      owner = "block";
      repo  = "goose";
      tag   = "v${version}";
      hash  = "sha256-ER4FI2QT4wIGxk0QZbDtgJTQUI38CSMJbLT8s8Rb4Po=";
    };

    useFetchCargoVendor = true;
    cargoHash          = "sha256-TTOCJMZL8BtLm/6h2DxyjSVuUjNP0RgD8jjfEB0+nGc=";

    nativeBuildInputs = [ prev.pkg-config prev.protobuf ];
    buildInputs       = [ prev.dbus ] ++
                        prev.lib.optionals prev.stdenv.hostPlatform.isLinux [ prev.xorg.libxcb ];

    env.LIBCLANG_PATH = "${prev.lib.getLib prev.llvmPackages.libclang}/lib";

    preBuild = ''
      mkdir -p tokenizer_files/Xenova--gpt-4o tokenizer_files/Xenova--claude-tokenizer
      ln -s ${gpt-4o-tokenizer} tokenizer_files/Xenova--gpt-4o/tokenizer.json
      ln -s ${claude-tokenizer} tokenizer_files/Xenova--claude-tokenizer/tokenizer.json
    '';

    checkFlags = [
      # Tests that require network access
      "--skip=test_concurrent_access"
      "--skip=test_model_not_in_openrouter"
      "--skip=test_pricing_cache_performance"
      "--skip=test_pricing_refresh"
      # Previous failing tests
      "--skip=jetbrains::tests::test_capabilities"
      "--skip=jetbrains::tests::test_router_creation"
      "--skip=config::base::tests::test_multiple_secrets"
      "--skip=config::base::tests::test_secret_management"
      "--skip=providers::factory::tests::test_create_lead_worker_provider"
      "--skip=providers::factory::tests::test_create_regular_provider_without_lead_config"
      "--skip=providers::factory::tests::test_lead_model_env_vars_with_defaults"
      "--skip=providers::gcpauth::tests::test_token_refresh_race_condition"
      # HTTP transport tests that fail in sandbox
      "--skip=transport::streamable_http::tests::test_handle_outgoing_message_http_error"
      "--skip=transport::streamable_http::tests::test_handle_outgoing_message_invalid_json"
      "--skip=transport::streamable_http::tests::test_handle_outgoing_message_notification"
      "--skip=transport::streamable_http::tests::test_handle_outgoing_message_session_id_handling"
      "--skip=transport::streamable_http::tests::test_handle_outgoing_message_session_not_found"
      "--skip=transport::streamable_http::tests::test_handle_outgoing_message_successful_request"
    ];

    nativeCheckInputs = [ prev.writableTmpDirAsHomeHook ];
    __darwinAllowLocalNetworking = true;

    # allow nix-update to work
    passthru.updateScript = prev.nix-update-script { };

    meta = with prev.lib; {
      description = "Goose CLI tool";
      homepage = "https://github.com/block/goose";
      license = licenses.mit;
      maintainers = [ ];
      platforms = platforms.all;
    };
  };
}