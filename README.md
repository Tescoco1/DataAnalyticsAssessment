# DataAnalyticsAssessment
This repository contains solutions to a SQL proficiency assessment focused on practical business use cases involving customer behavior and financial transactions. The dataset consists of four core tables: users_customuser, savings_savingsaccount, plans_plan, and withdrawals_withdrawal.

Each SQL script in this repository is designed to solve one of four targeted business problems using efficient and well-structured SQL queries.


### Q1: High-Value Customers with Multiple Products

**Objective:** Identify users who have at least one funded savings account and one funded investment plan, sorted by total deposits.

**Approach:**
- Joined users_customuser with savings_savingsaccount (using confirmed_amount > 0) and plans_plan (filtered with is_a_fund = 1).
- Grouped by user and counted distinct savings and investment products.
- Filtered for users with both product types and ordered results by total deposit value in Naira.

**Challenges:**
- Ensured distinct counts to avoid duplication.
- Normalized currency (from Kobo to Naira) using division by 100.

###  Q2: Transaction Frequency Analysis

**Objective:** Calculate average monthly transaction counts per user and categorize them into frequency buckets.

**Approach:**
- Used two CTEs: 
  - One to count monthly transactions per user.
  - Another to compute each user's average transactions per month.
- Categorized users as "High", "Medium", or "Low Frequency".
- Aggregated the number of users and calculated the average for each group.

**Challenges:**
- Required rounding and formatting for readability.
- Considered the use of `DATE_FORMAT` to group transactions by month.

###  Q3: Account Inactivity Alert

**Objective:** Flag savings and investment plans with no transaction activity in the last 365 days.

**Approach:**
- Created a CTE to get the latest transaction date per user.
- Joined this with `plans_plan` and filtered for plans with inactivity beyond 1 year.
- Displayed plan type, last activity date, and days of inactivity.

**Challenges:**
- Handled plan types dynamically using a CASE statement.
- Ensured inactive plans are correctly filtered using DATEDIFF.

### Q4: Customer Lifetime Value (CLV) Estimation

**Objective:** Estimate each customer’s lifetime value based on tenure and transaction activity.

**Approach:**
- Calculated tenure (in months) and total transaction count/value.
- Computed estimated CLV
- Profit rate = 0.1% of transaction value.
- Handled zero-tenure and zero-transaction scenarios using `NULLIF` and `COALESCE`.

**Challenges:**
- Edge-case handling for division by zero.
- Ensured proper formatting and rounding for the final CLV estimate.

