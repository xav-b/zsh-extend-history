# http://zsh.sourceforge.net/Doc/Release/Functions.html
# NOTE is ";" a good idea?

# defaul configuration (can be overwritten)
export EXTENDED_HISTORY_FILE="$HOME/.zsh_extended_history"

_command_history_preexec() {
  # NOTE should it be global?
  printf "startts=$(date +%s);user_cmd=$1;real_cmd=$2;user=$USER;host=$(hostname);pwd=$PWD" >> ${EXTENDED_HISTORY_FILE}
}

_command_history_precmd() {
  # Executed before each prompt.
  # idea: detect git project

  # it has to be the first line otherwise we risk to get the exit code of
  # another command
  local LAST_EXIT_CODE=$?

  # FIXME it's written twice
  printf ";endts=$(date +%s);code=${LAST_EXIT_CODE}\n" >> ${EXTENDED_HISTORY_FILE}
}

# register hooks
precmd_functions+=(_command_history_precmd)
preexec_functions+=(_command_history_preexec)
