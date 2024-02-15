-- ADVANCED
-- HARD/EXPERT

-- Gunakan db belajar2.sql
-- database belajar2

Create table  Trips (
	id int, 
	client_id int, 
	driver_id int, 
	city_id int, 
	status varchar(50), 
	request_at varchar(50)
);
select * from trips ;

Create table Users (
	users_id int, 
	banned varchar(50), 
	role varchar(50)
);
select * from Users;

insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
select * from trips;

insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');
select * from users;

-- Hard Problem | Complex
select  request_at, 
		count(
			CASE WHEN status in ('cancelled_by_driver','cancelled_by_client') then 1 
			else null 
			end
			) as cancelled_trip_count,
		count(1) as total_trips,
		1.0 * count(
			CASE WHEN status in ('cancelled_by_driver','cancelled_by_client') then 1 
			else null 
			end
			) / count(1) * 100 as cancelled_percent
from trips t 
inner join users c on t.client_id=c.users_id
inner join users d on t.driver_id=d.users_id
where c.banned='No' and d.banned='No'
group by request_at;

select t.request_at as day, 
       count(CASE WHEN status in ('cancelled_by_driver','cancelled_by_client') then 1 else null end) as cancelled_trip_count,
       count(1) as total_trips,
       1.0 * count(CASE WHEN status in ('cancelled_by_driver','cancelled_by_client') then 1 else null end) / count(1) * 100 as "Cancellation Rate"
from trips t 
inner join users c on t.client_id=c.users_id
inner join users d on t.driver_id=d.users_id
where c.banned='No' and d.banned='No'
group by t.request_at;

create table players
(
	player_id int,
	group_id int
);
insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);
select * from players;

create table matches
(
	match_id int,
	first_player int,
	second_player int,
	first_score int,
	second_score int
);
insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);
select * from matches;

-- identifikasi pemain dengan peringkat pertama di setiap grup 
-- berdasarkan total skor mereka dalam pertandingan.
with 
player_score as 
(
	select first_player as player_id,first_score as score from matches
	union  all
	select second_player as player_id,second_score as score from matches
),
final_scores as 
(
	select p.group_id,
		   ps.player_id,
		   sum(score) as score 
	from player_score ps 
	inner join players p on p.player_id=ps.player_id
	group by p.group_id,ps.player_id
),
final_ranking as
(
	select *,
	rank() over(partition by group_id order by score desc, player_id asc) as rn
	from final_scores
)
select * from final_ranking where rn=1;


create table usersp(
	user_id int,
	join_date date,
	favorite_brand varchar(50)
);

create table ordersp(
	order_id int,
	order_date date,
	item_id int,
	buyer_id int,
	seller_id int
);

create table itemsp(
	item_id int, 
	item_brand varchar(50)
);

insert into usersp values 
(1,'2019-01-01','Lenovo'),
(2,'2019-02-09','Samsung'),
(3,'2019-01-19','LG'),
(4,'2019-05-21','HP');

insert into itemsp values 
(1,'Samsung'),
(2,'Lenovo'),
(3,'LG'),
(4,'HP');

insert into ordersp values 
(1,'2019-08-01',4,1,2),
(2,'2019-08-02',2,1,3),
(3,'2019-08-03',3,2,3),
(4,'2019-08-04',1,4,2),
(5,'2019-08-04',1,3,4),
(6,'2019-08-05',2,2,4);

select * from usersp;
select * from itemsp;
select * from ordersp;

-- Analisis pasar: tulis kueri sql untuk mengetahui dari setiap penjual, 
-- apakah merek barang kedua (berdasarkan tanggal) yang mereka jual adalah 
-- merek favorit mereka atau bukan.
-- Jika penjual menjual kurang dari dua item, laporkan jawaban penjual tersebut 
-- karena tidak ada keluaran.

