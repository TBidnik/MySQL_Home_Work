drop database if exists terem; 
create database terem; 
use terem; 
   

drop table if exists catalogs; 
create table catalogs (
	id bigint unsigned not null auto_increment, 
    name varchar(100) comment 'Название раздела', 
    unique unique_name(name(10)),
    primary key(id)	
    ) comment  = 'Названия категорий'; 

drop table if exists products; 
create table products (
	id bigint unsigned not null auto_increment, 
    name varchar(100) comment 'Название',
    discription text comment 'Описание', 
    price decimal (11, 2) comment 'Цена', 
    photo_id bigint unsigned,
    sizes varchar(255) comment 'Размеры',
    square decimal (11, 2) comment 'Общая площадь', 
    catalog_id bigint unsigned not null, 
    created_at datetime default current_timestamp, 
    updated_at datetime default current_timestamp on update current_timestamp, 
    primary key(id),
    unique key id(id), 
    key catalog_id (catalog_id), 
    constraint products_ibfk_1 foreign key(catalog_id) references catalogs(id)
    ) comment = 'Позиции'; 
    
    drop table if exists photos;
	create table photos (
    id bigint unsigned not null auto_increment, 
	product_id bigint unsigned not null,
    catalog_id bigint unsigned not null,
	description text,
	filename varchar(250) default null,
    primary key(id),
    unique key id(id),
    key product_id(product_id),
    key catalog_id(catalog_id), 
	constraint photos_ibfk_1 foreign key(product_id) references products(id),
    constraint photos_ibfk_2 foreign key(catalog_id) references catalogs(id)
) comment = 'Фото проектов'  ; 
    
  drop table if exists sizes; 
   create table sizes (
		id bigint unsigned not null auto_increment,
        sizes varchar(255) comment 'Размеры',
		catalog_id bigint unsigned not null,
		product_id bigint unsigned not null,
        primary key(id),
		unique key id(id),
		key catalog_id(catalog_id),
		key product_id(product_id),
        constraint sizes_ibfk_1 foreign key(product_id) references products(id),
		constraint sizes_ibfk_2 foreign key(catalog_id) references catalogs(id)
         ) comment = 'Размеры'; 
         
drop table if exists squares; 
   create table squares (
		id bigint unsigned not null auto_increment,
        squares decimal (11, 2) comment 'Общая площадь',
		catalog_id bigint unsigned not null,
		product_id bigint unsigned not null,
        primary key(id),
		unique key id(id),
		key catalog_id(catalog_id),
		key product_id(product_id),
        constraint squares_ibfk_1 foreign key(product_id) references products(id),
		constraint squares_ibfk_2 foreign key(catalog_id) references catalogs(id)
         ) comment = 'Площадь'; 
         
         
drop table if exists prices; 
   create table prices (
		id bigint unsigned not null auto_increment,
		price decimal (11, 2) comment 'Цена',
        size_id bigint unsigned not null,
		square_id bigint unsigned not null,      
        catalog_id bigint unsigned not null,
        product_id bigint unsigned not null, 
        primary key(id),
		unique key id(id),
		key catalog_id (catalog_id),
		key product_id (product_id),
        key size_id (size_id),
        key square_id (square_id),
        constraint prices_ibfk_1 foreign key(product_id) references products(id),
		constraint prices_ibfk_2 foreign key(catalog_id) references catalogs(id),
        constraint prices_ibfk_3 foreign key(size_id) references sizes(id),
		constraint prices_ibfk_4 foreign key(square_id) references squares(id)
        ) comment = 'Прайс'; 

	drop table if exists services; 
	create table services (
	    id bigint unsigned not null auto_increment,
		name varchar(100) comment 'Название',
		discription text comment 'Описание',
        unique unique_name(name(10)),
        primary key(id),
		unique key id(id)
        ) comment = 'Наименование услуг';  
        
	drop table if exists users; 
	create table users (
	id bigint unsigned not null auto_increment, 
	name varchar(50) default null, 
	surname varchar(50) default null, 
	email varchar(100) default null,
	phone bigint default null, 
	gender char(1) default null,
	birthday date default null,
	hometown varchar(150) default null,
    created_at datetime default current_timestamp,
    primary key (id),
	unique key id (id),
    unique key email (email),
	key phone (phone),
	key name (name, surname)	
   ) comment = 'Покупатели';
   
drop table if exists requests; 
  create table requests (
  id bigint unsigned not null auto_increment, 
  user_id bigint unsigned not null, 
  product_id bigint unsigned, 
  service_id bigint unsigned, 
  price_id bigint unsigned, 
  status enum('development', 'rejection', 'in the order') default 'development', 
  development_at datetime default now(),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp on update  current_timestamp,
  primary key (id),
  unique key id (id),
  key user_id(user_id),
  key product_id(product_id), 
  key setvice_id(service_id), 
  key price_id(price_id),
  constraint requests_ibfk_1 foreign key(user_id) references users(id),
  constraint requests_ibfk_2 foreign key(product_id) references products(id),
  constraint requests_ibfk_3 foreign key(service_id) references services(id),
  constraint requests_ibfk_4 foreign key(price_id) references prices(id)
 ) comment = 'Заявки';  
	
        
drop table if exists orders; 
  create table orders (
  id bigint unsigned not null auto_increment,
  user_id bigint unsigned not null,
  product_id bigint unsigned not null,
  request_id bigint unsigned not null,
  price_id bigint unsigned not null, 
  status enum('development', 'montage', 'realised') default 'development',
  development_at datetime default now(),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp on update  current_timestamp,
  primary key (id),
  unique key id (id),
  key user_id(user_id),
  key product_id(product_id),
  key request_id(request_id),
  key price_id(price_id),
  constraint orders_ibfk_1 foreign key(user_id) references users(id),
  constraint orders_ibfk_2 foreign key(product_id) references products(id),
  constraint orders_ibfk_3 foreign key(request_id) references requests(id),
  constraint orders_ibfk_4 foreign key(price_id) references prices(id)
 ) comment = 'Заказы';  
    
drop table if exists discounts; 
	create table discounts (
	id bigint unsigned not null auto_increment,		
	product_id bigint unsigned not null,
	discount bigint unsigned not null,
	started_at datetime,
	finished_at datetime,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,		
	primary key (id),
    unique key id (id), 
    key product_id(product_id), 
    constraint discounts_ibfk_1 foreign key(product_id) references products(id)
) comment = 'Скидки';
    
drop table if exists comments; 
	create table comments (
    id bigint unsigned not null auto_increment,
	user_id bigint unsigned not null,
	product_id bigint unsigned not null, 
	body text,
	created_at datetime default current_timestamp, 
	updated_at datetime default current_timestamp on update current_timestamp, 
    primary key(id),
    unique key(id),
	key user_id(user_id),
	key product_id(product_id), 
    constraint comments_ibfk_1 foreign key (user_id) references users(id), 
    constraint comments_ibfk_2 foreign key (product_id) references products(id)
) comment = 'Отзывы покупателей' ;     
   

