#!/bin/bash
################################################################################
# Description : Provision the infrastructure in AWS
#               - Initialize Terraform
#               - Create/update the infrastructure
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
require_vars PUBLIC_KEY

# PARAMETERS
verbose=
component=all

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

usage() {
    cat <<EOF

Description:
  Provision the infrastructure in AWS
  - Initialize Terraform
  - Create/update the infrastructure

Usage:
  $script_name [-h] [-v]

Options:
  -h : Help
  -v : Verbose [default = no]

EOF

    exit $1
}

#-------------------------------------------------------------------------------
# Parameters
#-------------------------------------------------------------------------------

while getopts hv j
do
    case $j in
        h)  usage 0;;
        v)  verbose=-v;;
        \?) usage 9;;
    esac
done
shift $((OPTIND - 1))

[[ -n $verbose ]] && set -x

#-------------------------------------------------------------------------------
# MAIN
#-------------------------------------------------------------------------------

title "START $script_name"

export TF_VAR_public_key=$PUBLIC_KEY

cd $proj_path/terraform || exit

echo ""
echo "=> Initializing Terraform"
echo ""

terraform init

echo ""
echo "=> Creating/updating the infrastructure"
echo ""

terraform apply

title "END $script_name"

exit 0
