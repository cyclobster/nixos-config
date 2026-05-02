{ config, pkgs, ... }:

{
 home.username = "roger";
 home.homeDirectory = "/home/roger";
 home.stateVersion = "25.11";
 
 programs.home-manager.enable = true;

 programs.zsh = {
  enable = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  initContent = ''
    setfont ter-v32b 2>/dev/null || true
  '';
 };

 programs.kitty.enable = true;

 home.sessionVariables = {
  SHELL = "${pkgs.zsh}/bin/sh";
 };
}
