#! /bin/bash

if [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    echo "Cannot connect 1password ssh agent: not a wsl environment.";
    return 0;
fi

NPIPERELAY_INSTALLED=$(which "npiperelay.exe" > /dev/null; echo $?)

if [[ $NPIPERELAY_INSTALLED != "0" ]]; then
    echo "Cannot connect 1password ssh agent: npiperelay.exe is not installed on host or is not available on host PATH";
    return 0;
fi

mkdir -p "$HOME/.1password"
export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

ALREADY_RUNNING=$(ps -auxww | grep "[n]piperelay.exe .* -s //./pipe/openssh-ssh-agent" | awk '{print $2}') 

if [[ -n "$ALREADY_RUNNING" ]]; then
  echo "Agent is already running with PID '${ALREADY_RUNNING}'"
  kill "${ALREADY_RUNNING}"
fi

if [[ -S $SSH_AUTH_SOCK ]]; then
  echo "removing previous ssh socket";
  rm "$SSH_AUTH_SOCK";
fi
# setsid to force new session to keep running
# set socat to listen on $SSH_AUTH_SOCK 
# forward to npiperelay which then forwards to openssh-ssh-agent on windows

echo "Connecting 1password to host agent.."
(setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &);

