# Project Description

The script contained in this repository 'run_analysis.R' downloads the dataset
of accelerometer measurements from a Samsung phone, and transforms it into a
tidy dataset after several transformation described in the 'CodeBook.md' file.

# Prequisites and Information

To run the script you must first make sure to do the following:
* Install 'reshape2' for using 'melt' and 'dcast'.
  Run in R: install.packages('reshape2')

The dataset will be downloaded from the following link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

If you wish to turn off the downloading of the file each time, you can simply
set the variable 'download' to FALSE when calling 'main' on the last line.
This will assume the files exist and are unzipped in the current directory.

# Running the Script

You can run the script from within R like so:
source('run_analysis.R')

And you can run the script from the command line like so:
Rscript run_analysis.R
