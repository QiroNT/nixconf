{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:
let
  windows-fonts =
    {
      pname,
      version,
      url,
      hash,
      desc,
    }:
    let
      languageFonts = import ./${pname}-languages.nix;
      source =
        with lib.attrsets;
        mapAttrs' (
          name: fonts:
          nameValuePair name (builtins.concatStringsSep " " (map (font: "Windows/Fonts/" + font) fonts))
        ) languageFonts;
    in
    stdenvNoCC.mkDerivation {
      inherit pname version desc;

      src = fetchurl {
        inherit url hash;
        meta.license = lib.licenses.unfree;
      };

      outputs = [ "out" ] ++ builtins.attrNames source;

      nativeBuildInputs = [ p7zip ];

      unpackPhase = ''
        runHook preUnpack
        7z x $src
        7z x -aoa sources/install.wim Windows/{Fonts/"*".{ttf,ttc},System32/Licenses/neutral/"*"/"*"/license.rtf}
        runHook postUnpack
      '';

      installPhase =
        ''
          runHook preInstall

          mkdir -p $out/share/fonts/truetype
        ''
        + lib.strings.concatLines (
          lib.lists.forEach (builtins.attrNames source) (
            name:
            let
              outHome = "$" + name;
            in
            ''
              install -Dm644 ${source.${name}} -t ${outHome}/share/fonts/truetype
              ln -s ${outHome}/share/fonts/truetype/*.{ttf,ttc} $out/share/fonts/truetype
              install -Dm644 Windows/System32/Licenses/neutral/*/*/license.rtf -t ${outHome}/share/licenses
            ''
          )
        )
        + ''
          install -Dm644 Windows/System32/Licenses/neutral/*/*/license.rtf -t $out/share/licenses

          runHook postInstall
        '';

      meta = with lib; {
        description = "Some TrueType fonts from ${desc} (Arial, Bahnschrift, Calibri, Cambria, Candara, Consolas, Constantia...)";
        homepage = "https://learn.microsoft.com/typography/";
        license = licenses.unfree;
        platforms = platforms.all;
        maintainers = with maintainers; [ sobte ];

        # Set a non-zero priority to allow easy overriding of the
        # fontconfig configuration files.
        priority = 5;
      };
    };
in
windows-fonts {
  pname = "windows11-fonts";
  version = "10.0.26100.1742-3";
  url = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso";
  hash = "sha256-dVqQ1D6CanS54ZMqNHiLiY4CgnJDm3d+VZPe6NU2Iq4=";
  desc = "Microsoft Windows 11 fonts";
}
