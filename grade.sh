#!/bin/bash

# Constants for paths and file names
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
EXPECTED_FILENAME="ListExamples.java"
EXPECTED_CLASSNAME="ListExamples"

# Clean up before starting
rm -rf student-submission
rm -rf grading-area
mkdir grading-area

# Clone student repository
git clone "$1" student-submission
echo 'Finished cloning'

# Validation of the correct file submission
find student-submission -name $EXPECTED_FILENAME > filelist.txt
if [ ! -s filelist.txt ]; then
    echo "Required file $EXPECTED_FILENAME not found in your submission."
    exit 1
else
    echo "Required file found."
fi

# Copy necessary files to the grading area
while IFS= read -r file; do
    cp "$file" grading-area/
done < filelist.txt
cp lib/* grading-area/ # Assuming your test files and libraries are in a lib directory

cd grading-area

# Compilation with detailed feedback
javac -cp "$CPATH" $EXPECTED_FILENAME SolutionTest.java
if [ $? -ne 0 ]; then
    echo "Compilation failed. Please check your code for syntax errors or missing dependencies."
    exit 1
else
    echo "Compilation successful."
fi

# Running tests and providing feedback
java -cp "$CPATH" org.junit.runner.JUnitCore SolutionTest
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Some tests failed. Please review the test results above for details."
else
    echo "All tests passed successfully."
fi

cd ..
# Clean up after script execution
rm -rf grading-area
rm filelist.txt
