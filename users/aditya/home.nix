# https://github.com/notthebee/nix-config/blob/main/users/notthebee/dots.nix

{ inputs, lib, config, pkgs,  ... }: 
{
  home = {
    username = "aditya";
    homeDirectory = "/home/aditya";
    stateVersion = "23.11";
    packages = [
      pkgs.yt-dlp
      pkgs.gopls
      pkgs.delve
    ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      search_mode = "fuzzy";
      filter_mode = "host";
      filter_mode_shell_up_key_binding = "host";
      style = "full";
      show_preview = true;
      scroll_context_lines = 3;
      max_preview_height = 4;
      enter_accept = true;
      keymap_mode = "vim-insert";
    };
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";
    initExtra = "source ~/.config/zsh/.p10k.zsh";

    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    history = {
      size = 5000000000;
      save = 5000000000;
      path = ".local/share/zsh/history";
    };

    plugins = [
      { name = "powerlevel10k"; src = pkgs.zsh-powerlevel10k; file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";}
    ];

    shellAliases = {
      k9="killall -9";
      k15="killall -15";

      mv="mv -iv";
      rm="rm -v";

      ls="eza -h --color=auto --group-directories-first";
      ll="eza -l";
      lh="eza -alF";
      lg="eza -alF | grep -i";
      
      sudo="sudo ";

      # systemd
      sc-disable="systemctl disable";
      sc-enable="systemctl enable";
      sc-restart="systemctl restart";
      sc-start="systemctl start";
      sc-status="systemctl status";
      sc-stop="systemctl stop";

      digs="dig +short";
      curldoh="curl --doh-url https://cloudflare-dns.com/dns-query";
      publicip="dig +short myip.opendns.com @resolver1.opendns.com -4";
      
      downl="aria2c -c -x 8 -s 8";
      qrgen=" qrencode -t ANSI";

      # alias watch to itself so it works with other aliases. Pretty cool actually.
      watch="watch ";

      # Program alternatives
      cat="bat";

      # Git
      cdr="cd $(git rev-parse --show-toplevel)"; # jumps to the root path of a git repository
      gb="git branch";
      gca="git commit --amend'";
      gco="git checkout'";
      gp="git push'";
      grh="git reset --hard'";
      gu="git reset HEAD"; # unstage a file

      vim="nvim";
      du="du -ch";
      df="df -h";
      wget="wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\""; # In order to avoid history file in $HOME"

      # Audio and video downloaders from spotify and youtube
      yt="yt-dlp --add-metadata -f 'bestvideo[ext=mp4]'";
      yta="yt-dlp --downloader aria2c";

      # speedtest: get a 100MB file via wget
      speedtest="wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip";

      # Weather Report
      weather="curl https://wttr.in/kathmandu";

      # URL encode and decode
      urlencode="python -c \"import sys, urllib.parse as ul; [sys.stdout.write(ul.quote_plus(l)) for l in sys.stdin]\"'";
      urldecode="python -c \"import sys, urllib.parse as ul; [sys.stdout.write(ul.unquote_plus(l)) for l in sys.stdin]\"'";
    };
  };

  programs.git = {
    enable = true;
    userName  = "Aditya Thebe";
    userEmail = "contact@adityathebe.com";
  };

  programs.home-manager.enable = true;
}
