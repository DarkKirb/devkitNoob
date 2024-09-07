# References:
# - https://gcc.gnu.org/install/index.html
{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  texinfo,
  perl,
  gmp,
  mpfr,
  libmpc,
  isl,
  zstd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "noobkitPPC";
  version = "45.2";

  __structuredAttrs = true;

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
  sourceRoot = ".";

  nativeBuildInputs = [texinfo perl];
  buildInputs = [gmp mpfr libmpc isl zstd];

  hardeningDisable = ["format"];
  env = {
    DKN_NAME = finalAttrs.pname;
    DKN_VERSION = finalAttrs.version;
    DKN_BUGURL = "${finalAttrs.meta.homepage}/issues";
    BUILD_DKPRO_PACKAGE = 2;
  };

  patchPhase = ''
    runHook prePatch
    '${stdenv.shell}' '${./apply_patches.sh}'
    runHook postPatch
  '';
  buildPhase = ''
    runHook preBuild
    export DKN_PREFIX="$prefix"
    '${stdenv.shell}' '${./build.sh}'
    runHook postBuild
  '';
  dontInstall = true;

  meta = {
    description = "Toolchain for Nintendo GameCube & Wii homebrew development";
    homepage = "https://github.com/devkitNoob/devkitNoob";
    license = [
      # Binutils and GCC
      lib.licenses.gpl3Plus

      # Newlib
      lib.licenses.gpl2Plus
    ];
    # TODO maintainers = [ lib.maintainers.novenary ];
    platforms = lib.platforms.unix;
  };
})
