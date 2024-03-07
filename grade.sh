CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

cp student-submission/Solution.java grading-area/
cp student-submission/SolutionTest.java grading-area/

cd grading-area

javac -cp "$CPATH" *.java
if [ $? -ne 0 ]; then
    echo "Compilation failed. Please check your code for errors."
    exit 1
else
    echo "Compilation successful."
fi



# Then, add here code to compile and run, and do any post-processing of the
# tests

java -cp "$CPATH" org.junit.runner.JUnitCore SolutionTest
if [ $? -ne 0 ]; then
    echo "Some tests failed. Please review the test results above for details."
else
    echo "All tests passed successfully."
fi


cd ..