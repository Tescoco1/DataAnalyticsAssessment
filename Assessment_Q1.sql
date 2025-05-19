-- Q1: High-Value Customers with Multiple Products

-- Step 1: Select basic user information
-- Step 2: Join with savings_savingsaccount to count funded savings plans
-- Step 3: Join with plans_plan to count funded investment plans (is_a_fund = 1)
-- Step 4: Filter users with at least one savings and one investment
-- Step 5: Aggregate total confirmed_amount (in Naira) and sort by it

SELECT
    u.id AS user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(DISTINCT sa.id) AS num_savings, -- count of funded savings plans
    COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) AS num_investments, -- count of investments
    SUM(sa.confirmed_amount / 100.0) AS total_funding -- total deposit in Naira
FROM
    users_customuser u
-- Join with savings table to get deposits
LEFT JOIN
    savings_savingsaccount sa ON u.id = sa.owner_id AND sa.confirmed_amount > 0
-- Join with plans to find investment plans
LEFT JOIN
    plans_plan pp ON u.id = pp.owner_id AND pp.is_a_fund = 1
GROUP BY
    u.id, u.first_name, u.last_name
-- Only include users with both savings and investments
HAVING
    COUNT(DISTINCT sa.id) > 0
    AND COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) > 0
ORDER BY
    total_funding DESC;
