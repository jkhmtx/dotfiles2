{pkgs, ...}: {
  config = {
    home.packages = [pkgs.ardour pkgs.guitarix pkgs.qjackctl];
  };
}
