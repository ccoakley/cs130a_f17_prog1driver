#!/bin/bash

current_dir=${pwd}
student_executables_dir=/cs/class/cs130a/TURNIN/prog1/
test_dir=/cs/class/cs130a/test/prog1/
test_input_dir=/cs/class/cs130a/prog1_tests/
test_output_dir=/cs/class/cs130a/prog1_outputs/
prog1_grades=/cs/class/cs130a/prog1_grades.txt
grader_output=/cs/class/cs130a/grader_output.txt

cd ${student_executables_dir}
student_files=$(ls | grep -v LOGFILE)
cd ${current_dir}

cd ${test_input_dir}
input_files=$(ls *.txt)
cd ${current_dir}

# initialize gradefile
echo '' > ${prog1_grades}
echo '' > ${grader_output}

for student_file in ${student_files}; do
  trimmed=$(echo $student_file | sed -e 's/-/./' | cut -d'.' -f1)
  latest=$(ls -c ${student_executables_dir}${trimmed}-*.tar.Z | head -n1)
  latest=$(echo $latest | rev | cut -d'/' -f1 | rev)
  if [[ -z $latest ]]; then
    latest=${student_file}
  fi
  if [[ ! ${student_file} = ${latest} ]]; then
    echo skipping ${student_file} because ${latest} >> ${grader_output}
  else
    cd ${current_dir}
    echo ${student_file} >> ${prog1_grades}
    echo ${student_file} >> ${grader_output}
    echo Testing ${student_file}
    date
    stat -c %y "${student_executables_dir}${student_file}" >> ${prog1_grades}
    rm -rf ${test_dir}
    mkdir -p ${test_dir}
    cp "${student_executables_dir}${student_file}" ${test_dir}
    cd ${test_dir}
    tar -xzvf ${student_file}
    # alternative for absolute path
    # find . -iname makefile | xargs readlink -f
    codedir=$(dirname "$(readlink -f "$(find . -iname "Makefile" | head -n1)")") || echo Makefile not found >> ${prog1_grades}
    echo codedir: ${codedir}
    cd ${codedir}
    make
    ls "${codedir}"
    if [[ -f ./prog1 ]]; then
      for input_file in ${input_files}; do
        index=$(echo $input_file | cut -d'_' -f1)
        echo $index
        cat ${test_input_dir}${input_file} | ./prog1 | sed -e "s/[ \t]*$//" > out_${input_file}
        diff out_${input_file} ${test_output_dir}out_${input_file} | head -n10 >> ${grader_output}
        if [[ 0 -eq $(diff out_${input_file} ${test_output_dir}out_${input_file} | wc -l) ]]; then
          echo "${index}: yes" >> ${prog1_grades}
        else
          echo "${index}: no" >> ${prog1_grades}
        fi
      done
    else
      echo "no prog1" >> ${prog1_grades}
    fi
    echo '' >> ${prog1_grades}
    cd ${current_dir}
    rm -rf ${test_dir}
  fi
done
