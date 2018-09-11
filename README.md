# script-templates
merely some starter code for writing a simple script

# bash template
*how to use*
the bash template has several features and sections for easily writing a quick script that handles errors and does some parsing of command line options and such.

globals: many simple variables can be stored in the $_GLOBALS_ array (dictionary). Constants that you might want to edit from one script to the next are defined in the set_constants function at the top of the script for easy locating/editing during development or when things change.

colors are defined if the terminal supports it, for use in the error messages or in your own output.

an error function exists that you can explicitly call like so:
` error 1 "error 1" `
this function is also called when your script throws errors itself, notifying you of the line number in your script that failed (and the function if applicable)
