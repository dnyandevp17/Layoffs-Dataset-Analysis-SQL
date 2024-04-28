# Layoffs-Dataset-Analysis-SQL

This project involves the analysis of a dataset containing information about layoffs that occurred in various companies during the year 2022. The dataset was obtained from Kaggle and has been cleaned and analyzed using SQL queries.

# Data Cleaning:
The data cleaning process involved several steps to ensure the dataset's quality and consistency:

    1.Creation of a staging table to preserve the raw data.
    2.Removal of duplicate rows based on specific columns.
    3.Standardization of data and correction of errors (e.g., trimming whitespace, standardizing industry names).
    4.Handling of null values by either populating them with relevant information or deleting irrelevant rows.
    5.Conversion of the date column from text to date format.

# Exploratory Data Analysis (EDA):
The EDA focused on uncovering trends, patterns, and interesting insights within the dataset:

    1.Identification of companies with the highest total layoffs and highest percentage layoffs.
    2.Analysis of companies with 100% layoff rates and examination of their funding levels.
    3.Investigation of companies with the highest layoffs on a single day.
    4.Aggregation of layoffs based on various dimensions such as location, industry, country, and year.
    5.Determination of the top 3 companies with the most layoffs for each year.
    6.Calculation of the rolling total of layoffs per month to observe trends over time.
