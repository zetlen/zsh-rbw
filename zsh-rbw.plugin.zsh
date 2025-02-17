# rbwpw function copies the password of a service to the clipboard
# and clears it after 20 seconds
function rbwpw {
  if [[ $# -ne 1 ]]; then
    echo "usage: rbwpw <service>"
    return 1
  fi
  local service=$1
  if ! rbw unlock; then
    echo "rbw is locked"
    return 1
  fi
  local pw=$(rbw get $service 2>/dev/null)
  if [[ -z $pw ]]; then
    echo "$service not found"
    return 1
  fi
  echo -n $pw | clipcopy
  echo "password for $service copied!"
  {sleep 20 && clipcopy </dev/null 2>/dev/null} &|
}

function _rbwpw {
  local -a services
  services=("${(@f)$(rbw ls --fields name,folder,user | column -t 2>/dev/null)}")
  [[ -n "$services" ]] && compadd -a -- services
}

_fzf_complete_rbwpw() {
  _fzf_complete 
}

compdef _rbwpw rbwpw
