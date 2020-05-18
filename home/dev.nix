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
    ];
}
