{
  pkgs,
  ...
}:
{
  documentation = {
    enable = false;
    man.enable = false;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  programs.nixvim.plugins = {
    lsp.servers.clangd.enable = false;
    plantuml-syntax.enable = false;
    yazi.enable = false;
  };

  home-manager.users = {
    root.programs = {
      man.enable = false;
      yazi.enable = false;
    };
    nim.programs = {
      man.enable = false;
      yazi.enable = false;
    };
  };

  stylix = {
    cursor = null;
    targets.qt.enable = false;
    fonts.monospace = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans Mono";
    };
  };
}
