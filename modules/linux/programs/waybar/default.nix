_: {
  programs.waybar.enable = true;
  programs.waybar.style = builtins.readFile ./style.css;
  programs.waybar.settings.mainBar = {
    layer = "top"; # Waybar at top layer
    # position = "bottom"; # Waybar position (top|bottom|left|right)
    height = 16; # Waybar height (to be removed for auto height)
    # width = 1280; # Waybar width
    spacing = 4; # Gaps between modules (4px)
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    # Choose the order of the modules
    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
    ];
    modules-center = [
      "hyprland/window"
    ];
    modules-right = [
      "tray"
      "pulseaudio"
      "network"
      "cpu"
      "memory"
      "disk"
      "clock"
    ];
    # Modules configuration
    "hyprland/workspaces" = {
      active-only = false;
      all-outputs = true;
      disable-scroll = false;
      on-scroll-up = "hyprctl dispatch workspace -1";
      on-scroll-down = "hyprctl dispatch workspace +1";
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        urgent = "";
        active = "";
        default = "󰧞";
      };
      sort-by-number = true;
    };
    tray = {
      icon-size = 16;
      spacing = 5;
    };
    clock = {
      # timezone = "America/New_York";
      format = " {:%H:%M}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = " {:%d/%m}";
    };
    cpu = {
      format = "󰻠 {usage}%";
      format-alt = "󰻠 {avg_frequency} GHz";
      interval = 5;
    };
    memory = {
      format = "󰍛 {}%";
      format-alt = "󰍛 {used}/{total} GiB";
      interval = 5;
    };
    disk = {
      format = "󰋊 {}%";
      format-alt = "󰋊 {used}/{total} GiB";
      interval = 5;
      path = "/";
    };
    network = {
      format-wifi = "󰤨";
      format-ethernet = " {ifname}: Aesthetic";
      format-linked = " {ifname} (No IP)";
      format-disconnected = "󰤭";
      format-alt = " {ifname}: {ipaddr}/{cidr}";
      tooltip-format = "{essid}";
      on-click-right = "nm-connection-editor";
    };
    pulseaudio = {
      # scroll-step = 1; # %, can be a float
      format = "{volume}% {icon} {format_source}";
      format-bluetooth = "{volume}% {icon} {format_source}";
      format-bluetooth-muted = " {icon} {format_source}";
      format-muted = " {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          ""
          ""
          ""
        ];
      };
      on-click = "pavucontrol";
    };
    "custom/launcher" = {
      format = "";
      on-click = "wofi --show drun";
    };
  };
}
