final: prev: {
  immich = prev.immich.overrideAttrs (finalAttrs: previousAttrs: {
    version = "v3.0.1";
    src = prev.fetchFromGitHub {
        owner = "immich-app";
        repo = "immich";
        tag = finalAttrs.version;
        hash = "sha256-Z18SEjUdFP2/grQtHFI6J7CVcAMalshPt3Sd4tGXsDw=";
    };
  });
}
