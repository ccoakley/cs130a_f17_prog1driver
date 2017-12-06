#!/bin/bash

prog=/cs/class/cs130a/coakley_version/prog1
test_input_dir=/cs/class/cs130a/prog1_tests/
test_output_dir=/cs/class/cs130a/prog1_outputs/

files=$(ls $test_input_dir)

for file in $files; do
  echo ${file}
  index=$(echo ${file} | cut -d'_' -f1)
  echo ${index}
  outfile=${test_output_dir}out_${file}
  echo ${outfile}
  cat ${test_input_dir}${file} | ${prog} > ${outfile}
done
