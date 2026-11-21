WITH cus_report AS ( SELECT c.customer_id, c.customer_name, 
COUNT( DISTINCT o.order_id) total_order, 
MIN(o.order_date) first_order, MAX( o.order_date) last_order 
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.customer_name),
order_report AS ( SELECT o.customer_id, 
SUM (od.quantity) total_items, SUM ( od.quantity * p.price) total_revenue 
FROM orders o JOIN order_detail od ON o.order_id = od.order_id 
JOIN products p ON od.product_id = p.product_id GROUP BY o.customer_id)
SELECT cr.customer_id, cr.customer_name, 
COALESCE( orr.total_items, 0) total_items, 
COALESCE (orr.total_revenue,0) total_revenue,
ROUND(COALESCE ( orr.total_revenue, 0) / NULLIF ( cr.total_order,0),2) average_order_value, 
cr.first_order, cr.last_order FROM cus_report cr 
LEFT JOIN order_report orr ON cr.customer_id = orr.customer_id 
ORDER BY COALESCE (orr.total_revenue,0) DESC;
 