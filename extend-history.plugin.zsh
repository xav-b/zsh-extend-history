# http://zsh.sourceforge.net/Doc/Release/Functions.html
# NOTE is ";" a good idea?

# defaul configuration (can be overwritten)
export EXTENDED_HISTORY_FILE="$HOME/.zsh_extended_history"

_record() {
  printf "$@" >> ${EXTENDED_HISTORY_FILE}
}

_record_project_info() {
  git status &> /dev/null
  if [[ "$?" -eq 0 ]]; then
    _record "git_branch=$(git rev-parse --abbrev-ref HEAD);git_commit=$(git rev-parse --short HEAD);git_project=$(basename $(git rev-parse --show-toplevel));"
  fi

  # TODO support other language than Python
  if [[ -n "${VIRTUAL_ENV}" ]]; then
    _record "venv=${VIRTUAL_ENV};runtime=$(python --version);"
  fi
}

_record_terminal_info() {
  # TODO tmux? ($TMUX $TMUX_PANE)
  _record "tty=$(tty);term=${TERM};shell=${SHELL};tmux=${TMUX};"
}

_command_history_preexec() {
  # NOTE should it be global?
  _record "startts=$(date +%s);user_cmd=$1;real_cmd=$2;user=$USER;host=$(hostname);pwd=$PWD;"

  _record_terminal_info

  _record_project_info
}

_command_history_precmd() {
  # Executed before each prompt.
  # idea: detect git project

  # it has to be the first line otherwise we risk to get the exit code of
  # another command
  local LAST_EXIT_CODE=$?

  # FIXME it's written twice
  _record "endts=$(date +%s);code=${LAST_EXIT_CODE}\n"
}

# register hooks
precmd_functions+=(_command_history_precmd)
preexec_functions+=(_command_history_preexec)
