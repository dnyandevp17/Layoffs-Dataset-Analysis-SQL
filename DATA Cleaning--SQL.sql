-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

SELECT 
    *
FROM
    world_layoffs.layoffs;


-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens

CREATE TABLE world_layoffs.layoffs_temp 
LIKE world_layoffs.layoffs;

INSERT INTO world_layoffs.layoffs_temp
SELECT * FROM world_layoffs.layoffs;

SELECT 
    *
FROM
    world_layoffs.layoffs_temp;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways


-- 1. check for duplicates and remove any

WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM world_layoffs.layoffs_temp
)
SELECT * FROM duplicate_cte
WHERE row_num > 1;

-- to delete duplicate , create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column

CREATE TABLE `world_layoffs`.`layoffs_temp2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);

SELECT 
    *
FROM
    world_layoffs.layoffs_temp2;

INSERT INTO world_layoffs.layoffs_temp2
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM world_layoffs.layoffs_temp;

DELETE FROM world_layoffs.layoffs_temp2 
WHERE
    row_num >= 2;

SELECT 
    *
FROM
    world_layoffs.layoffs_temp2;



-- 2. standardize data and fix errors

-- removes whitespaces 
SELECT 
    layoffs_temp2.company, TRIM(layoffs_temp2.company)
FROM
    world_layoffs.layoffs_temp2;

UPDATE world_layoffs.layoffs_temp2 
SET 
    layoffs_temp2.company = TRIM(layoffs_temp2.company);


-- Crypto has multiple different variations. We need to standardize that -  say all to Crypto
SELECT 
    *
FROM
    world_layoffs.layoffs_temp2
WHERE
    layoffs_temp2.industry LIKE 'Crypto%';

UPDATE world_layoffs.layoffs_temp2 
SET 
    layoffs_temp2.industry = 'Crypto'
WHERE
    layoffs_temp2.industry LIKE 'Crypto%';


--  apparently we have some "United States" and some "United States." with a period at the end.
SELECT 
    layoffs_temp2.country,
    TRIM(TRAILING '.' FROM layoffs_temp2.country)
FROM
    world_layoffs.layoffs_temp2
WHERE
    layoffs_temp2.country LIKE 'United States%';

UPDATE layoffs_temp2 
SET 
    layoffs_temp2.country = TRIM(TRAILING '.' FROM layoffs_temp2.country)
WHERE
    layoffs_temp2.country LIKE 'United States%';



-- date column is in String format and data type is text , so we need to convert it into date format and change data type
SELECT 
    `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM
    world_layoffs.layoffs_temp2;

UPDATE world_layoffs.layoffs_temp2 
SET 
    `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_temp2
MODIFY COLUMN `date` DATE ;


-- Dealing with null values and blank rows

	-- incase of industry column we can populate null values if there is another row with the same company name, it will update it to the non-null industry values
    
SELECT 
    layoffs_temp2.company, layoffs_temp2.industry
FROM
    world_layoffs.layoffs_temp2
WHERE
    layoffs_temp2.industry IS NULL
        OR layoffs_temp2.industry = '';
    
UPDATE world_layoffs.layoffs_temp2 
SET 
    layoffs_temp2.industry = NULL
WHERE
    layoffs_temp2.industry = '';
    
SELECT 
    layoffs_temp2.company, layoffs_temp2.industry
FROM
    world_layoffs.layoffs_temp2
WHERE
    layoffs_temp2.company = 'Airbnb';
    
SELECT 
    t1.industry, t2.industry
FROM
    world_layoffs.layoffs_temp2 AS t1
		JOIN
    world_layoffs.layoffs_temp2 AS t2 ON t1.company = t2.company
WHERE
    t1.industry IS NULL
		AND t2.industry IS NOT NULL;
    
UPDATE world_layoffs.layoffs_temp2 AS t1
		JOIN
    world_layoffs.layoffs_temp2 AS t2 ON t1.company = t2.company 
SET 
    t1.industry = t2.industry
WHERE
    t1.industry IS NULL
        AND t2.industry IS NOT NULL;

    
    -- in case of irrelevant null values, delete the rows
SELECT 
    layoffs_temp2.total_laid_off,
    layoffs_temp2.percentage_laid_off
FROM
    world_layoffs.layoffs_temp2
WHERE
    layoffs_temp2.total_laid_off IS NULL
        AND layoffs_temp2.percentage_laid_off IS NULL;
    
DELETE FROM world_layoffs.layoffs_temp2 
WHERE
    layoffs_temp2.total_laid_off IS NULL
    AND layoffs_temp2.percentage_laid_off IS NULL;


-- Now lastly delete the added column row_num for removing duplicates, so extra space is taken

ALTER TABLE world_layoffs.layoffs_temp2
DROP COLUMN row_num;

-- DATA after Cleaning
SELECT 
    *
FROM
    world_layoffs.layoffs_temp2;
