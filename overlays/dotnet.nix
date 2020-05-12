self: super: {
  dotnet-sdk_3_1 = super.dotnet-sdk_3.overrideAttrs (oldAttrs: rec {
    pname = oldAttrs.pname; # "dotnet-sdk";
    version = "3.1.101";
    suffix = "x64";
    src = super.fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-${suffix}.tar.gz";
      sha512 = "2hsda4491f5i0465grw8yvwiqkyz5p72cq7xjfg6zz446gxqwmd3dd593b0wwq6y16n2rbrc036zlfg5vn5cn3d2wlw6qp77cr7bvpf";
    };
  });
}