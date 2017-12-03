#!/bin/bash

current_dir=${pwd}
student_executables_dir=/cs/class/cs130a/TURNIN/prog1/
test_dir=/cs/class/cs130a/test/prog1/
test_input_dir=/cs/class/cs130a/prog1_tests/
test_output_dir=/cs/class/cs130a/prog1_outputs/
prog1_grades=/cs/class/cs130a/prog1_grades.txt

cd ${student_executables_dir}
student_files=${ls | grep -v LOGFILE}
cd ${current_dir}

cd ${test_input_dir}
input_files=${ls *.txt}
cd ${current_dir}

for student_file in ${student_files}; do
  cd ${current_dir}
  stat -c %y "$student_file" > $prog1_grades
  mkdir -p ${test_dir}
  cp ${student_executables_dir}${student_file} ${test_dir}
  cd ${test_dir}
  tar -xzvf ${student_file}
  # alternative for absolute path
  # find . -iname makefile | xargs readlink -f
  cd $(dirname $(find . -iname "Makefile"))
  make
  for input_file in ${input_files}; do
    index=${echo $input_file | cut -d'_' -f1}
    cat ${test_input_dir}${input_file} | ./prog1 > out_${input_file}
    if [[ 0 -eq $(diff out_${input_file} ${test_output_dir}out_${input_file} | wc -l) ]]; then
      echo "${index}: yes" >> ${prog1_grades}
    else
      echo "${index}: no" >> ${prog1_grades}
    fi
  done
  echo '' >> ${prog1_grades}
  cd ${current_dir}
  rm -rf ${test_dir}
done
