#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# $Id: script 2 2017-01-01 12:00:00Z user $ (work_name)
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
# This is a default template to begin writing a simple python script
# You can add a description of your script in this box
#....................................................................
#
from sys import exit, stdin
from argparse import ArgumentParser, REMAINDER

GLOBALS={}
def debug(message):
    """ print out debug messages when the debug flag is on
    """
    if GLOBALS['verbose']:
        print(message)

def parse_opts():
    """ Parse the arguments passed to the script for evaluating
    """
    parser = ArgumentParser(description='A description of this script ')
    parser.add_argument('--verbose', '-v', action='store_true', help="be verbose")
    parser.add_argument('--dry-run', '-n', action='store_true', help="don't actually do anything, just say what would be done")
    ##add your own args here, or collect them all in 'remainders'
    parser.add_argument('remainders', nargs=REMAINDER)

    cli_args = parser.parse_args()
    GLOBALS['verbose'] = cli_args.verbose
    GLOBALS['dry_run'] = cli_args.dry_run

    if stdin.isatty():
        GLOBALS['args'] = " ".join(cli_args.remainders)
    else:
        GLOBALS['args'] = " ".join(cli_args.remainders) + " " + stdin.read()

 ## V insert your own functions here! V

def main():
    """ The main function: you can call your functinos from here
    """

if __name__ == "__main__":
    """ Start our script when called; exit when imported
    """
    parse_opts()
    main()
else:
    print("This program does not support importing")
    exit(-1)
#__END__#
