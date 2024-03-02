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

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName  = "Aditya Thebe";
    userEmail = "contact@adityathebe.com";
  };

  programs.home-manager.enable = true;
}