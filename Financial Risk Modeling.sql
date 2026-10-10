-- Step 1: Database and Table Creation (DDL)
-- Create Database
CREATE DATABASE IF NOT EXISTS financial_risk_db;
USE financial_risk_db;

-- Create Table for Financial Risk Assessment
CREATE TABLE IF NOT EXISTS risk_assessment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Age INT,
    Gender VARCHAR(50),
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(50),
    Income DECIMAL(12, 2),
    Credit_Score DECIMAL(6, 2),
    Loan_Amount DECIMAL(12, 2),
    Loan_Purpose VARCHAR(50),
    Employment_Status VARCHAR(50),
    Years_At_Current_Job INT,
    Payment_History VARCHAR(50),
    Debt_To_Income_Ratio DECIMAL(6, 4),
    Assets_Value DECIMAL(12, 2),
    Number_Of_Dependents INT,
    City VARCHAR(100),
    State VARCHAR(50),
    Country VARCHAR(100),
    Previous_Defaults INT,
    Marital_Status_Change INT,
    Risk_Rating VARCHAR(50)
);

-- Check total row count vs non-null counts for key metrics
SELECT 
    COUNT(*) AS Total_Rows,
    COUNT(Income) AS Non_Null_Income,
    COUNT(Credit_Score) AS Non_Null_Credit_Score,
    COUNT(Loan_Amount) AS Non_Null_Loan_Amount,
    COUNT(Assets_Value) AS Non_Null_Assets_Value,
    COUNT(Previous_Defaults) AS Non_Null_Defaults
FROM risk_assessment;

-- Check percentage of missing values for Income and Credit Score
SELECT 
    (COUNT(*) - COUNT(Income)) * 100.0 / COUNT(*) AS Missing_Income_Pct,
    (COUNT(*) - COUNT(Credit_Score)) * 100.0 / COUNT(*) AS Missing_Credit_Score_Pct
FROM risk_assessment;

-- 1. Distribution of Risk Ratings (Target Variable)
SELECT 
    Risk_Rating, 
    COUNT(*) AS Total_Customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM risk_assessment), 2) AS Percentage
FROM risk_assessment
GROUP BY Risk_Rating
ORDER BY Total_Customers DESC;

-- 2. Distribution of Loans by Purpose
SELECT 
    Loan_Purpose, 
    COUNT(*) AS Loan_Count,
    ROUND(AVG(Loan_Amount), 2) AS Avg_Loan_Amount
FROM risk_assessment
GROUP BY Loan_Purpose
ORDER BY Loan_Count DESC;

-- 3. Employment Status Breakdown
SELECT 
    Employment_Status, 
    COUNT(*) AS Count,
    ROUND(AVG(Income), 2) AS Avg_Income
FROM risk_assessment
GROUP BY Employment_Status
ORDER BY Count DESC;

-- 1. Average Financial Metrics by Risk Rating
SELECT 
    Risk_Rating,
    ROUND(AVG(Income), 2) AS Avg_Income,
    ROUND(AVG(Credit_Score), 2) AS Avg_Credit_Score,
    ROUND(AVG(Loan_Amount), 2) AS Avg_Loan_Amount,
    ROUND(AVG(Debt_To_Income_Ratio), 4) AS Avg_DTI_Ratio,
    ROUND(AVG(Assets_Value), 2) AS Avg_Assets
FROM risk_assessment
GROUP BY Risk_Rating
ORDER BY Avg_Credit_Score DESC;

-- 2. Impact of Payment History on Risk Rating
SELECT 
    Payment_History,
    Risk_Rating,
    COUNT(*) AS Frequency
FROM risk_assessment
GROUP BY Payment_History, Risk_Rating
ORDER BY Payment_History, Frequency DESC;

-- 3. Previous Defaults vs Risk Rating
SELECT 
    Previous_Defaults,
    Risk_Rating,
    COUNT(*) AS Customer_Count
FROM risk_assessment
GROUP BY Previous_Defaults, Risk_Rating
ORDER BY Previous_Defaults;


-- 1. Risk Distribution by Education Level
SELECT 
    Education_Level,
    Risk_Rating,
    COUNT(*) AS Count
FROM risk_assessment
GROUP BY Education_Level, Risk_Rating
ORDER BY Education_Level, Count DESC;

-- 2. Risk Distribution by Marital Status
SELECT 
    Marital_Status,
    Risk_Rating,
    COUNT(*) AS Count,
    ROUND(AVG(Income), 2) AS Avg_Income
FROM risk_assessment
GROUP BY Marital_Status, Risk_Rating
ORDER BY Marital_Status;

-- 3. Top Countries/States with Highest Average Risk or Loan Amounts
SELECT 
    Country,
    State,
    COUNT(*) AS Total_Loans,
    ROUND(AVG(Loan_Amount), 2) AS Avg_Loan_Amount,
    ROUND(AVG(Debt_To_Income_Ratio), 4) AS Avg_DTI
FROM risk_assessment
GROUP BY Country, State
ORDER BY Total_Loans DESC
LIMIT 10;


-- Identify High-Risk Profiles for targeted portfolio review
SELECT 
    id,
    Age,
    Income,
    Credit_Score,
    Loan_Amount,
    Debt_To_Income_Ratio,
    Previous_Defaults,
    Risk_Rating
FROM risk_assessment
WHERE Risk_Rating = 'High'
  AND (Credit_Score < 600 OR Previous_Defaults > 1 OR Debt_To_Income_Ratio > 0.4)
ORDER BY Credit_Score ASC, Loan_Amount DESC
LIMIT 100;