Feature Selection 
=================

Original Dataset Information
----------------------------

The following information is from the original dataset description from the Samsung website:

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

The following activites were measured:

WALKING: The subject was walking
WALKING_UPSTAIRS: The subject was climbing stairs
WALKING_DOWNSTAIRS: The subject was going down stairs
SITTING: The subject was sitting
LAYING: The subject was laying down

There were 30 subjects in the test, and they are numbered 1-30.

Transformation of data in the script that result in tidy dataset
----------------------------------------------------------------

The following steps were taken:
* Merge the datasets within the files 'train/X_train.txt' and 'test/X_test.txt'.
* Add a variable for Activity with the appropriate Activity name, by adding the values from 'train/y_train.txt' and 'test/y_test.txt' respectively to the datasets and mapping each of the values there (from 1 to 6) to the appropriate activity name as it is stated in the original file 'activity_labels.txt'.
* Add a variable for Subject with data from the files 'train/subject_train.txt' and 'test/subject_test.txt' respectively.
* Filtered the columns in the resulting dataset so that only those variables that correspond to means and standard deviations remain.
* For each unique combination of Subject and Activity, calculated the average of all observations for each variable.
* Outputted this tidy dataset as 'tidy_dataset.txt'.

Each row in the resulting tidy dataset corresponds to one unique combination of Subject and Activity.
Each variable name is according to the descriptions in the original dataset text, and average of all measurements for a specific Subject and Activity, and is in a separate column.
