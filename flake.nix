{
  description = "Dev environment flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    fontsConf = pkgs.makeFontsConf {
      fontDirectories = [
        pkgs.corefonts
      ];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        typst
        corefonts
        fontconfig
        just
      ];

      shellHook = ''
        export FONTCONFIG_FILE="${fontsConf}"
      '';
    };
  };
}
