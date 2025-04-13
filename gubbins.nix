{
  buildNpmPackage,
  fetchFromGitea,
  ...
}: buildNpmPackage rec {
  pname = "gubbins";
  version = "0.0.4";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "HU90m";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7YlogUqTkjP52Ovv7qcNxzW6YHAWgSG2OAPkupRQtOM=";
  };
  dontNpmBuild = true;
  npmDepsHash = "sha256-NWiPyGAMYR10S2m4F5fXXAVUnyovRuJ/mhfNr1QByug=";
}
