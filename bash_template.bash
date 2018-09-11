#!/bin/bash -euE
# $Id: script 2 2017-01-01 12:00:00Z user $ (work_name)
#....................................................................
# This is a default template to begin writing a simple bash script
# You can add a description of your script in this box
#....................................................................

declare -A _GLOBALS_=()
function set_constants() {
    # #=---------------------------------------------------------------=#
    # | This is at the top of the script for easily editing constants,  |
    # | setting environment variables, and such things                  |
    # | For safety you can define variables from the arguments like so: |
    # |  VAR=${1:-something}                                            |
    # #=-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-=#
    # '  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  '
    _GLOBALS_['debug_flag']=false
    _GLOBALS_['dry_run']=false
    ## Set defaults for command line options
    _GLOBALS_['param']="default value"
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
    [ "${_GLOBALS_['debug_flag']:-}" == true ] && ${@:-echo} || _INVALID_=0
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
    while [ $# -gt 0 ]; do
        case ${1:-} in
            -h | --help)
                usage; success
                ;;
            -v | --verbose)
                _GLOBALS_['debug_flag']=true
                ;;
            -n | --dry-run)
                _GLOBALS_['dry_run']=true
                ;;
            # #=--------------------------------------------------------=#
            # | place new options here, and update the 'usage' function  |
            # | param is given as an example for opts that take a value  |
            # #=-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|=#
            # '  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V  V '
            -p | -p=* | --param | --param=*)
                local arg="${1#-*=*}"; local arg=${arg#--param*}; local arg=${arg#-p*};
                ## ^^ Change the --param/-p fields in the above two lines for new parameters to add
                if [[ -z ${arg:-} ]]; then local argshift=0; else local argshift=1; local arg+=" ";fi
                if [[ ! -z ${2:-} ]] && [[ "${2:0:1}" != "-" ]]; then local arg+="${@:2}";
                    if [[ "${arg:0:1}" == '"' ]] || [[ "${arg:0:1}" == "'" ]]; then
                        local arg="${arg%[\"\']*}"; local arg="${arg#*[\"\']}"; shift;
                    else local arg=${arg%%[[:space:]]-*}; shift; fi
                elif [[ ${argshift} != 1 ]]; then echo "You specified: $1, but provided no value"; usage; success;
                else argshift=0; fi
                array_to_count=(${arg}); local num_of_array=$((${#array_to_count[@]} - ${argshift}));
                _GLOBALS_['param']="${arg}"; shift "${num_of_array-1}"; continue
                ;;
            --)
                break
                ;;
            -[[:alpha:]][[:alpha:]]*)
                split=${1}; shift
                set -- $(echo "$split" | cut -c 2- | sed 's/./-& /g') "$@"
                continue
                ;;
            --* | -?)
                echo "Not a valid option: '${1}'" >&2
                usage; success
                ;;
            *)
                break
                ;;
        esac
        shift
    done
    _GLOBALS_['args']=("${@:-}")
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
#___END___#