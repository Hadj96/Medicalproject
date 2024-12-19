``` sql
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
```

| AgeCat | AgeCount | AVGCharges |
| ------ | -------- | ---------- |
| Teen | 106 | 8660.07 |
| Adult | 405 | 10398.9 |
| Middle-aged | 416 | 16412.47 |
| Senior | 73 | 20631.01 |

```sql
SELECT 
  round(charges,-4) AS Charge_Bin,
  COUNT(*) Count,
  COUNT(*) * 100 / SUM(COUNT(*) ) OVER() 'Count%'
FROM PatientData
GROUP BY Charge_Bin
ORDER BY Charge_Bin;
/* Half the individuals (40%) have charges between 10K and 20K, and 71% pay lees than 20K */
``` 
| Charge_Bin | Count | Count% |
| ---------- | ----- | ------ |
| 0.0 | 271 | 27.1000 |
| 10000.0 | 449 | 44.9000 |
| 20000.0 | 125 | 12.5000 |
| 30000.0 | 55 | 5.5000 |
| 40000.0 | 73 | 7.3000 |
| 50000.0 | 22 | 2.2000 |
| 60000.0 | 5 | 0.5000 |


```sql
--Global Median charges 
WITH RankedCharges AS (
    SELECT 
        charges,
        ROW_NUMBER() OVER (ORDER BY charges) AS row_num,
        COUNT(*) OVER () AS total_rows
    FROM 
        PatientData
        )
SELECT ROUND(AVG(charges), 2) AS Median_Charges
FROM RankedCharges
WHERE 
    row_num IN (
        FLOOR((total_rows + 1) / 2),
        CEIL((total_rows + 1) / 2) 
    );
    
-- Global Avg_Charges
SELECT ROUND(avg(charges)) Global_AVG_Charges
FROM PatientData;
    
/* The average charge (13463) is higher than the median (9421.97). This suggests a
right-skewed distribution with outliers driving the mean higher. */
```
| Median_Charges |
| -------------- |
| 9421.97 |

| Global_AVG_Charges |
| ------------------ |
| 13463.0 |
```sql 
-- MALE Charges Distribution
SELECT 
  round(charges,-4) AS Charge_Bin,
  COUNT(*) Count,
  COUNT(*) * 100 / SUM(COUNT(*) ) OVER() 'Count%'
FROM PatientData
WHERE sex = 'Male'
GROUP BY Charge_Bin
ORDER BY Charge_Bin;
``` 
| Charge_Bin | Count | Count% |
| ---------- | ----- | ------ |
| 0.0 | 141 | 27.8656 |
| 10000.0 | 215 | 42.4901 |
| 20000.0 | 59 | 11.6601 |
| 30000.0 | 29 | 5.7312 |
| 40000.0 | 46 | 9.0909 |
| 50000.0 | 14 | 2.7668 |
| 60000.0 | 2 | 0.3953 |

```sql
-- FEMALE Charges Distribution
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
```
| Charge_Bin | Count | Count% |
| ---------- | ----- | ------ |
| 0.0 | 130 | 26.3158 |
| 10000.0 | 234 | 47.3684 |
| 20000.0 | 66 | 13.3603 |
| 30000.0 | 26 | 5.2632 |
| 40000.0 | 27 | 5.4656 |
| 50000.0 | 8 | 1.6194 |
| 60000.0 | 3 | 0.6073 |


```sql 
-- Male and Female AVG Charges
SELECT 
	sex,
	ROUND(AVG(charges),2) AVG_charges
FROM PatientData
GROUP BY Sex;
    
-- Male and Female MEDIAN Charges
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
```
| sex | AVG_charges |
| --- | ----------- |
| female | 12945.18 |
| male | 13968.88 |

| sex | Male_Female_Median_Charges |
| --- | -------------------------- |
| female | 9566.99 |
| male | 9288.03 |

```sql 
-- Number of Smokers
SELECT smoker, COUNT(*) Count,
ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY smoker;
```
| smoker | Count | % |
| ------ | ----- | - |
| false | 788 | 78.80 |
| true | 212 | 21.20 |


```sql 
-- Region Distribution
  SELECT region, COUNT(*) count,
 ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY  region;
```
| region | count | % |
| ------ | -------- | - |
| northeast | 324 | 32.40 |
| northwest | 325 | 32.50 |
| southeast | 351 | 35.10 |

