


drop function sum_price_realised;
delimiter //
create function sum_price_realised()
returns int reads sql data
begin
	declare res INT;
	select (select price from prices where id = price_id) into res from orders
    where status = 'realised'
		;
	return sum(res);
end//

delimiter ;

select sum_price_realised(); 

delimiter //
create function discount_product(u_id INT, check_discount_id INT)
returns int reads sql data
begin
	declare res INT;
	select count(*) into res from orders
	where 
		(product_id = u_id and discount = check_discount_id) 
		;
	return res;
end//

delimiter ;