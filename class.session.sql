SELECT 
    productline 
    , COUNT(productname) AS product_count
FROM products
GROUP BY productline
ORDER BY productname;

SELECT 
    country
    ,sum (od.quantityOrdered * od.priceEach) AS total_revenu
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.country 
ORDER BY total_revenu DESC
LIMIT 10;

SELECT c.customerNumber
    , c.customerName
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
WHERE strftime('%y', o.orderDate ) = IN('2003', '2004')
;


SELECT *
    , c.customerName
FROM customers c
WHERE c.customerNumber IN (
    SELECT o.customerNumber
    FROM orders o
    WHERE strftime('%Y', orderDate) in ('2003','2004')
)
;