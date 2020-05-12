{ pkgs, ... }:

{
    home.packages = with pkgs; [
        # this is defined in an overlay
        pkgs.dotnet-sdk_3_1
    ];
}