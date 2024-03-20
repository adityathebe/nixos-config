# https://github.com/notthebee/nix-config/blob/main/users/notthebee/dots.nix

{ config, pkgs, ... }: 
{
  home = {
    username = "aditya";
    homeDirectory = "/home/aditya";
    stateVersion = "23.11";
    packages = [
      pkgs.awscli
      pkgs.delve
      pkgs.gopls
      pkgs.gotools
      pkgs.kubectl
      pkgs.kubectx
      pkgs.pgcli
      pkgs.yt-dlp
    ];
  };

  programs.home-manager.enable = true;

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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  # xdg.configFile = {
    # "nvim" = {
    #   source = builtins.fetchGit {
    #     url = "https://github.com/AstroNvim/AstroNvim";
    #     rev = "d36af2f75369e3621312c87bd0e377e7d562fc72";
    #   };
    # };
    # "nvim/lua/user" = {
    #   source = builtins.fetchGit {
    #     url = "https://github.com/adityathebe/astronvim";
    #     rev = "f509363ff2229c324f040ffdd59a99bcca6c53ca";
    #   };
    # };
  # };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-a";
    keyMode = "vi";
    sensibleOnTop = true;
    terminal = "xterm-256color";
    plugins = [
      pkgs.tmuxPlugins.power-theme
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.better-mouse-mode
    ];
    extraConfig = ''
      # So vim colors are rendered properly (but this isn't working right now)
      set-option -sa terminal-overrides ',xterm-256color:RGB'

      # Start new pane & window on the current path
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window
    '';
  };

  programs.lazygit = {
    enable = true;
  };

  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";
    defaultKeymap = "emacs";
    initExtra = ''
    source ~/.config/zsh/.p10k.zsh

    # Basic auto/table completion
    autoload -Uz compinit && compinit
    zstyle ':completion:*' menu select
    zmodload zsh/complist

    # Better completion
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

    # ctrl+E to go to the end of line
    bindkey '^E' end-of-line

    # make search up and down work, so partially type and hit up/down to find relevant stuff
    bindkey '^[[A' up-line-or-search                                                
    bindkey '^[[B' down-line-or-search

    # [Ctrl-RightArrow] - move forward one word
    bindkey -M emacs '^[[1;5C' forward-word
    bindkey -M viins '^[[1;5C' forward-word
    bindkey -M vicmd '^[[1;5C' forward-word

    # [Ctrl-LeftArrow] - move backward one word
    bindkey -M emacs '^[[1;5D' backward-word
    bindkey -M viins '^[[1;5D' backward-word
    bindkey -M vicmd '^[[1;5D' backward-word

    # [Delete] - delete forward
    bindkey -M emacs "^[[3~" delete-char

    # Bind Home/End keys
    bindkey  "^[[H"   beginning-of-line
    bindkey  "^[[F"   end-of-line
    '';

    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    history = {
      size = 5000000000;
      save = 5000000000;
      path = "${config.home.homeDirectory}/.local/share/zsh/history";
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
      gca="git commit --amend";
      gco="git checkout";
      gp="git push";
      grh="git reset --hard";
      gu="git reset HEAD"; # unstage a file

      # Kubernetes
      k="kubectl";
      kg="kubectl get";
      kgp="kubectl get pods";
      kgd="kubectl get deployments";
      kgy="kubectl get -o yaml";
      kgpw="kubectl get pods -o wide";

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
    aliases = {
      l = "log --pretty=format:\"%C(auto)%h%x09%C(blue)%an%x09%C(auto)%ad%x09%C(red)%s\"";
    };
    extraConfig = {
      gpg = {
        format = "ssh"; # use SSH keys to sign instead of gpg keys. So I only have to maintain one key.
      };

      core = {
        # tell Git to convert CRLF to LF on commit but not the other way around
        autocrlf = "input";
        editor = "vim";
        pager = "bat";
      };

      branch = {
        sort = "-committerdate";
      };

      pull.rebase = true;

      push = {
        # assume --set-upstream on default push when no upstream tracking exists for the current branch
        autoSetupRemote = true;
        # always push the local branch to a remote branch with the same name.
        default = "current";
      };

      init.defaultBranch = "main";

      pager.branch = false;

      commit.gpgsign = true;

      merge = {
        # https://jvns.ca/blog/2024/02/16/popular-git-config-options/#merge-conflictstyle-zdiff3
        conflictstyle = "zdiff3";
      };

      diff = {
        algorithm = "histogram";
      };

      commit.verbose = true;

      # Remember merge conlict resolutions
      rerere.enabled = true;
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "ssh.github.com";
        port = 443;
        identityFile = "~/.ssh/adityathebe";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
