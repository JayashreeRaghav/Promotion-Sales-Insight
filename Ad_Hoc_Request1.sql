/*Provide a list of products with a base price greater than 500 and that are featured in promo type of 
'BOGOF' (Buy One Get One Free). This information will help us identify high-value products that are currently 
being heavily discounted, which can be useful for evaluating our pricing and promotion strategies.*/

SELECT P.PRODUCT_NAME, F.BASE_PRICE, F.PROMO_TYPE 
FROM FACT_EVENTS F 
JOIN DIM_PRODUCTS P
ON F.PRODUCT_CODE = P.PRODUCT_CODE
WHERE F.PROMO_TYPE  LIKE "BOGOF" AND F.BASE_PRICE > 500;
