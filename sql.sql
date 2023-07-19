/*Q1. Write a query to display customer_id, customer full name with their title (Mr/Ms),  
both first name and last name are in upper case, customer_email,  customer_creation_year
 and display customer’s category after applying below categorization rules:
 i. if CUSTOMER_CREATION_DATE year <2005 then category A
 ii. if CUSTOMER_CREATION_DATE year >=2005 and <2011 then category B 
 iii. if CUSTOMER_CREATION_DATE year>= 2011 then category C
 Expected 52 rows in final output.
[Note: TABLE to be used - ONLINE_CUSTOMER TABLE] 
Hint:Use CASE statement. create customer_creation_year column with the help of customer_creation_date, 
no permanent change in the table is required. 
(Here don’t UPDATE or DELETE the columns in the table nor CREATE new tables for your representation. 
A new column name can be used as an alias for your manipulation in case if you are going to
use a CASE statement.) 
*/

## Answer 1.
Use orders;
Select customer_id,concat(
Case
When customer_gender='m' then 'mr.'
Else 'ms.'end ,' ',upper(customer_fname),' ',upper(customer_lname)) 
As customer_full_name,customer_email,(customer_creation_date),
Case  
When year(customer_creation_date)<2005 then 'a'
When year(customer_creation_date)>=2005 and year(customer_creation_date)<2011 then 'b' 
Else 'c'
End as customers_category 
From online_customer;


/* Q2. Write a query to display the following information for the products which have 
not been sold: product_id, product_desc, product_quantity_avail, product_price,
inventory values (product_quantity_avail * product_price), 
New_Price after applying discount as per below criteria. 
Sort the output with respect to decreasing value of Inventory_Value. 
i) If Product Price > 200,000 then apply 20% discount 
ii) If Product Price > 100,000 then apply 15% discount 
iii) if Product Price =< 100,000 then apply 10% discount 
Expected 13 rows in final output.
[NOTE: TABLES to be used - PRODUCT, ORDER_ITEMS TABLE]
Hint: Use CASE statement, no permanent change in table required. 
(Here don’t UPDATE or DELETE the columns in the table nor CREATE new tables for your representation.
 A new column name can be used as an alias for your manipulation in case if you are going to use 
 a CASE statement.)
*/
## Answer 2.
Select p.product_id,p.product_desc,p.product_quantity_avail,p.product_price,(p.product_quantity_avail*p.product_price)  as inventory_values,
(case
When p.product_price >20000 then p.product_price * 0.8
When product_price >10000 then p.product_price * 0.85
Else p.product_price * 0.9
End) as new_price from product p left join order_items o on p.product_id=o.product_id
Where product_quantity is null order by inventory_values desc;


/*Q3. Write a query to display Product_class_code, Product_class_desc,
 Count of Product type in each product class, 
 Inventory Value (p.product_quantity_avail*p.product_price). 
 Information should be displayed for only those product_class_code 
 which have more than 1,00,000 Inventory Value.
 Sort the output with respect to decreasing value of Inventory_Value. 
Expected 9 rows in final output.
[NOTE: TABLES to be used - PRODUCT, PRODUCT_CLASS]
Hint: 'count of product type in each product class' is the count of product_id based on product_class_code.
*/

## Answer 3.
Select pc.product_class_code, pc.product_class_desc, count(p.product_id) as count_product_type, sum(p.product_quantity_avail * p.product_price) as inventory_value
From product p 
Join product_class pc on p.product_class_code = pc.product_class_code 
Group by pc.product_class_code, pc.product_class_desc 
Having inventory_value > 100000 
Order by inventory_value desc;



/* Q4. Write a query to display customer_id, full name, customer_email, 
customer_phone and country of customers who have cancelled all the orders placed by them.
Expected 1 row in the final output
[NOTE: TABLES to be used - ONLINE_CUSTOMER, ADDRESSS, OREDER_HEADER]
Hint: USE SUBQUERY
*/
 
## Answer 4.
Select o.customer_id,concat(upper(o.customer_fname),' ',upper(o.customer_lname)) 
Full_name,o.customer_email, o.customer_phone,a.country
From online_customer o
Inner join address a
Using (address_id)
Inner join order_header 
Using (customer_id)
Where order_status= 'cancelled'
Group by o.customer_id,o.customer_email,o.customer_phone,a.country having 
Count(distinct order_status)=1;


