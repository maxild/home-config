{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ctags

    # this is defined in an overlay
    dotnet-sdk_3_1

    # (with dotnetCorePackages; combinePackages [
    #   sdk_2_1
    #   sdk_3_0
    #   sdk_3_1
    # ])

    mono

    # Powershell Core
    powershell
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    ALTERNATE_EDITOR = "nano";
    # TODO
    #VIM_SOURCE_DIR="$HOME/vim";
    DOTNET_ROOT="${pkgs.dotnet-sdk_3_1}";
  };
}