with rnk_orders as
(
	select *,
		   rank() over(partition by seller_id order by order_date asc)  as rn
	from ordersp
)
select u.user_id as seller_id,
	   ro.*,
	   i.item_brand,
	   u.favorite_brand,
	   CASE 
		   when i.item_brand = u.favorite_brand then 'Yes' 
		   else 'No' 
	   end as second_item_fav_brand
from usersp u 
left join rnk_orders ro on ro.seller_id=u.user_id and rn=2
left join itemsp i on  i.item_id=ro.item_id;

-- final querry 
with rnk_orders as
(
	select *,
		   rank() over(partition by seller_id order by order_date asc)  as rn
	from ordersp
)
select u.user_id as seller_id,
	   CASE 
		   when i.item_brand = u.favorite_brand then 'Yes' 
	   	   else 'No' 
	   end as second_item_fav_brand
from usersp u 
left join rnk_orders ro on ro.seller_id = u.user_id and rn = 2
left join itemsp i on  i.item_id = ro.item_id;


create table spending (
	user_id int,
	spend_date date,
	platform varchar(10),
	amount int
);

insert into spending values
(1,'2019-07-01','mobile',100),
(1,'2019-07-01','desktop',100),
(2,'2019-07-01','mobile',100),
(2,'2019-07-02','mobile',100),
(3,'2019-07-01','desktop',100),
(3,'2019-07-02','desktop',100);
select * from spending;

/* 
-- Platform pembelian pengguna.
-- - Tabel mencatat riwayat pengeluaran pengguna yang melakukan pembelian 
-- dari situs belanja online yang memiliki desktop dan aplikasi seluler.
-- - Tulis kueri SQL untuk menemukan jumlah total pengguna dan 
-- jumlah total yang dibelanjakan hanya menggunakan seluler, hanya desktop
-- dan seluler dan desktop secara bersamaan untuk setiap tanggal.
*/
WITH all_spend AS (
    SELECT spend_date,
           user_id,
           MAX(platform) AS platform,
           SUM(amount) AS amount
    FROM spending
    GROUP BY spend_date, user_id 
    HAVING COUNT(DISTINCT platform) = 1
    UNION ALL 
    SELECT spend_date,
           user_id,
           'Both' AS platform,
           SUM(amount) AS amount
    FROM spending
    GROUP BY spend_date, user_id 
    HAVING COUNT(DISTINCT platform) = 2
    UNION ALL
    SELECT DISTINCT spend_date,
                    NULL::INTEGER AS user_id, -- Change the data type to match user_id
                    'Both' AS platform,
                    0 AS amount
    FROM spending
)
SELECT spend_date,
       platform,
       SUM(amount) AS total_amount,
       COUNT(DISTINCT user_id) AS total_user
FROM all_spend
GROUP BY spend_date, platform
ORDER BY spend_date, platform DESC;

create table sales (
	product_id int,
	period_start date,
	period_end date,
	average_daily_sales int
);
insert into sales values
(1,'2019-01-25','2019-02-28',100),
(2,'2018-12-01','2020-01-01',10),
(3,'2019-12-01','2020-01-31',1);
select * from sales;

-- Logika Rekursif pada PostgreSQL
WITH RECURSIVE cte_numbers AS (
    SELECT 1 AS num -- anchor query
    UNION ALL 
    SELECT num + 1 -- recursive query
    FROM cte_numbers
    WHERE num < 6 -- filter to stop the recursion
)
SELECT num 
FROM cte_numbers;

-- UNRESOLVED DOCUMENTATION
WITH RECURSIVE r_cte AS (
    SELECT MIN(period_start)::timestamp AS dates, MAX(period_end) AS max_date FROM sales
    UNION ALL
    SELECT dates + INTERVAL '1 day', max_date FROM r_cte
    WHERE dates < max_date
)
SELECT product_id, EXTRACT(YEAR FROM dates) AS report_year, SUM(average_daily_sales) AS total_amount 
FROM r_cte
INNER JOIN sales ON dates BETWEEN period_start AND period_end
GROUP BY product_id, EXTRACT(YEAR FROM dates)
ORDER BY product_id, EXTRACT(YEAR FROM dates);
