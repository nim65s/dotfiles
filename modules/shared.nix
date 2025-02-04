{
  config,
  clan-core,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Enables the OpenSSH server for remote access
    clan-core.clanModules.sshd
    # Set a root password
    clan-core.clanModules.root-password
    clan-core.clanModules.user-password
    clan-core.clanModules.state-version
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 30;
  };

  catppuccin.enable = true;

  clan = {
    user-password.user = "user";
    core.networking.zerotier.networkId = builtins.readFile (
      config.clan.core.settings.directory + "/machines/ashitaka/facts/zerotier-network-id"
    );
  };

  console.keyMap = "fr-bepo";

  environment.systemPackages = with pkgs; [
    alacritty
    btop
    coreutils
    cntr
    dfc
    fd
    file
    graphviz
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
    tig
    tmux
    usbutils
    zellij
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.root = import ./root-home-minimal.nix;
  };

  i18n.defaultLocale = "fr_FR.UTF-8";

  networking.firewall = {
    allowedTCPPorts = [ 655 ];
    allowedUDPPorts = [ 655 ];
  };

  nix = {
    extraOptions = ''
      !include ${config.sops.secrets.nix-access-tokens.path}
    '';
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    package = pkgs.lix;
    settings = {
      extra-substituters = [
        "https://gepetto.cachix.org"
        "https://nim65s.cachix.org"
        "https://nix-community.cachix.org"
        "https://rycee.cachix.org"
        "https://ros.cachix.org"
      ];
      extra-trusted-public-keys = [
        "gepetto.cachix.org-1:toswMl31VewC0jGkN6+gOelO2Yom0SOHzPwJMY2XiDY="
        "nim65s.cachix.org-1:aycmWbuJijDcr9npRLM/2X76kY86iToBI2tlkpp2BLE="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      ];
    };
  };

  programs = {
    fish.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    nix-ld.enable = true;
    trippy.enable = true;
    vim.enable = true;
  };

  services = {
    avahi.enable = true;

    tinc.networks.mars = {
      package = pkgs.tinc;
      extraConfig = ''
        connectTo = mononoke
        GraphDumpFile = |${lib.getExe' pkgs.graphviz "circo"} -Tsvg -o/tmp/tinc.mars.svg
      '';
      hostSettings = {
        ashitaka = {
          addresses = [
            {
              address = "192.168.8.238";
              port = 655;
            }
          ];
          subnets = [
            {
              address = "10.0.55.205";
              prefixLength = 32;
            }
          ];
          rsaPublicKey = ''
            -----BEGIN RSA PUBLIC KEY-----
            MIICCgKCAgEAo9i81Cm+Q2tt4HftW3GjR/GVAGewIL4/GsX8RjB2agJrerIOj1ys
            UUnbNaYZXoErwYrt7pE9Qt38aD0raXQRyGqGrMim2e0xeJz2/ogpN4FFB4HB/bU+
            lV2y45ZqYvV7jCUhduI70ro25vqoawBMvJx3ko/thTJRdwVniFnNp2wlyvcI01BA
            hjhgqp27Wblo+ZJNJ6O13F8bsPzz+XzjRTMvizWG1Iv/5ZdAzMtj7HFUbg1KGD/x
            ySkrX8OqTzKX5vnz2UhV1mfmZ3SrUNjr1De/iJxOQ59tLAFIdNAIpR7dWSh1WVCc
            7zHpcaQ3uOqgHBhKz1Y4ti6vfRh3QUPW5CFXCPa+buePyPb4tNormkItWV4/RXtg
            KPIhLjp/UWHQavVjRsfWi5GQ50CWv+yNTbOcM/MUjUOjVOLy5jawS9VVJ3rq6B8N
            6Ip2+miYSffpPPZUFSOtc5QzkSIj8/5iKziTLIm1Ete/DaaRllgMw8AhPsU3Uxzr
            KWTm58haJ5x9/Iwm7q1Ngj19U7l2/v3rG2dZLoQr/Y39YJDsPtTWaIOBfKrXM7gt
            aeku1NEyJVpfVHeVE1WWelpkRboKKEY30BTGYX1ouoI8ws9ElE1m+YhZJgZLt2f+
            R7jdAeugWutjR4QFiPNS6tyqMfP1O7WWui78whkgGcBRHy3ix9XnQa8CAwEAAQ==
            -----END RSA PUBLIC KEY-----
          '';
        };
        hattori = {
          addresses = [
            {
              address = "192.168.1.200";
              port = 655;
            }
          ];
          subnets = [
            {
              address = "10.0.55.200";
              prefixLength = 32;
            }
          ];
        };
        loon = {
          addresses = [
            {
              address = "192.168.1.204";
              port = 655;
            }
            {
              address = "192.168.8.240";
              port = 655;
            }
          ];
          subnets = [
            {
              address = "10.0.55.204";
              prefixLength = 32;
            }
          ];
          rsaPublicKey = ''
            -----BEGIN RSA PUBLIC KEY-----
            MIICCgKCAgEAl2gdD25WOuGSuSlM2Si9KgYS8Ync9PygggaQMAJhgDnLr4QsHFES
            vLwekjawC7YNZ0K7wAq/OA49EA2MuLonRIZxezhRE4xHpS8N7SH3MF9mx3tyGvbY
            +1FwKEM1/paSQ0OOszWVG43yhqpdXue2Q6kEl0nYLPnyDiCvzOimnDSu/MOj33q9
            7o/r3gm8eL3wimu6TZRgG1/GaNq4/9HvKxGeEyIBa5LDtypmiFw4oORj575Ppk6n
            JHCo7xeoYGyP/GVHLPCaxwZ0MZbmt5oOAdd6HN5JytwNc25ZU5FEKeNweyQN06IG
            BO+ZM9IPUGpjsNalhtoFOXr2zFCyGROGjd11hUwNrG4J3rKz/HmMH5i+RXM6/Ya0
            Tsn5I4aryzFff6kstf9B2YEFJA9//1Ta82uIsPzcdAXZLhF+ww4aBS6Xsav8Udrz
            BxaTnynL+XJSVUZnlCkSK2HevBpd/0DWUqkjt3ixGlzpQenkwQ3hcwrfO/JgKEaZ
            7l+lk/IGoGop3ZDknp10tnHJOiDI8FN99KbYOv/MN3pOoEWhk7igToY9utYUtoZu
            eGPVSnB62opoGzV0lKYYmA4OiFBqh+RZ7+S/uy3V5TlbjhwZE0Dnic8EWaFNQA6q
            nrB/t/frqSwj//EG3SjAUzIJvQnk0GTa2DvbTTz1F8eG46caljSYI5UCAwEAAQ==
            -----END RSA PUBLIC KEY-----
          '';
        };
        mononoke = {
          addresses = [
            {
              address = "mononoke.tetaneutral.net";
              port = 53;
            }
          ];
          subnets = [
            {
              address = "10.0.55.50";
              prefixLength = 32;
            }
          ];
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
          addresses = [
            {
              address = "192.168.1.10";
              port = 655;
            }
          ];
          subnets = [
            {
              address = "10.0.55.10";
              prefixLength = 32;
            }
          ];
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
          addresses = [
            {
              address = "192.168.1.203";
              port = 655;
            }
          ];
          subnets = [
            {
              address = "10.0.55.203";
              prefixLength = 32;
            }
          ];
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
        zhurong = {
          addresses = [
            {
              address = "192.168.1.20";
              port = 655;
            }
          ];
          subnets = [
            {
              address = "10.0.55.20";
              prefixLength = 32;
            }
          ];
          rsaPublicKey = ''
            -----BEGIN RSA PUBLIC KEY-----
            MIICCgKCAgEAxE5OHgRQayZxKJ0bpzCb5+YUTvRydMrAqlsGmONxZauAAlp9mJYR
            9Od+DvFDlvMH+PdQ4Ih4uq2ODdDJvJh2j+h5VfBrzoSR7s4YLD4gAHDKpo6sexgc
            zt9VNwg/MCETE8397/gZD+P2L5e++aK37wFgZxNE/T1zJKIPyyETF49/5/MOiUtE
            gjoOiE1WjjPPb1ZuB+DScCVTIWtzKpbZ2SSBFiRX6rF+EHdOctjD0Lej0Nddaklo
            uuW+qikHdeXKxyu6HwRzA4AqXDTUuhOsMnWAIBHXRGuS+Eu6R1lbmALXdttG704U
            UUpYg105XIiNUqyv8PcCk7FDsBpMSxcnRbPZJSO9GiFKsDDNIoVonxkla04JIi6h
            laZmuM2gHr0UdnzRu+w8mtZ5sqCk29awohnxQYcB4zgAaHXToWFsG/bhv07fKBHf
            UswQ/y0eEjymoDv0CxO7Ue8sHlQ5uilb+bXUg8GwfMg2hy0hDKiAc3BCwGY+OxCT
            D83ZFcx4HdPHm651OCFFubFj5tDWVxZqhld8XoEqVB6KzZH3/bIIDwMlS+fqqmkd
            ZCCVXqe/Kmtee8vrd4N3AzsRmtCPFeZTpGBhsJoggqBDIAO3xZKxuevoNpmp1M7J
            nFzPmaE6fsy+gEHAwfDveIIy5JmCx8N4U4ydrgJwZwaBJBLT0GLksekCAwEAAQ==
            -----END RSA PUBLIC KEY-----
          '';
        };
      };
    };
    udev.packages = [
      pkgs.stlink
    ];
  };

  time.timeZone = "Europe/Paris";

  users.users =
    let
      common = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH38Iwc5sA/6qbBRL+uot3yqkuACDDu1yQbk6bKxiPGP nim@loon"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBbE5nRZpgFdZJgC+hTzdyYLxKUBY59WFYOQ/O1oxwc gsaurel@upepesanke"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOwQHhg10BZUogtkz+MlOsnmQER2Kkf9YjL3taOcNtbJAAAABHNzaDo= nim@sk1"
        ];
        shell = pkgs.fish;
      };
    in
    {
      root = common;
      user = common // {
        isNormalUser = true;
        extraGroups = [
          "dialout"
          "docker"
          "input"
          "networkmanager"
          "video"
          "wheel"
        ];
        uid = 1000;
      };
    };
}
