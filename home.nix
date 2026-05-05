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
  initContent = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
      start-hyprland
    fi
  '';
 };

programs.wofi.enable = true;

 programs.kitty = {
  enable = true;
  settings = {
   shell = "zsh";
  };
  font = {
   name = "monospace";
   size = 14;
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
  package = pkgs.firefox.override {
   cfg.enableWidevineCDM = true;
  };
  profiles.roger = {
   settings = {
    "media.eme.enabled" = true;
    "media.gmp-widevinecdm.enabled" = true;
   };
   extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
    tridactyl
    lastpass-password-manager
   ];
   extensions.force = true;
  };
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
  
     # Controls
     ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
     ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
     ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"
     ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
     ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
     ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
     ", XF86WLAN, exec, nmcli radio wifi toggle"
     ", XF86Favorites, exec, firefox"

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
