-- QUESTION 1: High-Value Customers with Multiple Products
SELECT 
    users_customuser.id AS owner_id,
    CONCAT(users_customuser.first_name, ' ', users_customuser.last_name) AS name, -- concatenate the first and last name
    COUNT(DISTINCT CASE WHEN plans_plan.is_regular_savings = 1 THEN plans_plan.id END) AS savings_count, -- count distinct savings plan 
    COUNT(DISTINCT CASE WHEN plans_plan.is_a_fund = 1 THEN plans_plan.id END) AS investment_count, -- count distinct investment plans
    SUM(savings_savingsaccount.confirmed_amount) AS total_deposits -- sum all total deposits
FROM 
    users_customuser
    INNER JOIN plans_plan ON users_customuser.id = plans_plan.owner_id
    INNER JOIN savings_savingsaccount ON savings_savingsaccount.plan_id = plans_plan.id
GROUP BY 
    users_customuser.id, users_customuser.first_name, users_customuser.last_name
HAVING 
    savings_count >= 1 
    AND investment_count >= 1 -- filter for savings and investment plans only
ORDER BY 
    total_deposits DESC; -- sort by highest deposits