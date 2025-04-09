{
  buildNpmPackage,
  fetchFromGitea,
  ...
}: buildNpmPackage rec {
  pname = "gubbins";
  version = "0.0.3";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "HU90m";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uZ8nzYbeDbS8YK56lbYr5LRuNbGWeEfagg+xt4Y5mqs=";
  };
  dontNpmBuild = true;
  npmDepsHash = "sha256-NWiPyGAMYR10S2m4F5fXXAVUnyovRuJ/mhfNr1QByug=";
}
