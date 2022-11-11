# Name: Phuoc Truong Nguyen
# Date: 11 Nov 2022
# Description: Data wrangling Rscript for Assignment 2.

#!/usr/bin/env Rscript

################################# Task 2. #################################
# Create data frame from URL.
learning2014 <-
  read.table(
    "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",
    sep = "\t",
    header = TRUE
  )

# Look at data frame structure/dimensions.
str(learning2014)
dim(learning2014)
# Answer: Data frame has 183 observations of 60 variables, i.e. 183 rows and 60 columns.

################################# Task 3. #################################
# Add new columns to data frame.
library(tidyverse)

learning2014$attitude <- lrn14$Attitude / 10

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)

# Rename some columns for convenience.
learning2014 <- learning2014 %>% rename(age = Age, points = Points)

# Create new data frame.
new_learning2014 <- learning2014 %>% select(gender, age, attitude, deep, stra, surf, points) %>% filter(points > 0)

# Check that the new data frame has the correct/expected dimensions of 166 observations and 7 variables.
dim(new_learning2014)

################################# Task 4. #################################
# Set working directory.
setwd("~/Desktop/GitHub/IODS-project/")

# Export data frame to CSV file.
write_csv(x = new_learning2014, file = "Data/learning2014.csv")

# Import CSV file to RStudio.
imported_learning2014 <- read_csv(file = "Data/learning2014.csv", col_names = TRUE)

# Check imported data.
str(imported_learning2014)
head(imported_learning2014)
