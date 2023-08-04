<!--

https://jeromebelleman.gitlab.io/posts/publishing/manpages/

-->

% shell_argument_parsing_file(1)
% Felipe M. Vieira
% August 2023

# NAME

shell_argument_parsing_file – A bash library to parse CLI arguments defined in a [recfile][recutils_website].

# SYNOPSIS

**shell_argument_parsing_file** [**\--help** | **\--test**]

# DESCRIPTION

**shell_argument_parsing_file** provides a bash function (`parse`) that takes 3 arguments:

```
source /usr/local/lib/shell_argument_parsing_file/shell_argument_parsing_file

declare -A arguments

parse ./shell_argument_parsing_file_entrypoint.rec arguments "${*:-}"
```

A recfile, a bash associative array (to mutate it) and a string with the CLI arguments to parse.

The associative array is mutated and its contents are:

*   Key value pairs of the parameters at the recfile.

    If a parameter consumes 0 arguments, its contents are set to `true`.

    Parameters that consume more than 2 arguments are not supported yet.

*   `rest_n`: number of parameters not parametrized at the recfile.

*   `rest0`: the 0-th parameter not parametrized at the recfile.

The executable is provided solely for testing purposes.

# GENERAL OPTIONS

**-t**, **\--test**
:   Test the program.

**-h**, **\--help**
:   Print help and exit.

[recutils_website]: https://www.gnu.org/software/recutils/ (GNU Recutils)
