
# DataAnalytics-Assessment

Data Analytics Assessment Submission

---

## Question 1: High-Value Customers with Multiple Products

**Scenario**: The business wants to identify customers with at least one funded savings plan and one funded investment plan to target cross-selling opportunities.

**Approach**:
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount` tables.
- Used `CASE WHEN` inside `COUNT(DISTINCT ...)` to count only savings or investment plans based on `is_regular_savings` and `is_a_fund`.
- Aggregated total inflow using `SUM(confirmed_amount)`.
- Applied `HAVING` clause to filter customers who have both plan types.
- Sorted by `total_deposits` in descending order to highlight top contributors.

**Why it works**:
- Ensures only users who are actively using multiple financial products are selected.
- Filters for savings and investment plans only.

---

## Question 2: Transaction Frequency Analysis

**Scenario**: The finance team needs to segment users based on how frequently they transact.

**Approach**:
- Grouped transactions per user and calculated the number of months between the first and last transaction using `TIMESTAMPDIFF`.
- Use `GREATEST(..., 1)` to avoid errors.
- Classified users into `"High Frequency"`, `"Medium Frequency"`, and `"Low Frequency"` based on their average number of monthly transactions.
- Final results show how many users fall into each category and the average transaction rate for that group.

**Why it works**:
- It provides a clear behavioral segmentation using real transaction history.

---

## Question 3: Account Inactivity Alert

**Scenario**: The operations team needs to flag plans (savings or investment) that have seen no inflow for over a year.

**Approach**:
- Selected plans from `plans_plan` that are either savings or investments.
- Joined with `savings_savingsaccount` and filtered only transactions with confirmed inflows (`confirmed_amount > 0`).
- Used `MAX(transaction_date)` per plan to find the most recent inflow date.
- Applied a `HAVING` clause to return only those inactive for more than 365 days.

**Why it works**:
- Targets only active financial products and helps the business flag stale accounts for re-engagement or closure.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Scenario**: Marketing wants to estimate how valuable each customer is over time based on their transaction behavior.

**Approach**:
- Computed **tenure in months** since account creation using `TIMESTAMPDIFF`.
- Calculated CLV using the formula: `CLV = (total confirmed inflow / tenure_months) * 12 * 0.001`

- Used a `LEFT JOIN` and filtered by `confirmed_amount > 0` to ensure only valid deposits were counted.
- Handled short-tenured users with `GREATEST(..., 1)` to avoid divide-by-zero errors.
- Final results are sorted to prioritize top-value customers.

**Why it works**:
- It uses fact-based approach and no estimation in calculating the customer lifetime value.

---

## Challenges & Resolutions

### 1. **Avoiding Divide-By-Zero in Tenure Calculations**
**Challenge**: Some users may have a tenure of less than one month.
**Resolution**: Used `GREATEST(..., 1)` to ensure a minimum divisor of 1.

---

### 2. **Distinguishing Between Savings and Investment Plans**
**Challenge**: Some plans may be neither or both `is_regular_savings` and `is_a_fund`.
**Resolution**: Applied conditional logic (`CASE WHEN`) with `DISTINCT COUNT` to avoid double-counting.

---

### 3. **Accurate CLV Interpretation**
**Challenge**: Deciding between estimating profit per transaction vs. using actual transaction value.
**Resolution**: Aligned with the business rule that “profit per transaction is 0.1% of the transaction value”, and computed CLV using actual confirmed inflows only.

---

## Final Notes

- All monetary amounts (e.g., `confirmed_amount`) are handled in **kobo** as per schema conventions.
- SQL formatting emphasizes readability and maintainability.
- Queries are optimized for clarity and precision — avoiding unnecessary subqueries or complexity.

