{ pkgs ? import <nixpkgs> {} }:

let
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

  watch = let derivation = pkgs.writeShellScript "hakyll-watch" ''
    xdg-open _site/index.html;

    ${builder}/bin/site watch
    '';
    in {
    type = "app";
    program = "${derivation}";
  };

 in site
