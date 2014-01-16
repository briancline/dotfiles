#!/usr/bin/env bash
#
# swaplist.sh
#
# Gets current swap usage for all running processes, displays all
# swapping processes and how much swap memory they're consuming,
# in descending order by kilobytes of swap
#
# The script formerly known on the intertubes as "find-out-what-is-using-your-swap.sh":
# -- rev 0.4, 2014-01013, Brian Cline       - cleanup, readability, better arg handling
# -- rev.0.3, 2012-09-03, Jan Smid          - alignment and intendation, sorting
# -- rev.0.2, 2012-08-09, Mikko Rantalainen - pipe the output to "sort -nk3" to get sorted output
# -- rev.0.1, 2011-05-27, Erik Ljungstrom   - initial version


SCRIPT_NAME=$(basename $0)

SORT="kb"  # {pid|kb|name} [default: kb]
TOTAL_ONLY=false


while getopts "hTs:" opt; do
    case $opt in
        h)
            echo "Usage: ${SCRIPT_NAME} [-h] [-T] [-s value]"
            echo ""
            echo "Uses Linux' procfs (/proc) to determine how much swap space is being used by"
            echo "processes on the system, gathering details on each process and how much swap"
            echo "memory each is using."
            echo ""
            echo "Flags:"
            echo "    -h        Shows this help."
            echo "    -T        Only provide the total memory used in kilobytes. (default: off)"
            echo "    -s value  The value by which the full process list will be sorted."
            echo "              Valid values are kb, pid, and name. (default: $SORT)"
            exit 0
            ;;
        T)
            TOTAL_ONLY=true
            ;;
        s)
            SORT=$OPTARG
            ;;
        \?)
            echo "Unknown option -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument" >&2
            exit 1;
            ;;
    esac
done


if [ ! -x "$(which mktemp)" ]; then
    echo "ERROR: mktemp is not available!" >&2
    exit 1
fi

TMPDIR=$(mktemp -d)
if [ ! -d "${TMPDIR}" ]; then
    echo "ERROR: unable to create temp dir ${TMPDIR}!" >&2
    exit 1
fi

touch ${TMPDIR}/${SCRIPT_NAME}.pid \
      ${TMPDIR}/${SCRIPT_NAME}.kb \
      ${TMPDIR}/${SCRIPT_NAME}.name


PROC_SUM=0
SYS_TOTAL=0

for procdir in $(find /proc/ -maxdepth 1 -type d -regex "^/proc/[0-9]+"); do
    pid=$(echo $procdir | cut -d / -f 3)
    procname=$(ps -p $pid -o comm --no-headers)

    for swap in $(grep Swap $procdir/smaps 2>/dev/null | awk '{ print $2 }'); do
        let PROC_SUM=$PROC_SUM+$swap
    done

    if [ $PROC_SUM -gt 0 ]; then
        echo -e "${pid}\t${PROC_SUM}\t${procname}" >> ${TMPDIR}/${SCRIPT_NAME}.pid
        echo -e "${PROC_SUM}\t${pid}\t${procname}" >> ${TMPDIR}/${SCRIPT_NAME}.kb
        echo -e "${procname}\t${PROC_SUM}\t${pid}" >> ${TMPDIR}/${SCRIPT_NAME}.name
    fi

    let SYS_TOTAL=$SYS_TOTAL+$PROC_SUM
    PROC_SUM=0
done


if ! $TOTAL_ONLY; then
    case "${SORT}" in
        name)
            echo -e "name\tkB\tpid"
            echo "========================================"
            cat ${TMPDIR}/${SCRIPT_NAME}.name | sort -r
            echo "========================================"
            ;;

        kb | kB | KB)
            echo -e "kB\tpid\tname"
            echo "========================================"
            cat ${TMPDIR}/${SCRIPT_NAME}.kb | sort -rh
            echo "========================================"
            ;;

        pid)
            echo -e "pid\tkB\tname"
            echo "========================================"
            cat ${TMPDIR}/${SCRIPT_NAME}.pid | sort -rh
            echo "========================================"
            ;;

        *)
            echo "Invalid sort value \"${SORT}\". Please use pid, kb, or name." >&2
            ;;
    esac
fi

echo "Total swap used: ${SYS_TOTAL} kB"

rm -rf "${TMPDIR}/"
