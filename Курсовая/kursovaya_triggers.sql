



-- Добавление в таблицу заказов новый заказ после получения новой заявки в статусе "Заказ"

drop trigger if exists requests_from_order; 

delimiter //

create trigger requests_from_order after insert on requests
for each row
begin
	insert into orders (user_id, product_id, request_id, price_id, status)
	values (new.user_id, new.product_id, new.price_id, new.status = 'in the order' );
end//

delimiter ;