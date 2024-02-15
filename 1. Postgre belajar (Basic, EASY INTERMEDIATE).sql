-- BASIC

-- Queri untuk melihat tabel yang ada pada database
select * from pg_tables where schemaname = 'public';

drop table barang;

create table barang (
	kode int not null,
	name varchar(100) not null,
	harga int not null default 1000,
	jumlah int not null default 0,
	waktu_dibuat TIMESTAMP not null default current_timestamp
);

select * from barang;

INSERT INTO barang (kode, name, harga, jumlah)
VALUES (1, 'makan', 1000, 1);

truncate table barang;

drop table barang;

create table products(
	id varchar(10) not null,
	name varchar(100) not null,
	description text,
	price int not null,
	quantity int not null default 0,
	created_at timestamp not null default current_timestamp
);

select * from products;

insert into products (id, name, price, quantity)
values('P0001', 'Mie Ayam', 10000, 5);

insert into products (id, name, description, price, quantity) values
('P0002', 'Mie Ayam Bakso Tahu', 'Mie Ayam Original + Bakso Tahu', 15000, 5);

insert into products (id, name, description, price, quantity) values
('P0003', 'Bakso Tahu', 'Bakso + Tahu', 7000, 5),
('P0004', 'Tahu', Null, 2000, 5);

alter table products
	add primary key (id);

select id, name, price from products
where id = 'P0001';

create type PRODUCT_CATEGORY as enum ('makanan', 'minuman', 'lain-lain');

alter table products
	add column category PRODUCT_CATEGORY;
	
update products set category = 'makanan'
where id = 'P0001';

update products set
	category = 'makanan',
	description = 'Bakso Gehu'
where id = 'P0003';

update products set
	price = price + 500
where id = 'P0004';

update products set 
	category = 'makanan'
where id = 'P0002';

insert into products (id, name, description, price, quantity) values
('P0005', 'Delete', 'Delete', 0, 0);

delete from products where id = 'P0005';

select id as kode, name as "nama makanan", price as harga from products order by price DESC;
select id as kode, name as "nama makanan", price as harga from products order by price ASC;

select * from products where price <> 7000;
select * from products where price != 7000;

select * from products where price > 5000 and category = 'makanan';
select * from products where price = 5000 or id = 'P0003';

insert into products (id,name, price, quantity, category) values
('P0005', 'pocari', 7000, 9, 'minuman'),
('P0006', 'kelapa', 10000, 3, 'minuman');
select * from products order by id;

select * from products where price > 5000 and category = 'minuman';
select * from products where price > 8000 or category = 'minuman';

select * from products where (quantity > 5 or category = 'makanan') and price = 10000;

select * from products where name like '%a%';

select * from products where description is null;
select * from products where description is not null;

select * from products where price between 8000 and 15000;
select * from products where quantity  between 6 and 10;

select * from products where category in ('makanan','minuman');
select * from products where category not in ('minuman');

select * from products 
where price > 0 
order by price asc;

select * from products 
where price > 0 
order by price asc 
limit 2;

select * from products 
where price > 0 
order by price asc 
limit 2 offset 2;

select category from products;
select distinct category from products;

select 10 + 10 as hasil;

select id, price/1000 as "price in k" from products;

select id, name, power(price, 2) as "price pangkat 2" from products;

create table admin
(
	id serial not null,
	first_name varchar(100) not null,
	last_name varchar(100),
	primary key (id)
);

insert into admin (first_name, last_name) values
('satrio', 'mukti'),
('xsat' , null);

select * from admin;

select currval(pg_get_serial_sequence('admin', 'id'));
select currval('admin_id_seq');

create sequence contoh_sequence;

select nextval('contoh_sequence');
select currval('contoh_sequence');

select id, lower(name), length(name), lower(description) from products;

select id, extract(year from created_at), extract(second from created_at) from products;

select id,
	case category
		when 'makanan' then 'enak'
		when 'minuman' then 'seger'
		else '?????'
	end as category
