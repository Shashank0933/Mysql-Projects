/*
Personal Budget Analysis
*/

create database Project;        #-------New Database is created
use Project;                    #-------Using created database

show tables;                    #-------Checking tables after importing data form .csv file

desc personal_budget;            #------Checking table Schemas 
select * from personal_budget;     #------checking Data from table

# -------------------------Queries Starts from here--------------------------

#Track Monthly Expenditure:

SELECT Category, SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
WHERE MONTH(Transaction_Date) = '01'  #-- Example: January
GROUP BY Category;

# This groups the data by Category and sums the Spent_Amount for each category to show total expenditures.
#----------------------------------------------------------------------

#Identify Over-Budget Categories:

SELECT Category, Budget_Amount, SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Category, Budget_Amount
HAVING SUM(Spent_Amount) > Budget_Amount;

# This groups by Category and filters to show only those categories where the total spent exceeds the budgeted amount.
#----------------------------------------------------------------------

#Total Spending by Account Type:

SELECT Account_Type, SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Account_Type;

# This formats the Transaction_Date to extract the month and year, grouping the total spent by month for analysis.
#----------------------------------------------------------------------

#Calculate Remaining Budget per Category:

SELECT Category, Budget_Amount, SUM(Spent_Amount) AS Total_Spent, 
       (Budget_Amount - SUM(Spent_Amount)) AS Remaining_Budget
FROM personal_budget
GROUP BY Category, Budget_Amount;

# This provides a high-level overview of overall budget versus spending.
#----------------------------------------------------------------------

#Find Transactions by Specific Vendor:

SELECT * 
FROM personal_budget
WHERE Vendor = 'SuperMart';

# This groups the spending by Vendor, summing it up, and then orders it to show the top 5 vendors by total spending
#----------------------------------------------------------------------

# Track Total Expenditure by Category

SELECT Category, SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Category;

#This Query groups the data by Category and sums the Spent_Amount for each category to show total expenditures.
#----------------------------------------------------------------------

# Identify Over-Budget Categories

SELECT Category, Budget_Amount, SUM(Spent_Amount) AS Total_Spent, 
       (Budget_Amount - SUM(Spent_Amount)) AS Remaining_Budget
FROM personal_budget
GROUP BY Category, Budget_Amount
HAVING SUM(Spent_Amount) > Budget_Amount;

#This groups by Category and filters to show only those categories where the total spent exceeds the budgeted amount.
#----------------------------------------------------------------------


# Monthly Spending Overview

SELECT DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month, 
       SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Month
ORDER BY Month;

#This formats the Transaction_Date to extract the month and year, grouping the total spent by month for analysis.
#----------------------------------------------------------------------

# Calculate Overall Budget and Spending Balance

SELECT SUM(Budget_Amount) AS Total_Budget, 
       SUM(Spent_Amount) AS Total_Spent, 
       (SUM(Budget_Amount) - SUM(Spent_Amount)) AS Overall_Balance
FROM personal_budget;

#This provides a high-level overview of overall budget versus spending
#----------------------------------------------------------------------


# Top Spending Vendors

SELECT Vendor, SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Vendor
ORDER BY Total_Spent DESC
LIMIT 5;

#This groups the spending by Vendor, summing it up, and then orders it to show the top 5 vendors by total spending.
#----------------------------------------------------------------------

#Expenditure Trend Over Time

SELECT YEAR(Transaction_Date) AS Year, 
       WEEK(Transaction_Date) AS Week, 
       SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Year, Week
ORDER BY Year, Week;

# This provides insight into spending trends over weeks, helping you visualize how spending patterns change over time.
#----------------------------------------------------------------------

# Average Spending by Account Type

SELECT Account_Type, AVG(Spent_Amount) AS Average_Spent
FROM personal_budget
GROUP BY Account_Type;

# This groups the data by Account_Type and calculates the average spending for each type.
#----------------------------------------------------------------------

# Recent Transactions

