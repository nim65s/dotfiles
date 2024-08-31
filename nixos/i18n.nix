_:
let
  fr = "fr_FR.UTF-8";
in
{
  i18n = {
    defaultLocale = fr;
    extraLocaleSettings = {
      LC_ADDRESS = fr;
      LC_IDENTIFICATION = fr;
      LC_MEASUREMENT = fr;
      LC_MONETARY = fr;
      LC_NAME = fr;
      LC_NUMERIC = fr;
      LC_PAPER = fr;
      LC_TELEPHONE = fr;
      LC_TIME = fr;
    };
  };
}
