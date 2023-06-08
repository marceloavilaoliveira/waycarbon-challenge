#!/bin/bash
################################################################################
# Description : Update the server IP in Dynu site
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
ip=

# DYNU SETUP
rest_url="https://api.dynu.com/v2"
api_key="5W66VVfebb3cU3343d4554X6dVT72VfY"
server_id="9962912"
server_name="waycarbon-challenge.freeddns.org"

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

usage() {
    cat <<EOF

Description:
  Update the server IP in Dynu site

Usage:
  $script_name [-h] [-v] -i ip

Options:
  -h    : Help
  -v    : Verbose [default = no]
  -i ip : New server IP

EOF

    exit $1
}

#-------------------------------------------------------------------------------
# Parameters
#-------------------------------------------------------------------------------

while getopts hvi: j
do
    case $j in
        h)  usage 0;;
        v)  verbose=-v;;
        i)  ip=$OPTARG;;
        \?) usage 9;;
    esac
done
shift $((OPTIND - 1))

[[ -n $verbose ]] && set -x

require_option ip

if [[ ! $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
then
    die "'ip' $ip is invalid"
fi

#-------------------------------------------------------------------------------
# MAIN
#-------------------------------------------------------------------------------

title "START $script_name"

echo ""
echo "=> Updating the $server_name server IP to $ip"
echo ""

curl --silent --data @- --header 'accept: application/json' --header "API-Key:$api_key" --request POST $rest_url/dns/$server_id <<EOF
{
    "name"       : "waycarbon-challenge.freeddns.org",
    "ipv4Address": "$ip"
}
EOF

title "END $script_name"

exit 0
