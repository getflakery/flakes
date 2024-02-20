{ config, lib, pkgs, app ... }:

let
  flakeryDomain = builtins.readFile /metadata/flakery-domain;
in
{
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    systemd.services.go-webserver = {
      description = "go webserver";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${app}/bin/app";
        Restart = "always";
        KillMode = "process";
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts."${flakeryDomain}".extraConfig = ''
        handle /* {
          reverse_proxy http://127.0.0.1:8080
        }
      '';
    };
}
