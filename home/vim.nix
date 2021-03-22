{ pkgs, config, ... }:

let

  # We group the keybindings according to the "Keymap Reference" headings in
  # the $default keymap reference card
  # https://resources.jetbrains.com/storage/products/intellij-idea/docs/IntelliJIDEA_ReferenceCard.pdf
  riderKeymapsFile = ''
  <keymap name="CustomMade" parent="$default" version="1" disable-mnemonics="false">
  ${builtins.readFile ../dotfiles/idea-keymaps/03_Cancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/05_VimCancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/07_File.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/08_Editor.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/10_CreateAndEdit.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/20_AnalyzeAndExplore.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/20_Rider_AnalyzeAndExplore.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/30_VersionControl.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/40_MasterYourIDE.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/40_Rider_MasterYourIDE.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/45_ToolWindows.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/50_FindEverything.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/60_NavigateFromSymbols.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/60_Rider_NavigateFromSymbols.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/70_NavigateInContext.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/80_BuildRunAndDebug.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/80_Rider_BuildRunAndDebug.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/90_Rider_UnitTests.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/95_RefactorAndCleanup.xml}
  </keymap>
  '';

  golandKeymapsFile = ''
  <keymap name="CustomMade" parent="$default" version="1" disable-mnemonics="false">
  ${builtins.readFile ../dotfiles/idea-keymaps/03_Cancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/05_VimCancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/07_File.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/08_Editor.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/10_CreateAndEdit.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/20_AnalyzeAndExplore.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/30_VersionControl.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/40_MasterYourIDE.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/45_ToolWindows.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/50_FindEverything.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/60_NavigateFromSymbols.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/70_NavigateInContext.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/80_BuildRunAndDebug.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/95_RefactorAndCleanup.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/95_Goland_RefactorAndCleanup.xml}
  </keymap>
  '';

  clionKeymapsFile = ''
  <keymap name="CustomMade" parent="$default" version="1" disable-mnemonics="false">
  ${builtins.readFile ../dotfiles/idea-keymaps/03_Cancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/05_VimCancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/07_File.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/08_Editor.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/10_CreateAndEdit.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/20_AnalyzeAndExplore.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/30_VersionControl.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/40_MasterYourIDE.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/45_ToolWindows.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/50_FindEverything.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/60_NavigateFromSymbols.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/70_NavigateInContext.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/80_BuildRunAndDebug.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/95_RefactorAndCleanup.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/95_CLion_RefactorAndCleanup.xml}
  </keymap>
  '';

  intelliJIdeaKeymapsFile = ''
  <keymap name="CustomMade" parent="$default" version="1" disable-mnemonics="false">
  ${builtins.readFile ../dotfiles/idea-keymaps/03_Cancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/05_VimCancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/07_File.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/08_Editor.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/10_CreateAndEdit.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/20_AnalyzeAndExplore.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/30_VersionControl.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/40_MasterYourIDE.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/45_ToolWindows.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/50_FindEverything.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/60_NavigateFromSymbols.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/70_NavigateInContext.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/80_BuildRunAndDebug.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/95_RefactorAndCleanup.xml}
  </keymap>
  '';

  pycharmKeymapsFile = ''
  <keymap name="CustomMade" parent="$default" version="1" disable-mnemonics="false">
  ${builtins.readFile ../dotfiles/idea-keymaps/03_Cancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/05_VimCancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/07_File.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/08_Editor.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/10_CreateAndEdit.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/20_AnalyzeAndExplore.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/30_VersionControl.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/40_MasterYourIDE.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/45_ToolWindows.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/50_FindEverything.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/60_NavigateFromSymbols.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/70_NavigateInContext.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/80_BuildRunAndDebug.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/95_RefactorAndCleanup.xml}
  </keymap>
  '';

  webstormKeymapsFile = ''
  <keymap name="CustomMade" parent="$default" version="1" disable-mnemonics="false">
  ${builtins.readFile ../dotfiles/idea-keymaps/03_Cancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/05_VimCancelations.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/07_File.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/08_Editor.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/10_CreateAndEdit.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/20_AnalyzeAndExplore.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/30_VersionControl.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/40_MasterYourIDE.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/45_ToolWindows.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/50_FindEverything.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/60_NavigateFromSymbols.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/70_NavigateInContext.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/80_BuildRunAndDebug.xml}
  ${builtins.readFile ../dotfiles/idea-keymaps/95_RefactorAndCleanup.xml}
  </keymap>
  '';

