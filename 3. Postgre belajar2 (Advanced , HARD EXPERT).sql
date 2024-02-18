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


--create table emmp(
--	emp_id int,
--	emp_name varchar(20),
--	department_id int,
--	manager_id int
--);
select * from emmp;
--insert into emmp values(1,'Adam Owens',103,3);
--insert into emmp values(2,'Smith Jones',102,5);
--insert into emmp values(3,'Hilary Riles',101,4);
--insert into emmp values(4,'Richard Robinson',103,3);
--insert into emmp values(5,'Samuel Pitt',103,3);
--insert into emmp values(6,'Mark Miles',null,7);
--insert into emmp values(7,'Jenny Jeff',999,null);

-- Menggunakan RECURSIVE CTE untuk menemukan manajer langsung dari setiap karyawan
WITH RECURSIVE EmpMgrCTE AS (
    SELECT emp_id, emp_name, manager_id, 0 AS EmpLevel
    FROM emmp
    WHERE manager_id IS NULL
    UNION ALL
    SELECT EMPP.emp_id, EMPP.emp_name, EMPP.manager_id, mngr.EmpLevel + 1
    FROM emmp EMPP
    INNER JOIN EmpMgrCTE AS mngr ON EMPP.manager_id = mngr.emp_id
)
SELECT * FROM EmpMgrCTE
ORDER BY EmpLevel;

-- Cara 1: Memeriksa tanggal yang valid untuk 29 Februari
DO $$
DECLARE
    year_val INT := 2024;
    leap_year_text TEXT;
BEGIN
    BEGIN
        PERFORM TO_DATE(year_val || '0229', 'YYYYMMDD');
        leap_year_text := 'LEAP YEAR';
    EXCEPTION WHEN others THEN
        leap_year_text := 'NOT A LEAP YEAR';
    END;

    RAISE NOTICE '%', leap_year_text;
END $$;


-- Cara 2: Menggunakan pernyataan CASE untuk menentukan apakah tahun kabisat
DO $$
DECLARE
    year_val INT := 2024;
    leap_year_text TEXT;
BEGIN
    IF (year_val % 4 = 0 AND year_val % 100 <> 0) OR (year_val % 400 = 0) THEN
        leap_year_text := 'LEAP YEAR';
    ELSE
        leap_year_text := 'NOT A LEAP YEAR';
    END IF;

    RAISE NOTICE '%', leap_year_text;
END $$;

-- Tampilkan semua date dari 2023-02-01 sampai 2023-03-7
WITH RECURSIVE calendar AS (
  SELECT DATE '2023-02-01'::TIMESTAMP AS cal_date
  UNION ALL
  SELECT cal_date + INTERVAL '1 day'
  FROM calendar
  WHERE cal_date < '2023-03-7'
)
SELECT cal_date::DATE
FROM calendar;

-- create table userss (
-- 	user_id integer,
-- 	name varchar(20),
-- 	join_date date
-- );
-- insert into userss values 
-- (1, 'Jon','2020-02-14'), 
-- (2, 'Jane', '2020-02-14'), 
-- (3, 'Jill','2020-02-15' ), 
-- (4, 'Josh','2020-02-15'), 
-- (5, 'Jean','2020-02-16'), 
-- (6, 'Justin','2020-02-17'),
-- (7, 'Jeremy', '2020-02-18');
-- select * from userss;
-- -- delete from userss;
-- create table events(
-- 	user_id integer,
-- 	type varchar(10),
-- 	access_date date
-- );
-- insert into events values 
-- (1, 'Pay', '2020-03-01'), 
-- (2, 'Music', '2020-03-02'), 
-- (2, 'P', '2020-03-12'),
-- (3, 'Music', '2020-03-15'), 
-- (4, 'Music','2020-03-15'), 
-- (1, 'P', '2020-03-16'), 
-- (3, 'P', '2020-03-22');
-- select * from  userss;
-- select * from  events;

-- hitung fraksi dari pengguna yang mengakses Amazon Music dan 
-- melakukan upgrade ke keanggotaan Prime
-- dalam waktu 30 hari setelah mendaftar
WITH UserMusic AS (
    SELECT DISTINCT u.user_id
    FROM userss u
    JOIN events e ON u.user_id = e.user_id
    WHERE e.type = 'Music'
),
UserPrime AS (
    SELECT DISTINCT u.user_id
    FROM userss u
    JOIN events e ON u.user_id = e.user_id
    WHERE e.type = 'P'
),
PrimeWithin30Days AS (
    SELECT u.user_id
    FROM userss u
    JOIN events e ON u.user_id = e.user_id
    WHERE e.type = 'P' AND e.access_date <= u.join_date + INTERVAL '30 days'
)
SELECT ROUND(COUNT(p.user_id)::NUMERIC / COUNT(m.user_id)::NUMERIC * 100, 2) AS fraction_of_users
FROM UserMusic m
LEFT JOIN PrimeWithin30Days p ON m.user_id = p.user_id;

