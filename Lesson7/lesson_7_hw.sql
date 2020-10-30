
# Задание № 1 
# Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

select name from users as u
where exists(select 1 from orders where user_id = u.id);


# Задание №2
# Выведите список товаров products и разделов catalogs, который соответствует товару.

select  p.name as product_name,
        c.name as catalog_name
from products p
join catalogs c on c.id = p.catalog_id;

# Задание № 3 
# Пусть имеется таблица рейсов flights (id, from, to) и таблица городов 
# cities (label, name). Поля from, to и label содержат английские названия городов,
# поле name — русское. Выведите список рейсов flights с русскими названиями городов.

drop database if exists flights; 
create database flights; 
use flights; 

create table cities (
	label varchar(100) primary key, 
    name varchar(100) not null);
insert into cities (label, name) value
('Moscow', 'Москва'), ('Irkutsk', 'Иркутск'), ('Novgorod', 'Новгород'), 
('Kazan', 'Казань'), ('Omsk', 'Омск');

create table flights(
	id serial primary key,
	`from` varchar(100) not null, 
    `to` varchar(100) not null); 

alter table flights
add constraint fk_from
foreign key (`from`)
references cities (label)
on delete cascade
on update cascade; 

alter table flights
add constraint fk_to
foreign key (`to`)
references cities (label)
on delete cascade
on update cascade; 

insert into flights (`from`, `to`) value
('Moscow', 'Omsk'), ('Novgorod', 'Kazan'), 
('Irkutsk', 'Moscow'), ('Omsk', 'Irkutsk'), 
('Moscow', 'Kazan');

select c.name as `from`, c1.name as `to`
from flights f 
join cities c on c.label = f.`from`
join cities c1 on c1.label = f.`to`
order by f.id


