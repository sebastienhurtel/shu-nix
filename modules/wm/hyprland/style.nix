{
  lib,
  config,
  username,
  ...
}:
let
  inherit (config.home-manager.users.${username}.lib.formats.rasi) mkLiteral;
  scheme = config.home-manager.users.${username}.lib.stylix.colors;
  wallpaper = config.home-manager.users.${username}.stylix.image;
  custom = {
    fonts = [
      ''"Fira Sans Semibold"''
      ''"Font Awesome 6 Free"''
      "FontAwesome"
      "Roboto"
      "Helvetica"
      "Arial"
      "sans-serif"
      "JetBrainsMono Nerd Font"
    ];
    font_family = lib.concatStringsSep ", " custom.fonts;
    font_size = "16px";
    font_weight = "bold";
    opacity = "0.8";
    indicator_height = "2px";
  };
  colors = {
    backgroundDark = scheme.base00;
    backgroundLight = scheme.base01;
    selectionBackground = scheme.base02;
    unfocused = scheme.base03;
    focused = scheme.base07;
    alternateText = scheme.base04;
    text = scheme.base05;
    urgent = scheme.base09;
    textOnBackground = scheme.base0E;
    red = scheme.base08;
    green = scheme.base0B;
    yellow = scheme.base0A;
    blue = scheme.base0C;
    orange = scheme.base09;
  };
in
{
  rofi = with custom; {
    configuration = {
      modi = "drun,run";
      show-icons = true;
      drun-display-format = "{name}";
      font = "${lib.lists.last fonts} 14";
    };
    "*" = with colors; {
      foreground = mkLiteral "#${backgroundDark}";
      background-alt = mkLiteral "#${backgroundLight}";
      selected = mkLiteral "#${selectionBackground}";
      urgent = mkLiteral "#${urgent}";
      active = mkLiteral "#${backgroundLight}";
      text-selected = mkLiteral "#${blue}";
      text = mkLiteral "#${text}";
      shade-shadow = mkLiteral "white / 6%";
      shade-bg = mkLiteral "white / 12%";
      shade-border = mkLiteral "white / 24%";
    };

    window = {
      anchor = mkLiteral "center";
      background-color = mkLiteral "black / 12%";
      border = mkLiteral "1px";
      border-color = mkLiteral "@selected";
      border-radius = mkLiteral "30px";
      cursor = "default";
      fullscreen = false;
      location = mkLiteral "center";
      padding = mkLiteral "0px";
      transparency = "real";
      width = mkLiteral "55%";
    };

    "element normal.normal" = with colors; {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "#${text}";
    };

    "element selected.normal" = {
      background-color = mkLiteral "@shade-bg";
      text-color = mkLiteral "@text-selected";
      border = mkLiteral "1px solid";
      border-color = mkLiteral "@selected";
    };

    element-text = {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "inherit";
      highlight = mkLiteral "inherit";
      cursor = mkLiteral "inherit";
      vertical-align = mkLiteral "0.5";
      horizontal-align = mkLiteral "0.5";
    };

    listview = {
      background-color = mkLiteral "transparent";
      columns = mkLiteral "2";
      cycle = "true";
      dynamic = "true";
      fixed-columns = "true";
      fixed-height = "true";
      layout = mkLiteral "vertical";
      lines = mkLiteral "6";
      reverse = "false";
      scrollbar = "false";
      spacing = mkLiteral "16px";
    };

    scrollbar = {
      margin = mkLiteral "0px 4px";
      handle-width = mkLiteral "8px";
      handle-color = mkLiteral "white";
      background-color = mkLiteral "@shade-shadow";
      border-radius = mkLiteral "4px";
    };

    message = {
      background-color = mkLiteral "@shade-bg";
      border = mkLiteral "1px solid";
      border-color = mkLiteral "transparent";
      border-radius = mkLiteral "12px";
      padding = mkLiteral "24px";
    };

    error-message = {
      padding = mkLiteral "100px";
      border = mkLiteral "0px solid";
      border-radius = mkLiteral "0px";
      background-color = mkLiteral ''black / 10%'';
      text-color = mkLiteral "@text";
    };

    textbox = {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "@text";
      vertical-align = mkLiteral "0.5";
      horizontal-align = mkLiteral "0.5";
      highlight = mkLiteral "none";
    };

    mainbox = {
      orientation = mkLiteral "horizontal";
      children = mkLiteral ''[ "img", "listbox"]'';
      background-color = mkLiteral "transparent";
      spacing = mkLiteral "24px";
    };

    listbox = {
      spacing = mkLiteral "20px";
      background-color = mkLiteral "transparent";
      orientation = mkLiteral "vertical";
      children = mkLiteral ''["inputbar", "message", "listview"]'';
    };

    img = {
      padding = mkLiteral "64px 128px";
      border-radius = mkLiteral "24px";
      background-image = mkLiteral ''url("${wallpaper}", height)'';
    };

    inputbar = {
      background-color = mkLiteral "@shade-bg";
      border-radius = mkLiteral "12px";
      children = mkLiteral ''[ "textbox-icon", "entry" ]'';
      margin = mkLiteral "0px";
      padding = mkLiteral "14px";
      spacing = mkLiteral "0px";
      text-color = mkLiteral "@text";
    };

    dummy = {
      background-color = mkLiteral "transparent";
    };

    textbox-icon = {
      background-color = mkLiteral "transparent";
      expand = false;
      str = " ";
      text-color = mkLiteral "inherit";
    };

    entry = {
      expand = false;
      background-color = mkLiteral "transparent";
      cursor = mkLiteral "text";
      placeholder = "Search... ";
      placeholder-color = mkLiteral "inherit";
      text-color = mkLiteral "@text";
    };

    element = {
      cursor = mkLiteral "pointer";
      border-radius = mkLiteral "10px";
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "@foreground";

      spacing = mkLiteral "0px";
      margin = mkLiteral "0px";
      padding = mkLiteral "6px";
    };

    element-icon = {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "inherit";
      size = mkLiteral "36px";
      cursor = mkLiteral "inherit";
    };
  };

  waybar = with custom; ''
        * {
            font-family: ${font_family};
            font-size: ${font_size};
        }

        window#waybar {
            transition-duration: .5s;
        }

        #workspaces {
            margin: 5px 1px 6px 1px;
            padding: 0px 0px;
            border-radius: 15px;
            border: 0px;
            font-weight: bold;
            font-style: normal;
            font-size: 21px;
        }

        #workspaces button {
            padding: 0px 11px 0px 7px;
            margin: 4px 3px;
            border-radius: 15px;
            border: 0px;
            transition: all 0.3s ease-in-out;
            background-color: @base03;
            color: @base00;
        }

        #workspaces button.active {
            padding: 0px 11px 0px 7px;
            border-radius: 15px;
            min-width: 40px;
            transition: all 0.3s ease-in-out;
            background-color: @base07;
            color: @base00;
        }

        #workspaces button:hover {
            background-color: @base0A;
        }

        #custom-appmenu {
            border-radius: 15px;
            padding: 0px 10px 0px 8px;
            margin: 10px 15px 10px 10px;
        }

        #tray {
            border-radius: 15px;
            padding: 0px 10px 0px 8px;
            margin: 10px 15px 10px 10px;
        }

        #tray > .passive {
            -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
            -gtk-icon-effect: highlight;
        }

        #bluetooth {
            font-weight: normal;
            border-radius: 15px;
        }

        #pulseaudio {
            border-radius: 15px;
        }

        #battery {
            border-radius: 15px;
        }

        #battery.critical:not(.charging) {
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

  '';
}
