{ config, clan-core, lib, pkgs, ... }:
{
  imports = [
    # Enables the OpenSSH server for remote access
    clan-core.clanModules.sshd
    # Set a root password
    clan-core.clanModules.root-password
    clan-core.clanModules.user-password
    clan-core.clanModules.state-version
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 30;
  };

  clan = {
    user-password.user = "user";
    core.networking.zerotier.networkId = builtins.readFile (config.clan.core.settings.directory + "/machines/ashitaka/facts/zerotier-network-id");
  };

  console.keyMap = "fr-bepo";

  environment.systemPackages = with pkgs; [
    alacritty
    btop
    coreutils
    dfc
    fd
    file
    htop
    iproute2
    jq
    kitty
    nettools
    ncdu
    pciutils
    psmisc
    ripgrep
    swaylock
    tmux
    usbutils
    zellij
  ];

  networking.firewall = {
    allowedUDPPorts = [ 655 ];
    allowedTCPPorts = [ 655 ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  programs = {
    fish.enable = true;
    niri.enable = true;
    vim.enable = true;
    waybar.enable = true;
    xwayland.enable = true;
  };

  security.pam.services.swaylock = {};

  services = {
    avahi.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        #autoLogin.relogin = true;
        autoNumlock = true;
      };
    };
    tinc.networks.mars = {
      package = pkgs.tinc;
      extraConfig = ''
        ConnectTo = mononoke
      '';
      hostSettings = {
        ashitaka = {
          addresses = [ { address = "192.168.1.205"; port = 655; } ];
          subnets = [ { address = "10.0.55.205"; prefixLength = 32; } ];
        };
        hattori = {
          addresses = [ { address = "192.168.1.200"; port = 655; } ];
          subnets = [ { address = "10.0.55.200"; prefixLength = 32; } ];
        };
        loon = {
          addresses = [ { address = "192.168.1.204"; port = 655; } ];
          subnets = [ { address = "10.0.55.204"; prefixLength = 32; } ];
          rsaPublicKey = ''
            -----BEGIN RSA PUBLIC KEY-----
            MIIBCgKCAQEA59ewksOYFBl2b9LZpNunUYgIndpsA0txhdI10+LG9DjWgdJwvZEk
            Ofj+vEz3f7q5jSTWWHe3OnHWHEVIFeRf8bvc2k62X3LrUSbBaflDzz/mARCrCYg3
            y6+fmCCFrBKTPg8eE9FVawj0kC6Gr3OVOlLOZGK6QnqQDRFBDqGqp6DsLVQz9U0d
            djF5I8oGiH6yPAWHys2ltb+H82JBSCXR5L5QwifFlz1sKFbIdVUt0pwm9iSuD9NG
            mW4iaYgx/BdEez6BkjhhsQ4HQNRJdpDwVggJ7+sHaw6oZcYO9/Go8zvclfui0T7K
            03l89MUl9w6XVd2ty0U3hIJiv9Y+WBcVpwIDAQAB
            -----END RSA PUBLIC KEY-----
          '';
        };
        mononoke = {
          addresses = [ { address = "mononoke.tetaneutral.net"; port = 53; } ];
          subnets = [ { address = "10.0.55.50"; prefixLength = 32; } ];
          rsaPublicKey = ''
            -----BEGIN RSA PUBLIC KEY-----
            MIIBCgKCAQEA2qxK/9BExnz3Z9sO9GN36WEN+tdVCJ+9ipa80H/FEinkLUlIEwED
            NuXtA7yKmSCqBP4lpF+HlvBlTStDkfWflgCviU081AVTNMPfqUHIv9ZOO9K8z/dX
            FVRuNypTf4Ro394N3EG3gYa7ZNgsu8wq6jgWyrUsuPt/1bTbjyxLxeyXo2dcU1u4
            /9fNQvx6x4zx36+giC3ovhKfJc2mlConp+y6Xy0mmBJzH28gq2zrEQMX5IvoHlZq
            YdD3pjHJPADTLitDVq7C7mCd4EHxOqVyuJ2jxb86jZeCHZl1x1+1TpitIQeqidPb
            4FRxihVFUsRckfxzjaoPt9HmAWpvb5bd6QIDAQAB
            -----END RSA PUBLIC KEY-----
          '';
        };
        perseverance = {
          addresses = [ { address = "192.168.1.10"; port = 655; } ];
          subnets = [ { address = "10.0.55.10"; prefixLength = 32; } ];
          rsaPublicKey = ''
            -----BEGIN RSA PUBLIC KEY-----
            MIICCgKCAgEAzo1ChjEu0veHhxGKNT1GiizwBvrIUclgEI9iyYQMzLRMHXf11wKG
            X/4OjJkHxRmSB9Q51JSGO7qhe/r6oMxKWBCZLVvqRJslMTSh0B51BZXmZcSwTPUF
            SjPWIMUEwnY6b4FwoleWEgLlEcgjUl5a25TiFjB59leTRmThekycmX6Vfy3gO2HD
            CWEQ6lfwtF5zypO/Eg9oeDs7sSkMbhxBzP0NhUTXQyrzmliUh5gqc8T0nZuUMxpM
            +Q7xPt/wfpFizkSqC0fQoFd75AawzHRedGKoNXWeOO6tixJ3eW2vovoeNj5j6o78
            LLYm2AzIBBTpMLVpmkpuwawCVrsiAhRwLLp/PZ2nPK26irwT2/Zx4vCQldtJfnO8
            lADYDpXfSGZoV9SZXWoCHa1jrUkN9jW05BY5Iqrg7cdxa8WAyOWJrRf8o/FKtydM
            mbdB7sA3Uouaz5Kq80xywx1eja5+79JemrHWSr5gbO3g+rfpE6urJ7Fb6RxPO2dT
            +JHXFaF/PPV8wAoE8Jm+HYZjan9Hvm9UcaUfuO+Hd3ZRrfqugG/H3bmOxsVyVoM0
            6mgmm6vxzVMHqVSUd0bLJAcl4cd36iyTOAujPDF15GYIDaKKalytA7/5bg7m6+N/
            mX00uD1wdMFmA1e9WA0w5UWEIQew1axJ7uQvQAjcRRu8Cl4Zo4/ef2sCAwEAAQ==
            -----END RSA PUBLIC KEY-----
          '';
        };
        yupa = {
          addresses = [ { address = "192.168.1.203"; port = 655; } ];
          subnets = [ { address = "10.0.55.203"; prefixLength = 32; } ];
          rsaPublicKey = ''
            -----BEGIN RSA PUBLIC KEY-----
            MIICCgKCAgEApVjLzS8Wy/lPnGrFyrXjVoVm6SlE3aFoWhY+WS2jQ+0d2yTxdzqI
            utTwPDRIIwxs6WaVDxZl43d+28qruxqONK7tJnx7KEuaWphvq6wmZTH56qg8Dkgi
            ME1/jn9pdZTrU7twFydCQUaIUTXI2INGE3U6dFA+B9p9VO89QL7RcEJbsv+TzZlR
            Kjiq5LGZXhQ+40fY8iX6zia7YBe+a4bR/+8nu/FWff3LuLiyWy6E+XfuDjG5rbi8
            6f1JDdM1Pfly/cmDnZME0bC9lhu4t6vmAJF57NLOC7c1tePmPN8o2habcBjmY09j
            B/YHi17lk4YT0oV5H98PZXiBzdASvahkN1yKR6dHfq37l1M2+wuJfpPsa5M/vkO6
            94RqTEsbrSczEOx+vGxkufcNHV3FPG2z+apJ9TxA2bmhisGnrNuzwoJRuIivcIG1
            tdc6s15eB1HO/79t6wX7MEtYecPtfCv2/UxKT5y8IuzIFkh+jjYBMXsVjN/L+1M0
            z3iWEbWL7CMiSI8kNlvsVEizbk8OAtKITVuBnOcP4UaUM/T2LiSkLNCR3Q34n4Cj
            nRqHGwNFubZwTuITLvtWxRAAqq9BS8i+uKqD0AmxEdsQ38RJOWKBTSH5Zo7H1Tde
            wdgpTYfQ1+5PV+6ipdI2GHYlxncLtMzeZtXDeeCAHmarNOkO32fasL8CAwEAAQ==
            -----END RSA PUBLIC KEY-----
          '';
        };
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "fr";
      windowManager.i3.enable = true;
    };
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH38Iwc5sA/6qbBRL+uot3yqkuACDDu1yQbk6bKxiPGP nim@loon"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBbE5nRZpgFdZJgC+hTzdyYLxKUBY59WFYOQ/O1oxwc gsaurel@upepesanke"
    ];
    user = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "input"
      ];
      uid = 1000;
      openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    };
  };
}