select o.customer_id,concat(upper(o.customer_fname),' ',upper(o.customer_lname))
Full_Name,o.customer_email, o.customer_phone,a.country
from online_customer o
inner join address a
using (Address_id)
inner join order_header
using (customer_id)
where Order_status= 'Cancelled';



/* Q5. Write a query to display Shipper name, City to which it is catering, 
num of customer catered by the shipper in the city , 
number of consignment delivered to that city for Shipper DHL 
Expected 9 rows in the final output
[NOTE: TABLES to be used - SHIPPER, ONLINE_CUSTOMER, ADDRESSS, ORDER_HEADER]
Hint: The answer should only be based on Shipper_Name -- DHL. 
The main intent is to find the number of customers and the consignments catered by DHL in each city.
 */

## Answer 5.  
Select s.shipper_name, a.city, count(distinct o.customer_id) as num_customers, count(o.order_id) as num_consignments
From shipper s
Inner join order_header o on s.shipper_id = o.shipper_id
Inner join online_customer c on o.customer_id = c.customer_id
Inner join address a on c.address_id = a.address_id
Where s.shipper_name = 'dhl'
Group by s.shipper_name, a.city;


/*Q6. Write a query to display product_id, product_desc, product_quantity_avail, quantity sold 
and show inventory Status of products as per below condition: 
a. For Electronics and Computer categories, 
if sales till date is Zero then show  'No Sales in past, give discount to reduce inventory', 
if inventory quantity is less than 10% of quantity sold, show 'Low inventory, need to add inventory', 
if inventory quantity is less than 50% of quantity sold, show 'Medium inventory, need to add some inventory',
if inventory quantity is more or equal to 50% of quantity sold, show 'Sufficient inventory' 
b. For Mobiles and Watches categories, 
if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
if inventory quantity is less than 20% of quantity sold, show 'Low inventory, need to add inventory', 
if inventory quantity is less than 60% of quantity sold, show 'Medium inventory, need to add some inventory',
if inventory quantity is more or equal to 60% of quantity sold, show 'Sufficient inventory' 

c. Rest of the categories, 
if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
if inventory quantity is less than 30% of quantity sold, show 'Low inventory, need to add inventory', 
if inventory quantity is less than 70% of quantity sold, show 'Medium inventory, need to add some inventory',
if inventory quantity is more or equal to 70% of quantity sold, show 'Sufficient inventory'
Expected 60 rows in final output
[NOTE: (USE CASE statement) ; TABLES to be used - PRODUCT, PRODUCT_CLASS, ORDER_ITEMS]
Hint:  quantity sold here is product_quantity in order_items table. 
You may use multiple case statements to show inventory status
(Low stock, In stock, and Enough stock) that meets both the conditions i.e. on products as well as on quantity
The meaning of the rest of the categories, means products apart from electronics,computers,mobiles and watches
*/

## Answer 6.
Select p.product_id,p.product_desc,p.product_quantity_avail,product_class_desc,sum(oi.product_quantity) as quantity_sold,
Case 
When pc.product_class_desc in ('electronics', 'computer') then
Case 
When sum(oi.product_quantity) = 0 then 'no sales in past, give discount to reduce inventory'
When p.product_quantity_avail < sum(oi.product_quantity) * 0.1 then 'low inventory, need to add inventory'
When p.product_quantity_avail < sum(oi.product_quantity) * 0.5 then 'medium inventory, need to add some inventory'
Else 'sufficient inventory'
            end
When pc.product_class_desc in ('mobiles', 'watches') then
Case 
When sum(oi.product_quantity) = 0 then 'no sales in past, give discount to reduce inventory'
When p.product_quantity_avail < sum(oi.product_quantity) * 0.2 then 'low inventory, need to add inventory'
When p.product_quantity_avail < sum(oi.product_quantity) * 0.6 then 'medium inventory, need to add some inventory'
Else 'sufficient inventory'
End
Else
Case 
When sum(oi.product_quantity) = 0 then 'no sales in past, give discount to reduce inventory'
When p.product_quantity_avail < sum(oi.product_quantity) * 0.3 then 'low inventory, need to add inventory'
When p.product_quantity_avail < sum(oi.product_quantity) * 0.7 then 'medium inventory, need to add some inventory'
Else 'sufficient inventory'
End
End as inventory_status
From product p 
Join product_class pc on p.product_class_code = pc.product_class_code 
Left join order_items oi on p.product_id = oi.product_id 
Group by p.product_id, p.product_desc, p.product_quantity_avail, pc.product_class_desc;


