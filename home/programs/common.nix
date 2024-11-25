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
    xclip

    # archives
    zip
    unzip
    p7zip

    # cloud native
    docker-compose
    kubectl
    minikube
    quickemu

    # multimedia
    vlc
    yt-dlp
  ];

  programs = {
    bash = {
      enable = true;
      shellAliases = {
        k = "kubectl";
        rbs = "sudo nixos-rebuild switch";
      };

      initExtra = ''
        source <(kubectl completion bash)
        alias k=kubectl
        complete -F __start_kubectl k
      '';
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = ''
        set-option -g mouse on
      '';
      plugins = with pkgs.tmuxPlugins; [
        better-mouse-mode
        sensible
        vim-tmux-navigator
      ];
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