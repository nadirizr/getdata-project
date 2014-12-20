library(reshape2)

download_and_extract_dataset <- function(web_path, dest_path = ".") {
        ## 'web_path' is a character vector indicating the URL of the dataset
        ## file to download, and assumes it a zip file to extract.
        
        ## 'dest_path' is an optional character vector indicating where to
        ## extract the data from the downloaded file (defaults to current
        ## working directory.
        
        if (!file.exists(dest_path)) {
                dir.create(dest_path)
        }

        dataset_file <- paste(dest_path, "dataset.zip")
        download.file(web_path, destfile = dataset_file, method = "curl")
        unzip(dataset_file, exdir = dest_path)
}

load_dataset <- function(directory = "./UCI HAR Dataset",
                         training_path = "train/X_train.txt",
                         training_activity_path = "train/y_train.txt",
                         training_subject_path = "train/subject_train.txt",
                         test_path = "test/X_test.txt",
                         test_activity_path = "test/y_test.txt",
                         test_subject_path = "test/subject_test.txt",
                         features_path = "features.txt",
                         activity_path = "activity_labels.txt") {
        ## 'directory' is a character vector indicating the location of the
        ## datasets to load.
        ## 'training_path' is a character vector indicating the relative path
        ## of the training data sets within 'directory'.
        ## 'training_activity_path' is a character vector indicating the relative
        ## path of the training data activity for each observation.
        ## 'training_subject_path' is a character vector indicating the relative
        ## path of the training data subject for each observation.
        ## 'test_path' is a character vector indicating the relative path
        ## of the test data sets within 'directory'.
        ## 'test_activity_path' is a character vector indicating the relative
        ## path of the test data activity for each observation.
        ## 'test_subject_path' is a character vector indicating the relative
        ## path of the test data subject for each observation.
        ## 'features_path' is a character vector indicating the relative path
        ## of the feature name file within 'directory'.
        ## 'activity_path' is a character vector indicating the relative path
        ## of the activity name file within 'directory'.
        ##
        ## Returns a data frame with all of the data from all data sets, merged
        ## into one.

        # Read the activity names into a vector of names where the activity
        # number is the index and the value is the activity name.
        activity_file <- paste(directory, "/", activity_path, sep="")
        activity_dataset <- read.table(activity_file, sep="")
        # After sorting by first column (just in case), second column is names.
        activity_names <- activity_dataset[with(activity_dataset, order(V1)),][,2]
        
        # --- Read the training dataset ---

        # Read the training dataset into a data frame.
        training_file <- paste(directory, "/", training_path, sep="")
        training_dataset <- read.table(training_file, sep="")

        # Read the training dataset activity file for each observation.
        training_activity_file <- paste(directory, "/", training_activity_path, sep="")
        training_activity_dataset <- read.table(training_activity_file, sep="")
        # Transform each of the activities to a name.
        training_activity_dataset[,1] <- apply(training_activity_dataset, 1,
                                               function(x) activity_names[x])
        # Merge the activity column into the training data set.
        training_dataset <- cbind(training_activity_dataset, training_dataset)

        # Read the training dataset subject file for each observation.
        training_subject_file <- paste(directory, "/", training_subject_path, sep="")
        training_subject_dataset <- read.table(training_subject_file, sep="")
        # Merge the subject column into the training data set.
        training_dataset <- cbind(training_subject_dataset, training_dataset)

        # --- Read the test dataset ---

        # Read the test dataset into a data frame.
        test_file <- paste(directory, "/", test_path, sep="")
        test_dataset <- read.table(test_file, sep="")

        # Read the test dataset activity file for each observation.
        test_activity_file <- paste(directory, "/", test_activity_path, sep="")
        test_activity_dataset <- read.table(test_activity_file, sep="")
        # Transform each of the activities to a name.
        test_activity_dataset[,1] <- apply(test_activity_dataset, 1,
                                           function(x) activity_names[x])
        # Merge the activity column into the test data set.
        test_dataset <- cbind(test_activity_dataset, test_dataset)

        # Read the test dataset subject file for each observation.
        test_subject_file <- paste(directory, "/", test_subject_path, sep="")
        test_subject_dataset <- read.table(test_subject_file, sep="")
        # Merge the subject column into the test data set.
        test_dataset <- cbind(test_subject_dataset, test_dataset)

        # --- Combine the datasets ---

        # Combine the two datasets.
        combined_dataset <- rbind(training_dataset, test_dataset)

        # Add the feature names as the column names.
        features_file <- paste(directory, "/", features_path, sep="")
        features_table <- read.table(features_file, sep="")
        # After sorting by first column (just in case), second column is names.
        feature_names <- features_table[with(features_table, order(V1)),][,2]
        names(combined_dataset) <- c("Subject", "Activity",
                                     as.character(feature_names))

        return(combined_dataset)
}

filter_dataset <- function(dataset,
                           feature_types=c("^Subject$", "^Activity$",
                                           "mean\\(\\)", "std\\(\\)")) {
        ## 'dataset' is a data frame produced by a call to 'load_dataset'.
        ## 'feature_types' is a vector of character vectors where each element
        ## represents a string which must appear in a column name for it to pass
        ## the filter and be present in the resulting data frame.
        ##
        ## Returns a filtered data frame with column only for those features
        ## that contain one of the strings in 'feature_types'.
        
        # Find the columns that answer to one of the regular expressions in
        # 'feature_types.
        dataset_names <- names(dataset)
        dataset_cols <- Reduce(c, sapply(feature_types,
                                         function(x) grep(x, dataset_names)))

        # Take only those columns.
        return(dataset[, dataset_cols])
}

calculate_tidy_average_dataset <- function(dataset) {
        ## 'dataset' is a data frame produced by a call to 'load_dataset', and
        ## possibly passed through 'filter_dataset'.
        ##
        ## Returns a dataset with the average of the various variables per each
        ## combination of Subject and Activity.
        
        # First we melt the data with regard to Subject and Activity, thus
        # grouping the observations according to that combination of variables.
        melted_dataset <- melt(dataset, id.vars=c("Subject", "Activity"))

        # Then we cast the data into a data frame where all the measured
        # variables are averaged for each combination of ID variables.
        casted_dataset <- dcast(melted_dataset,
                                Subject + Activity ~ variable,
                                mean)
        return(casted_dataset)
}

main <- function(download=TRUE) {
        ## Runs all of the steps above and writes the resulting dataset to a
        ## file called 'tidy_dataset.txt'.
        ## If 'download' is TRUE, downloads and unzips the dataset when running,
        ## otherwise assumes that the files exist.

        if (download) {
                web_path <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                print("Downloading dataset file from: ", web_path)
                download_and_extract_dataset(web_path)
                print("Done.")
        }

        print("Loading datasets from files...")
        dataset <- load_dataset()
        print("Filtering datasets for means and standard deviations...")
        dataset <- filter_dataset(dataset)
        print("Calculating averages of variables per Subject and Activity...")
        dataset <- calculate_tidy_average_dataset(dataset)
        print("Done.")

        print("Writing tidy dataset to file: tidy_dataset.txt")
        write.table(dataset, "tidy_dataset.txt", row.names=FALSE)
        print("Done.")
}

main()
