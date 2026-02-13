{ config, ... }:
{
  clan.core.vars.generators.access-tokens = {
    prompts.tokens-input.description = "your nix access-tokens, eg. 'github.com=ghp_eHWJ…xq0'";
    files.conf.secret = true;
    files.conf.owner = "nim";
    script = ''
      echo "access-tokens = $(cat $prompts/tokens-input)" > $out/conf
    '';
    share = true;
  };

  nix.extraOptions = ''
    !include ${config.clan.core.vars.generators.access-tokens.files.conf.path}
  '';

  home-manager.users.nim.nix.extraOptions = ''
    !include ${config.clan.core.vars.generators.access-tokens.files.conf.path}
  '';
}