create table billings(
	emp_name varchar(10),
	bill_date date,
	bill_rate int
);
insert into billings values
('Sachin','1990-01-01',25),
('Sehwag' ,'1989-01-01', 15),
('Dhoni' ,'1989-1-01', 20),
('Sachin' ,'1991-02-05', 30);

create table HoursWorked (
	emp_name varchar(20),
	work_date date,
	bill_hrs int
);
insert into HoursWorked values
('Sachin', '1990-07-01' ,3),
('Sachin', '1990-08-01', 5),
('Sehwag','1990-07-01', 2),
('Sachin','1991-07-01', 4);

select * from HoursWorked;
select * from billings;

-- TOTAL CHARGES AS PER BILLING RATE
SELECT *,
	   LEAD(BILL_DATE - INTERVAL '1 DAY',1,'9999-12-31') OVER(PARTITION BY EMP_NAME ORDER BY BILL_DATE ASC) AS BILL_DATE_END
FROM BILLINGS;

WITH DATE_RANGE AS (
	SELECT *,
		   LEAD(BILL_DATE - INTERVAL '1 DAY', 1, '9999-12-31') OVER(PARTITION BY EMP_NAME ORDER BY BILL_DATE ASC) AS BILL_DATE_END
	FROM BILLINGS
)
SELECT HW.EMP_NAME, 
	   SUM(DR.BILL_RATE * HW.BILL_HRS) 
FROM DATE_RANGE DR
INNER JOIN HoursWorked HW 
ON DR.EMP_NAME = HW.EMP_NAME AND HW.WORK_DATE BETWEEN DR.BILL_DATE AND DR.BILL_DATE_END -- Penambahan argument
GROUP BY HW.EMP_NAME;

-- CREATE table activityy(
-- 	user_id char(20),
-- 	event_name char(20),
-- 	event_date date,
-- 	country char(20)
-- );
-- insert into activityy values 
-- (1,'app-installed','2022-01-01','India')
-- ,(1,'app-purchase','2022-01-02','India')
-- ,(2,'app-installed','2022-01-01','USA')
-- ,(3,'app-installed','2022-01-01','USA')
-- ,(3,'app-purchase','2022-01-03','USA')
-- ,(4,'app-installed','2022-01-03','India')
-- ,(4,'app-purchase','2022-01-03','India')
-- ,(5,'app-installed','2022-01-03','SL')
-- ,(5,'app-purchase','2022-01-03','SL')
-- ,(6,'app-installed','2022-01-04','Pakistan')
-- ,(6,'app-purchase','2022-01-04','Pakistan');
-- select * from activityy;

-- tampilkan jumlah pembelian di India dan USA
SELECT CASE 
	   	  WHEN country IN ('India', 'USA') THEN country 
	   	  ELSE 'Others' 
	   END AS new_country,
       COUNT(DISTINCT user_id) as user_cnt 
FROM activityy
WHERE event_name = 'app-purchase'
GROUP BY 
CASE 
	WHEN country IN ('India', 'USA') THEN country 
	ELSE 'Others'
END;

-- tampilkan persentase user dari India dan USA
with country_wise_users as 
(
	SELECT CASE 
		   	  WHEN country IN ('India', 'USA') THEN country 
		   	  ELSE 'Others' 
		   END AS new_country,
	       COUNT(DISTINCT user_id) as user_cnt 
	FROM activityy
	WHERE event_name = 'app-purchase'
	GROUP BY 
	CASE 
		WHEN country IN ('India', 'USA') THEN country 
		ELSE 'Others'
	END
),
total as 
(
	select sum(user_cnt) as total_users 
	from country_wise_users 
)
select new_country,
	   user_cnt*1.0/total_users*100 as percent_users
from country_wise_users,
	 total;

-- tampilkan aktivitas sebelumnya, 1 baris setelahnya.
select *,
	   lag(event_name,1) over(partition by user_id order by event_date) as prev_event_name,
	   lag(event_date,1) over(partition by user_id order by event_date) as prev_event_date
from activityy;

-- hitung jumlah pengguna yang melakukan pembelian aplikasi 
-- pada tanggal yang sama dengan instalasi aplikasi sebelumnya.
WITH prev_data AS (
    SELECT *,
           LAG(event_name, 1) OVER (PARTITION BY user_id ORDER BY event_date) AS prev_event_name,
           LAG(event_date, 1) OVER (PARTITION BY user_id ORDER BY event_date) AS prev_event_date
    FROM activityy
)
SELECT event_date,
       COUNT(DISTINCT user_id) AS cnt_users
FROM prev_data
WHERE event_name = 'app-purchase'
  AND prev_event_name = 'app-installed'
  AND (EXTRACT(DAY FROM event_date) - EXTRACT(DAY FROM prev_event_date)) = 1
GROUP BY event_date;


create table bms(
	seat_no int ,
	is_empty varchar(10)
);
insert into bms values
(1,'N'),
(2,'Y'),
(3,'N'),
(4,'Y'),
(5,'Y'),
(6,'Y'),
(7,'N'),
(8,'Y'),
(9,'Y'),
(10,'Y'),
(11,'Y'),
(12,'N'),
(13,'Y'),
(14,'Y');

