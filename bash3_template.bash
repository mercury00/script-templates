#!/bin/bash -euE
# $Id: script 3 2017-01-01 12:00:00Z user $ (work_name)
# Copyright (C) 2020 Aaron Thomas
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
#....................................................................
# This is a default template to begin writing a simple bash script
# You can add a description of your script in this box
#....................................................................

declare -a _ARGS_
function set_constants() {
    # #=---------------------------------------------------------------=#
    # | This is at the top of the script for easily editing constants,  |
    # | setting environment variables, and such things                  |
    # | For safety you can define variables from the arguments like so: |
    # |  VAR=${1:-something}                                            |
    # #=-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-=#
    # '  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  '
    _DEBUG_FLAG_="false"
    _DRY_RUN_="false"
    ## Set defaults for command line options
    PARAM="default value"
}

function define_colors() {
    local _bCOLORS=0; local _NUM_COLORS=$(tput colors 2>/dev/null) || local _bCOLORS="${?}"
    if [[ ${_bCOLORS} == "0" ]] && [[ ${_NUM_COLORS} -gt 2 ]]; then
        #foreground='39' or '38', background='49' or '48'
            c_clear='\e[0;39;49m' ;          c_bold='\e[1;39;49m'
        c_underline='\e[4;39;49m' ;       c_inverse='\e[7;39;49m'
            c_black='\e[0;30;49m' ;          c_grey='\e[1;30;49m'
              c_red='\e[0;31;49m' ;     c_brightred='\e[1;31;49m'
            c_green='\e[0;32;49m' ;   c_brightgreen='\e[1;32;49m'
           c_yellow='\e[0;33;49m' ;  c_brightyellow='\e[1;33;49m'
             c_blue='\e[0;34;49m' ;    c_brightblue='\e[1;34;49m'
          c_magenta='\e[0;35;49m' ; c_brightmagenta='\e[1;35;49m'
             c_cyan='\e[0;36;49m' ;    c_brightcyan='\e[1;36;49m'
            c_white='\e[0;37;49m' ;   c_brightwhite='\e[1;37;49m'
    else
        c_clear=''; c_bold=''; c_underline=''; c_inverse=''
        c_red=''; c_brightred=''; c_green=''; c_brightgreen=''
        c_yellow=''; c_brightyellow=''; c_blue=''; c_brightblue=''
        c_magenta=''; c_brightmagenta=''; c_cyan=''; c_brightcyan=''
        c_black=''; c_grey=''
    fi
}

#....................................................................
# define the error/exit captures
#....................................................................
function error() {
    ## usage:  error ${?:-ERR_CODE} "message"
    ## this function is used to capture errors in the script manually
    local error_function="${FUNCNAME[1]}"
    local error_linenum="${BASH_LINENO[0]}"
    local exit_status="${1:-${?}}" ; if [[ "${exit_status:-}" == *[![:digit:]]* ]]; then exit_status=1; fi
    local exit_message="${2:-unknown error}"
    echo -en "${c_red}Fatal error ${exit_status:-unknown} in function ${error_function:-unknown} on line ${c_brightred}${error_linenum:-unknown}${c_clear}: ${exit_message:-unknown} "
    dirs -c
    exit ${exit_status}
}
function success() {
    onexit 0
}
function onexit() {
    local exit_status=${1:-$?}
    if [ ${exit_status} == 0 ]; then
        dirs -c
        exit ${exit_status}
    else
    echo -en "Script: ${0} stopped\n"
    dirs -c
    exit ${exit_status}
    fi
}

function debug() {
    ## usage: debug echo "This is a debug message for example"
    [ "${_DEBUG_FLAG_:-}" == "true" ] && ${@:-echo} || _INVALID_=0
}

function dryrun_eval() {
    ## usage: dryrun_eval "rm -rf /tmp/deleted"
    ## WARNING: USES eval!!! Be Very Careful!
    [ "${_DRY_RUN_:-}" == "true" ] && echo "${@:-}" || eval "${@:-echo}"
}

function usage() {
    # #=---------------------------------------------------------=#
    # |  Echo text about the proper usage of this script for help |
    # #=-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-=#
    # '  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  '
    local scriptname=$(basename ${0})
    echo "A description of this script"
    echo ""
    echo "Usage: ${scriptname} [-v] [-h] ..."
    echo "    -v|--verbose     be verbose"
    echo "    -h|--help        print this message"
    echo "    -n|--dry-run     don't actually do anything, just say what would be done"
    echo ""
}

function parse_opts() {
    unset _nextval_
    for _argv_ in "${@:-}"; do
        if [[ ! -z ${_nextval_:-} ]]; then
            declare "${_nextval_:-}"="${_argv_:-}"
            unset _nextval_
            continue
        fi
        shopt -s extglob
        case "${_argv_}" in
            -h | --help)
                usage; success
                ;;
            -v | --verbose)
                _DEBUG_FLAG_="true"
                ;;
            -n | --dry-run)
                _DRY_RUN_="true"
                ;;
            # #=--------------------------------------------------------=#
            # | place new options here, and update the 'usage' function  |
            # | param is given as an example for opts that take a value  |
            # #=-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|=#
            # '  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V '
            -p | -p=* | --param | --param=*)
                _argv_="${_argv_##@(--|-)@(p|param)?(=| )}"
                if [[ -z "${_argv_:-}" ]]; then _nextval_="PARAM"
                else PARAM=${_argv_}; fi
                continue
            ;;
            -* | -*=*)
                echo "Not a valid option: '${_argv_}'" >&2
                usage; success
            ;;
            *)
                _ARGS_+=(${_argv_})
                continue
            ;;
        esac
        shopt -u extglob
    done
}


# #=------------------------------------------------------------=#
# | add your own functions here!                                 |
# #=-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-=#
# '  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  '


#....................................................................
# we've called bash with -euE, exit on error and error on unset variables
# so define some error prodedures to take when erroring out:
#....................................................................
trap onexit HUP INT TERM QUIT EXIT
trap error ERR ILL
set -o nounset -o errexit
#....................................................................
#  Defining variables we're using and handle options
#....................................................................
set_constants
define_colors
parse_opts ${@:-}

# #=----------------------------------------------------------------#
# |Start our script                                                 |
# |put the guts of your script in here. Functions are defined above.|
# #=-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-=#
# '  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  '


## the script exits successfully
success
