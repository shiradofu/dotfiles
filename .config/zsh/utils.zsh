[[ "$OSTYPE" == "darwin"* ]] \
  && export IS_MAC=true \
  || export IS_MAC=false

[ -f /proc/sys/fs/binfmt_misc/WSLInterop ] \
  && export IS_WSL=true \
  || export IS_WSL=false

exists()   { type $1 > /dev/null 2>&1; }
required() {
  for arg; do
    if ! type "${arg}" > /dev/null 2>&1; then
      printf "${arg} required.\n"
      return 127
    fi
  done
}
