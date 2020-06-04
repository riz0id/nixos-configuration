{ ... }:

{
  networking = {
    hostName = "athodyd";
    hostId = "1337babe"; # haHAA

    interfaces.wlp2s0.useDHCP = true;

    networkmanager.enable = true;
  };
}
