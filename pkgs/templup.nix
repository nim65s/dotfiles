{
  writeShellApplication,
}:
writeShellApplication {
  name = "templup";
  text = builtins.readFile ../bin/templup;
}
