/*Generate a report that displays each campaign along with the total revenue generated before and after the campaign? 
The report includes three key fields: campaign_name, total_revenue(before_promotion), total_revenue(after_promotion).
This report should help in evaluating the financial impact of our promotional campaigns. (Display the values in millions)*/
with CTE1 as 
(SELECT
    CAMPAIGN_ID,
    PROMO_TYPE,
    CASE
       WHEN promo_type = 'BOGOF' 
           THEN (`QUANTITY_SOLD(AFTER_PROMO)`*2)* BASE_PRICE * (1-0.5)
       WHEN promo_type = '500 CASHBACK' 
           THEN (`QUANTITY_SOLD(AFTER_PROMO)`* (BASE_PRICE -500))
       WHEN promo_type = '50% OFF' 
           THEN `QUANTITY_SOLD(AFTER_PROMO)`* BASE_PRICE *(1-0.5)
       WHEN promo_type = '33% OFF' 
           THEN `QUANTITY_SOLD(AFTER_PROMO)`* BASE_PRICE *(1-0.33) 
       WHEN promo_type = '25% OFF' 
           THEN `QUANTITY_SOLD(AFTER_PROMO)`* BASE_PRICE*(1-0.25) 
       ELSE NULL
       END AS REVENUE_AFTER_PROMO,
    `QUANTITY_SOLD(BEFORE_PROMO)` AS QUANTITY_SOLD_BEFORE_PROMO,
    BASE_PRICE
FROM fact_events) 
SELECT 
     C.CAMPAIGN_NAME,
     ROUND(SUM(CT.QUANTITY_SOLD_BEFORE_PROMO * CT.BASE_PRICE)/1000000,2) AS TOTAL_REVENUE_BEFORE_PROMO,
     ROUND(SUM(CT.REVENUE_AFTER_PROMO)/1000000,2) AS TOTAL_REVENUE_AFTER_PROMO
FROM DIM_CAMPAIGNS C
JOIN CTE1 CT ON CT.CAMPAIGN_ID = C.CAMPAIGN_ID
GROUP BY C.CAMPAIGN_NAME
ORDER BY C.CAMPAIGN_NAME;