self: super:
let
  inherit (self) lib;
  sway-unwrapped =
    (super.sway-unwrapped.overrideAttrs (
      finalAttrs: previousAttrs: {
        src = self.fetchFromGitHub {
          owner = "svalaskevicius";
          repo = "sway";
          rev = "hiding-lone-titlebar-scenegraph";
          hash = "sha256-cXBEXWUj3n9txzpzDgl6lsNot1ag1sEE07WAwfCLWHc=";
        };
      }
    )).override
      {
        wlroots = super.wlroots.overrideAttrs {
          version = "0.18.0-dev";
          src = self.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "wlroots";
            repo = "wlroots";
            rev = "873e8e455892fbd6e85a8accd7e689e8e1a9c776";
            hash = "sha256-5zX0ILonBFwAmx7NZYX9TgixDLt3wBVfgx6M24zcxMY=";
          };
          patches = [ ];
        };
      };
in
{
  gruppled-white-lite-cursors = self.callPackage ./gruppled-lite-cursors {
    theme = "gruppled_white_lite";
  };
  sauce-code-pro = self.nerdfonts.override { fonts = [ "SourceCodePro" ]; };
  sway = super.sway.override { inherit sway-unwrapped; };
}
