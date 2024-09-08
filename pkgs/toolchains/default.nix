# References:
# - https://gcc.gnu.org/install/index.html
{
  variant,
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
} @ args: let
  attrsPaths = {
    ppc = ./ppc.nix;
  };
  variantAttrs = lib.callPackageWith args attrsPaths.${variant} {};
in
  stdenv.mkDerivation (finalAttrs:
    lib.recursiveUpdate {
      __structuredAttrs = true;

      sourceRoot = ".";

      nativeBuildInputs = [texinfo perl];
      buildInputs = [gmp mpfr libmpc isl zstd];

      hardeningDisable = ["format"];
      env = {
        DKN_NAME = finalAttrs.pname;
        DKN_VERSION = finalAttrs.version;
        DKN_BUGURL = "${finalAttrs.meta.homepage}/issues";
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
    } (variantAttrs finalAttrs))
