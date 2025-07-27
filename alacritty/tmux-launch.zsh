#!/bin/zsh

SESSION="main"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  /usr/bin/tmux new-session -t "$SESSION"
else
  /usr/bin/tmux new-session -s "$SESSION"
fi
