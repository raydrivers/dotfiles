if [ -t 2 ]; then
    _R=$(tput setaf 1 2>/dev/null) || _R=
    _G=$(tput setaf 2 2>/dev/null) || _G=
    _Y=$(tput setaf 3 2>/dev/null) || _Y=
    _C=$(tput setaf 6 2>/dev/null) || _C=
    _D=$(tput dim 2>/dev/null) || _D=
    _0=$(tput sgr0 2>/dev/null) || _0=
else
    _R= _G= _Y= _C= _D= _0=
fi

log_ok()   { printf '  %s+%s %s\n' "$_G" "$_0" "$1" >&2; }
log_info() { printf '%s%s%s\n' "$_G" "$1" "$_0" >&2; }
log_warn() { printf '%s%s%s\n' "$_Y" "$1" "$_0" >&2; }
log_error(){ printf '%s%s%s\n' "$_R" "$1" "$_0" >&2; }
log_section() { printf '\n%s%s%s\n' "$_G" "$1" "$_0" >&2; }
die() { log_error "$1"; exit "${2:-1}"; }