SELECT *
FROM personal_budget
ORDER BY Transaction_Date DESC
LIMIT 10;

#This orders the transactions by date in descending order to show the latest ones.
#----------------------------------------------------------------------


# Category-wise Budget Utilization

SELECT Category, 
       Budget_Amount, 
       SUM(Spent_Amount) AS Total_Spent,
       (SUM(Spent_Amount) / Budget_Amount * 100) AS Utilization_Percentage
FROM personal_budget
GROUP BY Category, Budget_Amount
ORDER BY Utilization_Percentage DESC;

#This calculates the utilization percentage by dividing the total spent by the budget amount for each category, ordering by the highest utilization.
#----------------------------------------------------------------------

# Least Spent Categories

SELECT Category, SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Category
ORDER BY Total_Spent ASC
LIMIT 5;

#This groups by category, sums the spending, and orders the results to show the least spent categories.
#----------------------------------------------------------------------

# Transactions in a Specific Date Range

SELECT *
FROM personal_budget
WHERE Transaction_Date BETWEEN '2024-01-01' AND '2024-02-01'
ORDER BY Transaction_Date;

# Adjust the dates in the BETWEEN clause to filter transactions for the desired period.
#----------------------------------------------------------------------

# Account Type Spending Comparison

SELECT Account_Type, SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Account_Type
HAVING SUM(Spent_Amount) > 0
ORDER BY Total_Spent DESC;

# This sums the spending per account type and filters to show only those with positive spending.
#----------------------------------------------------------------------

# Count of Transactions by Category

SELECT Category, COUNT(Transaction_ID) AS Transaction_Count
FROM personal_budget
GROUP BY Category;

# This counts the number of transactions for each category, helping to understand how often each category is being used.
#----------------------------------------------------------------------

# Vendors with Multiple Transactions

SELECT Vendor, COUNT(Transaction_ID) AS Transaction_Count
FROM personal_budget
GROUP BY Vendor
HAVING COUNT(Transaction_ID) > 1;

# This groups the data by vendor and counts the number of transactions, filtering to show only vendors with more than one transaction.
#----------------------------------------------------------------------

# Highest Single Transaction Amount

SELECT *
FROM personal_budget
ORDER BY Spent_Amount DESC
LIMIT 1;

# This orders the transactions by the Spent_Amount in descending order, limiting to the top result to find the highest single expenditure.
#----------------------------------------------------------------------

# Yearly Spending Summary

SELECT YEAR(Transaction_Date) AS Year, 
       SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Year
ORDER BY Year;

# This aggregates total spending by year, helping to visualize spending trends over time.
#----------------------------------------------------------------------

# Balance Analysis

SELECT AVG(Balance) AS Average_Balance, 
       MAX(Balance) AS Maximum_Balance, 
       MIN(Balance) AS Minimum_Balance
FROM personal_budget;

#  This provides insights into how balances fluctuate over the dataset.
#----------------------------------------------------------------------
 
# Percentage of Total Budget Utilization

SELECT 
    (SUM(Spent_Amount) / SUM(Budget_Amount) * 100) AS Total_Utilization_Percentage
FROM personal_budget;

# This calculates the overall percentage of the budget that has been spent across all categories.
#----------------------------------------------------------------------

# Top 3 Spending Categories by Month

WITH Monthly_Spending AS (
    SELECT 
        DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month,
        Category,
        SUM(Spent_Amount) AS Total_Spent
    FROM personal_budget
    GROUP BY Month, Category
)
SELECT Month, Category, Total_Spent
FROM (
    SELECT Month, Category, Total_Spent,
           ROW_NUMBER() OVER (PARTITION BY Month ORDER BY Total_Spent DESC) AS Ranks
    FROM Monthly_Spending
) AS Ranked
WHERE Ranks <= 3;

# This uses a Common Table Expression (CTE) to first calculate monthly spending by category, then ranks them to find the top 3 for each month.
#----------------------------------------------------------------------

