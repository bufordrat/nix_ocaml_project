{ nixpkgs ? import <nixpkgs> {} } :

let
  inherit (nixpkgs) pkgs;
  ocamlPackages = pkgs.recurseIntoAttrs pkgs.ocaml-ng.ocamlPackages_latest;
  prelude = pkgs.stdenv.mkDerivation rec {
    pname = "prelude";
    name = "prelude";

    src = fetchMercurial "https://www.lib.uchicago.edu/keith/hg/prelude";

    nativeBuildInputs = [ pkgs.ocaml ];

    makeFlags = [ "PREFIX=$(out)" ];
    installTargets = "install";
    installFlags = [
      "LIBDIR=$(out)/lib/ocaml/${pkgs.ocaml.version}/site-lib/${pname}"
      "DOCDIR=$(out)/share/doc/${pname}"
    ];

  };
in


pkgs.mkShell {
  name = "cecilia-env";
  buildInputs = with pkgs;
      [
        ocamlPackages.dune_3
        ocamlPackages.findlib
        ocamlPackages.ocaml
        ocamlPackages.utop
        ocamlPackages.re
        prelude
      ];
}
