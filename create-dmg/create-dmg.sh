#!/bin/sh

eprintf() {
    printf "$@" 1>&2
}

usage() {
    eprintf 'Usage: %s [-h] [/path/to/directory/containing/app]\n\n' "$(basename "$0")"
    eprintf 'Options:\n'
    eprintf -- '-h\tShow this message\n'
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

if [ "$1" = "-h" ]; then
    usage 2>&1
    exit 0
fi

if ! [ -d "$1" ]; then
  echo "Error: $1 is not a directory"
  exit 1
fi

case "$1" in
    *".app" )
        eprintf 'You must pass the folder containing the .app, not the .app itself\n'
        exit 1
        ;;
esac

if ! command -v create-dmg > /dev/null 2>&1; then
    eprintf 'You need to install "create-dmg" to run this script.\n'
    eprintf 'It can be installed with "brew install create-dmg"\n'
    exit 1
fi

create-dmg \
    --volname "QRCoder" \
    --volicon "AppIcon.icns" \
    --background "background.png" \
    --window-pos 200 120 \
    --window-size 800 400 \
    --icon-size 100 \
    --icon "QRCoder.app" 200 200 \
    --hide-extension "QRCoder.app" \
    --app-drop-link 600 200 \
    --no-internet-enable \
    "QRCoderInstaller.dmg" \
    "$1"
