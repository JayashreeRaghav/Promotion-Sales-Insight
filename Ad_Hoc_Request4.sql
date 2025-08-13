/*Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. 
Additionally, provide rankings for the categories based on their ISU%. The report will include three key 
fields: category, isu%, and rank order. This information will assist in assessing the category-wise success and impact 
of the Diwali campaign on incremental sales.

Note: ISU% (Incremental Sold Quantity Percentage) is calculated as the percentage increase/decrease in quantity sold
 (after promo) compared to quantity sold (before promo)*/     

WITH CATEGORY_SALE AS
(SELECT P.CATEGORY,
		SUM(`QUANTITY_SOLD(BEFORE_PROMO)`) AS QTY_BEFORE_PROMO,
        SUM((IF(PROMO_TYPE = "BOGOF", `QUANTITY_SOLD(AFTER_PROMO)` * 2,`QUANTITY_SOLD(AFTER_PROMO)`))) AS QTY_AFTER_PROMO
 FROM DIM_PRODUCTS P   
 JOIN FACT_EVENTS F ON P.PRODUCT_CODE = F.PRODUCT_CODE
 JOIN DIM_CAMPAIGNS C ON F.CAMPAIGN_ID = C.CAMPAIGN_ID
 WHERE C.CAMPAIGN_NAME = "DIWALI"
 GROUP BY P.CATEGORY)
 
 SELECT CATEGORY,
		ROUND(((QTY_AFTER_PROMO-QTY_BEFORE_PROMO)/QTY_BEFORE_PROMO) * 100,2) AS ISU_PERCENT,
        RANK() OVER (ORDER BY ((QTY_AFTER_PROMO-QTY_BEFORE_PROMO)/QTY_BEFORE_PROMO)DESC) AS RANK_ORDER
 FROM CATEGORY_SALE    
 ORDER BY ISU_PERCENT DESC;