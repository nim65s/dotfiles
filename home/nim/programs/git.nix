{
  lib,
  pkgs,
  ...
}:
let
  atjoin =
    {
      name,
      host ? "laas.fr",
    }:
    lib.concatStringsSep "@" [
      name
      host
    ];
in
{

  programs.git = {
    enable = true;
    attributes = [
      "*.png diff=exif-diff"
    ];
    lfs.enable = true;
    settings = {

      alias = {
        git = "!exec git";
        lg = "log --graph --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ar)%Creset'";
      };

      blame = {
        ignoreRevsFile = ".git-blame-ignore-revs";
      };

      branch = {
        sort = "-committerdate";
      };

      color = {
        ui = "always";
        branch = "always";
        interactive = "always";
        status = "always";
      };

      column = {
        ui = "auto";
      };

      commit = {
        verbose = true;
      };

      core = {
        excludesfile = "${../../../gitignore}";
      };

      diff = {
        algorithm = "histogram";
        colorMoved = true;
        colorMovedWS = "allow-indentation-change";
        guitool = "meld";
        tool = "nvimdiff";
        renames = "true";
        exif-diff.textconv = lib.getExe pkgs.exif-diff;
      };

      difftool = {
        cmd = "nvimdiff";
        prompt = false;
        icat.cmd = "compare -background none $REMOTE $LOCAL png:- | montage -background none -geometry 200x -font Iosevka $LOCAL - $REMOTE png:- | kitten icat";
      };

      fetch = {
        all = true;
        parallel = 4;
        prune = true;
        # pruneTags = true;
      };

      help = {
        autocorrect = 1;
      };

      hub = {
        protocol = "ssh";
      };

      init = {
        defaultBranch = "main";
      };

      merge = {
        conflictstyle = "zdiff3";
        tool = "nvimdiff";
        guitool = "meld";
      };

      mergetool = {
        meld.cmd = ''
          meld "$LOCAL" "$MERGED" "$REMOTE" --output "$MERGED"
        '';
      };

      user = {
        email = atjoin { name = "guilhem.saurel"; };
        name = "Guilhem Saurel";
        signingKey = "4653CF28";
      };

      pull = {
        ff = "only";
        rebase = true;
      };

      push = {
        autoSetupRemote = true;
        default = "simple";
      };

      rebase = {
        autosquash = true;
        autostash = true;
      };

      rerere = {
        autoupdate = true;
        enabled = true;
      };

      submodule = {
        fetchJobs = 4;
      };

      tag = {
        sort = "version:refname";
      };

      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
        "git@gitlab.laas.fr:" = {
          insteadOf = "https://gitlab.laas.fr/";
        };
      };
    };

    includes = [
      { path = "~/dotfiles/.gitconfig"; }
    ];
  };
}
