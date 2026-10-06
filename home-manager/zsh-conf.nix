{ ... }:

{
  home.sessionPath = [
    "$HOME/Android/Sdk/emulator"
    "$HOME/Android/Sdk/platform-tools"
    "$HOME/Android/Sdk/cmdline-tools/latest/bin"
    "$HOME/Android/Sdk/tools/bin"

    "$HOME/DevTools/android-studio/jbr/bin"
    "$HOME/DevTools/flutter/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.pyenv/bin"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      path = "$HOME/.histfile";
      size = 500;
      save = 1000;
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";

      ANDROID_HOME = "$HOME/Android/Sdk";
      JAVA_HOME = "$HOME/DevTools/android-studio/jbr";

      CHROME_EXECUTABLE = "/usr/bin/chromium";

      PYENV_ROOT = "$HOME/.pyenv";
      NVM_DIR = "$HOME/.nvm";
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };

    shellAliases = {
      ls = "eza -lah";
      cat = "bat";
      androidstudio = "$HOME/DevTools/android-studio/bin/studio.sh";
    };

    initContent = ''
      bindkey -e

      setopt extendedglob
      setopt notify

      # Lazy-load pyenv
      pyenv() {
        unset -f pyenv
        eval "$(command pyenv init -)"
        pyenv "$@"
      }

      # Lazy-load NVM
      nvm() {
        unset -f nvm node npm npx

        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

        nvm "$@"
      }

      node() {
        unset -f nvm node npm npx

        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

        node "$@"
      }

      npm() {
        unset -f nvm node npm npx

        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

        npm "$@"
      }

      npx() {
        unset -f nvm node npm npx

        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

        npx "$@"
      }

      [ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
    '';
  };
  programs.zoxide.enableZshIntegration = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      palette = "earthy";

      palettes.earthy = {
        # Standard colors
        blue = "#A68C8A";
        red = "#40170E";
        green = "#594347";
        yellow = "#D9CCCC";
        cyan = "#A68C8A";
        magenta = "#594347";
        white = "#D9CCCC";
        black = "#0D0D0D";

        # Extended palette
        rosewater = "#D9CCCC";
        flamingo = "#A68C8A";
        pink = "#594347";
        mauve = "#40170E";
        maroon = "#40170E";
        peach = "#D9CCCC";
        teal = "#594347";
        sky = "#A68C8A";
        sapphire = "#594347";
        lavender = "#40170E";

        # Text shades
        text = "#D9CCCC";
        subtext1 = "#A68C8A";
        subtext0 = "#594347";

        # Surface shades
        overlay2 = "#594347";
        overlay1 = "#A68C8A";
        overlay0 = "#40170E";
        surface2 = "#40170E";
        surface1 = "#0D0D0D";
        surface0 = "#0D0D0D";
        base = "#0D0D0D";
        mantle = "#0D0D0D";
        crust = "#40170E";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[❮](bold blue)";
      };

      bun.format = "via []($style)";
      buf.format = "with [⎈]($style)";
      c.format = "via []($style)";
      cmake.format = "via [⚙️]($style)";
      cobol.format = "via [⚙️]($style)";
      cpp.format = "via []($style)";
      crystal.format = "via []($style)";
      daml.format = "via [⚖️]($style)";
      dart.format = "via []($style)";
      deno.format = "via []($style)";
      dotnet.format = "[$symbol(🎯 $tfm )]($style)";
      elixir.format = "via []($style)";
      elm.format = "via []($style)";
      erlang.format = "via []($style)";
      fennel.format = "via []($style)";
      fortran.format = "via []($style)";
      gleam.format = "via []($style)";
      golang.format = "via []($style)";
      gradle.format = "via []($style)";
      haskell.format = "via []($style)";
      haxe.format = "via []($style)";
      helm.format = "via [⎈]($style)";
      java.format = "via []($style)";
      julia.format = "via []($style)";
      kotlin.format = "via []($style)";
      lua.format = "via []($style)";
      maven.format = "via []($style)";
      meson.format = "via [⚙️]($style)";
      mojo.format = "with [🔥]($style)";
      nim.format = "via [🐍]($style)";
      nodejs.format = "via []($style)";
      ocaml.format = "via [$symbol(\\($switch_indicator$switch_name\\) )]($style)";
      odin.format = "via [☸️]($style)";
      opa.format = "via [⚙️]($style)";
      perl.format = "via []($style)";
      php.format = "via []($style)";
      pixi.format = "via [$symbol($environment )]($style)";
      pulumi.format = "via [$symbol$stack]($style)";
      purescript.format = "via []($style)";
      python.format = "via []($style)";
      quarto.format = "via [📊]($style)";
      raku.format = "via [🦋]($style)";
      red.format = "via [🔴]($style)";
      rlang.format = "via [📐]($style)";
      ruby.format = "via []($style)";
      rust.format = "via []($style)";
      scala.format = "via []($style)";
      solidity.format = "via [🔗]($style)";
      swift.format = "via [🐦]($style)";
      typst.format = "via [📝]($style)";
      vagrant.format = "via [📦]($style)";
      vlang.format = "via [🌐]($style)";
      xmake.format = "via [⚙️]($style)";
      zig.format = "via [⚡]($style)";

      package = {
        format = "[$symbol$version]($style)";
        symbol = "📦 ";
      };
    };
  };
}
