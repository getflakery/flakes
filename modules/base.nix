{ config, pkgs, inputs, ... }:
{
  # https://www.tweag.io/blog/2020-07-31-nixos-flakes/#pinning-nixpkgs
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  # Makes it so things that require channels can still work
  # such as nix-shell
  nix.nixPath = [
    "nixpkgs=flake:nixpkgs"
  ];

  system.stateVersion = "23.05"; # Did you read the comment?

  services.tailscale = {
    enable = true;
    authKeyFile = "/tsauthkey";
    extraUpFlags = [ "--ssh" ];
  };

  security.sudo.wheelNeedsPassword = false;
  programs.zsh.enable = true;
  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
    group = "alice";
    shell = pkgs.zsh;
    # passwordFile = "/persist/passwords/alice";
  };
  users.groups.alice = { };
  environment.variables = { EDITOR = "nvim"; };
  programs.neovim.enable = true;
  # alias nvim to vim globally
  programs.neovim.vimAlias = true;
  programs.neovim.defaultEditor = true;
  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };


}
