local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local M = {}

function M.load()
    ls.add_snippets("nix", {
        s(
            "devflake",
            fmta(
                [[
                {
                  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

                  outputs = {
                    self,
                    nixpkgs,
                  }: let
                    system = "<>";
                    pkgs = import nixpkgs {inherit system;};
                  in {
                    devShells.${system}.default = pkgs.mkShell {
                      packages = with pkgs; [<>];
                    };
                  };
                }
                ]],
                {
                    i(1, "x86_64-linux"),
                    i(2, "cargo"),
                }
            )
        ),
    })
end

return M
