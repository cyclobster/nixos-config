{ config, pkgs, inputs, ... }:

{
 home.username = "roger";
 home.homeDirectory = "/home/roger";
 home.stateVersion = "25.11";

 home.packages = with pkgs; [
  hyprpaper
  wl-clipboard
  bat
  eza
  nerd-fonts.fira-code
 ];

  # Enable the service
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      
      # Preload images into memory
      preload = [
        "/home/roger/resources/wallpaper.jpg"
      ];

      # Assign wallpapers to monitors
      wallpaper = [
       {
        monitor = "eDP-1";
	path = "/home/roger/resources/wallpaper.jpg";
       }
      ];
    };
  };

 programs.home-manager.enable = true;

 programs.waybar = {
  enable = true;
  settings = {
    mainBar = {
      position = "top";
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
     modules-right = [ "temperature" "battery" "network" "pulseaudio" "backlight" "clock" ];

      temperature = {
       critical-threshold = 80;
       format = "{temperatureC}°C {icon}";
       format-icons = ["" "" ""];
      }; 
      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%Y-%m-%d %H:%M}";
	timezone = "America/New_York";
      };

      battery = {
        format = "{capacity}% {icon}";
        format-icons = ["" "" "" "" ""];
      };

      network = {
        interface = "wlp0s20f3";
        format-wifi = "{essid} ";
        format-disconnected = "Disconnected ";
      };

      pulseaudio = {
        format = "{volume}% ";
        format-muted = "Muted ";
      };

      backlight = {
        format = "{percent}% ";
      };
    };
  };
};
 programs.zsh = {
   enable = true;
   autosuggestion.enable = true;
   syntaxHighlighting.enable = true;
   
   shellAliases = {
     ll = "ls -la";
     update = "sudo nixos-rebuild switch --flake ~/nixos-config#carbon";
     gc = "sudo nix-collect-garbage -d";
     cat = "bat";
     ls = "eza --icons";
     vim = "nvim";
     vi = "nvim";
   };
 
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
   font_features = "monospace +liga +calt";
  };
  font = {
   name = "Firacode Nerd Font Mono";
   size = 14;
  };
 };
 
 programs.nixvim = {
  enable = true;
  defaultEditor = true;
  colorschemes.tokyonight.enable = true;
  clipboard = {
   register = "unnamedplus";
   providers.wl-copy.enable = true;
  };
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

   "exec-once" = [ "waybar" "hyprpaper" ];
   monitor = ",preferred,auto,1";
   
   input = {
    kb_layout = "us";
    kb_options = "caps:ctrl_modifier";
    touchpad = {
     natural_scroll = true;
    };
   };
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
  LESS = "-R --use-color -j5";
 };
}
