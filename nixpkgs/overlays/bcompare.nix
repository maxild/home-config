self: super: {
  # override the version
  bcompare = super.bcompare.overrideAttrs (old: rec {
    pname = "bcompare";
    version = "4.3.4.24657";
    src = super.fetchurl {
      url = "https://www.scootersoftware.com/${pname}-${version}_amd64.deb";
      sha256 = "sha256:031ivmpy0mk43skb30r7p5zwf0m90pmsqhaq5kc08gzy6g4s0wd0";
      # date = 2020-05-06T17:10:10-0700;
    };
  });
}