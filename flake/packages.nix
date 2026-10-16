{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages = rec {
        express = pkgs.callPackage ../express.nix { };
        default = express;
      };
    };
}
