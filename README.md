# E-Commerce Sales Analysis (2024–2025)

## Executive Summary

This project investigates e-commerce performance between 2024 and 2025 using SQL Server and Excel. The analysis explores changes in sales, customer acquisition, purchasing behaviour, and product performance to identify areas of concern and potential opportunities for improvement.

The findings show declining sales activity, fewer new customers, and weaker performance across several product categories. Further investigation highlights specific products that may require attention.

## Business Objective

To analyse e-commerce performance using SQL, evaluate year-on-year changes in sales, customer acquisition, and purchasing behaviour, and identify key business trends and opportunities for improvement.

## Tools and Technical Skills

- **SQL Server and SSMS:** Data analysis, multi-table joins, aggregations, conditional logic, date-based analysis, and year-on-year comparisons.
- **Excel:** Data cleaning, standardisation, date validation, and percentage-change calculations.
- **Data quality:** Identifying invalid dates, inconsistent text, unusual quantities, and shipping records requiring investigation.
- **Business analysis:** Investigating performance changes and translating findings into actionable recommendations.

## Key Findings

### 1. Sales performance declined

<img src="sales performance.png" alt="Sales performance declined" width="700">

- Revenue decreased between 2024 and 2025.
- Total orders fell from **118 to 102**, a decline of **13.6%**.
- Average order value decreased from **303.71 to 278.16**, a decline of **8.4%**.
- Units sold dropped from **621 to 516**, a decline of **16.9%**.

The combined decline in order volume, average order value, and units sold indicates that the business experienced weaker purchasing activity in 2025.

### 2. Customer acquisition weakened

New customer sign-ups fell from **49 in 2024 to 11 in 2025**, a decline of approximately **77.6%**.

This raises a concern about the business's ability to attract new customers. Further analysis of marketing activity, website traffic, and conversion rates would help determine what contributed to the decline.

### 3. Electronics and Footwear were major areas of concern

![Electronics and Footwear were major areas of concern](images/category revenue.png)

- **Electronics revenue** declined by approximately 23.1%.
- **Footwear revenue** declined by approximately 47.1%.
- Running Shoes unit sales fell from **70 to 37**.
- Smart Watch unit sales fell from **67 to 44**.

These findings helped narrow the investigation from overall sales performance to specific categories and products requiring closer attention.

### 4. Some products showed growth

Not all products performed poorly. Clothing revenue increased by approximately **27.6%**, while Wireless Headphones unit sales increased from **28 to 31**.

These results provide useful comparisons for investigating what may be contributing to stronger performance in selected products.

## Recommendations

1. **Investigate customer acquisition:** Review marketing campaigns, website traffic, and conversion rates to understand the decline in new customers.
2. **Review underperforming products:** Investigate demand, stock availability, customer feedback, and competitor pricing for Electronics and Footwear, particularly Running Shoes and Smart Watches.
3. **Learn from stronger performers:** Examine Clothing and Wireless Headphones for patterns that could inform product selection and marketing decisions.
4. **Monitor key performance indicators:** Track revenue, order volume, average order value, units sold, and new customer acquisition regularly to identify further changes.

These recommendations are investigative priorities rather than confirmed explanations, as additional data would be needed to establish the causes of the observed trends.

## Conclusion

This project demonstrates how SQL can be used beyond basic reporting to investigate business performance, identify the products and metrics driving changes, and develop evidence-based recommendations.

The analysis combines data preparation, relational querying, year-on-year comparisons, and follow-up investigation to turn raw transactional data into findings that can support business decisions.

## Data Scope

The analysis covers six related tables: Customers, Orders, Order Items, Products, Payments, and Shipping, covering 2024–2025.
