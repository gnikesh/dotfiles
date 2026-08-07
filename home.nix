{ config, lib, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    EZA_COLORS = "di=34:fi=37:ex=32:ln=36";
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
    initContent = lib.mkMerge [
      ''
        bindkey '^f' autosuggest-accept
      ''
      (lib.mkOrder 1500 ''
        if [[ -r "$HOME/.zshrc.local" ]]; then
          source "$HOME/.zshrc.local"
        fi
      '')
    ];
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
      # For coloring the files and directories
      ls = "eza --color=always";
      ll = "eza -lah --color=always";
    };
    sessionVariables = {
      EZA_COLORS = "di=34:fi=37:ex=32:ln=36";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    sideloadInitLua = true;
    withPython3 = true;
    withRuby = true;
  };

  # Edit-in-place: the real files stay in my repo, and the managed paths point at them.
  # iTerm2 reloads dynamic profiles from this directory while it is running.
  home.file."Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/iterm2/dotfiles.json";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  # These are iTerm2's global appearance settings, so they cannot live in a
  # dynamic profile. Keep them managed alongside the profile.
  home.activation.iterm2Preferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x /usr/bin/defaults ]; then
      /usr/bin/defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "2F91B29D-6B5B-4A31-9E73-4C6FC9F0F8EF"
      /usr/bin/defaults write com.googlecode.iterm2 HideTab -bool true
      /usr/bin/defaults write com.googlecode.iterm2 DimBackgroundWindows -bool true
      /usr/bin/defaults write com.googlecode.iterm2 DimOnlyText -bool false
      /usr/bin/defaults write com.googlecode.iterm2 SplitPaneDimmingAmount -float 0.55
    fi
  '';

  # Keep Pi's credential and runtime state local by linking only authored files and directories.
  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
