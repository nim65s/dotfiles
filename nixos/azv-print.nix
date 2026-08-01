{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    simple-scan
  ];

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr2 ];
    };
    saned.enable = true;
  };

  hardware = {
    printers = {
      ensureDefaultPrinter = "EPSON_WF-3725_Pro";
      ensurePrinters = [
        {
          deviceUri = "http://epson.azv:631/ipp/print";
          location = "azv";
          name = "EPSON_WF-3725_Pro";
          model = "epson-inkjet-printer-escpr2/Epson-WF-3720_Series-epson-escpr2-en.ppd";
        }
      ];
    };
    sane = {
      enable = true;
      extraBackends = [
        (pkgs.epkowa.overrideAttrs (oldAttrs: {
          postInstall = oldAttrs.postInstall + ''
            echo "net epson.azv" >> $out/etc/sane.d/epkowa.conf
          '';
        }))
      ];
      netConf = "epson.azv";
    };
  };
}
