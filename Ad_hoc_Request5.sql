/*Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all campaigns. 
The report will provide essential information including product name, category, and ir%. This analysis helps identify 
the most successful products in terms of incremental revenue across our campaigns, assisting in product optimization.*/ 

with CTE1 as 
(SELECT
    PRODUCT_CODE,
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
       (`QUANTITY_SOLD(BEFORE_PROMO)` * BASE_PRICE) AS REVENUE_BEFORE_PROMO,
    BASE_PRICE
FROM fact_events) 
SELECT 
     P.PRODUCT_NAME,
     P.CATEGORY,
     ROUND(((SUM(REVENUE_AFTER_PROMO)-SUM(REVENUE_BEFORE_PROMO))/SUM(REVENUE_BEFORE_PROMO))*100,2) AS IR_PERCENT
FROM DIM_PRODUCTS P
JOIN CTE1 CT ON CT.PRODUCT_CODE = P.PRODUCT_CODE
GROUP BY P.PRODUCT_NAME, P.CATEGORY
ORDER BY IR_PERCENT DESC
LIMIT 5;