# Name: Phuoc Truong Nguyen
# Date: 19 Nov 2022
# Description: Data wrangling Rscript for Assignment 3.
# Data source: http://www3.dsi.uminho.pt/pcortez/student.pdf

#!/usr/bin/env Rscript

################################# Task 3. #################################
# Set working directory.
setwd("Data/")

# Read CSV files.
student_mat <- read.csv("student-mat.csv", header = T, sep = ";")
student_por <- read.csv("student-por.csv", header = T, sep = ";")

# Check the structure and dimensions of imported data.
str(student_mat)
dim(student_mat)

str(student_por)
dim(student_por)

################################# Task 4. #################################
# Set columns to be excluded.
exclude_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

# Remove exclude_cols from all columns.
include_cols <- setdiff(colnames(student_por), exclude_cols)

#Join data frames with inner_join().
library(tidyverse)

student_mat_por <-
  inner_join(student_mat,
             student_por,
             by = include_cols,
             suffix = c(".math", ".por"))

str(student_mat_por)
dim(student_mat_por)

################################# Task 5. #################################
# Remove duplicates with a for loop.
student_alc <- select(student_mat_por, all_of(include_cols))

for(column_name in exclude_cols) {
  duplicate_columns <- select(student_mat_por, starts_with(column_name))
  first_column <- select(duplicate_columns, 1)[[1]]
  
  if (is.numeric(first_column)) {
    student_alc[column_name] <- rowMeans(duplicate_columns)
  } else {
    student_alc[column_name] <- first_column
  }
}

# Or with lapply(), another form of a loop.
student_alc_alt <- student_mat_por %>% select(all_of(include_cols))

custom_function <- function (column_name) { # Define what this function does (with column_name as the variable) when it's called.
  duplicate_columns <- select(student_mat_por, starts_with(column_name))
  
  if (is.numeric(as.matrix(duplicate_columns))) {
    as.data.frame(rowMeans(duplicate_columns))
  } else {
    coalesce(duplicate_columns[[1]], duplicate_columns[[2]]) # Join columns but print values from the first one.
  }
}

exclude_cols_data <- as.data.frame(lapply(exclude_cols, custom_function))
colnames(exclude_cols_data) <- exclude_cols # Rename columns here because I don't know how to do that in function.

student_alc_alt <- cbind(student_alc_alt, exclude_cols_data) # Join data frames.

identical(student_alc, student_alc_alt) # Check that resulting data frames are the same (just in case).

################################# Task 6. #################################
student_alc <- student_alc %>% mutate(alc_use = (Dalc + Walc) / 2, high_use = alc_use > 2)

################################# Task 7. #################################
glimpse(student_alc)
write_csv(student_alc, "student_alc.csv")
