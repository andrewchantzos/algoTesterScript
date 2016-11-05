# !/bin/bash
# Algorithms Tester
# 
# Author: Andreas Chantzos
# Date: 31/10/2016
#
# Platforms: Linux, OS X
#
# The scope of this bash script is to receive the folder with the 
# test cases Dr Fotakis releases and an executable and print the 
# differences between the program outputs and the correct ones (if there is any)
# as well as the execution time for each test case.
#
# The files of the folder with the testCases should not be changed!!!
# It is assumed that the pairs of input-output will be in the form input$i.txt, output$i.txt
#
#
# First argument: number of testCases in directory
# Second argument: relative path to directory with testcases
# Third argument: relative path to executable


# Function that checks if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# Arguments
numberOfTests=$1
testCaseDir=$2
exeFile=$3

# Number of passed testCases
passed=0

# Os detection
# if OS X
if [ "$(uname)" == "Darwin" ];
    then

    # check for gdate function in OS X
    if  command_exists gdate ;
    then
        for i in `seq 1 $numberOfTests`;
            do
                # start counting execution time of testcase
                startT=$(gdate +%s%N)
                # get difference between program ouptup and testcase output
                DIFF=$(diff -w <(./$exeFile $testCaseDir/input$i.txt) $testCaseDir/output$i.txt);
                retval=$?
                # stop counting
                endT=$(gdate +%s%N)
                # program executed without error
                if [ $retval -eq 0 ]
                then
                    # if there is difference int outputs print it
                    if [ "$DIFF" != "" ]
                    then
                        echo "Testcase$i: Wrong Output"
                        echo $DIFF
                    else
                        ((passed++))
                        echo "Testcase$i: Passed"
                    fi
                    # Calculate runtime
                    runtime=$(((endT-startT)/1000000));
                    echo "Testcase$i execution time: $runtime ms"
                    echo
                fi
            done
    # if there is not gdate installed in OS X use time to measure execution time
    else
        for i in `seq 1 $numberOfTests`;
            do
                # get difference between program ouptup and testcase output
                DIFF=$(diff -w <(time ./$exeFile $testCaseDir/input$i.txt) $testCaseDir/output$i.txt);
                retval=$?
                if [ $retval -eq 0 ]
                then
                    if [ "$DIFF" != "" ]
                    then
                        echo "Testcase$i: Wrong Output"
                        echo $DIFF
                        echo
                    else
                        ((passed++))
                        echo "Testcase$i: Passed"
                    fi
                fi
            done
    echo 'Install gdate with command: brew install coreutils'
    fi
    echo "Passed: $passed/$numberOfTests"
# if Linux
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]
then
    for i in `seq 1 $numberOfTests`;
            do
                # start counting execution time of testcase
                startT=$(date +%s%N)
                DIFF=$(diff -w <(./$exeFile $testCaseDir/input$i.txt) $testCaseDir/output$i.txt);
                retval=$?
                endT=$(date +%s%N)
                # program executed without error
                if [ $retval -eq 0 ]
                then
                    if [ "$DIFF" != "" ]
                    then
                        echo "Testcase$i: Wrong Output"
                        echo $DIFF
                    else
                        ((passed++))
                        echo "testcase$i: Passed"
                    fi
                    runtime=$(((endT-startT)/1000000));
                    # Calculate runtime
                    echo "Testcase$i execution time: $runtime ms"
                    echo
                fi
            done
     echo "Passed: $passed/$numberOfTests"
# Write a batch script man
elif [ -n "$COMSPEC" -a -x "$COMSPEC" ]
then
    echo $0: this script does not support Windows 
fi

exit

