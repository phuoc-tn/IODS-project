# Name: Phuoc Truong Nguyen
# Date: 29 Nov 2022
# Description: Data wrangling Rscript for Assignment 4.

#!/usr/bin/env Rscript

################################# Task 2. #################################
# Set working directory.
setwd("~/Desktop/GitHub/IODS-project/Data/")

# Read CSV files.
human_dev <-
  read_csv(
    "https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv"
  )
gender_ineq <-
  read_csv(
    "https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv",
    na = ".."
  )
################################# Task 3. #################################
# Check the structure and dimensions of imported data.
str(human_dev)
dim(human_dev)

str(gender_ineq)
dim(gender_ineq)

summary(human_dev)
summary(gender_ineq)
################################# Task 4. #################################
library(tidyverse)

renamed_human_dev <-
  human_dev %>% rename(
    "HDI" = "Human Development Index (HDI)",
    "Life.Exp" = "Life Expectancy at Birth",
    "Edu.Exp" = "Expected Years of Education",
    "Mean_EduYears" = "Mean Years of Education",
    "GNI" = "Gross National Income (GNI) per Capita",
    "GNI_minus_HDI" = "GNI per Capita Rank Minus HDI Rank"
  )

renamed_gender_ineq <-
  gender_ineq %>% rename(
    "GII" = "Gender Inequality Index (GII)",
    "Mat.Mor" = "Maternal Mortality Ratio",
    "Ado.Birth" = "Adolescent Birth Rate",
    "Parli.F" = "Percent Representation in Parliament",
    "Edu2.F" = "Population with Secondary Education (Female)",
    "Edu2.M" = "Population with Secondary Education (Male)",
    "Labo.F" = "Labour Force Participation Rate (Female)",
    "Labo.M" = "Labour Force Participation Rate (Male)"
  )
################################# Task 5. #################################
new_gender_ineq <-
  renamed_gender_ineq %>% mutate("Edu2.FM" = Edu2.F / Edu2.M,
                                 "Labo.FM" = Labo.F / Labo.M)
################################# Task 6. #################################
joined_data <-
  inner_join(renamed_human_dev, new_gender_ineq, "Country")
glimpse(joined_data)

write_csv(joined_data, "human.csv")
