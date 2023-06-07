#!/bin/bash
################################################################################
# Description : Push the docker images to Docker Hub
#               - Create the repositories if needed
#               - Tag the images
#               - Push the images
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

source $proj_path/.env
source $proj_path/bash/utils.sh

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------

# ENVIRONMENT
require_vars DOCKER_HUB_USER

# PARAMETERS
verbose=
component=all

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

usage() {
    cat <<EOF

Description:
  Push the docker images to Docker Hub
  - Create the repositories if needed
  - Tag the images
  - Push the images

Usage:
  $script_name [-h] [-v] [-c component]

Options:
  -h           : Help
  -v           : Verbose [default = no]
  -c component : Component to be pushed [default = $component]
                 - Must be a valid component:
                   $COMPONENTS
                 - all = all compoents

EOF

    exit $1
}

#-------------------------------------------------------------------------------
# Parameters
#-------------------------------------------------------------------------------

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

#-------------------------------------------------------------------------------
# MAIN
#-------------------------------------------------------------------------------

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

    if [[ $(curl --silent --output /dev/null --write-out "%{http_code}" --request GET https://hub.docker.com/v2/repositories/$DOCKER_HUB_USER/$image) = 200 ]]
    then
        note "Using the existent $image repository"
    else
        # CREATE THE REPOSITORY
        echo ""
        echo "=> Creating the $image repository"
        echo ""

        # CHECK IF GITHUB PASSWORD IS SET
        if [[ ${DOCKER_HUB_PASS:-unset} = unset ]]
        then
            # ASKS FOR THE GITHUB PASSWORD
            echo    ""
            echo    "Docker Hub password"
            echo -n "> "
            read -r -s DOCKER_HUB_PASS
            echo    ""

            require_option DOCKER_HUB_PASS
        fi

        curl --silent --user "$DOCKER_HUB_USER:$DOCKER_HUB_PASS" --data '{}' --header "Content-Type: application/json" --request POST "https://hub.docker.com/v2/repositories/$DOCKER_HUB_USER/$image"
    fi

    echo ""
    echo "=> Tagging the $image image"
    echo ""

    docker tag $image:latest $DOCKER_HUB_USER/$image:latest

    echo ""
    echo "=> Pushing the $image image"
    echo ""

    docker push $DOCKER_HUB_USER/$image:latest
done

title "END $script_name"

exit 0