from products;

select id, price,
	case
		when price <= 7000 then 'murah'
		when price <= 12000 then 'mahal'
		else 'mahal bet'
	end as cat_harga
from products;

select id, name,
	case
		when description is null then 'kosong'
		else description 
	end as description
from products;

select id, name, description from products;

select count(id) from products;
select max(price) from products;
select min(price) from products;
select avg(price) from products;

select category,
	max(price) as "termahal", 
	min(price) as "termurah",
	avg(price) as "rata-rata" from products 
group by category;

select category, count(id) as total from products
group by category having count(id)>2; 

select category,
	max(price) as "termahal", 
	min(price) as "termurah",
	avg(price) as "rata-rata" from products pr
group by category having max(pr.price) > 6000;

create table customer
(
	id serial not null,
	email varchar(100) not null,
	first_name varchar(100) not null,
	last_name varchar(100),
	primary key  (id),
	constraint unique_email unique (email)
);

insert into customer(email, first_name, last_name) values
('satrio@mail.com', 'satrio', null);

select * from customer;

insert into customer(email, first_name, last_name) values
('satrio@mail.com', 'mukti', null);
insert into customer(email, first_name, last_name) values
('mukti@mail.com', 'satrio', null);

delete from customer where id IN (4,5);

DELETE FROM customer
WHERE id NOT IN (
    SELECT MIN(id)
    FROM customer
    GROUP BY email
);

alter table customer 
	drop constraint unique_email;

alter table customer
	add constraint unique_email unique (email);
 
alter table products 
	add constraint price_check check (price > 1000);

alter table products 
	add constraint quantity_check check (quantity >= 0);
	
select * from products;

insert into products (id, name, price, quantity, category) values
('XXX1', 'tea jus', 1500, 0, 'minuman');

insert into products (id, name, price, quantity, category) values
('XXX2', 'tea gula', 1500, -1, 'minuman');

create table seller
(
	id serial not null,
	name varchar(100) not null,
	email varchar(100) not null,
	primary key (id),
	constraint email_unique unique (email)
);

select * from seller;

insert into seller(name , email) values
('Galeri Olahraga', 'galeri@email.com'),
('Toko tono', 'tono@email.com'),
('Toko budi', 'budi@email.com'),
('Toko ruly', 'ruly@email.com');

select * from seller where id = 1;
select * from seller where email = 'ruly@email.com';

select * from seller where id = 1 or email = 'ruly@email.com'; --No index Lama

--kombinasi index id dan nama agar pencarian lebih cepat
create index seller_id_and_name_index on seller(id,name); 
--kombinasi index email dan nama agar pencarian lebih cepat
create index seller_email_and_name_index on seller(email,name);
--index nama agar pencarian lebih cepat
create index seller_name_index on seller(name);

select * from products p where name like '%Mie%';

select * from products p
	where to_tsvector(name) @@ to_tsquery('ayam');

select cfgname from pg_ts_config where cfgname = 'indonesian';

-- indexing lebih cepat dari like \ alternatif dari like
create index products_name_search on products using gin (to_tsvector('indonesian',name));
create index products_description_search on products using gin (to_tsvector('indonesian',description));

select * from products
	where name @@ to_tsquery('mie');
	
select * from products
	where name @@ to_tsquery('mie | tahu');
	
select * from products
	where name @@ to_tsquery('mie & tahu');
	
select * from products
	where name @@ to_tsquery('''ayam bakso''');
	
select * from products
	where name @@ to_tsquery('!bakso'); 

--Relation Table

create table wishlist
(
	id SERIAL not null,
	id_product varchar(10) not null,
	description text,
	primary key (id),
	constraint fk_wishllist_product foreign key (id_product) references products(id)
);

alter table wishlist
	drop constraint fk_wishllist_product;
	
