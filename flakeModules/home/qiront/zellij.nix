{ ... }:
{
  flake.modules.homeManager.qiront-zellij =
    { ... }:
    {
      programs = {
        zellij = {
          enable = true;
          extraConfig = builtins.readFile ./config/zellij/unlock_first_keybinds.kdl;
          settings = {
            on_force_close = "quit";
            default_layout = "compact";
            pane_frames = false;
            plugins = {
              compact-bar = {
                _props.location = "zellij:compact-bar";
                tooltip = "F1";
              };
            };
          };
        };

        zsh.initContent = ''
          function current_dir() {
            local current_dir=$PWD
            if [[ $current_dir == $HOME ]]; then
              current_dir="~"
            else
              current_dir=/''${current_dir##*/}
            fi
            
            echo $current_dir
          }

          function change_tab_title() {
            local title=$1
            command nohup zellij action rename-tab $title >/dev/null 2>&1
          }

          function set_tab_to_working_dir() {
            local result=$?
            local title=$(current_dir)
            if [[ $result -gt 0 ]]; then
              title="$title [$result]" 
            fi

            change_tab_title $title
          }

          function set_tab_to_command_line() {
            local cmdline=$1
            local args=( ''${(Q)''${(z)cmdline}} )

            change_tab_title $args[1]
          }

          if [[ -n $ZELLIJ ]]; then
            add-zsh-hook precmd set_tab_to_working_dir
            add-zsh-hook preexec set_tab_to_command_line
          fi
        '';
      };
    };
}
