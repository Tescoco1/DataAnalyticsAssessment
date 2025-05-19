-- Q3: Account Inactivity Alert

-- Step 1: Use a CTE to find the most recent transaction date per user
-- Step 2: Join plans with latest transaction data
-- Step 3: Filter to find plans inactive for over 365 days
-- Step 4: Return the plan type and number of inactivity days

WITH recent_txn AS (
    -- Get the most recent transaction date per user
    SELECT
        owner_id,
        DATE(MAX(transaction_date)) AS most_recent_txn
    FROM
        savings_savingsaccount
    GROUP BY
        owner_id
)
SELECT
    pl.id AS plan_ref,
    pl.owner_id,
    -- Determine type of plan
    CASE
        WHEN pl.is_regular_savings = 1 THEN 'Savings'
        WHEN pl.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS category,
    rt.most_recent_txn,
    -- Calculate number of days since last transaction
    DATEDIFF(CURRENT_DATE(), rt.most_recent_txn) AS days_inactive
FROM
    plans_plan pl
JOIN
    recent_txn rt ON pl.owner_id = rt.owner_id
-- Filter out active users (who transacted within the past year)
WHERE
    rt.most_recent_txn < DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)
    AND (pl.is_regular_savings = 1 OR pl.is_a_fund = 1)
ORDER BY
    days_inactive DESC;
