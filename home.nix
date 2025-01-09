{ config, pkgs, ... }:

{
  home.username = "wminor";
  home.homeDirectory = "/Users/wminor"; # TODO: option for linux

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes. Some manual steps may be required.
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    bash
    bat
    btop
    cmatrix
    coreutils
    delta
    extract_url
    fd
    fzf
    gh
    git
    gnused
    htop
    jq
    ncdu
    neovim
    pstree
    ripgrep
    shellcheck
    stow
    sox
    tmux
    tree
    universal-ctags
    wget
    watch
    watchexec
    yazi
    yq
    # use macos bundled zsh for now to avoid the need for chsh shenanigans
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  home.file = {
    # these links assume the repo is checked out at ~/dotfiles. if we need the flexibility to override that, we
    # could create an option, like the example given here: https://github.com/nix-community/home-manager/issues/2085

    # neovim
    ".config/nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/init.lua";

    # git
    ".gitattributes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/git/.gitattributes";
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/git/.gitconfig";
    ".githelpers".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/git/.githelpers";
    ".global_gitignore".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/git/.global_gitignore";

    # zsh
    ".zprofile".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.zprofile";
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.zshrc";
    ".fzf.zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.fzf.zsh";
    ".local/share/zplugins/zsh-syntax-highlighting".source = builtins.fetchGit {
      url = "https://github.com/zsh-users/zsh-syntax-highlighting";
      ref = "refs/tags/0.8.0";
    };
    ".local/share/zplugins/zsh-autosuggestions".source = builtins.fetchGit {
      url = "https://github.com/zsh-users/zsh-autosuggestions";
      ref = "refs/tags/v0.7.1";
    };
    ".local/share/zplugins/zsh-autopair".source = builtins.fetchGit {
      url = "https://github.com/hlissner/zsh-autopair";
      ref = "master";
    };
    ".local/share/zplugins/pure".source = builtins.fetchGit {
      url = "https://github.com/sindresorhus/pure";
      ref = "refs/tags/v1.23.0";
    };

    # tmux
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/tmux/.tmux.conf";
    ".tmux/plugins/tpm".source = builtins.fetchGit {
      url = "https://github.com/tmux-plugins/tpm";
      ref = "refs/tags/v3.1.0";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
