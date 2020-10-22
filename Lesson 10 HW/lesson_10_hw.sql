-- Задание №1
-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, 
-- идентификатор первичного ключа и содержимое поля name.

use shop;

drop table if exists logs; 
create table logs (	 
    name_tbl varchar(45) comment 'Название таблицы', 
    created_at datetime not null,
    key_id bigint(20) not null comment'Первичный ключ',
    name_value varchar(45) comment 'Поле name'
) comment 'Архив данныйх' engine=ARCHIVE; 

drop trigger if exists tbl_users; 
delimiter // 
create trigger tbl_users after insert on users
for each row
begin 
	insert into logs (name_tbl, created_at, key_id, name_value)
    values ('users', now(), new.id, new.name); 
end // 
delimiter ; 

drop trigger if exists tbl_catalogs; 
delimiter // 
create trigger tbl_catalogs after insert on catalogs
for each row
begin 
	insert into logs (name_tbl, created_at, key_id, name_value)
    values ('catalogs', now(),  new.id, new.name); 
end // 
delimiter ; 

drop trigger if exists tbl_products; 
delimiter // 
create trigger tbl_products after insert on products
for each row
begin 
	insert into logs (name_tbl, created_at, key_id, name_value)
    values ('products', now(),  new.id, new.name); 
end // 
delimiter ; 

select * from shop.users; 
insert into users (name, birthday_at) values
 ('Наталия', '1986-01-29');
select * from shop.users;

select * from shop.catalogs; 
insert into catalogs values
(null, 'Звуковые карты'); 
select * from shop.catalogs;


select * from shop.products; 
insert into products (name, description, price, catalog_id) values
('Creative AE-7', 'PCI-E; EAX нет; ASIO v. 2.3 ; ЦАП / АЦП - 32 бит / 32 бит ; Пульт ДУ - есть; S / PDIF - оптический в...', '19970', '6');
select * from shop.products; 

select * from shop.logs; 

-- Задание 
-- В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

SADD ip 162.168.0.12 162.168.0.18 162.168.0.22 162.168.0.36 
SMEMBERS ip
SCARD ip 

-- Задание
-- При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот,
-- поиск электронного адреса пользователя по его имени.

set anonimus@gmail.com anonim 
set anonim anonimus@gmail.com

get anonimus@gmail.com
get anonim 

-- Задание 
-- Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB

mongo 
use shop 
db.shop.insert({catalogs: ['Процессоры', 'Материнские платы', 'Видео карты', 'Жесткие диски', 'Оперативная память', 'Звуковые карты']})
db.shop.insert({catalogs: 'Процессоры'}, {$snet : {name: ['', '', '', '']}, {description: ['', '', '', '']}, {price: ['', '', '', '']}})
db.shop.insert({catalogs: 'Материнские платы'}, {$snet : {name: ['', '', '']}, {description: '', '', ''}, {price: '', '', ''}})
-- Все значения не вставлял, чтобы лучше читалось