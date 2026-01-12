_:
let
  atjoin =
    {
      name,
      host ? "laas.fr",
    }:
    "${name}@${host}";
in
{
  accounts = {
    email = {
      maildirBasePath = ".mails";
      accounts = {
        cnrs = {
          address = atjoin {
            name = "guilhem.saurel";
            host = "cnrs.fr";
          };
          imap.host = "imap.cnrs.fr";
          imap.port = 993;
          smtp.host = "smtp.cnrs.fr";
          smtp.port = 587;
          smtp.tls.useStartTls = true;
          neomutt.enable = false;
          notmuch.enable = true;
          notmuch.neomutt.enable = true;
          offlineimap.enable = true;
          passwordCommand = "rbw get webmail.cnrs.fr";
          realName = "Guilhem Saurel";
          thunderbird = {
            enable = true;
            profiles = [ "nim" ];
            perIdentitySettings = id: {
              "mail.identity.id_${id}.fcc_reply_follows_parent" = true;
              "layers.acceleration.disabled" = true; # TODO
            };
          };
          userName = atjoin {
            name = "guilhem.saurel";
            host = "ods.services";
          };
        };

        laas =
          let
            mail = atjoin { name = "guilhem.saurel"; };
          in
          {
            address = mail;
            aliases = [
              (atjoin { name = "gsaurel"; })
              (atjoin { name = "saurel"; })
            ];
            imap.host = "imap.laas.fr";
            imap.port = 993;
            msmtp.enable = true;
            neomutt.enable = false;
            notmuch.enable = true;
            notmuch.neomutt.enable = true;
            offlineimap.enable = true;
            passwordCommand = "rbw get --folder laas main";
            primary = true;
            realName = "Guilhem Saurel";
            smtp.host = "smtp.laas.fr";
            smtp.tls.useStartTls = true;
            thunderbird = {
              enable = true;
              profiles = [ "nim" ];
              perIdentitySettings = id: {
                "mail.identity.id_${id}.fcc_reply_follows_parent" = true;
                "layers.acceleration.disabled" = true; # TODO
              };
            };
            userName = "gsaurel";
          };

        perso =
          let
            mail = atjoin {
              name = "guilhem";
              host = "saurel.me";
            };
          in
          {
            address = "${mail}";
            folders.inbox = "INBOX";
            imap.host = "mail.gandi.net";
            msmtp.enable = true;
            neomutt = {
              enable = true;
              extraConfig = ''
                set hostname="saurel.me"
                my_hdr Bcc: ${mail}
              '';
            };
            notmuch.enable = true;
            notmuch.neomutt.enable = true;
            offlineimap.enable = true;
            passwordCommand = "rbw get --folder mail perso";
            realName = "Guilhem Saurel";
            smtp.host = "mail.gandi.net";
            smtp.tls.enable = true;
            userName = atjoin {
              name = "guilhem";
              host = "saurel.me";
            };
          };
      };
    };
  };
}
