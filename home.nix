{ config, lib, ohMyBash ? null, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  commonAliases = {
    ".." = "cd ..";
    add = "git add .";
    push = "git push";
    pull = "git pull";
    m = "git switch main";
    cc = "claude --dangerously-skip-permissions";
    co = "codex --full-auto";
    # Keep file names icon-free and use color only.
    ls = "eza --color=always";
    ll = "eza -lah --color=always";
  };
in

{
  home.username = user;
  home.homeDirectory = if isDarwin then "/Users/${user}" else "/home/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    eza
  ] ++ lib.optional isDarwin pkgs.nerd-fonts.hack;
  fonts.fontconfig.enable = lib.mkIf isDarwin true;
  home.sessionVariables = {
    EDITOR = "nvim";
    EZA_COLORS = "di=34:fi=37:ex=32:ln=36";
  };
  # The Claude Code installer puts its launcher here.
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.shellAliases = commonAliases;

  programs.zsh = lib.mkIf isDarwin {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
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
  };

  programs.bash = lib.mkIf (!isDarwin) {
    enable = true;
    initExtra = lib.mkMerge [
      (lib.mkOrder 500 ''
        export OSH="${ohMyBash}"
        OSH_THEME="agnoster"
        plugins=(git)
        source "$OSH/oh-my-bash.sh"
      '')
      (lib.mkOrder 1500 ''
        if [[ -r "$HOME/.bashrc.local" ]]; then
          source "$HOME/.bashrc.local"
        fi
      '')
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    sideloadInitLua = true;
    withPython3 = true;
    withRuby = true;
  };

  # Edit-in-place: the real files stay in my repo, and the managed paths point at them.
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".wezterm.lua" = lib.mkIf isDarwin {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm/.wezterm.lua";
  };
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  # Claude Code uses its official installer and keeps itself updated, so only
  # install it when it is missing.
  home.activation.claudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -x "$HOME/.local/bin/claude" ]; then
      export PATH="${lib.makeBinPath [ pkgs.curl pkgs.bash pkgs.coreutils pkgs.gnugrep pkgs.gnused ]}:$PATH"
      run bash -c 'curl -fsSL https://claude.ai/install.sh | bash' \
        || echo "warning: Claude Code install failed; run: curl -fsSL https://claude.ai/install.sh | bash" >&2
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

  # OpenCode gets the shared instructions plus its own subagent delegation rules.
  # This is a generated file, so edits to either source need a rebuild.
  home.file.".config/opencode/AGENTS.md".text =
    builtins.readFile ./home/AGENTS.md
    + builtins.readFile ./home/.config/opencode/AGENTS.opencode.md;
  home.file.".config/opencode/opencode.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/opencode/opencode.jsonc";
  home.file.".config/opencode/agents".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/opencode/agents";
}
