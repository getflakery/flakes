{ ... }: {
  services.prometheus = {
    enable = true;
    port = 9090;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };
  # allow port 9002
  networking.firewall.allowedTCPPorts = [ 9002 ];
}
