# program 1 grader

This program lists over turned in programs, extracts them in a test directory,
looks for a Makefile (to find an appropriate subdirectory), calls make, finds the
expected output executable (prog1), and executes it against the tests.

Each test is compared against the associated output file. Despite my partial credit threats,
failing a test does not abort remaining tests. Differing outputs are logged.

## Test case generation

I have my version of the assignment. There is also a script to run my prog1 against
inputs to generate the test outputs.
