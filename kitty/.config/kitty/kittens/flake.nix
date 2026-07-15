{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [uv];

      shellHook = ''
        export PYTHONPATH="${pkgs.kitty}/lib/kitty:$PYTHONPATH"

        venv=".venv"
        if [ ! -d "$venv" ]; then
          uv venv
        fi

        . "$venv/bin/activate"
        echo "Activated virtual environment"
      '';
    };
  };
}
