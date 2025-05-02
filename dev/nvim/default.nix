{
  config,
  inputs,
  ...
}: let
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
      addOverlays =
        /*
        (import ./overlays inputs) ++
        */
        [
          (utils.standardPluginOverlay inputs)
        ];
      # see the packageDefinitions below.
      # This says which of those to install.
      packageNames = ["nvim"];

      luaPath = "${./config}";

      # the .replace vs .merge options are for modules based on existing configurations,
      # they refer to how multiple categoryDefinitions get merged together by the module.
      # for useage of this section, refer to :h nixCats.flake.outputs.categories
      categoryDefinitions.replace = {
        pkgs,
        categories,
        ...
      }: {
        lspsAndRuntimeDeps = with pkgs; {
          general = [
            universal-ctags
            ripgrep
            fd
            stdenv.cc.cc
          ];

          javascript = [
            biome
            nodePackages.eslint
            nodePackages.prettier
          ];

          lua = [
            lua-language-server
            stylua
          ];

          nix = [
            alejandra
            nix-doc
            nixd
          ];

          shell = [
            bash-language-server
            shellcheck
            shfmt
          ];

          toml = [
            taplo
          ];

          terraform = [
            terraform-ls
            tflint
          ];
        };

        # This is for plugins that will load at startup without using packadd:
        startupPlugins = {
          general = with pkgs.vimPlugins; {
            # you can make subcategories!!!
            # (always isnt a special name, just the one I chose for this subcategory)
            always = [
              blink-cmp
              lze
              lzextras
              nvim-notify
              plenary-nvim
              # vim-repeat
            ];
            extra = [
              # nvim-web-devicons
              oil-nvim
            ];
          };

          # You can retreive information from the
          # packageDefinitions of the package this was packaged with.
          themer = with pkgs.vimPlugins; (
            builtins.getAttr (categories.colorscheme or "onedark") {
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

          general = {
            # cmp = with pkgs.vimPlugins; [
            #   # cmp stuff
            #   nvim-cmp
            #   luasnip
            #   friendly-snippets
            #   cmp_luasnip
            #   cmp-buffer
            #   cmp-path
            #   cmp-nvim-lua
            #   cmp-nvim-lsp
            #   cmp-cmdline
            #   cmp-nvim-lsp-signature-help
            #   cmp-cmdline-history
            #   lspkind-nvim
            # ];

            treesitter = with pkgs.vimPlugins; [
              nvim-treesitter-textobjects
              nvim-treesitter
            ];

            telescope = with pkgs.vimPlugins; [
              telescope-fzf-native-nvim
              telescope-nvim
            ];

            quickfix = with pkgs.vimPlugins; [
              quicker-nvim
            ];

            # always = with pkgs.vimPlugins; [
            #   nvim-lspconfig
            #   lualine-nvim
            #   gitsigns-nvim
            #   # vim-sleuth
            #   # vim-fugitive
            #   # vim-rhubarb
            #   nvim-surround
            # ];
            #
            # extra = with pkgs.vimPlugins; [
            #   fidget-nvim
            #   # lualine-lsp-progress
            #   which-key-nvim
            #   comment-nvim
            #   undotree
            #   indent-blankline-nvim
            #   vim-startuptime
            # ];
          };
        };
        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
        };

        environmentVariables = {
        };

        extraWrapperArgs = {
        };
        extraLuaPackages = {
        };
      };

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim = {...}: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = ["vim" "vi"];
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
            # Core
            colorscheme = "catppuccin-mocha";
            general = true;
            themer = true;

            # Languages
            lua = true;
            markdown = true;
            nix = true;
            shell = true;
            terraform = true;
            toml = true;
            javascript = true;

            # Concerns
            lint = true;
            format = true;
          };
        };
      };
    };
  };
}
