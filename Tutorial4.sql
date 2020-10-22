/* Question 1: Invoices issued after their due date. Return all attributes */
SELECT * FROM Invoices I WHERE I.issued > I.due;

/* Question 2: Invoices that were issued before the date in which the order they refer to was placed. Return the ID of the invoice, the date it was issued, the ID of the order associated with it and the date the order was placed. */
SELECT I.invid, I.issued, O.ordid, O.odate 
FROM Invoices I 
JOIN Orders O ON I.ordid = O.ordid 
WHERE I.issued < O.odate;

/* Question 3: Orders that do not have a detail and were placed before 6 September 2016. Return all attributes. */
SELECT * 
FROM Orders O 
WHERE (O.ordid NOT IN (
    SELECT D.ordid from Details D)
    ) AND O.odate < '2016-09-06';

/* Question 4: Customers who have not placed any orders in 2016. Return all attributes. */
SELECT * 
FROM Customers C 
WHERE C.custid NOT IN (
    SELECT O.ocust FROM Orders O
);

/* Question 5: ) ID and name of customers and the date of their last order. For customers who did not place any orders, no rows must be returned. For each customer who placed more than one order on the date of their most recent order, only one row must be returned. */
SELECT C.custid, C.cname, MAX(O.odate)
FROM Customers C
JOIN Orders O ON C.custid = O.ocust
GROUP BY C.custid;

/* Question 6: Invoices that have been overpaid. Observe that there may be more than one payment referring to the
same invoice. Return the invoice number and the amount that should be reimbursed. */
SELECT I.invid, (P.amount - I.amount) AS reimbursement
FROM Invoices I 
JOIN Payments P 
ON I.invid = P.invid
WHERE P.amount > I.amount;

/* Question 7: Products that were ordered more than 10 times in total, by taking into account the quantities in which
they appear in the order details. Return the product code and the total number of times it was ordered. */
SELECT Counts.pcode, Counts.sum
FROM (SELECT D.pcode, SUM(D.qty)
        FROM Details D
        GROUP BY D.pcode) AS Counts
WHERE Counts.sum > 10;

/* Question 8: Products that are usually ordered in bulk: whenever one of these products is ordered, it is ordered in
a quantity that on average is equal to or greater than 8. For each such product, return product code
and price */
SELECT P.pcode, P.price
FROM Products P 
JOIN (SELECT D.pcode, AVG(D.qty)
        FROM Details D
        GROUP BY D.pcode) AS Averages 
ON P.pcode = Averages.pcode
WHERE Averages.avg >= 8;

/* Question 9: Total number of orders placed in 2016 by customers of each country. If all customers from a specific
country did not place any orders in 2016, the country will not appear in the output. */
SELECT C.country, COUNT(C.country)
FROM Customers C
JOIN Orders O
ON O.ocust = C.custid
WHERE O.odate <= '2016-12-31' AND O.odate >= '2016-01-01'
GROUP BY C.country;

/* Question 10: For each order without invoice, list its ID, the date it was placed and the total price of the products in
its detail, taking into account the quantity of each ordered product and its unit price. Orders without
detail must not be included in the answers. */
SELECT OrdersAndTotals.ordid, OrdersAndTotals.odate, OrdersAndTotals.total
FROM (
    SELECT O.ordid, O.odate, Totals.total
    FROM Orders O
    JOIN (
        SELECT D.ordid, D.pcode, D.qty * P.price AS total
        FROM Details D
        JOIN Products P on P.pcode = D.pcode) AS Totals
    ON Totals.ordid = O.ordid) AS OrdersAndTotals
WHERE OrdersAndTotals.ordid NOT IN (
    Select I.ordid FROM Invoices I);