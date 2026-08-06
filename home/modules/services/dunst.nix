{...}:
{
  services.dunst = {
  enable = true;
  settings = {
    global = {
      width = 320;
      height = 120;
      offset = "20x20";
      origin = "top-right";

      padding = 18;
      horizontal_padding = 18;

      separator_height = 10;
      separator_color = "frame";

      frame_width = 2;
      frame_color = "#313244";
      corner_radius = 10;

      font = "CaskaydiaCove Nerd Font Mono 10";
      format = "<b><span foreground='#f5c2e7'>%s</span></b>\n%b";
      alignment = "left";
      show_indicators = false;

      progress_bar = true;
      progress_bar_height = 4;
      progress_bar_frame_width = 0;
      progress_bar_corner_radius = 2;
      progress_bar_min_width = 284;
      progress_bar_max_width = 284;

      icon_position = "left";
      max_icon_size = 42;
      margin = 14;

      layer = "overlay";
      mouse_left_click = "close_current";
    };

    urgency_low = {
      background = "#11111b";
      foreground = "#a6adc8";
      frame_color = "#313244";
      progress_bar_value_color = "#a6adc8";
      timeout = 4;
    };

    urgency_normal = {
      background = "#11111b";
      foreground = "#cdd6f4";
      frame_color = "#cba6f7";
      progress_bar_value_color = "#cba6f7";
      timeout = 6;
    };

    urgency_critical = {
      background = "#11111b";
      foreground = "#f38ba8";
      frame_color = "#f38ba8";
      progress_bar_value_color = "#f38ba8";
      timeout = 0;
    };
  };
}; 
}
