
use terem; 
-- Представление страницы "Прайсы" 

create or replace view price_view(cat_name, prod_name, sizes_num, squers_num, prices_num)  as
select 
(select name from catalogs where id = catalog_id) as Catalog,
name, 
sizes, 
square, 
price
from products; 

-- Топ 3 товара, реализованных в заказах 

create or replace view products_view(Product_name) as
select 
(select name from products where id = product_id) as Products
from orders where status = 'realised' 
group by Products
order by count(*) desc
limit 3 ;

-- Лучший товар по результатам отзывов 

create or replace view comments_prod(Product_name) as 
select 
(select name from products where id = product_id) as Products
from comments 
group by Products
order by count(*) desc
limit 1 ;

-- Поиск покупателя, сделавшего заказ, который получит скидку

create or replace view discount_view(disc_user, disc_product, disc_date_order, disc_from_product, disc_price, disc_discount, disc_start, 
disc_finish, disc_status ) as
select
(select name from users where id = user_id) as 'User' , 
orders.product_id  as 'Product', 
orders.created_at as 'Date Order',
discounts.product_id as 'From Product',
(select price from prices where id = price_id) as 'Price',
discounts.discount as 'Discount', 
discounts.started_at 'Start',
discounts.finished_at 'Finish',
orders.status as 'Status'

from discounts , 
 orders where discounts.product_id = orders.product_id and  orders.created_at between started_at and finished_at
 and status = 'realised'
 group by User;
