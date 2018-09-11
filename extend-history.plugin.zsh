# Leverage zsh hooks to enhance history recording
# http://zsh.sourceforge.net/Doc/Release/Functions.html

# TODO use `locale`

# defaul configuration (can be overwritten)
export ZSH_EXTEND_HISTORY_DEFAULT_FILE="$HOME/.zsh_extended_history"
export ZSH_EXTEND_HISTORY_FILE="$ZSH_EXTEND_HISTORY_DEFAULT_FILE"

g_cmd=""

_check_mode() {
  [ -n "$ZSH_EXTEND_HISTORY_DEBUG" ] && echo "[WARN] debug mode activated on zsh history plugin"
  [ -n "$ZSH_EXTEND_HISTORY_DEBUG" ] && ZSH_EXTEND_HISTORY_FILE="/dev/stdout"
  # otherwise set it back to history file
  [ -z "$ZSH_EXTEND_HISTORY_DEBUG" ] &&  ZSH_EXTEND_HISTORY_FILE="${ZSH_EXTEND_HISTORY_FILE:-$ZSH_EXTEND_HISTORY_DEFAULT_FILE}"
}

_record() {
  g_cmd="${g_cmd};$@"
}

_commit() {
  _check_mode
  #printf "$@" >> ${ZSH_EXTEND_HISTORY_FILE}
  printf "${g_cmd}\n" >> ${ZSH_EXTEND_HISTORY_FILE}
  g_cmd=""
}

_record_project_info() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == true ]]; then
    _record "git_branch=$(git rev-parse --abbrev-ref HEAD);git_commit=$(git rev-parse --short HEAD);git_project=$(basename -s .git `git config --get remote.origin.url`)"
  fi

  # TODO support other language than Python
  if [[ -n "${VIRTUAL_ENV}" ]]; then
		# cf https://stackoverflow.com/questions/23862569/unable-to-store-python-version-to-a-shell-variable
    _record "venv=$(basename ${VIRTUAL_ENV});runtime=$(python --version 2>&1)"
  fi
}

_record_terminal_info() {
  _record "tty=$(tty);term=${TERM};shell=${SHELL};tmux=${TMUX}"
}

_command_history_preexec() {
  # NOTE should it be global?
  _record "uuid=$(uuidgen | tr '[:upper:]' '[:lower:]');startts=$(date +%s);user_cmd=$1;real_cmd=$2;user=$USER;host=$(hostname);pwd=$PWD"

  _record_terminal_info

  _record_project_info
}

_command_history_precmd() {
  # Executed before each prompt.

  # it has to be the first line otherwise we risk to get the exit code of
  # another command
  local LAST_EXIT_CODE=$?

  if [[ "$g_cmd" != "" ]]; then
    _record "endts=$(date +%s);code=${LAST_EXIT_CODE}"
    _commit
  else
    # reset (I'm not sure it's necessary)
    g_cmd=""
  fi
}

# register hooks
precmd_functions+=(_command_history_precmd)
preexec_functions+=(_command_history_preexec)
