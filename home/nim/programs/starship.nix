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
    };
  };
}
