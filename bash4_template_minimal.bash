#!/bin/bash -euE
# $Id: script 4 2017-01-01 12:00:00Z user $ (work_name)
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

#set constants
DEBUG_FLAG=false

function debug() {
    ## usage: debug printf "This is a debug message for example\n"
    ${DEBUG_FLAG:-false} && "${@:-printf}" 1>&2 || _INVALID_=0
}
function error() {
    ## usage:  error ${?:-ERR_CODE} "message"
    ## this function is used to capture errors in the script manually
    local error_function="${FUNCNAME[1]}"
    local error_linenum="${BASH_LINENO[0]}"
    local exit_status="${1:-${?}}" ; if [[ "${exit_status:-}" == *[![:digit:]]* ]]; then exit_status=1; fi
    local exit_message="${2:-unknown error}"
    printf 'Fatal error %d in function %s on line %d: %s\n' ${exit_status:-'-1'} "${error_function:-unknown}" ${error_linenum:-'-1'} "${exit_message:-unknown}"
    dirs -c
    exit ${exit_status}
}
function success() {
    onexit 0
}
function onexit() {
    local exit_status=${1:-$?}
    trap '' HUP INT TERM QUIT EXIT ERR ILL
    if [ ${exit_status} == 0 ]; then dirs -c; exit ${exit_status}
    else printf 'Script: %s stopped\n' "${0}"; dirs -c; exit ${exit_status}
    fi
}
function usage() {
    # put usage here:
    printf 'Usage: %s -h -v \n\n' "$0"
}
function parse_opts() {
    unset _nextval_
    for _argv_ in "${@:-}"; do
        if [[ ! -z ${_nextval_:-} ]]; then
            export ${_nextval_}=${_argv_}; unset _nextval_
            continue
        fi
        shopt -s extglob
        case "${_argv_}" in
            -h | --help)
                usage; success
                ;;
            -v | --verbose)
                DEBUG_FLAG=true
                ;;
            -p | -p=* | --param | --param=*)
                _argv_="${_argv_##@(--|-)@(p|param)?(=| )}"
                if [[ -z "${_argv_:-}" ]]; then _nextval_="param"
                else param=${_argv_}; fi
                continue
                ;;
            --)
                _ARGS_+=(${_argv_##-- })
                continue
                ;;
            -[[:alpha:]][[:alpha:]]*)
                local singleargs="${_argv_#-}"; local -a singles=();
                for (( index=0; index<=${#singleargs}; index++ )); do
                    singles+=("-${singleargs:${index}:1}"); done
                parse_opts "${singles[@]}"
                continue
                ;;
            -* | -*=*)
                printf "Not a valid option: '%s'\n" "${_argv_}" >&2
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

trap onexit HUP INT TERM QUIT EXIT
trap error ERR ILL
set -o nounset -o errexit -o errtrace -o pipefail
parse_opts "${@:-}"

#_start your script here_


#_end your script here_
success
#_end of script_