# TODO: check that realpath supports the -m option (Gnu realpath does)

function dbx-print-usage {
    echo "Usage: $0 $1"
}

function dbx-test-absolute {
    [[ "${1:0:1}" == / || "${1:0:2}" == ~[/a-z] ]]
}

function dbx-exit-on-error {
    echo "$1" 2>&1
    exit 1
}

function dbx-exit-on-usage {
    dbx-print-usage "$1"
    exit 1
}

realpath -m /dbx-nothing >/dev/null 2>&1 && \
    realpath -e / >/dev/null 2>&1 || \
    dbx-exit-on-error "Installed \`realpath' does not support required options \`-m' and \`-e'.
Consider installing GNU \`realpath'."

test -v DBX_HOME || dbx-exit-on-error "DBX_HOME undefined"
ABSOLUTE_DBX_HOME=`realpath -e $DBX_HOME` || dbx-exit-on-error "\$DBX_HOME does not exist: $DBX_HOME"
dbx-test-absolute "$DBX_HOME" || dbx-exit-on-error "\$DBX_HOME is not absolute"
test -d "$DBX_HOME" || dbx-exit-on-error "\$DBX_HOME is not a directory: $DBX_HOME"
