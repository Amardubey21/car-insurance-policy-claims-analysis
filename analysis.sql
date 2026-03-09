--1.Total Premium Collected in 2024
SELECT 
SUM(premium) AS total_premium_2024
FROM policy_sales_data;

--2.Total Claim Cost by Month (2025 & 2026)
SELECT
EXTRACT(YEAR FROM claim_date) AS year,
EXTRACT(MONTH FROM claim_date) AS month,
SUM(claim_amount) AS total_claim_cost
FROM claims_data
GROUP BY year, month
ORDER BY year, month;

--3.Claim Cost to Premium Ratio by Policy Tenure
SELECT
p.policy_tenure,
SUM(c.claim_amount) / SUM(p.premium) AS claim_to_premium_ratio
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.vehicle_id = c.vehicle_id
GROUP BY p.policy_tenure
ORDER BY p.policy_tenure;

--4.Claim Cost to Premium Ratio by Policy Purchase Month
SELECT
EXTRACT(MONTH FROM p.policy_purchase_date) AS purchase_month,
SUM(c.claim_amount) / SUM(p.premium) AS claim_ratio
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.vehicle_id = c.vehicle_id
GROUP BY purchase_month
ORDER BY purchase_month;

--5.Total Potential Claim Liability
SELECT
COUNT(*) * 10000 AS potential_claim_liability
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.vehicle_id = c.vehicle_id
WHERE c.vehicle_id IS NULL;

--6.Premium Earned Until Feb 28, 2026
SELECT
SUM(
(p.premium / (p.policy_tenure * 365.0)) *
(LEAST('2026-02-28'::date, p.policy_end_date) - p.policy_start_date)
) AS earned_premium
FROM policy_sales_data p
WHERE p.policy_start_date <= '2026-02-28';

--7.Monthly Expected Premium (Remaining Period)
SELECT
SUM(premium) / 46 AS expected_monthly_premium
FROM policy_sales_data;

--loss ratio
SELECT
SUM(c.claim_amount) / SUM(p.premium) AS loss_ratio
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.vehicle_id = c.vehicle_id;