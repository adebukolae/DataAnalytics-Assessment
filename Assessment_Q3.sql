-- QUESTION 3: Account Inactivity Alert
-- Find active savings or investment plans with no inflow transactions (confirmed_amount > 0)
-- in the last 365 days.
SELECT 
    plans_plan.id AS plan_id,
    plans_plan.owner_id,
    CASE 
        WHEN plans_plan.is_regular_savings = 1 THEN 'Savings'
        WHEN plans_plan.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type, -- determine if the plan is a savings or investment plan
    MAX(savings_savingsaccount.transaction_date) AS last_transaction_date, -- get the most recent transaction date
    DATEDIFF(CURDATE(), MAX(savings_savingsaccount.transaction_date)) AS inactivity_days -- calculate number of days since the last transaction
FROM 
    plans_plan
    INNER JOIN savings_savingsaccount ON savings_savingsaccount.plan_id = plans_plan.id
        AND savings_savingsaccount.confirmed_amount > 0 -- only consider inflow transactions
WHERE 
    (plans_plan.is_regular_savings = 1 OR plans_plan.is_a_fund = 1) -- consider only plans that are either savings or investment
GROUP BY 
    plans_plan.id, plans_plan.owner_id, plans_plan.is_regular_savings, plans_plan.is_a_fund
HAVING 
    MAX(savings_savingsaccount.transaction_date) < CURDATE() - INTERVAL 365 DAY -- only keep those with no transactions in the last 365 days
ORDER BY 
    inactivity_days DESC; -- sort by longest inactive period first