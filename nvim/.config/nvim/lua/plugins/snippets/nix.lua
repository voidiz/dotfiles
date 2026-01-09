local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local M = {}

function M.load()
    ls.add_snippets("nix", {
        s("devflake", {
            t({
                "{",
                '  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";',
                "",
                "  outputs = { self, nixpkgs }:",
                "    let",
                '      system = "',
            }),
            i(1, "x86_64-linux"),
            t({
                '";',
                "      pkgs = import nixpkgs { inherit system; };",
                "    in {",
                "      devShells.${system}.default = pkgs.mkShell {",
                "        packages = with pkgs; [ ",
            }),
            i(2, "git"),
            t({
                " ];",
                "      };",
                "    };",
                "}",
            }),
        }),
    })
end

return M