in

{
  # programs.vim = {
  #   enable = true;
  #   # plugins = [
  #   #   "ctrlp"
  #   #   "fugitive"
  #   #   "editorconfig-vim"
  #   #   "surround"
  #   #   "vim-colorschemes"
  #   # ];
  #   extraConfig = builtins.readFile ../dotfiles/vimrc;
  # };

  # Idea VIM plugin supports XDG_CONFIG_HOME
  xdg.configFile = {
    "ideavim/ideavimrc".text = ''
      ${builtins.readFile ../dotfiles/vimrc.base}
      ${builtins.readFile ../dotfiles/vimrc.idea}
    '';
  };

  #
  # Rider, GoLand etc.
  #

  # TODO: Your keymap should be saved in ~/.config/JetBrains/WebStorm2020.3/jba_config/linux.keymaps,
  #       if you have enabled IDE settings sync for keymaps, and you can manually transfer it to the same folder.
  # NOTE: If your settings are synchronized through the IDE Settings Sync plugin,
  #       these subfolders are located under jba_config in the configuration directory.

  # TODO: refactor into abstraction using
  #   product = (Rider, GoLand, CLion, IntelliJIdea, PyCharm, Webstorm)
  #   version = 2020.2
  #   keymapFile
  # attribute set keys depend on linux vs darwin
  home.file = {
  } // (if builtins.currentSystem == "x86_64-linux" then {} else
  {
    "Library/Application Support/JetBrains/Rider2020.3/keymaps/CustomMade.xml".text = riderKeymapsFile;
    "Library/Application Support/JetBrains/Rider2021.1/keymaps/CustomMade.xml".text = riderKeymapsFile;
    "Library/Application Support/JetBrains/GoLand2020.3/keymaps/CustomMade.xml".text = golandKeymapsFile;
    "Library/Application Support/JetBrains/CLion2020.3/keymaps/CustomMade.xml".text = clionKeymapsFile;
    "Library/Application Support/JetBrains/IntelliJIdea2020.3/keymaps/CustomMade.xml".text = intelliJIdeaKeymapsFile;
    "Library/Application Support/JetBrains/PyCharm2020.3/keymaps/CustomMade.xml".text = pycharmKeymapsFile;
    "Library/Application Support/JetBrains/WebStorm2020.3/keymaps/CustomMade.xml".text = webstormKeymapsFile;
  }) // (if builtins.currentSystem == "x86_64-linux" then {
    ".config/JetBrains/Rider2020.3/keymaps/CustomMade.xml".text = riderKeymapsFile;
    ".config/JetBrains/Rider2021.1/keymaps/CustomMade.xml".text = riderKeymapsFile;
    ".config/JetBrains/GoLand2020.3/keymaps/CustomMade.xml".text = golandKeymapsFile;
    ".config/JetBrains/CLion2020.3/keymaps/CustomMade.xml".text = clionKeymapsFile;
    ".config/JetBrains/IntelliJIdea2020.3/keymaps/CustomMade.xml".text = intelliJIdeaKeymapsFile;
    ".config/JetBrains/PyCharm2020.3/keymaps/CustomMade.xml".text = pycharmKeymapsFile;
    ".config/JetBrains/WebStorm2020.3/keymaps/CustomMade.xml".text = webstormKeymapsFile;
    # NOTE: choose settings to sync -> disable keymaps
    # ".config/JetBrains/WebStorm2020.3/jba_config/linux.keymaps/CustomMade.xml".text = webstormKeymapsFile;
  } else {});





  # nvim is installed into the nix store in the following rather complex manner:
  #
  # $ which vim
  #   /home/maxfire/.nix-profile/bin/vim
  # $ readlink -f $(which vim)
  #   /nix/store/qk2jip85migg0msk5h1h9ffrsjn5h6yl-neovim-0.4.3/bin/nvim
  # $ cat $( readlink -f $(which vim) )
  #   #! /nix/store/kgp3vq8l9yb8mzghbw83kyr3f26yqvsz-bash-4.4-p23/bin/bash -e
  #   export NVIM_SYSTEM_RPLUGIN_MANIFEST='/nix/store/qk2jip85migg0msk5h1h9ffrsjn5h6yl-neovim-0.4.3/rplugin.vim'
  #   exec -a "$0" "/nix/store/qk2jip85migg0msk5h1h9ffrsjn5h6yl-neovim-0.4.3/bin/.nvim-wrapped"  -u /nix/store/5k975mynq33ag2arv58angs14nznjdnn-vimrc "$@"
  #
  # That is an .nvim-wrapped executable script is wrapped by a bash shell script, and the -u switch will pass the vimrc run script.
  # The .nvim-wrapped script is a bash shell script containing
  #
  #   #! /nix/store/kgp3vq8l9yb8mzghbw83kyr3f26yqvsz-bash-4.4-p23/bin/bash -e
  #   export PATH=$PATH${PATH:+':'}'/nix/store/3wql63ic2wxzk0vg23yx9ffbjh47zpnl-neovim-ruby-env/bin'
  #   export GEM_HOME='/nix/store/3wql63ic2wxzk0vg23yx9ffbjh47zpnl-neovim-ruby-env/lib/ruby/gems/2.6.0'
  #   exec "/nix/store/paik8rpjf0n0ai4p68831hvsmirhxqjw-neovim-unwrapped-0.4.3/bin/nvim" \
  #       --cmd "let g:loaded_node_provider=1" \
  #       --cmd "let g:python_host_prog='/nix/store/qk2jip85migg0msk5h1h9ffrsjn5h6yl-neovim-0.4.3/bin/nvim-python'" \
  #       --cmd "let g:python3_host_prog='/nix/store/qk2jip85migg0msk5h1h9ffrsjn5h6yl-neovim-0.4.3/bin/nvim-python3'" \
  #       --cmd "let g:ruby_host_prog='/nix/store/qk2jip85migg0msk5h1h9ffrsjn5h6yl-neovim-0.4.3/bin/nvim-ruby'" \
  #       "$@"
  #
  # The vimrc script is generated by the nix build and looks like
  #
  #   set nocompatible
  #
  #   set packpath^=/nix/store/6msjqf5xzqkw1gv313zzic01ii5p85vg-vim-pack-dir
  #   set runtimepath^=/nix/store/6msjqf5xzqkw1gv313zzic01ii5p85vg-vim-pack-dir
  #
  #   filetype indent plugin on | syn on
  #
  #   " Your vimrc config starts here (~/.config/nvim/init.vim)
  #   .
  #   .
  #
  # To list everything in the nix store related to Vim:
  # $ nix-store --query --requisites ~/.nix-profile/ | grep -P '^[^-]+-.*?\K\bvim'
  #   /nix/store/ynwh265h3sf0pjdic30bpicq54xgw9b6-vimplugin-editorconfig-vim-2020-04-07
  #   /nix/store/6msjqf5xzqkw1gv313zzic01ii5p85vg-vim-pack-dir
  #   /nix/store/5k975mynq33ag2arv58angs14nznjdnn-vimrc
  # $ nix-store --query --requisites ~/.nix-profile/ | grep -P 'vim'
  #   /nix/store/2h1cpk4bxycgb1n7xnyxkz7py37yp9ji-python3.7-pynvim-0.4.1
  #   /nix/store/9yiq86gmnibpb5x4m235wppzwr96w4lf-ruby2.6.6-neovim-0.8.0
  #   /nix/store/3wql63ic2wxzk0vg23yx9ffbjh47zpnl-neovim-ruby-env
  #   /nix/store/ynwh265h3sf0pjdic30bpicq54xgw9b6-vimplugin-editorconfig-vim-2020-04-07
  #   /nix/store/6msjqf5xzqkw1gv313zzic01ii5p85vg-vim-pack-dir
  #   /nix/store/5k975mynq33ag2arv58angs14nznjdnn-vimrc
  #   /nix/store/ykp21nmhlsy98ysh0kjl6fqdfsq6wxka-python2.7-pynvim-0.4.1
  #   /nix/store/xj1v8fxb15vs19llga269dxsp1ssjab7-libvterm-neovim-0.1.3
  #   /nix/store/paik8rpjf0n0ai4p68831hvsmirhxqjw-neovim-unwrapped-0.4.3
  #   /nix/store/qk2jip85migg0msk5h1h9ffrsjn5h6yl-neovim-0.4.
  #
  # See also http://ivanbrennan.nyc/2018-05-09/vim-on-nixos
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      #tagbar
      #gruvbox
      #nerdtree
      # fugitive
      # airline
      # multiple-cursors
      # surround
      # nerdcommenter
      # easymotion
      # vim-obsession
      #vim-prosession
      # syntastic
      # ultisnips
      # vim-snippets
      # deoplete-nvim
      # deoplete-rust
      # deoplete-clang
      # deoplete-jedi
      # rust-vim

      # fugitive
      # gitgutter
      # nerdcommenter
      # nerdtree
      # surround
      # syntastic
      # tmux-navigator
      # vim-airline
      # vim-indent-guides
      # vim-markdown
      # vim-multiple-cursors
      # vim-nix
      # vim-trailing-whitespace
      # vimproc
      # youcompleteme

      editorconfig-vim
      ctrlp
      fzf-vim
      fzfWrapper
      # LanguageClient-neovim
      # lightline-vim
      # nerdtree
      # supertab
      # tabular
      # vim-better-whitespace
      # vim-multiple-cursors
      vim-surround
      vim-commentary

      #vimproc
      #vimproc-vim

      # themes
      #wombat256

      # language packages
      # Haskell
      #vim-hoogle
      # neco-ghc
      # haskell-vim
      # hlint-refactor-vim
      # ghc-mod-vim

      # Nix
      vim-nix

      # Csharp
      #vim-csharp

      # Powershell
      #vim-ps1

      # Python
      #semshi
    ];

    extraConfig = ''
      ${builtins.readFile ../dotfiles/vimrc.base}
      ${builtins.readFile ../dotfiles/vimrc}
    '';

    # TODO: Move config to dotfiles
    # extraConfig = ''
    #   colorscheme wombat256mod

    #   set number
    #   set expandtab
    #   set foldmethod=indent
    #   set foldnestmax=5
    #   set foldlevelstart=99
    #   set foldcolumn=0

    #   set list
    #   set listchars=tab:>-

    #   let g:better_whitespace_enabled=1
    #   let g:strip_whitespace_on_save=1
    #   let mapleader=' '

    #   let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

    #   if has("gui_running")
    #     imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
    #   else " no gui
    #     if has("unix")
    #       inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
    #     endif
    #   endif

    #   let g:haskellmode_completion_ghc = 0
    #   autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    #   autocmd FileType markdown setlocal conceallevel=0

    #   " Tabular bindings
    #   let g:haskell_tabular = 1
    #   vmap <leader>a= :Tabularize /=<CR>
    #   vmap <leader>a; :Tabularize /::<CR>
    #   vmap <leader>a- :Tabularize /-><CR>
    #   vmap <leader>a# :Tabularize /#<CR>

    #   " fzf bindings
    #   nnoremap <leader>r :Rg<CR>
    #   nnoremap <leader>b :Buffers<CR>
    #   nnoremap <leader>e :Files<CR>
    #   nnoremap <leader>l :Lines<CR>
    #   nnoremap <leader>L :BLines<CR>
    #   nnoremap <leader>c :Commits<CR>
    #   nnoremap <leader>C :BCommits<CR>
    # '';
  };
}