alter table wishlist
 	add constraint fk_wishlist_product foreign key (id_product) references products(id);
 	
 insert into wishlist (id_product, description) values
 ('P0001', 'Mie ayam loved');
 
select * from wishlist;

select * from wishlist w join products p 
on p.id = w.id_product;

select p.id, p.name, w.description from wishlist w 
join products p on p.id = w.id_product;

alter table wishlist 
	add column id_customer int;
	
select * from wishlist w ;

alter table wishlist 
	add constraint fk_wishlist_customer foreign key (id_customer) references customer (id);
	
update wishlist 
set id_customer = 1
where id in (3);

SELECT c.first_name ||' '|| c.last_name as "name", c.email, p.id, p.name, w.description from wishlist w 
	join products p on p.id = w.id_product
	join customer c on c.id = w.id_customer;
	
update customer 
set last_name = 'mukti'
where id = 1;

-- set one to one table
create table wallet
(
	id serial not null,
	id_customer int not null,
	balance int not null default 0,
	primary key (id),
	constraint wallet_customer_unique unique (id_customer),
	constraint fk_wallet_customer foreign key (id_customer) references customer(id)
);

select * from customer c ;

insert into wallet (id_customer, balance) values
(3, 1000),
(1, 1000);

select * from wallet;

update wallet 
set balance = 2000
where id = 1;

select * from customer c
	join wallet w on c.id = w.id_customer;
	
-- set one to many table
create table categories
(
	id varchar(10) not null,
	name varchar(100) not null,
	primary key (id)
);

select * from categories;

insert into categories(id, name) values
('C0001', 'makanan'), ('C0002', 'minuman')

drop table category ;

alter table products
	drop column category;

alter table products 
	add column id_categories varchar(10);

alter table products 
	add constraint fk_product_category foreign key (id_categories) references categories(id);

select * from products p order by id;

update products 
set id_categories = 'C0001'
where id in ('P0002','P0003');

update products 
set id_categories = 'C0002'
where id in ('P0005','P0006','XXX1');

select p.id, p.name, c.name from products p 
	join categories c on p.id_categories = c.id;

-- many to many table

create table orders
(
	id serial not null,
	total int not null,
	order_date timestamp not null default current_timestamp,
	primary key (id)
);

select * from orders;

create table orders_detail
(
	id_product varchar(10) not null,
	id_order int not null,
	price int not null,
	quantity int not null,
	primary key (id_product, id_order)
);

select * from orders_detail;

alter table orders_detail
	add constraint fk_orders_detail_product foreign key (id_product) references products(id),
	add constraint fk_orders_detail_order foreign key (id_order) references orders(id);

select * from orders ;

select * from orders_detail order by id_order;

insert into orders (total) values
(1),(1),(1);
select * from orders ;

select * from products p order by id;

insert into orders_detail (id_product, id_order, price, quantity) values
('P0001', 1, 1000, 2),
('P0002', 1, 1000, 2),
('P0003', 1, 1000, 2);
insert into orders_detail (id_product, id_order, price, quantity) values
('P0002', 2, 1000, 2),
('P0003', 2, 1000, 2),
('P0004', 2, 1000, 2);

select * from orders_detail;

select * from orders o
	join orders_detail od on od.id_order = o.id
	join products p on od.id_product = p.id
where o.id = 1;

-- inner join

insert into categories (id, name) values
('C0003', 'laptop'),
('C0004', 'gadget'),
('C0005', 'pulsa');

select * from categories ;

select * from products p ;
insert into products (id, name, price, quantity) values
('P0007', 'contoh1', 10000, 10),
('P0008', 'contoh2', 10000, 10),
('P0009', 'contoh3', 10000, 10);

select * from categories c
	inner join products p on p.id_categories = c.id;
	
-- left join
select * from categories c
	left join products p on p.id_categories = c.id;
	
-- right join
select * from categories c
	right join products p on p.id_categories = c.id;
	
-- full join
select * from categories c
	full join products p on p.id_categories = c.id;

