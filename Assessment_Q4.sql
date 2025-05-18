-- QUESTION 4: Customer Lifetime Value (CLV) Estimation (Factual, No Aliases)
-- Calculate CLV using actual confirmed inflow amounts (still in kobo)
-- Formula: CLV = (total confirmed inflow / tenure_months) * 12 * 0.001

SELECT 
    users_customuser.id AS customer_id,
    CONCAT(users_customuser.first_name, ' ', users_customuser.last_name) AS name,
    GREATEST(
        TIMESTAMPDIFF(MONTH, users_customuser.date_joined, CURDATE()), 
        1
    ) AS tenure_months, -- Calculate account tenure in months (minimum of 1 month)  
    COUNT(savings_savingsaccount.id) AS total_transactions, -- Count of confirmed inflow transactions
    ROUND(
        (
            SUM(savings_savingsaccount.confirmed_amount) / 
            GREATEST(TIMESTAMPDIFF(MONTH, users_customuser.date_joined, CURDATE()), 1)
        ) * 12 * 0.001,
        2
    ) AS estimated_clv -- CLV formula using actual inflows and fixed 0.1% profit rate

FROM users_customuser
LEFT JOIN savings_savingsaccount 
    ON users_customuser.id = savings_savingsaccount.owner_id 
    AND savings_savingsaccount.confirmed_amount > 0

GROUP BY 
    users_customuser.id, 
    users_customuser.first_name, 
    users_customuser.last_name, 
    users_customuser.date_joined

ORDER BY 
    estimated_clv DESC;
