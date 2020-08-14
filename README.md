# script-templates
merely some starter code for writing a simple script

# bash 4 template
**how to use**

The bash template has several features and sections for easily writing a quick script that handles errors and does some parsing of command line options for you.

At the top:

*set_constants*:
Many simple variables can be stored in the `$_GLOBALS_` associate array. Constants that you might want to edit from one script to the next are defined in the set_constants function at the top of the script for easy locating/editing during development or when things change.

*define_colors*:
If the terminal supports it, color varaibles are set up for use in the error messages or in your own output.

*error*:
A function exists that you can explicitly call like so:
` error 1 "error 1" `
this function is also called when your script throws errors itself, notifying you of the line number in your script that failed (and the function if applicable)

*debug*:
when the verbose flag is set, this function will execute whatever's passed to it. For example, `debug echo "this is a debug message"`

*usage*:
you can update this function to output help messages for your script

*parse_opts*:
this is where you'll add command line arguments. An example of the optional argument 'param' is given for you to modify/replace with your own optional arguments. Positional arguments are collected in the `$_ARGS_` array

You will likely want to remove the guiding comments when making your own script from this.

Space is given to add your own functions and to call them at the bottom of the script

# bash 3 template
**how to use**

*set_constants*:
Constants that you might want to edit from one script to the next are defined in the set_constants function at the top of the script for easy locating/editing during development or when things change.

*define_colors*:
If the terminal supports it, color varaibles are set up for use in the error messages or in your own output.

*error*:
A function exists that you can explicitly call like so:
` error 1 "error 1" `
this function is also called when your script throws errors itself, notifying you of the line number in your script that failed (and the function if applicable)

*debug*:
when the verbose flag is set, this function will execute whatever's passed to it. For example, `debug echo "this is a debug message"`

*usage*:
you can update this function to output help messages for your script

*parse_opts*:
this is where you'll add command line arguments. An example of the optional argument 'param' is given for you to modify/replace with your own optional arguments. Positional arguments are collected in the `$_ARGS_` array

You will likely want to remove the guiding comments when making your own script from this.

Space is given to add your own functions and to call them at the bottom of the script

# python template

This template merely sets up argparse with some dummy values and prevents importing.
