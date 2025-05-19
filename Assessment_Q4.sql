-- Q4: Customer Lifetime Value (CLV) Estimation

-- Step 1: Use CTE to calculate user tenure, transaction count, and total transaction value
-- Step 2: Calculate CLV based on given formula:
-- CLV = (transactions / tenure) * 12 * avg profit per transaction
-- where profit per transaction = 0.1% of transaction value

WITH user_metrics AS (
    -- Aggregate transaction and tenure data for each user
    SELECT
        cu.id AS client_id,
        CONCAT(cu.first_name, ' ', cu.last_name) AS full_name,
        TIMESTAMPDIFF(MONTH, cu.date_joined, CURRENT_DATE()) AS months_active,
        COUNT(tx.id) AS txn_count,
        SUM(tx.confirmed_amount / 100.0) AS total_txn_value
    FROM
        users_customuser cu
    LEFT JOIN
        savings_savingsaccount tx ON cu.id = tx.owner_id
    GROUP BY
        cu.id, cu.first_name, cu.last_name, cu.date_joined
)
SELECT
    client_id,
    full_name,
    months_active,
    txn_count,
    -- Compute estimated CLV with proper handling of division
    ROUND(
        (txn_count / NULLIF(months_active, 0)) * 12 *
        (0.001 * COALESCE(total_txn_value, 0) / NULLIF(txn_count, 0)),
        2
    ) AS estimated_clv
FROM
    user_metrics
WHERE
    months_active > 0
ORDER BY
    estimated_clv DESC;
