{
  config,
  lib,
  pkgs,
  nixvim,
  ...
}:
{
  imports = [
    nixvim.homeModules.nixvim
    ./minimal.nix
    ./accounts.nix
    ./nim-sync.nix
    ./options.nix
    ./packages.nix
    ./programs
    ./ssh.nix
  ];

  laasProxy.enable = lib.mkDefault true;

  home = {
    inherit (config.nim-home) homeDirectory username;
    file = {
      ".config/niri/config.kdl".source = pkgs.concatText "config.kdl" (
        [ ./niri.kdl ] ++ config.nim-home.niri
      );
      ".config/dfc/dfcrc".source = ../../.config/dfc/dfcrc;
      ".config/distrobox/distrobox.conf".source = ../../.config/distrobox/distrobox.conf;
      ".config/kitty/open-actions.conf".source = ../../.config/kitty/open-actions.conf;
      ".config/khal/config".source = ../../.config/khal/config;
      ".config/khard/khard.conf".source = ../../.config/khard/khard.conf;
      ".config/python_keyring/keyringrc.cfg".source = ../../.config/python_keyring/keyringrc.cfg;
      ".config/rofi-rbw.rc".source = ../../.config/rofi-rbw.rc;
      ".config/vdirsyncer/config".source = ../../.config/vdirsyncer/config;
      ".latexmkrc".source = ../../.latexmkrc;
      ".pypirc".source = ../../.pypirc;

      ".xinitrc".text = "exec ${lib.getExe pkgs.i3} > ~/.x.log 2> ~/.x.err";
    };

    keyboard = {
      layout = "fr";
      variant = "ergol";
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
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  services = {
    home-manager.autoExpire.enable = true;
    nim-sync.enable = true;
    ssh-agent.enable = true;
    swaync.enable = true;
    swayidle = {
      enable = true;
      events = {
        before-sleep = lib.getExe pkgs.swaylock;
      };
    };
  };

  systemd = {
    user = {
      services = {
        swaybgs = {
          Install.WantedBy = [ "graphical-session.target" ];
          Service.ExecStart = pkgs.writeShellScript "swaybgs" config.nim-home.swaybgs;
          Unit = {
            Description = "Set wallpaper(s)";
            PartOf = "graphical-session.target";
            After = "graphical-session.target";
          };
        };
      };
      #tmpfiles.rules = [
      #  "L ${config.home.homeDirectory}/.ssh/id_ed25519_sk - - - - ${sops.secrets.ssh-sk1.path}"
      #];
    };
  };
}
