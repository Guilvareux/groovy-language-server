{
    description = "Make Groovy Language Server";

    inputs = {
        nixpkgs.url = "nixpkgs";
        flake-utils.url = "github:numtide/flake-utils";
        gradle2nix.url = "github:tadfisher/gradle2nix/v2";
    };

    outputs = { nixpkgs, flake-utils, gradle2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
            inherit system;
            config = {allowUnfree = true;};
        };
    in {
        packages.default = gradle2nix.builders."${system}".buildGradlePackage rec {
            pname = "groovy-language-server";
            version = "0-unstable-2025-12-03";
            lockFile = ./gradle.lock;

            src = pkgs.fetchFromGitHub {
                name = "${pname}-${version}";
                owner = "GroovyLanguageServer";
                repo = "groovy-language-server";
                rev = "0746b250604c0a75bf620f7257aed8df12d025c3";
                sha256 = "sha256-rLi6xvGFVRvAVmP59Te1MxKA6HzQ+qPtEC5lMws5tFQ=";
            };

            buildInputs = with pkgs; [
                jdk
                gradle
                makeWrapper
            ];

            buildPhase = ''
                ${pkgs.gradle}/bin/gradle --offline build
            '';

            installPhase = ''
                mkdir -p $out/share/java
                mkdir -p $out/bin

                cp build/libs/${pname}-${version}-all.jar $out/share/java

                makeWrapper "${pkgs.jdk}/bin/java" "$out/bin/${pname}" \
                --add-flags "-jar $out/share/java/${pname}-${version}-all.jar" \
                --set CLASSPATH "$out/share/java/${pname}-${version}-all.jar:\$CLASSPATH"
            '';

            meta = with lib; {
                homepage = "https://github.com/GroovyLanguageServer/groovy-language-server";
                description = "Groovy Language Server";
                longDescription = "Groovy Language Server";
                license = licenses.asl20;
                platforms = platforms.all;
                maintainers = [ ];
            };
        };
    });
}
