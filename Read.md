# Medical Data Analysis

## Table of Contents
1. [Abstract](#abstract)  
2. [Objective](#objective)  
3. [Variables](#variables)  
4. [Segmentation Analysis](#segmentation-analysis)  
   - [City](#city)  
   - [Country](#country)  
   - [Territory](#territory)  
   - [Dealsize](#dealsize)  
5. [Appendix](#appendix)  

---

## Abstract
This project involves analyzing a dataset containing medical and demographic information for 1,000 individuals. The goal is to explore how various factors influence the cost of medical services, such as age, gender, region of residence, and lifestyle habits.

---

## Dataset Description
The dataset includes a range of variables that may impact medical expenses:

- **Age**: The age of the primary beneficiary, categorized as follows:  
  - Teen: 13–19 years  
  - Adult: 20–39 years  
  - Middle-aged Adult: 40–59 years  
  - Senior: 60+ years  

- **Gender**: The gender of the insurance policyholder:  
  - Male  
  - Female  

- **Body Mass Index (BMI)**: A measure of body fat based on weight and height, classified as:  
  - Underweight: BMI below 18.5  
  - Normal: BMI between 18.5 and 24.9  
  - Overweight: BMI between 25.0 and 29.9  
  - Obese: BMI of 30.0 or higher  

- **Children**: The number of dependents.  
- **Smoking Status**: Whether the individual is a smoker.  
- **Region**: The geographic region of the individual’s residence in the United States:  
  - Northeast  
  - Southeast  
  - Northwest  

- **Charges**: The cost of medical services billed to health insurance for each individual.  

---

## Objective
The analysis aims to investigate how these variables influence medical costs and to address the following key questions:

---

## Analysis


### 1. How are medical charges distributed?  
   
![alt text](<Graphs/General Medical Cost/Captura de pantalla 2024-12-18 223509.png>)

The **average overall medical charges** are **$13,463**; however, the distribution is highly **right-skewed**, with many **outliers**. This is evident from the **median**, which is **$9,421**, providing a more accurate representation of a **typical medical charge**.


![alt text](<Graphs/General Medical Cost/Captura de pantalla 2024-12-18 223626.png>)

The **median** is also a better indicator of the **typical medical charge** within each region. The **Southwest** has the **lowest average medical charges**, likely due to having the **fewest smokers**. The number of **smokers** is significant because they incur charges that are, on average, **four times greater** than those of **non-smokers**.



### 2. How do medical charges vary across different age categories (Teen, Adult, Middle-aged, Senior)? 
   
![alt text](<Graphs/General Medical Cost/Captura de pantalla 2024-12-18 223750.png>)

We can see that as **people age**, their **medical expenses** tend to increase. However, with a **low correlation** of **0.30**, we cannot confidently conclude that age is the primary cause. **Smoking** and having a **high BMI** show **stronger collinearity**, suggesting that the reason older people incur higher medical expenses could be due to **weight gain over the years**.

    
### 3. What is the correlation between the number of children and charges? (Correlation: **0.085**)  
![alt text](<Graphs/General Medical Cost/Captura de pantalla 2024-12-18 223724.png>)

There is **almost no correlation** between the **number of children** and **medical charges**.

![alt text](<Graphs/Demographic Impact On Medical Cost/Captura de pantalla 2024-12-18 224156.png>)


### 4. How does gender impact average medical expenses?  
![alt text](<Graphs/Demographic Impact On Medical Cost/Captura de pantalla 2024-12-18 223956.png>)

The **average** and **median medical expenses** for **males** are slightly higher than those for **females**, but the difference is **not significant**.


### 5. Do individuals with higher BMIs face greater medical costs? (Correlation: **0.65**)  

![alt text](<Graphs/BMI and Medical Expenses/Captura de pantalla 2024-12-18 224255.png>)

We could say that there is indeed a **correlation** between **BMI** and **medical costs**, but many of these individuals with a **high BMI** are also **smokers**, suggesting the need for **further analysis**.


![alt text](<Graphs/BMI and Medical Expenses/Captura de pantalla 2024-12-19 011019.png>)

### 6. How do average medical charges vary across BMI categories (Underweight, Normal, Overweight, Obese)?  
![alt text](<Graphs/BMI and Medical Expenses/Captura de pantalla 2024-12-18 224355.png>)

![alt text](<Graphs/BMI and Medical Expenses/Captura de pantalla 2024-12-18 224414.png>)

### 7.  What is the average cost difference between individuals categorized as ‘Obese’ and those who are ‘Not Obese’?  

![alt text](<Graphs/BMI and Medical Expenses/Captura de pantalla 2024-12-18 224310.png>)

There is a **significant difference** between individuals categorized as **‘Obese’** and those who are **‘Not Obese’**. Individuals classified as **Obese** (BMI greater than 30) spend an **average of $4,000 more** on medical expenses compared to the rest.

 

### 8.  What is the correlation between age and medical expenses? (Correlation: **0.30**)
![alt text](<Graphs/General Medical Cost/Captura de pantalla 2024-12-18 223750.png>)
![alt text](<Graphs/Age and Medical Costs/Captura de pantalla 2024-12-18 224735.png>)

We can **clearly see** that as people **age**, their medical expenses tend to **increase**. However, the correlation is **low (0.30)**, which suggests that aging alone may not be the primary factor. It is possible that **weight gain with age** contributes to the higher medical costs.



### 9.  What is the total cost contribution of smokers compared to non-smokers across the entire dataset?  

Although **smokers** make up only **20%** of the total group, their medical expenses account for **half of the total**, making them the **least favored group** in terms of cost distribution. This disproportionate spending highlights the **significant impact** of smoking on medical costs, suggesting that further **preventive measures** could reduce overall healthcare expenses.


![alt text](<Graphs/Smoking Status and Medical Expenses/Captura de pantalla 2024-12-18 224441.png>)

![alt text](<Graphs/Smoking Status and Medical Expenses/Captura de pantalla 2024-12-18 224605.png>)

![alt text](<Graphs/Smoking Status and Medical Expenses/Captura de pantalla 2024-12-19 012155.png>)

