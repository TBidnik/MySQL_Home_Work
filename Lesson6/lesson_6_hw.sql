# Задание №2
# Пусть задан некоторый пользователь. 
# Из всех друзей этого пользователя найдите человека, который больше всех общался
# с нашим пользователем.

select name, surname
	(select  user_id from (
	(select to_user_id as user_id, COUNT(*) as message_total from messages where from_user_id != 0 group by to_user_id)
	union all
	(select from_user_id as user_id, COUNT(*) as message_total from messages where to_user_id != 0 group by from_user_id)
	) as my_tmp_table
	where user_id in
	(select target_user_id from friend_requests where initiator_user_id = u.id and status = 'approved'
	 union
	 select initiator_user_id from friend_requests where target_user_id = u.id and status =  'approved') as fr_tbl) 'friends'
	group by user_id
	order by sum(message_total) desc
	limit 1
from user u 
where id = 1;



#Задание №3 
#Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT count(*) as total_likes FROM likes_posts as m WHERE id IN (
	SELECT id FROM likes_posts 	WHERE user_id IN (
		SELECT * FROM (
			SELECT user_id FROM users ORDER by birthday DESC LIMIT 10) as user_id));

# Задание №3 Пытаюсь выводить список пользователей с кол - ом лайков по каждому. Не получается. Не знаю почему

select id, name, surname,
(select count(*) as total_likes from likes_posts as p where id IN (
	select id from likes_posts 	where user_id in(
	(select count(*) from 
		likes_posts where likepage = user_id )))) 'likes',
	
timestampdiff (year, birthday, now()) as 'age'
from users order by birthday desc limit 10;

#Задание №4

select gender from (
	select "Mужчины" as gender, COUNT(*) as total from likes_posts where user_id in (select user_id from users as p where gender='m')
	union
	select "Женщины" as gender, COUNT(*) as total from likes_posts where user_id in (select user_id from users as p where gender='f')
) as my_sort
order by total desc
limit 1; 

# Задание № 5
# Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

select id, 
sum(activ) as total_activ from (	

	select * from (
		(select id,0 as activ from users where id not in (select user_id from photos group by user_id))
			union 
		(select user_id as id, COUNT(*) as activ from photos  group by user_id)
	) as total_photos 
	union all
	select * from (
		(select id,0 as activ from users where id not in (select from_user_id from messages group by from_user_id))
			union 
		(select from_user_id as id, COUNT(*) as activ from messages group by from_user_id)
	) as total_messages
	union all
	select * from (      
		(select id,0 as activ from users where id not in (select user_id from posts group by user_id))
			union 
		(select user_id as id, COUNT(*) as activ from posts group by user_id)
	) as total_posts
	union all 
	select * from (        
		(select id,0 as activ from users where id not in (select user_id from likes_posts group by user_id))
			union 
		(select user_id as id, COUNT(*) as activ from likes_posts group by user_id)
	) as total_likes
    
        
) as total_table
group by id
order by total_activ
limit 10; 