{
    description = "Make Groovy";

    inputs = {
        nixpkgs.url = "nixpkgs";
    };

    outputs = {}: {




        stdenvNoCC.mkDerivation rec {
            pname = "feather-font";
            version = "4.28";

            src = fetchFromGitHub {
                name = "${pname}-${version}";

                owner = "adi1090x";
                repo = "polybar-themes";
                rev = "46154c5283861a6f0a440363d82c4febead3c818";
                sha256 = "w1EqvFvQH0+CqzuJRBxUJLnG5joQVFlcSxyw9TvW4VI=";
            };

            installPhase = ''
                runHook preInstall

                install -Dm644 fonts/*.ttf -t $out/share/fonts/truetype

                runHook postInstall
            '';

            meta = with lib; {
                homepage = "https://github.com/feathericons/feather";
                description = "Feather Font";
                longDescription = "Feather Font";
                license = licenses.ofl;
                platforms = platforms.all;
                maintainers = [ ];
            };
        }

    };
}
