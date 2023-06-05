#!/bin/bash
################################################################################
# Description : Push the docker images to ECR
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
require_vars ECR_REGISTRY AWS_REGION

# PARAMETERS
verbose=
component=all

#------------------------------------------------------------------------------#
# Functions
#------------------------------------------------------------------------------#

usage() {
    cat <<EOF

Description:
  Push the docker images to ECR
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

    # CHECK IF THE REPOSITORY EXISTS
    if aws ecr describe-repositories --repository-names "$image" --region "$AWS_REGION" >/dev/null 2>&1
    then
        note "Using the existent $image repository"
    else
        # CREATE THE REPOSITORY
        echo ""
        echo "=> Creating the $image repository"
        echo ""

        aws ecr create-repository --repository-name $image --region $AWS_REGION
    fi

    echo ""
    echo "=> Tagging the $image image"
    echo ""

    docker tag $image:latest $ECR_REGISTRY.dkr.ecr.$AWS_REGION.amazonaws.com/$image

    echo ""
    echo "=> Pushing the $image image"
    echo ""

    docker push $ECR_REGISTRY.dkr.ecr.$AWS_REGION.amazonaws.com/$image:latest
done

title "END $script_name"

exit 0
