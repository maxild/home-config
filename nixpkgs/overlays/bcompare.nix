self: super: {
  # override the version
  bcompare = super.bcompare.overrideAttrs (old: rec {
    pname = "bcompare";
    version = "4.3.7.25118";
    src = super.fetchurl {
      url = "https://www.scootersoftware.com/${pname}-${version}_amd64.deb";
      sha256 = "sha256:165d6d81vy29pr62y4rcvl4abqqhfwdzcsx77p0dqlzgqswj88v8";
    };
  });
}
