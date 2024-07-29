{ modulesPath, ... }: {
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ./dev.nix
  ];
}