# Spending Trends Over the Months

SELECT 
    DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month,
    Category,
    SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Month, Category
ORDER BY Month, Category;

# This summarizes spending over months, allowing you to visualize how expenditures change over time.
#----------------------------------------------------------------------

# Identify Categories with Inconsistent Spending

SELECT Category,
       AVG(Spent_Amount) AS Average_Spent,
       STDDEV(Spent_Amount) AS Spending_Standard_Deviation
FROM personal_budget
GROUP BY Category
HAVING STDDEV(Spent_Amount) > 200; -- Adjust threshold as needed

# This calculates the standard deviation of spending for each category, helping to identify categories with highly inconsistent spending patterns.
#----------------------------------------------------------------------

# Monthly Balance Analysis

WITH Monthly_Balance AS (
    SELECT 
        DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month,
        SUM(Balance) AS Total_Balance
    FROM personal_budget
    GROUP BY Month
)
SELECT Month, Total_Balance,
       CASE 
           WHEN Total_Balance > 0 THEN 'Positive'
           WHEN Total_Balance < 0 THEN 'Negative'
           ELSE 'Zero'
       END AS Balance_Status
FROM Monthly_Balance
ORDER BY Month;

#This CTE first summarizes balances per month and then categorizes each month as having a positive, negative, or zero balance.
#----------------------------------------------------------------------

# Spending Distribution by Vendor

SELECT Vendor,
       SUM(Spent_Amount) AS Total_Spent,
       (SUM(Spent_Amount) / (SELECT SUM(Spent_Amount) FROM personal_budget) * 100) AS Percentage_Of_Total
FROM personal_budget
GROUP BY Vendor
ORDER BY Total_Spent DESC;

#This calculates the total spent per vendor and the percentage of total spending, giving insights into vendor reliance.
#----------------------------------------------------------------------

# Transaction Frequency by Category

SELECT Category, COUNT(Transaction_ID) AS Transaction_Frequency
FROM personal_budget
GROUP BY Category
ORDER BY Transaction_Frequency DESC;

#This counts the number of transactions per category, helping to understand how frequently each category is used.
#----------------------------------------------------------------------

# Overall Spending Comparison by Account Type

SELECT Account_Type,
       SUM(Spent_Amount) AS Total_Spent,
       AVG(Spent_Amount) AS Average_Spent_Per_Transaction
FROM personal_budget
GROUP BY Account_Type;

# This aggregates spending by account type while also calculating the average spending per transaction for each type.
#----------------------------------------------------------------------

# Future Budgeting Analysis

SELECT 
    YEAR(Transaction_Date) AS Year,
    MONTH(Transaction_Date) AS Month,
    SUM(Spent_Amount) AS Total_Spent,
    (SUM(Spent_Amount) / COUNT(Transaction_ID)) * (30) AS Forecasted_Spending_Next_Month
FROM personal_budget
GROUP BY Year, Month;

# This estimates future spending by calculating the average daily spending and multiplying it by 30 days.
#----------------------------------------------------------------------

#  Categorized Expenditure Summary

SELECT 
    Category,
    SUM(Budget_Amount) AS Total_Budget,
    SUM(Spent_Amount) AS Total_Spent,
    CASE 
        WHEN SUM(Spent_Amount) < SUM(Budget_Amount) THEN 'Under Budget'
        WHEN SUM(Spent_Amount) = SUM(Budget_Amount) THEN 'On Budget'
        ELSE 'Over Budget'
    END AS Budget_Status
FROM personal_budget
GROUP BY Category;

# This summarizes expenditures by category while indicating whether each category is under, on, or over budget.
#----------------------------------------------------------------------

# Vendor Analysis Over Time

SELECT 
    DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month,
    Vendor,
    SUM(Spent_Amount) AS Total_Spent
FROM personal_budget
GROUP BY Month, Vendor
ORDER BY Month, Total_Spent DESC;

# This allows you to see trends in vendor spending month over month.

