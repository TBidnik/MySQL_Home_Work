
-- Минимальная и максимальная цена в прайсе 
-- 1-й способ
select min(price) as min_price, max(price) as max_price
from prices; 
-- 2-й способ
select id, name, price from products order by price  limit 1;
select id, name, price from products order by  price desc limit  1;

-- Средняя цена прайса по каждому подразделу каталога 
select
  catalog_id,
  round(AVG(price), 2) as price
from
  products
group by
  catalog_id;

--  Возраст покупателей в таблице users
select * from terem.users;
select id, name, surname, timestampdiff(Year, birthday, NOW()) as age from users; 

-- Кто больше делают заказы мужчины или женщины? 

select gender from (
	select "Mужчины" as gender, COUNT(*) as total from orders where user_id in (select user_id from users as p where gender='m')
	union
	select "Женщины" as gender, COUNT(*) as total from orders where user_id in (select user_id from users as p where gender='f')
) as my_sort
order by total desc
limit 1; 

-- сСписок 10 самых молодых покупателей, сделавших заказ 

select 
	u.id,
	u.name, 
	u.surname,
	timestampdiff(year, u.birthday, now()) as 'age',
	count(*) as total_orders
from users u
join orders o 
	on u.id = o.user_id
group by u.id
order by age asc, total_orders desc
limit 10;
            
-- список пользователей users, которые осуществили хотя бы один заказ             
            
select id, name, surname  from users as u
where exists(select 1 from orders where user_id = u.id);

-- список товаров products и разделов catalogs,  которым соответствует товар
select  p.name as product_name,
        c.name as catalog_name
from products p
join catalogs c on c.id = p.catalog_id;

-- Вывод значений как на странице "Прайс" сайта 

select
    (select name from catalogs where id = catalog_id) as catalog, 
    name,  price,  sizes, square
from
  products
group by
    catalog, name,  price,  sizes, square;
    
-- Вывод списка покупателей, сделавших заказ, находящийся в статусе:

-- 1. 'montage'

select
id, 
	(select concat(name, ' ' , surname) from users where id = user_id) as Users,
    (select gender from users where id = user_id) as Gender,
    (select timestampdiff(year, birthday, now()) as 'age' from users where id = user_id) as Age,
	(select name from products where id = product_id) as Product,
	(select price from prices where id = price_id) as Price
from orders where status = 'montage'
group by Users;


-- 'realised'	
select
id, 
	(select concat(name, ' ' , surname) from users where id = user_id) as Users,
    (select gender from users where id = user_id) as Gender,
    (select timestampdiff(year, birthday, now()) as 'age' from users where id = user_id) as Age,
	(select name from products where id = product_id) as Product,
	(select price from prices where id = price_id) as Price
from orders where status = 'realised'
group by Users;	

-- Список заявок в статусе отмененных 

select
id, 
	(select concat(name, ' ' , surname) from users where id = user_id) as Users,
    (select gender from users where id = user_id) as Gender,
    (select timestampdiff(year, birthday, now()) as 'age' from users where id = user_id) as Age,
	(select name from products where id = product_id) as Product,
    (select name from services where id = service_id) as Service, 
	(select price from prices where id = price_id) as Price
from requests where status = 'rejection'
group by Users;	

-- Скидки
select O.id, O.product_id,
	O.price_id-(O.price_id/100*coalesce(D.discount, 0))
from orders O
left join 
	(select product_id, D.started_at) as d_str
		from (select product_id, count(1) as str from oders
        group by product_id) as P, 
        discount as D
        where D.srarted_at<str
        group by product_id) as S
	on S.prodict_id = O.product_id
left join discount as D
 on D.started_at = S.d_str