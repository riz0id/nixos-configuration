{ pkgs, ... }:

{
  # broken
  boot.blacklistedKernelModules = [ "i915" ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      s3tcSupport = true;
      extraPackages = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
    };

    nvidia = {
      modesetting.enable = true;
      prime = {
        sync.enable = true;
        # offload.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  services.devmon.enable = true;
  services.udisks2.enable = true;

  services.xserver = {
    enable = true;

    layout = "us";
    xkbOptions = "ctrl:nocaps";
    #dpi = 96;

    libinput = {
      enable = true;
      naturalScrolling = false;
      middleEmulation = true;
      tapping = true;
    };

    desktopManager.xterm.enable = true;
    displayManager.lightdm = {
      enable = true;

      greeter.enable = false;
      autoLogin.enable = true;
      # FIXME
      autoLogin.user = "riz";
    };
    windowManager.session = [{
      name = "dummy";
      start = "${pkgs.coreutils}/bin/true";
    }];
  };
}
