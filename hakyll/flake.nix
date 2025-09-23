{
  inputs.nixpkgs.url = "nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:

let pkgs = import nixpkgs { inherit system; };
  builder = pkgs.haskellPackages.developPackage {
    root = pkgs.nix-gitignore.gitignoreSourcePure [ "dist-newstyle" "dist" ".git"] ./.;

    # modifier = drv: pkgs.haskell.lib.overrideCabal drv ({
    #     buildTools = with pkgs.haskellPackages; [
    #       # cabal-install
    #       hakyll
    #       # pkgs.linkchecker
    #     ];
    #   }).overrideAttrs (old: {
    #     LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    #     LC_ALL = "C.UTF-8";
    #   });
  };

  site = pkgs.stdenv.mkDerivation {
    name = "syberant.github.io";
    src = pkgs.nix-gitignore.gitignoreSourcePure [
      ./.gitignore
      ".git"
      "*.cabal"
      "*.hs"
      ".github"
      "builder"
      "dist"
      "dist-newstyle"
    ] ./.;
    buildInputs = [ builder ];
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    LC_ALL = "C.UTF-8";
    buildPhase = ''
      ${builder}/bin/site build
    '';
    installPhase = ''
      cp -r _site $out
    '';
  };
 in {
      apps = {
        site = flake-utils.lib.mkApp {
          drv = builder;
          exePath = "/bin/site";
        };
      };
      packages = {
        inherit builder site;

        # Run `nix build` to build the site
        default = site;
      };

    });
}
