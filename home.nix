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

programs.wofi.enable = true;

 programs.kitty = {
  enable = true;
  settings = {
   shell = "zsh";
  };
 };
 
 programs.nixvim = {
  enable = true;
  defaultEditor = true;
  colorschemes.tokyonight.enable = true;
  plugins = {
   web-devicons.enable = true;
   telescope.enable = true;
   treesitter.enable = true;
   lsp = {
    enable = true;
    servers = {
     ts_ls.enable = true;
     nil_ls.enable = true;
    };
   };
  }; 
 };

 programs.firefox = {
  enable = true;
  configPath = "${config.xdg.configHome}/mozilla/firefox";
 };

 wayland.windowManager.hyprland = {
  enable = true;
  package = null;
  portalPackage = null;

  settings = {
   "$terminal" = "kitty";
   "$mod" = "MOD4";

   monitor = ",preferred,auto,1";
   
   general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    layout = "dwindle";
   };

   
   bind = [
    "$mod, Q, exec, kitty"
    "$mod, C, killactive"
    "$mod, M, exit"
    "$mod, E, exec, dolphin"
    "$mod, V, exec, togglefloating"
    "$mod, R, exec, wofi -- show drun"
    "$mod, F, exec, firefox"

     # move focus with mod + arrow keys
     "$mod, left, movefocus, l"
     "$mod, right, movefocus, r"
     "$mod, up, movefocus, u"
     "$mod, down, movefocus, d"
  
     "$mod, D, exec, wofi --show drun"
   ];
 
   env = [
    "NIXOS_OZONE_WL,1"
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "QT_QPA_PLATFORM,wayland"
   ];
  };
 };

 home.sessionVariables = {
  SHELL = "${pkgs.zsh}/bin/sh";
 };
}
