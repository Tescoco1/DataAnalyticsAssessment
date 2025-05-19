-- Q2: Transaction Frequency Analysis

-- Step 1: Create a CTE to calculate number of transactions per user per month
-- Step 2: Create a second CTE to calculate average transactions per user
-- Step 3: Categorize each user based on frequency of transactions
-- Step 4: Aggregate number of users per frequency category

WITH txn_monthly AS (
    -- Count transactions per user per month
    SELECT
        ss.owner_id,
        DATE_FORMAT(ss.transaction_date, '%Y-%m-01') AS txn_month,
        COUNT(*) AS monthly_txn_count
    FROM
        savings_savingsaccount ss
    GROUP BY
        ss.owner_id, DATE_FORMAT(ss.transaction_date, '%Y-%m-01')
),
average_usage AS (
    -- Calculate average monthly transactions for each user
    SELECT
        owner_id,
        AVG(monthly_txn_count) AS avg_monthly_txns
    FROM
        txn_monthly
    GROUP BY
        owner_id
)
-- Categorize users and count them by frequency type
SELECT
    CASE
        WHEN avg_monthly_txns >= 10 THEN 'High Frequency'
        WHEN avg_monthly_txns >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS usage_category,
    COUNT(*) AS users_in_group,
    ROUND(AVG(avg_monthly_txns), 1) AS average_txns
FROM
    average_usage
GROUP BY
    usage_category
ORDER BY
    CASE
        WHEN usage_category = 'High Frequency' THEN 1
        WHEN usage_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
