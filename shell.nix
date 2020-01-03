with import <nixpkgs> {};
mkShell {
  buildInputs = [
    ansible
    python37Packages.netaddr
    vagrant
  ];
}