/* Q7. Write a query to display order_id and volume of the biggest order (in terms of volume) 
that can fit in carton id 10 .
Expected 1 row in final output
[NOTE: TABLES to be used - CARTON, ORDER_ITEMS, PRODUCT]
Hint: First find the volume of carton id 10 and then find the order id with products having
total volume less than the volume of carton id 10
 */

## Answer 7.
Select orde.order_id , ( pro.len *pro. Width * pro. Height ) product_volume
From product pro join order_items orde using ( product_id ) 
Where ( pro.len *pro. Width * pro. Height ) <= ( select ( car. Len * car . Width * car. Height )
carton_volume from carton car where carton_id = 10 ) order by product_volume 
Desc limit 1;



/*Q8. Write a query to display customer id, customer full name, total quantity and 
total value (quantity*price) shipped where mode of payment is Cash and customer last name starts with 'G'
Expected 2 rows in final output
[NOTE: TABLES to be used - ONLINE_CUSTOMER, ORDER_ITEMS, PRODUCT, ORDER_HEADER]
*/

## Answer 8.
Select oc.customer_id,concat(oc.customer_fname,' ',oc.customer_lname) as Full_name,count(o.product_quantity) as total_quantity,
Sum(o.product_quantity * p.product_price) as total_value 
From online_customer oc
Inner join order_header oh
Using (customer_id)
Inner join order_items o
Using(order_id)
Inner join product p
Using (product_id) 
Where order_status = 'shipped' and payment_mode='cash' and customer_lname like 'g%'
Group by customer_id;



/*Q9. Write a query to display product_id, product_desc and total quantity of products which are sold together
 with product id 201 and are not shipped to city Bangalore and New Delhi. 
Expected 6 rows in final output
[NOTE: TABLES to be used - ORDER_ITEMS, PRODUCT, ORDER_HEADER, ONLINE_CUSTOMER, ADDRESS]
Hint: Display the output in descending order with respect to the sum of product_quantity. 
(USE SUB-QUERY) In final output show only those products ,
 product_id’s which are sold with 201 product_id (201 should not be there in output) 
 and are shipped except Bangalore and New Delhi
 */

## Answer 9.
SELECT p.product_id, p.product_desc, SUM(oi.product_quantity) AS total_quantity
FROM order_items oi
JOIN product p ON oi.product_id = p.product_id
JOIN order_header oh ON oi.order_id = oh.order_id
JOIN online_customer oc ON oh.customer_id = oc.customer_id
JOIN address a ON oc.address_id = a.address_id
WHERE oi.order_id IN 
(SELECT oi2.order_id 
FROM order_items oi2 
WHERE oi2.product_id = 201) 
AND a.city NOT IN ('Bangalore', 'New Delhi') 
AND oi.product_id != 201 and order_status='shipped'
GROUP BY p.product_id, p.product_desc
ORDER BY total_quantity DESC;


/* Q10. Write a query to display the order_id, customer_id and customer fullname, total quantity of products 
shipped for order ids which are even and shipped to address where pincode is not starting with "5" 
Expected 15 rows in final output
[NOTE: TABLES to be used - ONLINE_CUSTOMER, ORDER_HEADER, ORDER_ITEMS, ADDRESS]
 */

## Answer 10.
Select o.order_id,oc.customer_id,concat(oc.customer_fname,' ',customer_lname) as full_name,
Sum(o.product_quantity) as total_quantity
From order_items o
Inner join order_header oh using(order_id)
Inner join online_customer oc
Using(customer_id)
Inner join address a
Using (address_id)
Where order_id % 2 = 0 and pincode not like '5%' and order_status='shipped'
Group by order_id;


 
