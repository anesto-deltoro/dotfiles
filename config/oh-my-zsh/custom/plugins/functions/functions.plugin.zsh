# Create a new directory and enter it

mk() {
  mkdir -p "$@" && cd "$@"
}

# Check if resource is served compressed

check_compression() {
  curl --write-out 'Size (uncompressed) = %{size_download}\n' --silent --output /dev/null $1
  curl --header 'Accept-Encoding: gzip,deflate,compress' --write-out 'Size (compressed) =   %{size_download}\n' --silent --output /dev/null $1
  curl --head --header 'Accept-Encoding: gzip,deflate' --silent $1 | grep -i "cache\|content\|vary\|expires"
}

# Get gzipped file size

gz() {
  local ORIGSIZE=$(wc -c < "$1")
  local GZIPSIZE=$(gzip -c "$1" | wc -c)
  local RATIO=$(echo "$GZIPSIZE * 100/ $ORIGSIZE" | bc -l)
  local SAVED=$(echo "($ORIGSIZE - $GZIPSIZE) * 100/ $ORIGSIZE" | bc -l)
  printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" "$ORIGSIZE" "$GZIPSIZE" "$SAVED" "$RATIO"
}

# Create a data URL from a file

dataurl() {
  local MIMETYPE=$(file --mime-type "$1" | cut -d ' ' -f2)
  if [[ $MIMETYPE == "text/*" ]]; then
    MIMETYPE="${MIMETYPE};charset=utf-8"
  fi
  echo "data:${MIMETYPE};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Tree
t() {
  tree -AdL ${1:-1}
}

# Get Bundle ID of macOS app
# Example: bundleid terminal

bundleid() {
  local ID=$( osascript -e 'id of app "'"$1"'"' )
  if [ ! -z $ID ]; then
    echo $ID | tr -d '[:space:]' | pbcopy
    echo "$ID (copied to clipboard)"
  fi
}

# Webserver

srv() {
  local DIR=${1:-.}
  local AVAILABLE_PORT=$(get-port)
  local PORT=${2:-$AVAILABLE_PORT}
  if [ "$PORT" -le "1024" ]; then
    sudo -v
  fi
  open "http://localhost:$PORT"
  ws --directory "$DIR" --port "$PORT"
}

# Get IP from hostname

hostname2ip() {
  ping -c 1 "$1" | egrep -m1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
}

# Upload file to transfer.sh
# https://github.com/dutchcoders/transfer.sh/

transfer() {
  tmpfile=$( mktemp -t transferXXX )
  curl --progress-bar --upload-file "$1" https://transfer.sh/$(basename $1) >> $tmpfile;
  cat $tmpfile;
  rm -f $tmpfile;
}

# Find real from shortened url

unshorten() {
  curl -sIL $1 | sed -n 's/Location: *//p'
}

# Show line, optionally show surrounding lines

line() {
  local LINE_NUMBER=$1
  local LINES_AROUND=${2:-0}
  sed -n "`expr $LINE_NUMBER - $LINES_AROUND`,`expr $LINE_NUMBER + $LINES_AROUND`p"
}

# Show duplicate/unique lines
# Source: https://github.com/ain/.dotfiles/commit/967a2e65a44708449b6e93f87daa2721929cb87a

duplines() {
  sort $1 | uniq -d
}

uniqlines() {
  sort $1 | uniq -u
}