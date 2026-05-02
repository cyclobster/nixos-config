{ config, pkgs, inputs, ... }:

{
 home.username = "roger";
 home.homeDirectory = "/home/roger";
 home.stateVersion = "25.11";
 
 programs.home-manager.enable = true;

 programs.zsh = {
  enable = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
 };

 programs.kitty.enable = true;

 wayland.windowManager.hyprland = {
  enable = true;
  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  settings = {
   "$terminal" = "kitty";
   "$mod" = "SUPER";

   monitor = ",preferred,auto,1";

   exec-once = [ "kitty" ];

   bind = [
    "$mod, Return, exec, $terminal"
    "$mod, Q, killactive"
    "mod SHIFT, E, exit"
   ];

   input = {
    kb_layout = "us";
    touchpad = {
      natural_scroll = true;
    };
   };
  };
 };

 home.sessionVariables = {
  SHELL = "${pkgs.zsh}/bin/sh";
 };
}
