{
  config,
  lib,
  pkgs,
  ...
}: let
  tpLinkArcherTx16750uNano = {
    idVendor = "0bda";
    idProduct = "1a2b";
    realtekDriver = "rtl8852bu";
    kernelModule = "8852au";
  };
  usb-modeswitch = lib.getExe pkgs.usb-modeswitch;
in {
  boot.kernelModules = [
    tpLinkArcherTx16750uNano.kernelModule
  ];

  boot.extraModulePackages = [
    config.boot.kernelPackages."${tpLinkArcherTx16750uNano.realtekDriver}"
  ];

  services.udev.extraRules =
    # The device hosts a Windows mountpoint that functions as CDROM for the driver.
    # This allows the driver to be installed on the Windows host,
    # and the driver code reinterprets the device as an ethernet device.
    # We can install the driver ourselves and simply switch the USB mode to WiFi.
    ''
      ATTR{idVendor}=="${tpLinkArcherTx16750uNano.idVendor}", ATTR{idProduct}=="${tpLinkArcherTx16750uNano.idProduct}", RUN+="${usb-modeswitch} -K -v ${tpLinkArcherTx16750uNano.idVendor} -p ${tpLinkArcherTx16750uNano.idProduct}"
    '';
}
