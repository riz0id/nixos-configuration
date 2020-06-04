# most of this file was "inspired" by cleverca22:
# https://github.com/cleverca22/nixos-configs/blob/e25d62b39e16460b83a59763c261deb1ada95839/nixops-managed.nix
{ config, pkgs, options, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;

    config.packageOverrides = pkgs: {
      unstable = import <unstable> {};
      maschinen-system = pkgs.copyPathToStore ./.;
      maschinen-scripts = pkgs.runCommand "maschinen-scripts" {
        xinput = pkgs.xorg.xinput;
        inherit (pkgs) gawk coreutils scrot sox imagemagick i3lock;
      } ''
        cp -r ${./scripts} $out
        chmod -R +w $out
        patchShebangs $out
        substituteAllInPlace $out/polybar-hackspeed.sh
        substituteAllInPlace $out/glitchlock.sh
      '';
    };
  };
  system.extraSystemBuilderCmds = ''
    ln -sv ${
      builtins.path {
        name = "maschinen-nixpkgs";
        path = pkgs.path;
      }
    } $out/maschinen-nixpkgs
    ln -sv ${./overlays} $out/maschinen-overlays
    ln -sv ${./.} $out/maschinen-system
  '';
}
