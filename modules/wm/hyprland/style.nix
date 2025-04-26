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
    text = scheme.base05;
    alternate_text = scheme.base01;
    background_0 = scheme.base00;
    background_1 = scheme.base01;
    selected_background = scheme.base02;
    urgent = scheme.base09;
    border_color = scheme.base0D;
    on_background = scheme.base0D;
    off_background = scheme.base0E;
    red = scheme.base08;
    green = scheme.base0B;
    yellow = scheme.base0A;
    blue = scheme.base0C;
    orange = scheme.base09;
    opacity = "0.8";
    indicator_height = "2px";
  };
in
{
  colors = { inherit (custom) blue red green yellow orange; };
  rofi = with custom; {
    configuration = {
      modi = "drun,run";
      show-icons = true;
      drun-display-format = "{name}";
      font = "${lib.lists.last fonts} 14";
    };
    "*" = {
      foreground = mkLiteral "#${background_0}";
      background-alt = mkLiteral "#${background_1}";
      selected = mkLiteral "#${selected_background}";
      urgent = mkLiteral "#${urgent}";
      active = mkLiteral "#${background_1}";
      text-selected = mkLiteral "#${on_background}";
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

    "element normal.normal" = {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "#${off_background}";
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
    @define-color backgroundlight #${background_1};
    @define-color backgrounddark #${background_0};
    @define-color workspacesbackground1 #${on_background};
    @define-color workspacesbackground2 #${off_background};
    @define-color bordercolor #${border_color};
    @define-color textcolor #${text};
    @define-color alternate_text #${alternate_text};
    @define-color iconcolor #${text};

    * {
        all: unset;
        font-family: ${font_family};
        border: none;
        border-radius: 0px;
    }

    window#waybar {
        background-color: rgba(0,0,0,0.2);
        border-bottom: 0px solid #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
    }

    #workspaces {
        margin: 5px 1px 6px 1px;
        padding: 0px 0px;
        border-radius: 15px;
        border: 0px;
        font-weight: bold;
        font-style: normal;
        font-size: ${font_size};
        color: @textcolor;
    }

    #workspaces button {
        padding: 0px 11px 0px 7px;
        margin: 4px 3px;
        border-radius: 15px;
        border: 0px;
        color: @textcolor;
        background: @backgroundlight;
        transition: all 0.3s ease-in-out;
    }

    #workspaces button.active {
        color: @textcolor;
        padding: 0px 12px 0px 8px;
        background: @workspacesbackground1;
        border-radius: 15px;
        min-width: 40px;
        transition: all 0.3s ease-in-out;
    }

    #workspaces button:hover {
        color: @textcolor;
        padding: 0px 12px 0px 8px;
        background: @workspacesbackground2;
        border-radius: 15px;
    }

    tooltip {
        border-radius: 10px;
        background-color: @backgroundlight;
        opacity: 0.8;
        padding: 20px;
        margin: 0px;
    }

    tooltip label {
        color: @textcolor;
    }

    .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
    }

    .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
    }

    #custom-appmenu {
        background-color: @backgroundlight;
        font-size: ${font_size};
        color: @textcolor;
        border-radius: 15px;
        padding: 0px 10px 0px 8px;
        margin: 10px 15px 10px 10px;
    }

    #custom-exit {
        margin: 0px 20px 0px 0px;
        padding:0px;
        font-size:20px;
        color: @iconcolor;
    }

    #clock {
        background-color: @backgroundlight;
        font-size: 16px;
        color: @textcolor;
        border-radius: 15px;
        padding: 2px 10px 0px 10px;
        margin: 10px 15px 10px 0px;
    }

     #backlight {
        background-color: @backgroundlight;
        font-size: 16px;
        color: @textcolor;
        border-radius: 15px;
        padding: 2px 10px 0px 10px;
        margin: 10px 15px 10px 0px;
    }

    #pulseaudio {
        background-color: @backgroundlight;
        font-size: 16px;
        color: @textcolor;
        border-radius: 15px;
        padding: 2px 10px 0px 10px;
        margin: 10px 15px 10px 0px;
    }

    #pulseaudio.muted {
        background-color: @backgroundlight;
        color: @textcolor;
    }

    #network {
        background-color: @backgroundlight;
        font-size: 16px;
        color: @textcolor;
        border-radius: 15px;
        padding: 2px 10px 0px 10px;
        margin: 10px 15px 10px 0px;
    }

    #network.ethernet {
        background-color: @backgroundlight;
        color: @textcolor;
    }

    #network.wifi {
        background-color: @backgroundlight;
        color: @textcolor;
    }

     #bluetooth, #bluetooth.on, #bluetooth.connected {
        background-color: @backgroundlight;
        font-size: 16px;
        color: @textcolor;
        border-radius: 15px;
        padding: 2px 10px 0px 10px;
        margin: 10px 15px 10px 0px;
    }

    #bluetooth.off {
        background-color: transparent;
        padding: 0px;
        margin: 0px;
    }

    #battery {
        background-color: @backgroundlight;
        font-size: 16px;
        color: @textcolor;
        border-radius: 15px;
        padding: 2px 15px 0px 10px;
        margin: 10px 15px 10px 0px;
    }

    #battery.charging, #battery.plugged {
        color: @textcolor;
        background-color: @backgroundlight;
    }

    @keyframes blink {
        to {
            background-color: @backgroundlight;
            color: @textcolor;
        }
    }

    #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: @textcolor;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #tray {
        margin:0px 10px 0px 0px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
    }

    label:focus {
        background-color: #000000;
    }
  '';
}