-- subqueries
select * from products;
select avg(price) as "rata-rata" from products;
select * from products p 
	where price > (select avg(price) from products);
	
select p.price from products p 
	join categories c on c.id = p.id_categories;
select max(price) from (select p.price from products p 
	join categories c on c.id = p.id_categories) as "max";
	
-- set operator
-- UNION
create table guestbook
(
	id serial not null,
	email varchar(100) not null,
	title varchar(100) not null,
	content text,
	primary key (id)
);

select * from guestbook ;
-- \dt guestbook

select * from customer;

insert into guestbook(email, title, content) values
('mukti@mail.com', 'feedback mukti', 'feedback mukti'),
('mukti@mail.com', 'feedback mukti', 'feedback mukti'),
('satrio@mail.com', 'feedback satrio', 'feedback satrio'),
('satrio@mail.com', 'feedback satrio', 'feedback satrio'),
('prayoga@mail.com', 'feedback prayoga', 'feedback prayoga'),
('eko@mail.com', 'feedback eko', 'feedback eko');

select * from guestbook ;

select distinct email from customer c 
union
select distinct email from guestbook ;

-- UNION ALL
select distinct email from customer c 
union all
select distinct email from guestbook ;

-- INTERSECT
select distinct email from customer c 
intersect
select distinct email from guestbook ;

-- EXCEPT
select distinct email from guestbook  
except
select distinct email from customer c  ;

-- Operator set with subquery
select email, count(email) from (
	select email from customer
	union all
	select email from guestbook 
) as jumlah 
group by email;

-- Perintah DDL (Data Definition Language) tidak bisa menggunakan fitur transaction

start transaction;

insert into guestbook(email, title, content) values
('transaction@mail.com', 'transaction', 'transaction1');
insert into guestbook(email, title, content) values
('transaction@mail.com', 'transaction', 'transaction2');
insert into guestbook(email, title, content) values
('transaction@mail.com', 'transaction', 'transaction3');
insert into guestbook(email, title, content) values
('transaction@mail.com', 'transaction', 'transaction4');

commit;

select * from guestbook ;

start transaction;

insert into guestbook(email, title, content) values
('transaction@mail.com', 'rolback', 'rollback1');
insert into guestbook(email, title, content) values
('transaction@mail.com', 'rolback', 'rollback2');
insert into guestbook(email, title, content) values
('transaction@mail.com', 'rolback', 'rollback3');
insert into guestbook(email, title, content) values
('transaction@mail.com', 'rolback', 'rollback4');

select * from guestbook ;

rollback;

select * from guestbook ;

-- schema
-- melihat schema yang sedang dipilih
select current_schema();
show search_path;

create schema contoh;

drop schema contoh;

set search_path to contoh;
select current_schema();

set search_path to public;
select current_schema();

create table contoh.products
(
	id serial not null,
	name varchar(100) not null,
	primary key(id)
);

insert into contoh.products(name) values
('bakso'),
('sate'),
('naspad');

select * from products;
select * from contoh.products;

-- role
create role kasir;
alter role kasir login password 'rahasia';

grant insert, select on all tables in schema public to kasir;
-- psql --host=localhost --port=5432 --dbname=belajar --username=kasir --password

-- login klien postgre(dbeaver/psql) ke role "kasir"
select * from public.products;

-- denied
select * from contoh.products;

-- login klien postgre(dbeaver/psql) ke role "postgres"/root admin
REVOKE INSERT, SELECT ON ALL TABLES IN SCHEMA public FROM kasir;
 
drop role kasir;

-- backup database
-- pg_dump --host=localhost --port=5432 --dbname=belajar --username=postgres --format=plain --file=C:/Users/user/Downloads/backup.sql

-- database restore
create database belajar_restore;
-- psql --host=localhost --port=5432 --dbname=belajar_restore --username=postgres --file=C:/Users/user/Downloads/backup.sql
