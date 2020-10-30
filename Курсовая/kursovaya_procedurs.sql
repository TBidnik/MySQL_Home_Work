
-- Общий город с выбранным пользователем 

delimiter //

create procedure users_hometown(in for_user_id int )
begin
	
	select u2.id
	from users u1
	join users u2
		on u1.hometown = u2.hometown
	where u1.id = for_user_id
	and u2.id <> for_user_id;

end//

delimiter ;
set @user_id = 1;
call users_hometown(@user_id); 



-- Скидка на конкретный товар
drop procedure if exists product_discount; 
delimiter //
create procedure product_discount(in for_product_id int )
begin
	
	select o.product_id
	from orders o
	join discounts d
		on o.product_id = d.product_id
	where o.id = for_product_id
	and o.created_at between d.started_at and d.finished_at;

end//

delimiter ;
set @product_id = 1;
call product_discount(@product_id); 