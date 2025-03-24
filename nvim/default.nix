{ config, lib, home, inputs, ... }: let
  utils = inputs.nixCats.utils;
in {
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {

    home.sessionVariables.EDITOR = "${config.nixCats.out.packages.nvim}/bin/nvim";

    # this value, nixCats is the defaultPackageName you pass to mkNixosModules
    # it will be the namespace for your options.
    nixCats = {
      enable = true;
      nixpkgs_version = inputs.nixpkgs;
      # this will add the overlays from ./overlays and also,
      # add any plugins in inputs named "plugins-pluginName" to pkgs.neovimPlugins
      # It will not apply to overall system, just nixCats.
      addOverlays = /* (import ./overlays inputs) ++ */ [
        (utils.standardPluginOverlay inputs)
      ];
      # see the packageDefinitions below.
      # This says which of those to install.
      packageNames = [ "nvim" ];

      luaPath = "${./config}";

      # the .replace vs .merge options are for modules based on existing configurations,
      # they refer to how multiple categoryDefinitions get merged together by the module.
      # for useage of this section, refer to :h nixCats.flake.outputs.categories
      categoryDefinitions.replace = ({ pkgs, settings, categories, extra, name, mkNvimPlugin, ... }@packageDef: {
        lspsAndRuntimeDeps = with pkgs; {
          general = [
	    universal-ctags
            ripgrep
            fd
            stdenv.cc.cc
            stylua
	  ];

	  lua = [
	    lua-language-server
	  ];

	  nix = [
	    nix-doc
	    nixd
          ];
        };

	# This is for plugins that will load at startup without using packadd:
        startupPlugins = {
          general = with pkgs.vimPlugins; {
            # you can make subcategories!!!
            # (always isnt a special name, just the one I chose for this subcategory)
            always = [
              lze
              lzextras
              # vim-repeat
              plenary-nvim
              nvim-notify
            ];
            extra = [
              oil-nvim
              # nvim-web-devicons
            ];
          };

          # You can retreive information from the
          # packageDefinitions of the package this was packaged with.
          themer = with pkgs.vimPlugins;
            (builtins.getAttr (categories.colorscheme or "onedark") {
                # Theme switcher without creating a new category
                "onedark" = onedark-nvim;
                "catppuccin" = catppuccin-nvim;
                "catppuccin-mocha" = catppuccin-nvim;
                "tokyonight" = tokyonight-nvim;
                "tokyonight-day" = tokyonight-nvim;
              }
            );
        };

        optionalPlugins = {
          lint = with pkgs.vimPlugins; [
            nvim-lint
          ];

          format = with pkgs.vimPlugins; [
            conform-nvim
          ];

          markdown = with pkgs.vimPlugins; [
            markdown-preview-nvim
          ];

          lua = with pkgs.vimPlugins; [
            lazydev-nvim
          ];

          general = {
            cmp = with pkgs.vimPlugins; [
              # cmp stuff
              nvim-cmp
              luasnip
              friendly-snippets
              cmp_luasnip
              cmp-buffer
              cmp-path
              cmp-nvim-lua
              cmp-nvim-lsp
              cmp-cmdline
              cmp-nvim-lsp-signature-help
              cmp-cmdline-history
              lspkind-nvim
            ];

            treesitter = with pkgs.vimPlugins; [
              nvim-treesitter-textobjects
              (nvim-treesitter.withPlugins (
                plugins: with plugins; [
                  nix
                  lua
                ]
              ))
            ];

            telescope = with pkgs.vimPlugins; [
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              telescope-nvim
            ];

            always = with pkgs.vimPlugins; [
              nvim-lspconfig
              lualine-nvim
              gitsigns-nvim
              # vim-sleuth
              # vim-fugitive
              # vim-rhubarb
              nvim-surround
            ];

            extra = with pkgs.vimPlugins; [
              fidget-nvim
              # lualine-lsp-progress
              which-key-nvim
              comment-nvim
              undotree
              indent-blankline-nvim
              vim-startuptime
            ];
          };
        };
        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = with pkgs; [
            # libgit2
          ];
        };

        environmentVariables = {
        };

        extraWrapperArgs = {
        };
        # lists of the functions you would have passed to
        # python.withPackages or lua.withPackages

        # get the path to this python environment
        # in your lua config via
        # vim.g.python3_host_prog
        # or run from nvim terminal via :!<packagename>-python3
        extraPython3Packages = {
        };
        # populates $LUA_PATH and $LUA_CPATH
        extraLuaPackages = {
        };
      });

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim = {pkgs , ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = [ "vim" "vi" ];
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
	    colorscheme = "catppuccin-mocha";

            general = true;
            themer = true;

            nix = true;
            lua = true;

	    lint = true;
	    format = true;
	    markdown = true;

          };
        };
      };
    };
  };

}
