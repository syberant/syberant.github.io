{ pkgs ? import <nixpkgs> {} }:

let blog = import ./hakyll/default.nix { inherit pkgs; };
in pkgs.stdenv.mkDerivation {
  name = "pages.infiniterecursion.eu";

  src = ./.;

  buildCommand = ''
    mkdir -p $out

    cp --recursive $src/evolvim $out
    cp $src/*.html $out
    cp --recursive ${blog} $out/blog
  '';
}
