{ config, pkgs, lib, ... }:

let
  cfgName = "dslStandardConfig";
  cfg = config.${cfgName};
in
{
  options.${cfgName} = {
    configureTmux = lib.mkEnableOption "Set tmux conf";
    configureVscode = lib.mkEnableOption "Set vscode key bindings + add vscodevim";
  };

  config = lib.mkMerge [
    (
      lib.mkIf cfg.configureTmux {
        home.packages = [ pkgs.xclip ];
        programs.tmux = {
          extraConfig = builtins.readFile ./files/tmux.conf;
        };
      }
    )
    (
      lib.mkIf cfg.configureVscode {
        programs.vscode = {
          extensions = with pkgs.vscode-extensions; [
            vscodevim.vim
          ];
          keybindings = builtins.fromJSON (builtins.readFile ./files/vscode_keybindings.json);
        };
      }
    )
  ];
}
