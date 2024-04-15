{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    #utils
    dua
    ffmpeg
    tree

    # archives
    zip
    unzip
    p7zip

    # cloud native
    docker-compose
    kubectl
    quickemu

    # multimedia
    vlc
  ];

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        ctrlp-vim
        gruvbox
        nerdtree
        vim-airline
        vim-airline-themes
        vim-fugitive
        vim-surround
      ];
      settings = { ignorecase = true; };
      extraConfig = ''
        set mouse=a
        let g:airline_powerline_fonts = 1
        set t_Co=256
        let g:airline_theme='murmur'

        silent! colorscheme gruvbox
        set background=dark

        let mapleader = ","
        map <leader>f :CtrlP<CR>
        map <leader>n :NERDTreeToggle<CR>
        map <leader>t <Esc>:tabnew<CR>

        inoremap kj <Esc>
        cnoremap kj <C-C>

        :set number
        :set relativenumber
        :set cursorline

        :set tabstop=2
        :set shiftwidth=2
        :set expandtab
      '';
    };

    btop.enable = true; # replacement of htop/nmon
    jq.enable = true; # A lightweight and flexible command-line JSON processor
    ssh.enable = true;
    aria2.enable = true;
  };

  services = {
    # TODO: add more services
  };
}
