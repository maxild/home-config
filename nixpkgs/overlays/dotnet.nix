# self: super: {
#   dotnet-sdk_3_1 = super.dotnet-sdk_3.overrideAttrs (oldAttrs: rec {
#     pname = oldAttrs.pname; # "dotnet-sdk";
#     version = "3.1.101";
#     suffix = "x64";
#     src = super.fetchurl {
#       url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-${suffix}.tar.gz";
#       sha512 = "2hsda4491f5i0465grw8yvwiqkyz5p72cq7xjfg6zz446gxqwmd3dd593b0wwq6y16n2rbrc036zlfg5vn5cn3d2wlw6qp77cr7bvpf";
#     };
#   });
# }

self: super:

  let
    dotnet_sdk_version = "3.1.101";
    platform = if super.stdenv.isDarwin then "osx" else "linux";
    system = super.stdenv.hostPlatform.system;
    # buildDotnet uses stdenv.hostPlatform.system to lookup the sha512 value
    sha512_3_1 = {
      x86_64-linux = "2hsda4491f5i0465grw8yvwiqkyz5p72cq7xjfg6zz446gxqwmd3dd593b0wwq6y16n2rbrc036zlfg5vn5cn3d2wlw6qp77cr7bvpf";
      x86_64-darwin = "1bs0p7jm5gaarc4ss6zfakzw03g0hf8vshlvjpdnxj9mjhssk45gv6h2jlamfkhb0w1a0i1y7j86w9haamwq62d3crg7dskdk76a25j";
    };

  in

    {
      dotnet-sdk_3_1 = super.dotnetCorePackages.sdk_3_1.overrideAttrs (oldAttrs: rec {
        pname = oldAttrs.pname; # "dotnet-sdk";
        version = dotnet_sdk_version;
        suffix = "x64";
        src = super.fetchurl {
          url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
          sha512 = sha512_3_1."${system}" or (throw "Missing hash for host system: ${system}");
        };
      });
    }
