-- Exploratory Data Analysis

-- exploring the data and find trends or patterns or anything interesting like outliers

SELECT 
    *
FROM
    world_layoffs.layoffs_temp2;
    

-- maximum of total layoff 
SELECT 
    MAX(layoffs_temp2.total_laid_off)
FROM
    world_layoffs.layoffs_temp2;
    
    
-- Looking at Percentage to see how big these layoffs were
SELECT 
    MAX(layoffs_temp2.percentage_laid_off),
    MIN(layoffs_temp2.percentage_laid_off)
FROM
    world_layoffs.layoffs_temp2
WHERE
    layoffs_temp2.percentage_laid_off IS NOT NULL;
    
    
-- Here maximum percentage layoff is 1 i.e 100% , so let's see those companies
SELECT 
    *
FROM
    world_layoffs.layoffs_temp2
WHERE
    layoffs_temp2.percentage_laid_off = 1;
    
    
-- if we order by funds_raised_millions we can see how big some of these companies were
SELECT 
    *
FROM
    world_layoffs.layoffs_temp2
WHERE
    layoffs_temp2.percentage_laid_off = 1
ORDER BY
	layoffs_temp2.funds_raised_millions DESC;
    
    
-- let's see companies with biggest layoff on a single day
SELECT 
    layoffs_temp2.company, layoffs_temp2.total_laid_off
FROM
    world_layoffs.layoffs_temp2
ORDER BY layoffs_temp2.total_laid_off DESC;


-- Companies with most total layoffs
SELECT 
    layoffs_temp2.company, SUM(layoffs_temp2.total_laid_off)
FROM
    world_layoffs.layoffs_temp2
GROUP BY layoffs_temp2.company
ORDER BY 2 DESC;


-- total layoffs based on location
SELECT 
    layoffs_temp2.location, SUM(layoffs_temp2.total_laid_off)
FROM
    world_layoffs.layoffs_temp2
GROUP BY layoffs_temp2.location
ORDER BY 2 DESC;


-- total layoffs based on industry
SELECT 
    layoffs_temp2.industry, SUM(layoffs_temp2.total_laid_off)
FROM
    world_layoffs.layoffs_temp2
GROUP BY layoffs_temp2.industry
ORDER BY 2 DESC;


-- total layoffs based on country
SELECT 
    layoffs_temp2.country, SUM(layoffs_temp2.total_laid_off)
FROM
    world_layoffs.layoffs_temp2
GROUP BY layoffs_temp2.country
ORDER BY 2 DESC;


-- total layoffs based on year
SELECT 
    YEAR(layoffs_temp2.date), SUM(layoffs_temp2.total_laid_off)
FROM
    world_layoffs.layoffs_temp2
GROUP BY YEAR(layoffs_temp2.date)
ORDER BY 2 DESC;


-- Top 3 companies with most layoffs  per year
WITH cte_company_year AS
(
SELECT 
    layoffs_temp2.company,
    YEAR(`date`) AS years,
    SUM(layoffs_temp2.total_laid_off) AS total_layoff
FROM
    world_layoffs.layoffs_temp2
GROUP BY layoffs_temp2.company , YEAR(`date`)
),
cte_company_rank AS
(
SELECT 
	company, years, total_layoff, 
    DENSE_RANK() OVER(PARTITION BY years ORDER BY total_layoff DESC) as ranking
FROM 
	cte_company_year
)
SELECT 
    company, years, total_layoff, ranking
FROM
    cte_company_rank
WHERE
    years IS NOT NULL AND ranking <= 3
ORDER BY years DESC;


-- Rolling Total of Layoffs Per Month
WITH cte_rolling_total(dates, total_layoff) AS
(
SELECT 
    SUBSTRING(`date`, 1, 7), SUM(layoffs_temp2.total_laid_off)
FROM
    world_layoffs.layoffs_temp2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1, 7)
ORDER BY 1 ASC
)
SELECT 
	dates, total_layoff, 
    SUM(total_layoff) OVER(ORDER BY dates ASC) as rolling_total
FROM 
	cte_rolling_total;