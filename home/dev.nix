{ pkgs, ... }:

{
    home.packages = with pkgs; [
        ctags

        # this is defined in an overlay
        dotnet-sdk_3_1
    ];
}
