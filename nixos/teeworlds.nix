{
  services = {
    teeworlds = {
      enable = true;
      openPorts = true;
      name = "TODO";
      motd = "TODO";
      extraOptions = [
        "sv_maprotation dm1 dm2 dm6 dm7 dm8 dm9 ctf1 lms1"
      ];
      game = {
        timeLimit = 3;
        enableTeamDamage = false;
      };
      server = {
        bindAddr = "TODO";
        enableHighBandwidth = true;
      };
    };
  };
}
