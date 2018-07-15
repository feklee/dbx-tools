set -e

function dbx-test-absolute {
    [[ "${1:0:1}" == / || "${1:0:2}" == ~[/a-z] ]]
}

function dbx-exit-on-error {
    echo "$1" >&2
    exit 1
}

function dbx-exit-on-help {
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

function dbx-exit-on-missing-args {
    dbx-exit-on-help 1
}

function dbx-exit-on-invalid-option {
    dbx-exit-on-error "Invalid option: -$1"
}

function dbx-parse-options {
    KEYS=${!OPTIONS[@]}
    OPTSTRING=":${KEYS// /}"
    ENABLED_OPTIONS=""
    while getopts "$OPTSTRING" OPT; do
	test $OPT = ? && dbx-exit-on-invalid-option $OPTARG
	test $OPT = h && dbx-exit-on-help
	ENABLED_OPTIONS+=$OPT
    done
}

function dbx-test-option-enabled {
    [[ $ENABLED_OPTIONS = *$1* ]]
}

# TODO: Check installation of dbxcli
realpath -m /dbx-nothing >/dev/null 2>&1 && \
    realpath -e / >/dev/null 2>&1 || \
    dbx-exit-on-error "Installed \`realpath' does not support required options \`-m' and \`-e'.
Consider installing GNU \`realpath'."

test -v DBX_HOME || dbx-exit-on-error "DBX_HOME undefined"
ABSOLUTE_DBX_HOME=`realpath -e $DBX_HOME` || dbx-exit-on-error "\$DBX_HOME does not exist: $DBX_HOME"
dbx-test-absolute "$DBX_HOME" || dbx-exit-on-error "\$DBX_HOME is not absolute"
test -d "$DBX_HOME" || dbx-exit-on-error "\$DBX_HOME is not a directory: $DBX_HOME"

declare -A OPTIONS
OPTIONS[h]="explain usage"
