{
  fetchurl,
  fetchFromGitHub,
}: finalAttrs: {
  pname = "noobkitPPC";
  version = "45.2";

  srcs = [
    (fetchFromGitHub rec {
      name = repo;
      owner = "devkitNoob-mirrors";
      repo = "buildscripts";
      rev = "devkitPPC_r${finalAttrs.version}";
      hash = "sha256-n5voe1Gc4p7Xn9kO4pfI26aeSQFneyZypnCSYMcO2gw=";
    })
    (fetchurl rec {
      url = "mirror://gnu/binutils/binutils-${version}.tar.bz2";
      version = "2.42";
      hash = "sha256-qlSFDr2lBkxyzU7C2bBWwpQlKZFIY1DZqXqypt/frxI=";
    })
    (fetchurl rec {
      url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
      version = "13.2.0";
      hash = "sha256-4nXnZEKmBnNBon8Exca4PYYTFEAEwEE1KIY9xrXHQ9o=";
    })
    (fetchurl rec {
      url = "https://sourceware.org/pub/newlib/newlib-${version}.tar.gz";
      version = "4.4.0.20231231";
      hash = "sha256-DBZqOeG/CVHfr81olJ/g5LbTZYCB1igvOa7vxjEPLxM=";
    })
  ];

  env = {
    BUILD_DKPRO_PACKAGE = 2;
  };

  meta = {
    description = "Toolchain for Nintendo GameCube & Wii homebrew development";
  };
}
