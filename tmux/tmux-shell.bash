# `tmux` wrapper for interactive shells:
# - attach existing session(s)
# - prompt to choose when multiple sessions exist
# - create new session only when none exists
tmux() {
  if [ "$#" -gt 0 ]; then
    command tmux "$@"
    return
  fi

  if [ -n "$TMUX" ]; then
    echo "Already inside tmux."
    return
  fi

  if ! command tmux has-session 2>/dev/null; then
    command tmux new-session
    return
  fi

  mapfile -t _tmux_sessions < <(command tmux list-sessions -F '#S')
  if [ "${#_tmux_sessions[@]}" -eq 1 ]; then
    command tmux attach-session -t "${_tmux_sessions[0]}"
    return
  fi

  echo "Choose tmux session:"
  select _tmux_choice in "${_tmux_sessions[@]}" "Create new session"; do
    if [ -z "$_tmux_choice" ]; then
      echo "Invalid choice."
      continue
    fi
    if [ "$_tmux_choice" = "Create new session" ]; then
      command tmux new-session
    else
      command tmux attach-session -t "$_tmux_choice"
    fi
    break
  done
}
