{ lib, config, username, ... }:
let
  scheme = config.home-manager.users.${username}.lib.stylix.colors;
  custom = {
    fonts = [
      ''"Fira Sans Semibold"''
      ''"Font Awesome 6 Free"''
      "FontAwesome"
      "Roboto"
      "Helvetica"
      "Arial"
      "sans-serif"
    ];
    font_family = lib.concatStringsSep ", " custom.fonts;
    font_size = "16px";
    font_weight = "bold";
    text_color = scheme.base05;
    alternate_text_color = scheme.base01;
    background_0 = scheme.base00;
    background_1 = scheme.base01;
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
  style = with custom; ''
    @define-color backgroundlight #${background_1};
    @define-color backgrounddark #${background_0};
    @define-color workspacesbackground1 #${on_background};
    @define-color workspacesbackground2 #${off_background};
    @define-color bordercolor #${border_color};
    @define-color textcolor #${text_color};
    @define-color alternate_text_color #${alternate_text_color};
    @define-color iconcolor #${text_color};

    * {
        all: unset;
        font-family: ${font_family};
        border: none;
        border-radius: 0px;
    }

    window#waybar {
        background-color: rgba(0,0,0,0.2);
        border-bottom: 0px solid #ffffff;
        /* color: #FFFFFF; */
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
        padding: 1px 1px;
        margin: 4px 3px;
        border-radius: 15px;
        border: 0px;
        color: @textcolor;
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
        opacity:0.8;
        padding:20px;
        margin:0px;
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
        background-color: #${yellow};
        font-size: 22px;
        color: @alternate_text_color;
        border-radius: 15px;
        padding: 0px 10px 0px 10px;
        margin: 10px 15px 10px 10px;
    }

    #custom-exit {
        margin: 0px 20px 0px 0px;
        padding:0px;
        font-size:20px;
        color: @iconcolor;
    }

    #clock {
        background-color: #${red};
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
        background-color: @backgrounddark;
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
