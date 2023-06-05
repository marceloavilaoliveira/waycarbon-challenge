#!/bin/bash
################################################################################
# Description : Shell utility configuration/functions
# Author      : Marcelo Avila de Oliveira <marceloavilaoliveira@gmail.com>
################################################################################

#------------------------------------------------------------------------------#
# Configuration
#------------------------------------------------------------------------------#

# Project components
COMPONENTS="frontend|backend"

# Abort the script on errors that normally would be ignored
set -eu -o pipefail

# Remove space (' ') from IFS so that variables expand as a single word
IFS=$(printf '\n\t')

trap 'cancel' 1 2 3 14 15

#------------------------------------------------------------------------------#
# Function
#------------------------------------------------------------------------------#

function title {
    echo ""
    echo "--------------------------------------------------------------------------------"
    echo "$(date "+%d/%m/%y %H:%M:%S") $1"
    echo "--------------------------------------------------------------------------------"
}

function die {
    echo ""
    echo "ERROR: $*" >&2
    exit 2
}

function dief {
    echo ""
    echo "ERROR: $*" >&2
    echo >&2
    exit 2
}

function cancel {
    # Restore the default terminal line settings
    stty sane
    echo ""
    echo ""
    echo "CANCELED"
    exit 3
}

function warn {
    echo ""
    echo "WARNING: $*" >&2
}

function note {
    echo ""
    echo "NOTE: $*" >&2
}

# Check if all variables passed as arguments are set
function require_vars {
   for var in "$@"; do
       [[ ${!var:-unset} != unset ]] || die "The variable '$var' is unset or null"
   done
}

function require_option {
   for var in "$@"; do
       [[ ${!var:-unset} != unset ]] || die "The option '$var' must be provided"
   done
}

function require_root {
    [[ $EUID -eq 0 ]] || die 'This script must be invoked by root.'
}

function require_readable_files {
    for file in "$@"; do
        [[ -f $file && -r $file ]] || die "The readable file '$file' is not available, are you using the correct user/machine?"
    done
}

function require_readable_dirs {
    for dir in "$@"; do
        [[ -d $dir && -r $dir ]] || die "The readable directory '$dir' is not available, are you using the correct user/machine?"
    done
}

function require_writable_dirs {
    for dir in "$@"; do
        [[ -d $dir && -w $dir ]] || die "The writable directory '$dir' is not available, are you using the correct user/machine?"
    done
}

function create_tmpdir {
    TMPDIR=$(mktemp -d /tmp/tmp.XXXXXXXXXX) || die "Problems creating temporary directory"
    trap 'rm -rf $TMPDIR' EXIT
}
