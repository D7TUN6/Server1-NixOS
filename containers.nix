# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };

  # Enable container name DNS for non-default Podman networks.
  # https://github.com/NixOS/nixpkgs/issues/226365
  networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."mc-1_16_5-anarchy" = {
    image = "alpine:latest";
    volumes = [
      "/home/server/data/services/datas/d7tun6-space/game_servers/mc-1_16_5-anarchy:/data:rw"
    ];
    ports = [
      "25566:25566/tcp"
      "25576:25576/tcp"
    ];
    cmd = [ "/bin/sh" "/data/mc/start.sh" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc-1_16_5-anarchy"
      "--network=docker-compose_default"
    ];
  };
  systemd.services."podman-mc-1_16_5-anarchy" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-docker-compose_default.service"
    ];
    requires = [
      "podman-network-docker-compose_default.service"
    ];
    partOf = [
      "podman-compose-docker-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-docker-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mc-1_20-anarchy" = {
    image = "alpine:latest";
    volumes = [
      "/home/server/data/services/datas/d7tun6-space/game_servers/mc-1_20-anarchy:/data:rw"
    ];
    ports = [
      "25567:25567/tcp"
      "25577:25577/tcp"
    ];
    cmd = [ "/bin/sh" "/data/mc/start.sh" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc-1_20-anarchy"
      "--network=docker-compose_default"
    ];
  };
  systemd.services."podman-mc-1_20-anarchy" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-docker-compose_default.service"
    ];
    requires = [
      "podman-network-docker-compose_default.service"
    ];
    partOf = [
      "podman-compose-docker-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-docker-compose-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mc-1_7_10-zhora-private" = {
    image = "alpine:latest";
    volumes = [
      "/home/server/data/services/datas/zhora-space/game-servers/mc-1_7_10-zhora-private:/data:rw"
    ];
    ports = [
      "25565:25565/tcp"
      "25575:25575/tcp"
    ];
    cmd = [ "/bin/sh" "/data/mc/start.sh" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc-1_7_10-zhora-private"
      "--network=docker-compose_default"
    ];
  };
  systemd.services."podman-mc-1_7_10-zhora-private" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-docker-compose_default.service"
    ];
    requires = [
      "podman-network-docker-compose_default.service"
    ];
    partOf = [
      "podman-compose-docker-compose-root.target"
    ];
    wantedBy = [
      "podman-compose-docker-compose-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-docker-compose_default" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f docker-compose_default";
    };
    script = ''
      podman network inspect docker-compose_default || podman network create docker-compose_default
    '';
    partOf = [ "podman-compose-docker-compose-root.target" ];
    wantedBy = [ "podman-compose-docker-compose-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-docker-compose-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
