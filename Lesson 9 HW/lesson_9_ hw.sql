
-- Задание №1
-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из 
-- таблицы shop.users в таблицу sample.users. Используйте транзакции.
use sample; 
select * from users; 
start transaction; 
insert into sample.users select * from shop.users where id = 1; 
commit; 
select * from users; 

-- Задание №2
-- Создайте представление, которое выводит название name товарной позиции из таблицы products и 
-- соответствующее название каталога name из таблицы catalogs.
use shop; 
create or replace view total_name(prod_name, cat_name)  as
select p.name, cat.name 
from products as p
left join catalogs as cat
on p.catalog_id = cat.id;
select * from total_name;  

-- Задание №3
-- Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи 
-- за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1,
 -- если дата присутствует в исходном таблице и 0, если она отсутствует.

drop database if exists dateb; 
create database dateb; 
use dateb; 

drop table if exists created_base; 
create table created_base (
	created_at date
    ); 

insert into created_base values 
('2018-08-01'), ('2018-08-04'), ('2018-08-16'), ('2018-08-17'); 

select * from created_base order by created_at; 

use dateb; 

select 
	time_period.selected_date as day,
	(select exists(select * from created_base where created_at = day)) as has_already
from 
	(select v.* from 
		(select adddate('1970-01-01', t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) selected_date from 
			(select 0 i union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0, 
			(select 0 i union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
            (select 0 i union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
            (select 0 i union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
            (select 0 i union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) as v
		where selected_date between '2018-08-01' and '2018-08-31') as time_period; 
        
-- Хотел еще вот так
-- drop database if exists dateb; 
-- select date(adddate('2018-08-15', interval @i := @i+1 day)) as date from created_base having @i < datediff('2018-08-04', '2018-08-16'); 
-- Но не получилось


-- Хранимые процедуры и фунциии, триггеры. 

-- Задание №1 
 -- Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
--  с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 -- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
 
 drop procedure if exists hello; 
delimiter //
create procedure hello ()
begin 
	if(curtime() between '06:00:00' and '12:00:00') then
		select 'Доброе утро';
	elseif(curtime() between '12:00:00' and '18:00:00') then 
		select 'Добрый день'; 
	elseif(curtime() between '18:00:00' and '00:00:00') then 
		select 'Добрый вечер'; 
	else
		select 'Доброй ночи'; 
	end if; 
end //
delimiter ; 
call hello(); 


-- Задание №2 
-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
 -- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают 
 -- неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно 
 -- из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
 
drop trigger if exists nullTrigger;
delimiter //
create trigger nullTrigger before insert on products
for each row
begin
	if(isnull(new.name)) then
		set new.name = 'NoName';
	end if;
	if(isnull(new.description)) then
		set new.description = 'No Desc';
	end if;
end //
delimiter ;

insert into products (name, description, price, catalog_id)
values (null, null, 5000, 25);

