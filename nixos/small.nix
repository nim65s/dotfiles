{
  pkgs,
  ...
}:
{
  programs.nixvim.plugins = {
    lsp.servers.clangd.enable = false;
    plantuml-syntax.enable = false;
    yazi.enable = false;
  };

  home-manager.users.nim.programs.yazi.enable = false;
  home-manager.users.root.programs.yazi.enable = false;

  stylix = {
    targets.qt.enable = false;
    fonts.monospace = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans Mono";
    };
  };
}