```sql 
-- Smokers per Region

 SELECT smoker,region, COUNT(*) count,
 ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY smoker, region
 ORDER BY smoker;
```
| smoker | region | count | % |
| ------ | ------ | -------- | - |
| false | northeast | 257 | 25.70 |
| false | northwest | 267 | 26.70 |
| false | southeast | 264 | 26.40 |
| true | northeast | 67 | 6.70 |
| true | northwest | 58 | 5.80 |
| true | southeast | 87 | 8.70 |


```sql 
-- Smokers by Gender

SELECT sex, smoker, COUNT(*) count,
ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY smoker, sex;
```
| sex | smoker | count | % |
| --- | ------ | -------- | - |
| female | false | 401 | 40.10 |
| male | false | 387 | 38.70 |
| male | true | 119 | 11.90 |
| female | true | 93 | 9.30 |

```sql 
-- Gender Distribution by Region
 SELECT sex, region, COUNT(*) count,
ROUND(COUNT(*) / (SELECT COUNT(*) FROM PatientData) *100,2) AS '%'
 FROM PatientData
 GROUP BY  sex, region
 ORDER BY sex;
 /* The distribution of sexes and smokers across regions is fairly balanced. */ 
```
| sex | region | COUNT(*) | % |
| --- | ------ | -------- | - |
| female | northeast | 161 | 16.10 |
| female | northwest | 164 | 16.40 |
| female | southeast | 169 | 16.90 |
| male | northeast | 163 | 16.30 |
| male | northwest | 161 | 16.10 |
| male | southeast | 182 | 18.20 |



```sql 
--Smoker AVG Charges
SELECT smoker, ROUND(AVG(charges),2) AVGcharges
FROM PatientData
GROUP BY smoker;


-- Smoker Median charges
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
```
| smoker | AVGcharges |
| ------ | ------- |
| false | 8506.91 |
| true | 31885.5 |

| smoker | medianCharges |
| ------ | ------------- |
| false | 7256.72 |
| true | 33750.29 |

| Smoker_non_smoker_charges_rate |
| ------------------------------ |
| 3.75 |

```sql 
-- AVG_Medical_charges by Children Number
SELECT 
	children, round(AVG(charges))
FROM
	PatientData
GROUP BY 
	children;
```

| children | round(AVG(charges)) |
| -------- | ------------------- |
| 0 | 12337.0 |
| 2 | 14129.0 |
| 3 | 16904.0 |
| 4 | 13430.0 |
| 1 | 13460.0 |
| 5 | 9060.0 |

```sql
-- BMI Categories

CREATE TEMPORARY Table BMI_table AS
SELECT *,
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

SELECT
    SUM(( - (SELECT AVG(charges) FROM patientdata)) * 
    (bmi - (SELECT AVG(bmi) FROM patientdata))) /
    SQRT(
        SUM(POWER(charges - (SELECT AVG(charges) FROM patientdata), 2)) * 
        SUM(POWER(bmi - (SELECT AVG(bmi) FROM patientdata), 2))
    ) AS correlation
FROM
    patientdata;



SELECT Obese, Round(AVG(charges),2) AVG_Charges
FROM BMI_table
GROUP BY 1
ORDER BY 2; 

/* Individuals categorized as "Obese" have significantly higher medical charges compared to those
 in other BMI categories, with an average difference of around 4,000. */
```
|BMI_Category|AVG_Charges|
|------------|-----------|
|Underweight |9041.63    |
|Overweight  |11058.58   |
|Normal      |11087.45   |
|Obese       |15712.18   |

| correlation |
| ----------- |
| 6.300890725544628e-16 |

|Obesity Level      |AVG_Charges|
|-----------|-----------|
|Not Obese  |10997.29   |
|Obese      |15712.18   |


SELECT
    SUM((charges - (SELECT AVG(charges) FROM patientdata)) * 
    (children - (SELECT AVG(children) FROM patientdata))) /
    SQRT(
        SUM(POWER(charges - (SELECT AVG(charges) FROM patientdata), 2)) * 
        SUM(POWER(children - (SELECT AVG(children) FROM patientdata), 2))
    ) AS correlation
FROM
    patientdata;