$env.config = {
    show_banner: false

    shell_integration: {
      # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
      osc2: false
      # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
      osc7: false
      # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it
      osc8: false
      # osc9_9 is from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
      osc9_9: false
      # osc133 is several escapes invented by Final Term which include the supported ones below.
      # 133;A - Mark prompt start
      # 133;B - Mark prompt end
      # 133;C - Mark pre-execution
      # 133;D;exit - Mark execution finished with exit code
      # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
      osc133: false
      # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
      # 633;A - Mark prompt start
      # 633;B - Mark prompt end
      # 633;C - Mark pre-execution
      # 633;D;exit - Mark execution finished with exit code
      # 633;E - NOT IMPLEMENTED - Explicitly set the command line with an optional nonce
      # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
      # and also helps with the run recent menu in vscode
      osc633: false
      # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
      reset_application_mode: true
    }

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: false
    }

    table: {
        mode: rounded
        index_mode: always
        show_empty: true
        padding: { left: 1, right: 1 }
    }

    history: {
        max_size: 1_000_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: true
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        external: {
            enable: true
            max_results: 100
        }
        use_ls_colors: true
    }

    cursor_shape: {
        emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
        vi_insert: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
    }

    float_precision: 2
    use_ansi_coloring: true
    bracketed_paste: true
    edit_mode: vi
    render_right_prompt_on_last_line: false
    use_kitty_protocol: false
    highlight_resolved_externals: false # true enables highlighting of external commands in the repl resolved by which.
}

$env.PROMPT_COMMAND = { ||
  let default_style = (ansi reset) + (ansi blue)

  let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {
      (ansi red_bold) + ($env.LAST_EXIT_CODE | into string) + $default_style + " | "
  } else {
    ""
  }

  let git_id = (
    git rev-parse --abbrev-ref HEAD
    | complete
    | match $in {
      { exit_code: 0, stdout: "HEAD\n" } => (git rev-parse --short HEAD | complete),
      _ => $in,
    }
    | match $in {
      { exit_code: 0, stdout: $id } => { $id | str trim | $in + " | "},
      _ => "",
    }
  )
  let time_taken = $env.CMD_DURATION_MS | into duration -u ms | if ($in > 0.5sec) { " | " + ($in | into string) } else { "" }

  let info = " " + $last_exit_code + $git_id + (pwd) + $time_taken + " "

  $default_style + ($info | fill -c "━" -a middle -w (term size).columns) + (ansi reset) + "\n"
}
$env.PROMPT_COMMAND_RIGHT = ""


$env.EDITOR = "nvr -o"
$env.GIT_EDITOR = "nvr --remote-wait-silent"
$env.VISUAL = "nvr --remote-wait-silent"


# Set-up GPG SSH socket
$env.GPG_TTY = ^tty
$env.SSH_AUTH_SOCK = ^gpgconf --list-dirs agent-ssh-socket
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye | ignore


use std/dirs
alias nterm2 = with-env { SHELL: (which nu | get 0.path) } { nvim +term +term "+args # %" +startinsert }
alias dadd = dirs add
alias dn = dirs next
alias dp = dirs prev
alias ddrop = dirs drop

use nu_scripts/custom-completions/rg/rg-completions.nu *
use nu_scripts/custom-completions/uv/uv-completions.nu *
use nu_scripts/custom-completions/gh/gh-completions.nu *
use nu_scripts/custom-completions/git/git-completions.nu *
use nu_scripts/custom-completions/nix/nix-completions.nu *
use nu_scripts/custom-completions/aws/aws-completions.nu *
use nu_scripts/custom-completions/pass/pass-completions.nu *
use nu_scripts/custom-completions/curl/curl-completions.nu *
use nu_scripts/custom-completions/typst/typst-completions.nu *
use nu_scripts/custom-completions/cargo/cargo-completions.nu *
use nu_scripts/custom-completions/rustup/rustup-completions.nu *
