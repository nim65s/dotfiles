{
  exiftool,
  gnugrep,
  writeShellApplication,
}:
writeShellApplication {
  name = "exif-diff";
  runtimeInputs = [
    exiftool
    gnugrep
  ];
  text = ''
    exiftool -sort "$1" | grep -v 'File Name\|Directory\|Date/Time\|Permissions'
  '';
}
