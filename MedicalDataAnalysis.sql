		SELECT * FROM PatientData ORDER BY charges ASC;

# Age Category counts and Avearages

WITH AgeCategory AS (
SELECT 
	age,
    charges,
	CASE
		WHEN age <=19 THEN 'Teen'
		WHEN age BETWEEN 20 AND 39 THEN 'Adult'
		WHEN age BETWEEN 40 AND 59 THEN 'Middle-aged'
		When age >= 60 THEN 'Senior'
		Else 'Undefined'
		END AS AgeCat
	FROM PatientData
)
SELECT
	AgeCat,
	COUNT(AgeCat) AgeCount,
	ROUND(AVG(charges),2) AVGCharges
FROM AgeCategory
GROUP BY 1;
/* Senior and Teens are the most underpopulated groups.
 with "Senior" having the highest average charges, nearly double that of the "Adult" group.*/


# Distribution of Charges
SELECT 
  round(charges,-4) AS Charge_Bin,
  COUNT(*) Count,
  COUNT(*) * 100 / SUM(COUNT(*) ) OVER() 'Count%'
FROM PatientData
GROUP BY Charge_Bin
ORDER BY Charge_Bin;
/* Half the individuals (40%) have charges between 10K and 20K, and 71% pay lees than 20K */

# Median charges of individuals
WITH RankedCharges AS (
    SELECT 
        charges,
        ROW_NUMBER() OVER (ORDER BY charges) AS row_num,
        COUNT(*) OVER () AS total_rows
    FROM 
        PatientData
)
SELECT 
    ROUND(AVG(charges), 2) AS Median_Charges
FROM 
    RankedCharges
WHERE 
    row_num IN (
        FLOOR((total_rows + 1) / 2),
        CEIL((total_rows + 1) / 2) 
    );
    
# Avg_Charges calculation
SELECT 
	ROUND(avg(charges)) Global_AVG_Charges
FROM 
	PatientData;
    
/* The average charge (13463) is higher than the median (9421.97). This suggests a
right-skewed distribution with outliers driving the mean higher. */

# MALE Distribution of Charges
SELECT 
  round(charges,-4) AS Charge_Bin,
  COUNT(*) Count,
  COUNT(*) * 100 / SUM(COUNT(*) ) OVER() 'Count%'
FROM PatientData
WHERE sex = 'Male'
GROUP BY Charge_Bin
ORDER BY Charge_Bin;

# FEMALE Distribution of Charges
SELECT 
  round(charges,-4) AS Charge_Bin,
  COUNT(*) Count,
  COUNT(*) * 100 / SUM(COUNT(*) ) OVER() 'Count%'
FROM PatientData
WHERE sex = 'Female'
GROUP BY Charge_Bin
ORDER BY Charge_Bin;

/* Male anf Female charge distribution follows the same pattern as the overall dataset
with the majority paying less than 20K*/

# Male and Female AVG Charges

SELECT 
	sex,
	ROUND(AVG(charges),2) AVG_charges
FROM
	PatientData
GROUP BY
	Sex;
    
# Male and Female MEDIAN Charges
WITH RankedData AS (
    SELECT
        sex,
        charges,
        ROW_NUMBER() OVER (PARTITION BY sex ORDER BY charges) AS RowAsc,
        COUNT(*) OVER (PARTITION BY sex) AS TotalRows
    FROM PatientData
)
SELECT
    sex,
    ROUND(AVG(charges), 2) AS Male_Female_Median_Charges
FROM RankedData
WHERE RowAsc IN (TotalRows / 2, (TotalRows + 1) / 2)
GROUP BY sex;

/* The Male-Female Charge Distribution follows the same pattern as the overall Distribution.
Both having the distribution right-skewed */



# Smoker, Region and Sex Totals
SELECT smoker, COUNT(*) Count,
ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY smoker;
 
  SELECT region, COUNT(*),
 ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY  region;

 
 SELECT smoker,region, COUNT(*),
 ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY smoker, region
 ORDER BY smoker;

SELECT sex, smoker, COUNT(*),
ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY smoker, sex;
 
 SELECT sex, region, COUNT(*),
ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY  sex, region
 ORDER BY sex;

/* The distribution of sexes and smokers across regions is fairly balanced. */ 

# Smoker AVG Charges
SELECT smoker, ROUND(AVG(charges),2) charges
FROM PatientData
GROUP BY smoker;


# Smoker Median charges
WITH RankData AS (
    SELECT 
        smoker,
        charges,
        ROW_NUMBER() OVER (PARTITION BY smoker ORDER BY charges) AS Smoker_rank,
        COUNT(*) OVER (PARTITION BY smoker) AS Total_count
    FROM PatientData
)
SELECT 
	smoker,
	ROUND(AVG(charges),2) medianCharges
    FROM RankData
WHERE Smoker_rank IN (total_count / 2, (total_count + 1) / 2)
GROUP BY smoker;


-- Smoker Charges Comparison
SELECT
    ROUND(
        AVG(CASE WHEN smoker = 'True' THEN charges END) / 
        AVG(CASE WHEN smoker = 'False' THEN charges END), 2
    ) AS Smoker_non_smoker_charges_rate
FROM PatientData;

/* The average charges for smokers are approximately 3.75 times higher than for non-smokers,
 highlighting the significant cost impact of smoking on medical expenses. */


# Individuals with dependent children and their AVG_Medical_charges
SELECT 
	children, round(AVG(charges))
FROM
	PatientData
GROUP BY 
	children;
    
# BMI Categories

CREATE TEMPORARY Table BMI_table AS
SELECT 
*,
  CASE 
  WHEN BMI < 18.5 THEN 'Underweight'
  WHEN BMI >= 18.5 AND BMI < 25 THEN 'Normal'
  WHEN BMI >= 25 AND BMI < 30 THEN 'Overweight'
  WHEN BMI >= 30 THEN 'Obese'
  Else 'Undefined'
  END AS BMI_Category,

  CASE 
  WHEN BMI < 30 THEN 'Not Obese'
  WHEN BMI >= 30 THEN 'Obese'
  Else 'Undefined'
  END Obese

FROM PatientData;

SELECT BMI_Category, Round(AVG(charges),2)AVG_Charges
FROM BMI_table
GROUP BY 1
ORDER BY 2; 

SELECT Obese, Round(AVG(charges),2) AVG_Charges
FROM BMI_table
GROUP BY 1
ORDER BY 2; 

/* Individuals categorized as "Obese" have significantly higher medical charges compared to those
 in other BMI categories, with an average difference of around 4,000. */






SELECT * FROM PatientData;


