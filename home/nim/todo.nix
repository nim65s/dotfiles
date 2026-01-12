{
  config,
  lib,
  nixvim,
  pkgs,
  ...
}:
{
  imports = [
    nixvim.homeModules.nixvim
    ./packages.nix
    ./programs
  ];
  home = {
    file = {
      ".config/dfc/dfcrc".source = ../../.config/dfc/dfcrc;
      ".config/distrobox/distrobox.conf".source = ../../.config/distrobox/distrobox.conf;
      # TODO: wip bépo / ergol
      #".config/niri/config.kdl".source = ../.config/niri/config.kdl;
      ".config/kitty/open-actions.conf".source = ../../.config/kitty/open-actions.conf;
      ".config/khal/config".source = ../../.config/khal/config;
      ".config/khard/khard.conf".source = ../../.config/khard/khard.conf;
      ".config/python_keyring/keyringrc.cfg".source = ../../.config/python_keyring/keyringrc.cfg;
      ".config/rofi-rbw.rc".source = ../../.config/rofi-rbw.rc;
      ".config/vdirsyncer/config".source = ../../.config/vdirsyncer/config;
      ".ipython/profile_default/ipython_config.py".source =
        ../../.ipython/profile_default/ipython_config.py;
      ".latexmkrc".source = ../../.latexmkrc;
      ".pypirc".source = ../../.pypirc;

      ".xinitrc".text = "exec ${lib.getExe pkgs.i3} > ~/.x.log 2> ~/.x.err";
    };

    sessionVariables = {
      BROWSER = lib.getExe config.programs.firefox.finalPackage;
      CMAKE_BUILD_TYPE = "RelWithDebInfo";
      CMAKE_C_COMPILER_LAUNCHER = "sccache";
      CMAKE_CXX_COMPILER_LAUNCHER = "sccache";
      CMAKE_COLOR_DIAGNOSTICS = "ON";
      CMAKE_EXPORT_COMPILE_COMMANDS = "ON";
      CMAKE_GENERATOR = "Ninja";
      CMEEL_LOG_LEVEL = "DEBUG";
      CTEST_OUTPUT_ON_FAILURE = "ON";
      CTEST_PROGRESS_OUTPUT = "ON";
      DELTA_PAGER = "less -FR";
      GITHUB_TOKEN_CMD = "rbw get github-token";
      NIXOS_OZONE_WL = 1;
      # PAGER = "vim -c PAGER -";
      POETRY_VIRTUALENVS_IN_PROJECT = "true";
      RUSTC_WRAPPER = lib.getExe pkgs.sccache;
      SHELL = lib.getExe pkgs.fish;
      SSH_ASKPASS = "$HOME/scripts/ask_rbw.py";
      SSH_ASKPASS_REQUIRE = "prefer";
      #TWINE_USERNAME = "nim65s";
    };
  };
}
