{
  pkgs,
  ...
}:
{
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr2 ];
    };
    saned.enable = true;
  };
  hardware = {
    printers = {
      ensureDefaultPrinter = "EPSON_WF-3720_Series";
      ensurePrinters = [
        {
          deviceUri = "ipp://epson.azv/ipp";
          location = "azv";
          name = "EPSON_WF-3720_Series";
          model = "EPSON WF-3720 Series";
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
