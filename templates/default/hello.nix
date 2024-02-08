# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";


  system.stateVersion = "23.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
  };
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
  users.users."alice".openssh.authorizedKeys.keys = [
    # replace with your ssh key                                                       <
    "ssh-ed25519 NOTAREALKEYBUTTHISISWHEREYOURSSHOULDBEdslkfjsoi3cjnefoODIUFNI0JDNCKL+" # content of authorized_keys file
  ];

}
