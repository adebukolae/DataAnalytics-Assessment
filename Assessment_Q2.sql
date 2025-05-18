-- QUESTION 2: Transaction Frequency Analysis
-- Calculate average transactions per customer per month and categorize them

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,  -- Number of customers in each frequency category
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month  -- Average transactions/month per category
FROM (
    SELECT 
        u.id AS owner_id,
        COUNT(s.id) AS total_transactions,  -- Total number of transactions per customer       
        ROUND(
            COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(s.created_on), CURDATE()), 1),
            2
        ) AS avg_transactions_per_month, -- Compute average transactions per month (ensure at least 1 month to avoid division by zero) 
        CASE 
            WHEN COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(s.created_on), CURDATE()), 1) >= 10 THEN 'High Frequency'
            WHEN COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(s.created_on), CURDATE()), 1) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category -- Categorize based on transaction frequency
    FROM 
        users_customuser u
    INNER JOIN 
        savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY 
        u.id
    HAVING 
        avg_transactions_per_month IS NOT NULL  -- Only include customers with calculable frequency
) AS customer_frequency
GROUP BY 
    frequency_category
ORDER BY 
    CASE frequency_category 
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;
