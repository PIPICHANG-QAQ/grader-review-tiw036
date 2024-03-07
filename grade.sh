#!/bin/bash

# Constants for paths and file names
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
EXPECTED_FILENAME="ListExamples.java"

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
cp "/path/to/your/SolutionTest.java" grading-area/ # Adjust this path as needed
cp /path/to/your/lib/* grading-area/ # Adjust this path as needed

cd grading-area

# Compilation with detailed feedback
javac -cp "$CPATH" *.java 2> compilation-errors.txt
if [ $? -ne 0 ]; then
    echo "Compilation failed. Please check your code for syntax errors or missing dependencies."
    cat compilation-errors.txt
    exit 1
else
    echo "Compilation successful."
fi

# Running tests and providing feedback
java -cp "$CPATH" org.junit.runner.JUnitCore SolutionTest > test-results.txt
grep -o 'Tests run: [0-9]*, Failures: [0-9]*, Errors: [0-9]*' test-results.txt > test-summary.txt

# Extracting test pass/fail counts
passed_tests=$(grep -o 'Failures: 0, Errors: 0' test-summary.txt | wc -l | xargs)
total_tests=$(grep -o 'Tests run: [0-9]*' test-summary.txt | wc -l | xargs)

if [ $passed_tests -eq $total_tests ]; then
    echo "All tests passed successfully."
else
    echo "Some tests failed. Please review the test results above for details."
fi

# Optionally, output the test result summary
cat test-summary.txt

cd ..
# Clean up after script execution
rm -rf grading-area
rm filelist.txt
