{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        inherit (config.checks.prek) shellHook;
        buildInputs = [
          pkgs.gnused
          pkgs.just
          pkgs.nvfetcher
        ]
        ++ config.checks.prek.enabledPackages;
      };
    };
}
