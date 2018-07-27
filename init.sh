set -e

function test-absolute {
    [[ "${1:0:1}" == / || "${1:0:2}" == ~[/a-z] ]]
}

function test-in-dbx-home {
    LOCAL_PATH="$1"
    DBX_PATH=${LOCAL_PATH##$DBX_HOME}
    test "$DBX_PATH" != "$1"
}

function exit-on-error {
    echo "$1" >&2
    exit 1
}

function exit-on-help {
    EXIT_STATUS=${1-0}

    echo -n "Usage: `basename $0`"

    KEYS=${!OPTIONS[@]}
    test -n "$KEYS" && echo -n " [-${KEYS// /] [-}]"
    test -n "$NON_OPTION_ARGS" && echo -n " $NON_OPTION_ARGS"
    echo

    test -n "$DESCRIPTION" && echo && echo "$DESCRIPTION"

    test -z "$KEYS" && exit $EXIT_STATUS
    echo
    for KEY in $KEYS; do
        echo -e "  -$KEY\t${OPTIONS[$KEY]}"
    done
    exit $EXIT_STATUS
}

function exit-on-missing-args {
    exit-on-help 1
}

function exit-on-invalid-option {
    exit-on-error "Invalid option: -$1"
}

function exit-on-cancelled {
    exit-on-error Cancelled
}

function parse-options {
    KEYS=${!OPTIONS[@]}
    OPTSTRING=":${KEYS// /}"
    ENABLED_OPTIONS=""
    while getopts "$OPTSTRING" OPT; do
        test $OPT = ? && exit-on-invalid-option $OPTARG
        test $OPT = h && exit-on-help
        ENABLED_OPTIONS+=$OPT
    done
}

function test-option-enabled {
    [[ $ENABLED_OPTIONS = *$1* ]]
}

function local-path {
    # Argument is expected to be absolute, enforce that:
    ABSOLUTE_PATH_ON_DBX=`realpath -m "/$1"`

    # Go into dir, step by step, stripping the path from the
    # front. This is done to get the same case as already locally set
    # up (Dropbox is case insensitive, some `dbxcli' commands return
    # paths in different case than others).
    DBX_PATH="${ABSOLUTE_PATH_ON_DBX:1}"
    cd "$DBX_HOME" || return 1
    while test -n "$DBX_PATH"; do
        S=${DBX_PATH%%/*}
        test "$S" != . && DBX_SUB_DIR="$S" || \
                DBX_SUB_DIR="$DBX_PATH"
        LOCAL_FILE=`find -iname "$DBX_SUB_DIR" -maxdepth 1 | \
head -n 1`
        test -z "$LOCAL_FILE" && break
        test -f "$LOCAL_FILE" && { DBX_PATH="$LOCAL_FILE"; break; }
        cd "$LOCAL_FILE" || return 1
        DBX_PATH=${DBX_PATH##$DBX_SUB_DIR}
        DBX_PATH=${DBX_PATH##/}
    done

    LOCAL_PATH=`realpath -m "$PWD/$DBX_PATH"`
    echo $LOCAL_PATH
}

function create-revision-dir {
    REVISION_DIR="$DOT_DIR/revisions"
    mkdir -p "$REVISION_DIR" || \
        exit-on-error "Cannot create $REVISION_DIR"
}

function create-hash-dir {
    HASH_DIR="$DOT_DIR/hashes"
    mkdir -p "$HASH_DIR" || \
        exit-on-error "Cannot create $HASH_DIR"
}

function ask-to-continue {
    read -r -p "$1 [y/N] " RESPONSE
    test "${RESPONSE,,}" = y || exit-on-cancelled
}

function compute-b2sum {
    ABS_LOCAL_FILE="$1"
    {
        stat "$ABS_LOCAL_FILE" && cat "$ABS_LOCAL_FILE"
    } | b2sum
}

function compute-hash {
    ABS_LOCAL_FILE="$1"
    MD5SUM=`compute-b2sum "$ABS_LOCAL_FILE"` || \
        exit-on-error "Cannot compute hash for $ABS_LOCAL_FILE"
    HASH=${MD5SUM%% *}
}

function store-hash {
    touch "$HASH_DIR/$HASH"
}

which dbxcli >/dev/null 2>&1 || exit-on-error "\`dbxcli' not found"

# `echo' to cancel possible login prompt:
echo | OUT=`dbxcli version 2>/dev/null` || \
    exit-on-error "Cannot get version of \`dbxcli'. Are you logged in?"
# Version check using `$OUT' is currently not implemented, see:
# https:/github.com/dropbox/dbxcli/issues/99

realpath -m /dbx-nothing >/dev/null 2>&1 && \
    realpath -e / >/dev/null 2>&1 || \
    exit-on-error "Installed \`realpath' does not support required options \`-m' and \`-e'.
Consider installing GNU \`realpath'."

test -v DBX_HOME || exit-on-error "DBX_HOME undefined"
ABSOLUTE_DBX_HOME=`realpath -e $DBX_HOME` || exit-on-error "\$DBX_HOME does not exist: $DBX_HOME"
test-absolute "$DBX_HOME" || exit-on-error "\$DBX_HOME is not absolute"
test -d "$DBX_HOME" || exit-on-error "\$DBX_HOME is not a directory: $DBX_HOME"

DOT_DIR="$HOME/.dbx-tools"
create-revision-dir
create-hash-dir

declare -A OPTIONS
OPTIONS[h]="explain usage"
