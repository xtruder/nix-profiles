{ config, pkgs, lib, ... }:

with lib;

{
  options.themes.numix-solarized.enable = mkEnableOption "solarized";

  config = mkIf (
    config.themes.numix-solarized.enable &&
    config.profiles.x11.enable
  ) {
    # extra fonts
    fonts.fonts = [ pkgs.source-code-pro pkgs.font-awesome-ttf pkgs.powerline-fonts ];

    programs.bash.promptInit = "source ${./bashrc}";
    programs.chromium.extensions = ["eimadpbcbfnmbkopoojfekhnkhdbieeh"]; # dark reader

    profiles.x11 = {
      gtk2.theme = "NumixSolarizedDark";
      gtk3.theme = "NumixSolarizedDark";

      qt = {
        theme = "Breeze";

        # solarized colors for qt
        settings = ''
          customColors\0=4278201142
          customColors\1=4278662722
          customColors\10=4285297092
          customColors\11=4292032130
          customColors\12=4287865249
          customColors\13=4280983960
          customColors\14=4294833891
          customColors\15=4293847253
          customColors\2=4291513110
          customColors\3=4292620847
          customColors\4=4283985525
          customColors\5=4286945536
          customColors\6=4284840835
          customColors\7=4290087168
          customColors\8=4286813334
          customColors\9=4280716242
          Palette\active=#839496, #002b36, #004051, #003543, #00151b, #001c24, #839496, #93a1a1, #839496, #002b36, #002b36, #000000, #073642, #93a1a1, #0000ff, #ff00ff, #101010, #000000, #ffffdc, #ffffff
          Palette\inactive=#839496, #002b36, #004051, #00313e, #00151b, #001c24, #839496, #93a1a1, #839496, #002b36, #002b36, #000000, #073642, #93a1a1, #0000ff, #ff00ff, #101010, #000000, #ffffdc, #ffffff
          Palette\disabled=#808080, #002b36, #004051, #00313e, #00151b, #001c24, #808080, #93a1a1, #808080, #002b36, #002b36, #000000, #073642, #808080, #0000ff, #ff00ff, #101010, #000000, #ffffdc, #ffffff
        '';
      };

      iconTheme = "Numix";

      Xresources = ''
        /* colors */
        #define U_window_transparent		argb:00000000
        #define U_window_highlight_on		#066999
        #define U_window_highlight_on_a		argb:cc066999
        #define U_window_highlight_off		#B0C4DE
        #define U_window_highlight_off_a	argb:ccB0C4DE
        #define U_window_background		#263238
        #define U_window_background_a		argb:96263238
        #define U_window_urgent			#dc322f
        #define U_window_inactive		#B0C4DE
        #define U_text_color			#eceff1
        #define U_text_color_alt		#3f3f3f

        !
        !   ├────────────────────rofi.width──────────────────────┤
        ! ┬ ╔════════════════════════════════════════════════════╗
        ! │ ║run:query                                           ║ ◀- rofi.color-window[0]
        ! │ ║====================================================║ ◀- rofi.separator-style
        ! │ ║item1░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║ ◀- rofi.color-normal[0] 
        ! │ ╟───────────────────────────────────────────────────█╢
        ! │ ║item2▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█║ ◀- selected line
        ! │ ╟───────────────────────────────────────────────────█╢
        ! │ ║item3░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
        ! │ ╟───────────────────────────────────────────────────█╢
        ! │ ║item4▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█║ ◀- rofi.color-normal[2] 
        ! │ ╟───────────────────────────────────────────────────█╢
        ! │ ║item5░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
        ! ┴ ╚════════════════════════════════════════════════════╝
        ! ▲                                                     ▲
        ! │                                                     │
        ! rofi.lines                                            rofi.hide-scrollbar
        !
        !     main background,    main border color,    separator color
        rofi.color-window:  U_window_background_a,    U_window_background_a,    #26a69a

        !     line background,    text foreground,    alt line background,    highlighted background,   highlighted foreground
        rofi.color-normal:  U_window_transparent,   U_text_color,     U_window_transparent,   U_window_highlight_on_a,  U_text_color

        !       active window                     text on selected line
        rofi.color-active:  U_window_highlight_off,   #268bd2,      #eee8d5,      #268bd2,      #FDF6E3

        !     #fdf6e3,
        rofi.color-urgent:  #00ff00,      #dc322f,      #eee8d5,      #dc322f,      #fdf6e3

        rofi.bw:              0
        rofi.color-enabled:   true
        rofi.columns:         1
        rofi.eh:              1
        rofi.hide-scrollbar:  true
        rofi.line-margin:     5
        rofi.lines:           5
        rofi.location:        0
        rofi.padding:         30
        rofi.separator-style: none
        rofi.sidebar-mode:    false
        rofi.terminal:        xterm

        !! Color schemes
        #define S_base03        #002b36
        #define S_base02        #073642
        #define S_base01        #586e75
        #define S_base00        #657b83
        #define S_base0         #839496
        #define S_base1         #93a1a1
        #define S_base2         #eee8d5
        #define S_base3         #fdf6e3

        *background:            S_base03
        *foreground:            S_base0
        *fadeColor:             S_base03
        *cursorColor:           S_base1
        *pointerColorBackground:S_base01
        *pointerColorForeground:S_base1

        #define S_yellow        #b58900
        #define S_orange        #cb4b16
        #define S_red           #dc322f
        #define S_magenta       #d33682
        #define S_violet        #6c71c4
        #define S_blue          #268bd2
        #define S_cyan          #2aa198
        #define S_green         #859900

        !! black dark/light
        *color0:                S_base02
        *color8:                S_base01

        !! red dark/light
        *color1:                S_red
        *color9:                S_orange

        !! green dark/light
        *color2:                S_green
        *color10:               S_base01

        !! yellow dark/light
        *color3:                S_yellow
        *color11:               S_base00

        !! blue dark/light
        *color4:                S_blue
        *color12:               S_base0

        !! magenta dark/light
        *color5:                S_magenta
        *color13:               S_violet

        !! cyan dark/light
        *color6:                S_cyan
        *color14:               S_base1

        !! white dark/light
        *color7:                S_base2
        *color15:               S_base3

        !! xterm fonts
        XTerm*faceName: Source Code Pro,Source Code Pro Semibold
       
        Xft.autohint: 0
        Xft.antialias: 1
      '';
    };

    profiles.i3.extraConfig = ''
      font pango: Source Code Pro 8

      new_window pixel 1
      new_float pixel 1

      # Colors alias
      set $CL_BG #073642
      set $CL_FG #ABB2BF
      set $CL_CUR #2aa198
      set $CL_BLACK #000000
      set $CL_RED #dc322f
      set $CL_GREEN #859900
      set $CL_ORANGE #cb4b16
      set $CL_BLUE #268bd2
      set $CL_MAGENTA #d33682
      set $CL_CYAN #2aa198

      # Decotations colors

      # class                 border      backgr.     text    indicator   child_border
      client.focused          $CL_CUR     $CL_CUR     $CL_BG   $CL_CUR     $CL_CUR
      client.focused_inactive $CL_BG      $CL_BG      $CL_CUR  $CL_BG      $CL_BG
      client.unfocused        $CL_BG      $CL_BG      $CL_CUR  $CL_BG      $CL_BG
      client.urgent           $CL_RED     $CL_RED     $CL_BG   $CL_RED     $CL_RED
      client.placeholder      $CL_BG      $CL_BG      $CL_WHITE $CL_BLACK  $CL_BG
    '';

    profiles.i3.extraBarConfig = ''
      position bottom
      font pango: Source Code Pro 10

      colors {
          background #073642
          statusline #ffffff
          separator #2aa198

          focused_workspace  #167AC6 #167AC6 #CCCCCC
          active_workspace   #073642 #5f676a #dedede
          inactive_workspace #073642 #073642 #888888
          urgent_workspace   #333333 #900000 #ffffff
      }
    '';

    profiles.dunst.configuration = {
      global = {
        alignment = "center";
        transparency = 0;
        line_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        separator_color = "#2aa198";
        geometry = "400x5-6+30";
        font = "Source Code Pro 12";
        frame_width = 1;
        frame_color = "#2aa198";
      };

      urgency_low = {
        background = "#002b36";
				foreground = "#93a1a1";
      };

      urgency_normal = {
        background = "#002b36";
				foreground = "#93a1a1";
      };

      urgency_critical = {
        background = "#002b36";
				foreground = "#93a1a1";
      };
    };

    environment.systemPackages = with pkgs; [
      # gtk theme
      numix-solarized-gtk-theme

      # qt theme
      breeze-qt5

      # icon theme
      pkgs.numix-icon-theme

      # cursor theme
      pkgs.numix-cursor-theme
    ];
  };
}