-- UNRESOLVED DOCUMENTATION
select * from (
SELECT *
,LAG(is_empty,1) over(order by seat_no) as prev_1
,LAG(is_empty,2) over(order by seat_no) as prev_2
,Lead(is_empty,1) over(order by seat_no) as next_1
,Lead(is_empty,2) over(order by seat_no) as next_2
FROM BMS) A
where is_empty = 'Y' and prev_1 = 'Y' and prev_2 = 'Y'
or (is_empty = 'Y' and prev_1 = 'Y' and next_1 = 'Y')
or (is_empty = 'Y' and next_1 = 'Y' and next_2 = 'Y') ;

-- UNRESOLVED DOCUMENTATION
select * from (
SELECT *
,sum(case when is_empty='Y' then 1 else 0 end) over(order by seat_no rows between 2 preceding and current row) as prev_2
,sum(case when is_empty='Y' then 1 else 0 end) over(order by seat_no rows between 1 preceding and 1 following) as prev_next_1
,sum(case when is_empty='Y' then 1 else 0 end) over(order by seat_no rows between current row and 2 following) as next_2
FROM BMS) a 
where prev_2=3 or prev_next_1=3 or next_2=3;

-- UNRESOLVED DOCUMENTATION
with diff_num as (
select *
,row_number() over(order by seat_no) as rn
,seat_no-row_number() over(order by seat_no) as diff
 from bms where is_empty='Y'),
 cnt as (
 select diff, count(1) as c from diff_num 
 group by diff having count(1)>=3)
 select * from diff_num where diff in (select diff from cnt) ;


create table Contests ( contest_id INT, hacker_id INT, name VARCHAR(200) );
insert into Contests (contest_id, hacker_id, name) values (66406, 17973, 'Rose'), (66556, 79153, 'Angela'), (94828, 80275, 'Frank');

create table Colleges( college_id INT, contest_id INT );
insert into Colleges (college_id, contest_id) values (11219, 66406), (32473, 66556), (56685, 94828);

create table Challenges ( challenge_id INT, college_id INT );
insert into Challenges (challenge_id, college_id) values (18765, 11219), (47127, 11219), (60292, 32473), (72974, 56685);

create table View_Stats ( challenge_id INT, total_views INT, total_unique_views INT );
insert into View_Stats (challenge_id, total_views, total_unique_views) values (47127, 26, 19), (47127, 15, 14), (18765, 43, 10), (18765, 72, 13), (75516, 35, 17), (60292, 11, 10), (72974, 41, 15), (75516, 75, 11);

create table Submission_Stats ( challenge_id INT, total_submissions INT, total_accepted_submissions INT );
insert into Submission_Stats (challenge_id, total_submissions, total_accepted_submissions) values (75516, 34, 12), (47127, 27, 10), (47127, 56, 18), (75516, 74, 12), (75516, 83, 8), (72974, 68, 24), (72974, 82, 14), (47127, 28, 11);

select * from Contests;
select * from Colleges;
select * from Challenges;
select * from View_Stats;
select * from Submission_Stats;

/*
John mewawancarai banyak kandidat dari berbagai perguruan tinggi menggunakan tantangan dan kontes coding.
Tulis kueri yang menampilkan kontes_id, hacker_id, nama, jumlah total_pengajuan,
total_accepted_submissions, total_views, dan total_unique_views untuk setiap kontes yang diurutkan berdasarkan kontes_id.
Kecualikan kontes dari hasil jika keempat jumlah semuanya nol.
*/

select con.contest_id,
        con.hacker_id, 
        con.name, 
        sum(total_submissions), --stats table
        sum(total_accepted_submissions), -- stats table
        sum(total_views), -- from view_stats
		sum(total_unique_views)
from contests con 
join colleges col on con.contest_id = col.contest_id 
join challenges cha on  col.college_id = cha.college_id 
left join
(select challenge_id, sum(total_views) as total_views, sum(total_unique_views) as total_unique_views
	from view_stats group by challenge_id) vs on cha.challenge_id = vs.challenge_id 
left join
(select challenge_id, sum(total_submissions) as total_submissions, sum(total_accepted_submissions) as total_accepted_submissions 
 from submission_stats group by challenge_id) ss on cha.challenge_id = ss.challenge_id
    group by con.contest_id, con.hacker_id, con.name;

-- Karyawan dengan gaji terdekat dengan gaji rata-rata di suatu departemen.
select * from empt;

WITH SAL_DIFF AS 
(
	SELECT emp_name, 
		   salary, 
		   empt.department_id, 
		   Avg_Sal, 
		   (salary - Avg_Sal) as SalDiff,
		   RANK() OVER(PARTITION BY empt.department_id ORDER BY ABS(salary - Avg_Sal)) AS Sal_Diff
	FROM empt 
	INNER JOIN (
		SELECT empt.department_id,
			   AVG(salary) as Avg_Sal 
		from empt 
		GROUP BY department_id
	) AS Avg_Sal
	ON empt.department_id = Avg_Sal.department_id
)
SELECT emp_name ,salary, department_id FROM SAL_DIFF 
WHERE Sal_Diff <= 1;
