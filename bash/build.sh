#!/bin/bash
################################################################################
# Description : Build the docker images
# Author      : Marcelo Avila de Oliveira <marceloavilaoliveira@gmail.com>
################################################################################

#-------------------------------------------------------------------------------
# General
#-------------------------------------------------------------------------------

script_pathname=$(readlink -nf "$0")
script_path=$(dirname $script_pathname)
script_name=$(basename $script_pathname)
proj_path=$(dirname $script_path)

#-------------------------------------------------------------------------------
# Libraries
#-------------------------------------------------------------------------------

source $proj_path/bash/utils.sh

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------

# PARAMETERS
verbose=
component=all

#------------------------------------------------------------------------------#
# Functions
#------------------------------------------------------------------------------#

usage() {
    cat <<EOF

Description:
  Build the docker images

Usage:
  $script_name [-h] [-v] [-c component]

Options:
  -h           : Help
  -v           : Verbose [default = no]
  -c component : Component to be built [default = $component]
                 - Must be a valid component:
                   $COMPONENTS
                 - all = all compoents

EOF

    exit $1
}

#------------------------------------------------------------------------------#
# Parameters
#------------------------------------------------------------------------------#

while getopts hvc: j
do
    case $j in
        h)  usage 0;;
        v)  verbose=-v;;
        c)  component=$OPTARG;;
        \?) usage 9;;
    esac
done
shift $((OPTIND - 1))

[[ -n $verbose ]] && set -x

component=$(echo $component | tr '[:upper:]' '[:lower:]')

if [[ ! $component =~ ^($COMPONENTS|all)$ ]]
then
    die "'component' $component is invalid"
fi

#------------------------------------------------------------------------------#
# MAIN
#------------------------------------------------------------------------------#

title "START $script_name"

if [[ $component = "all" ]]
then
    component_aux=$COMPONENTS
else
    component_aux=$component
fi

for comp in $(echo $component_aux | tr '|' '\n')
do
    echo ""
    echo "#"
    echo "# Component: $comp"
    echo "#"

    image=waycarbon-challenge-$comp

    echo ""
    echo "=> Building the $image image"
    echo ""

    docker build -t $image:latest ./$comp
done

title "END $script_name"

exit 0
