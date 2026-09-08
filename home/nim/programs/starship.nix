{
  programs.starship = {
    presets = [
      "nerd-font-symbols"
    ];
    settings = {
      format = "┬─ $all$time$line_break╰─ $jobs$battery$status$container$os$shell$character";
      time.disabled = false;
      status.disabled = false;
      package.disabled = true;
      os.disabled = false;
      shell = {
        disabled = false;
        fish_indicator = "";
        bash_indicator = "";
      };
      username.format = "[$user]($style)@";
      hostname.ssh_symbol = "";
    };
  };
}
