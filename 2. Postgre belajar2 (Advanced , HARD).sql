-- ADVANCED
-- HARD

-- Gunakan db belajar2.sql

-- create database belajar2;

create table emp
(
	emp_id int,
	emp_name Varchar(20),
	department_id Varchar(20),
	salary int
);

INSERT INTO emp values (1,'Ankit',100,10000);
INSERT INTO emp values
(2,'Mohit',100,15000),
(3,'Vikas',100,10000),
(4,'Rohit',100,5000),
(5,'Mudit',200,12000),
(6,'Agam',200,12000),
(7,'Sanjay',200,9000),
(8,'Ashish',200,5000);

-- Common Table Expression (CTE)
-- kumpulan hasil sementara yang diberi nama yang dapat Anda referensikan dalam perintah SELECT, INSERT, UPDATE, atau DELETE.
-- CTE digunakan untuk menyusun kueri yang lebih kompleks dengan lebih terstruktur.
-- syntax : WITH cte_name as (cte querry), CTE bisa dibuat lebih dari satu
-- dipsahkan menggunakan koma.
select * from emp;

with 
cte1 as 
(
	select emp_id,
		   department_id 
	from emp
)
select * FROM cte1;

select * from emp;

-- RANK===BERIKAN PERINGKAT YANG SAMA PADA GAJI YANG SAMA
select emp_id, emp_name ,department_id, salary,
	rank() OVER(order by salary desc) as rnk 
from emp;

-- DENSE RANK == dua orang dengan gaji yang sama mendapat pangkat yang sama, 
-- jangan melewatkan angka seperti RANK
SELECT emp_id, emp_name, department_id, salary,
	DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rnk
FROM emp;

-- Tenampilkan semua jenis dari RANK dan DENSE RANK beserta row number asal 
-- berdasarkan gaji.
-- Tampilkan informasi karyawan bersama dengan tiga kolom tambahan: 
-- rnk (peringkat), dens_rnk (peringkat padat), dan rows_number (nomor baris) 
-- berdasarkan gaji dalam setiap departemen_id.
select emp_id, emp_name ,department_id, salary,
	RANK() OVER(partition by department_id ORDER by salary desc) as rnk,
	DENSE_RANK() OVER(partition by department_id order by salary desc) as dens_rnk,
	row_number() OVER(partition by department_id order by salary desc) as rows_number
from emp;

-- Tampilkan Rank 1 yang sama, dari setiap department_id
select * from (
	select 
		emp_id, 
		emp_name,
		department_id, 
		salary,
		RANK() OVER(partition by department_id ORDER by salary desc) as rnk
	from 
		emp 
) as a 
WHERE 
	rnk=1;


create table empm
(
	emp_id int,
	emp_name Varchar(20),
	department_id Varchar(20),
	salary int,
	manager_id int
);

INSERT INTO empm values(1,'Ankit',100,10000,4);
INSERT INTO empm values(2,'Mohit',100,15000,5);
INSERT INTO empm values(3,'Vikas',100,10000,4);
INSERT INTO empm values(4,'Rohit',100,5000,2);
INSERT INTO empm values(5,'Mudit',200,12000,6);
INSERT INTO empm values(6,'Agam',200,12000,2);
INSERT INTO empm values(7,'Sanjay',200,9000,2);
INSERT INTO empm values(8,'Ashish',200,5000,2);

select * from empm;

-- Tampilkan nama manager dari setiap emp_name, emp_salary beserta manager_salarynya.
select 
	e.emp_id, 
	e.emp_name, 
	e.salary as emp_salary, 
	m.emp_name as manager,
	m.salary as manager_salary 
from 
	empm as e 
inner join 
	empm as m on e.manager_id = m.emp_id;


create table customer_orders (
	order_id integer,
	customer_id integer,
	order_date date,
	order_amount integer
);

select * from customer_orders;

insert into customer_orders values
(1,100,cast('2022-01-01' as date),2000),
(2,200,cast('2022-01-01' as date),2500),
(3,300,cast('2022-01-01' as date),2100),
(4,100,cast('2022-01-02' as date),2000),
(5,400,cast('2022-01-02' as date),2200),
(6,500,cast('2022-01-02' as date),2700),
(7,100,cast('2022-01-03' as date),3000),
(8,400,cast('2022-01-03' as date),1000),
(9,600,cast('2022-01-03' as date),3000);

-- tampilkan semua customer_id yang melakukan order paling awal tanpa redudansi
select customer_id, min(order_date) as first_visit_date from customer_orders
group by customer_id ;

-- tampilkan pelanggan baru dan pelanggan berulang pada setiap tanggal yang ada pada
-- record/database
with first_date as(
	select 
		customer_id,
		min(order_date) as first_visit_date 
	from 
		customer_orders
	group by 
		customer_id
),
visit_flag as (
	select 
		co.*, 
		fv.first_visit_date,
		CASE WHEN co.order_date=fv.first_visit_date then 1 else 0 end as first_visit_flag,
		CASE WHEN co.order_date!=fv.first_visit_date then 1 else 0 end as repeat_visit_flag  
	from 
		customer_orders co 
	inner join 
		first_date fv on co.customer_id=fv. customer_id
	order by 
		order_id
)
select 
	order_date,
	sum(first_visit_flag) no_of_new_customer,
	sum(repeat_visit_flag) as no_of_repeat_customer
from 
	visit_flag 
group by 
	order_date;

-- tampilkan pelanggan baru dan pelanggan berulang pada setiap tanggal yang ada pada
-- record/database.
-- kueri lebih sederhana.
with first_date as(
	select 
		customer_id,
		min(order_date) as first_visit_date 
	from 
		customer_orders
	group by 
		customer_id
)
select 
	co.order_date,
	sum(CASE WHEN co.order_date=fv.first_visit_date then 1 else 0 end) as first_visit_flag,
	sum(CASE WHEN co.order_date!=fv.first_visit_date then 1 else 0 end) as repeat_visit_flag  
from 
	customer_orders co 
inner join 
	first_date fv on co.customer_id=fv. customer_id
group by 
	co.order_date
;

-- tampilkan pelanggan baru dan pelanggan berulang pada setiap tanggal yang ada pada
-- record/database.
-- kueri lebih sederhana 2.
SELECT
	order_date,
    COUNT(CASE WHEN order_date = first_visit_date THEN 1 ELSE NULL END) AS no_of_new_customer,
    COUNT(CASE WHEN order_date != first_visit_date THEN 1 ELSE NULL END) AS no_of_repeat_customer
FROM(
	SELECT
		co.*,
		fv.first_visit_date
	FROM
		customer_orders co
	INNER JOIN(
		SELECT
			customer_id,
			MIN(order_date) AS first_visit_date
		FROM
			customer_orders
		GROUP BY
			customer_id
	) as fv ON co.customer_id = fv.customer_id
) as combined_data
GROUP BY
    order_date;

create table entries 
( 
	name varchar(20),
	address varchar(20),
	email varchar(20),
	floor int,
	resources varchar(10)
);

insert into entries values 
('A','Bangalore','A@gmail.com',1,'CPU'),
('A','Bangalore','A1@gmail.com',1,'CPU'),
('A','Bangalore','A2@gmail.com',2,'DESKTOP'),
('B','Bangalore','B@gmail.com',2,'DESKTOP'),
('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
('B','Bangalore','B2@gmail.com',1,'MONITOR');

select * from entries;

	select 
		name,
		resources 
	from 
		entries;

-- berikan informasi tentang lantai yang paling sering dikunjungi, 
-- jumlah total kunjungan, dan sumber daya yang digunakan untuk setiap nama, 
-- diurutkan berdasarkan peringkat kunjungan lantai.
with 
Distinct_resources as (
	select 
		name,
		resources 
	from 
		entries
),
agg_resources as (
	select 
		name,
		string_agg(resources,',') as used_resouces 
	from 
		distinct_resources 
	group by name
),
total_visits as (
	select 
		name, 
		count(1) as total_visits , 
		STRING_AGG(resources,',') as resources_used 
	from 
		entries 
	group by 
		name
), 
floor_visit as (
	select 
		name,
		floor,
		count(1) as no_of_floor_visits,
		rank() over(partition by name order by count(1) desc) as rn
	from 
		entries  
	group by 
		name, 
		floor
)
select 
	fv.name,
	fv.floor as most_visited_floor,
	tv.total_visits,
	ar.used_resouces
from 
	floor_visit as fv 
inner join 
	total_visits as tv on fv.name=tv.name
inner join 
	agg_resources as ar on fv.name=ar.name
where rn=1;


create table empt
(
	emp_id int,
	emp_name Varchar(20),
	department_id Varchar(20),
	salary int,
	manager_id int
);

alter table empt 
	add column time timestamp not null default current_timestamp;


INSERT INTO empt values(1,'Ankit',100,10000,4);
INSERT INTO empt values(2,'Mohit',100,15000,5);
INSERT INTO empt values(3,'Vikas',100,10000,4);
INSERT INTO empt values(4,'Rohit',100,5000,2);
INSERT INTO empt values(5,'Mudit',200,12000,6);
INSERT INTO empt values(6,'Agam',200,12000,2);
INSERT INTO empt values(7,'Sanjay',200,9000,2);
INSERT INTO empt values(8,'Ashish',200,5000,2);
INSERT INTO empt values(1,'saurabh',900,12000,2);

select * from empt;

truncate empt;

-- Cek jumlah emp_id yang duplikat
select emp_id ,count(1) from empt group by emp_id having count(1)>1;

-- Hapus emp_id yg duplikat, sisakan 1 (Fail/Err)
with cte as (select * , row_number() over(partition by emp_id order by emp_id) as rn from empt)
delete from cte where rn>1;

-- Hapus emp_id yg duplikat, sisakan 1 (Fixed)
DELETE FROM empt
WHERE ctid IN (
  SELECT ctid
  FROM (
    SELECT ctid,
           ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY ctid) AS row_num
    FROM empt
  ) AS duplicates
  WHERE row_num > 1
);

select manager_id from empm
union 
select manager_id from empt;

-- Melihat salary tertinggi di setiap departemen
select empt.* ,dense_rank() over(partition by department_id order by salary desc) as rn from empt order by salary desc;

-- Melihat salary tertinggi di urutan ke 2 teratas
select * from (select empt.* ,dense_rank() over(partition by department_id order by salary desc) as rn from empt) as a
where rn=2;

create table Orders
(
	customer_name Varchar(20),
	order_date date,
	order_amount int,
	customer_gender varchar(7)
);

select * from orders;
INSERT INTO orders values('Shilpa','2020-01-01',10000,'Male');
INSERT INTO orders values('Rahul','2020-01-02',12000,'Female');
INSERT INTO orders values('SHILPA','2020-01-01',12000,'Male');
INSERT INTO orders values('Rohit','2020-01-03',15000,'Female');
INSERT INTO orders values('Shilpa','2020-01-03',14000,'Male');
select * from orders;

-- Lihat semua transaksi yang dilakukan oleh SHILPA (menggunakan upper)
-- akan mencocokkan semua baris di mana customer_name memiliki nilai seperti shilpa, Shilpa, SHILPA, dll.
select * from orders where upper(customer_name)='SHILPA';

-- Lihat semua transaksi yang dilakukan oleh SHILPA (menggunakan lower)
select * from orders where lower(customer_name)='shilpa';

-- Lihat semua transaksi yang dilakukan oleh SHILPA (tanpa upper)
-- hanya teks yang sama persis yang akan cocok, baik itu huruf besar atau kecil.
select * from orders where customer_name='SHILPA';

-- Tukar nilai gender Female ke Male dan sebaliknya
select * from orders;
update orders 
set customer_gender = case 
	when customer_gender='Female' then 'Male'
	when customer_gender='Male' then 'Female' 
end;

-- ekstrak 2022-01-23 menjadi sebuah integer 23 , 1 dan 2022
SELECT EXTRACT(DAY FROM DATE '2022-01-23') AS day,
       EXTRACT(MONTH FROM DATE '2022-01-23') AS month,
       EXTRACT(YEAR FROM DATE '2022-01-23') AS year;

select dateadd(day,2,'2022-01-23');

-- tambahkan 2 hari dari tanggal 2022-01-23
SELECT DATE '2024-02-29' + INTERVAL '2 days';

-- tambahkan 2 hari dari tanggal 2022-01-23 (Alternatif)
SELECT '2024-02-29'::DATE + 2;

-- hitung berapa hari dari tanggal 2022-01-01 ke 2022-03-23
SELECT DATE '2022-03-23' - DATE '2022-01-01';

-- hitung berapa minggu dari tanggal 2022-01-01 ke 2022-03-23(Pecahan)
SELECT ceiling(DATE '2022-03-23' - DATE '2022-01-01') / 7 AS weeks;
SELECT floor((DATE '2022-03-23' - DATE '2022-01-01')) / 7 AS weeks;

-- hitung berapa minggu dari tanggal 2022-01-01 ke 2022-03-23(Pembulatan ke bawah)
SELECT (DATE '2022-03-23' - DATE '2022-01-01') / 7 as weeks;

create table customer_orders_dates ( 
	order_id int,
	customer_id int,
	order_date date,
	ship_date date
);

select * from customer_orders_dates;
insert into customer_orders_dates values(1000, 1 , '2022-01-05', '2022-01-11');
insert into customer_orders_dates values(1001, 2 , '2022-02-04', '2022-02-16');
insert into customer_orders_dates values(1002, 3 , '2022-01-01', '2022-01-19');
insert into customer_orders_dates values(1003, 4 , '2022-01-06', '2022-01-30');
insert into customer_orders_dates values(1004, 1 , '2022-02-07', '2022-02-13');
insert into customer_orders_dates values(1005, 4 , '2022-01-07', '2022-01-31');
insert into customer_orders_dates values(1006, 3 , '2022-02-08', '2022-02-26');
insert into customer_orders_dates values(1007, 2 , '2022-02-09', '2022-02-21');
insert into customer_orders_dates values(1008, 4 , '2022-02-10', '2022-03-06');
select * from customer_orders_dates;

-- lihat Estimasi hari pengantaran orderan(Fail/Err)
select *, DATEDIFF(day,order_date,ship_date) as days_to_ship from customer_orders_dates;

-- lihat Estimasi hari pengantaran orderan(Postgres)
SELECT *, (ship_date - order_date) AS days_to_ship FROM customer_orders_dates;

-- lihat Estimasi week pengantaran orderan(Fail/Err)
select *, DATEDIFF(week,order_date,ship_date) as days_to_ship from customer_orders_dates ;

-- lihat Estimasi week pengantaran orderan(Postgres)
SELECT *, 
		(ship_date - order_date) / 7.0  AS weeks_to_ship
FROM customer_orders_dates;


-- hitung estimasi pengantaran berdasarkan hari
-- jika dalam satu hari ada 5 hari kerja (libur di hari sabtu dan minggu)(SSMS : SQL Server Management Studio)
select *, DATEDIFF(day,order_date,ship_date) as days_to_ship,
		DATEDIFF(week,order_date,ship_date) as week_between_days,
		DATEDIFF(day,order_date,ship_date) - 2 * DATEDIFF(week,order_date,ship_date) as business_days_to_ship
 from customer_orders_dates ;

-- hitung estimasi pengantaran berdasarkan hari
-- jika dalam satu hari ada 5 hari kerja (libur di hari sabtu dan minggu)(PostgreSQL)
select *, 
		(ship_date - order_date) AS days_to_ship,
		(ship_date - order_date) / 7.0 AS week_between_days,
		(ship_date - order_date) - 2 * ((ship_date - order_date) / 7) AS business_days_to_ship
from customer_orders_dates ;

create table customer_dob ( 
	customer_id int,
	customer_name varchar(20),
	gender varchar(7),
	dob date
);

drop table customer_dob;

SELECT * FROM  customer_dob;
insert into customer_dob values(1,'Rahul' , 'M', '2000-01-05');
insert into customer_dob values(2,'Shilpa' , 'F', '2004-04-05');
insert into customer_dob values(3,'Ramesh' , 'M', '2003-07-07');
insert into customer_dob values(4,'katrina' , 'F', '2005-02-05');
insert into customer_dob values(5,'Alia' , 'F', '1992-01-01');
SELECT * FROM  customer_dob;

-- tampilkan semua umur pelanggan(tanggal lahir)
SELECT *,
    EXTRACT(YEAR FROM AGE(current_date, dob)) AS customer_age
FROM customer_dob;

create table emp_compensation (
	emp_id int,
	salary_component_type varchar(20),
	val int
);

select * from emp_compensation ec ;

insert into emp_compensation values 
(1,'salary',10000),(1,'bonus',5000),(1,'hike_percent',10),
(2,'salary',15000),(2,'bonus',7000),(2,'hike_percent',8),
(3,'salary',12000),(3,'bonus',6000),(3,'hike_percent',7);
select * from emp_compensation ec ;

truncate table emp_compensation ;

-- Pivot adalah salah satu teknik transformasi data dalam database yang 
-- digunakan untuk mengubah susunan atau struktur data dari 
-- format panjang (long format) menjadi format lebar (wide format), 
-- atau sebaliknya.

-- tampilkan gambaran tentang komposisi gaji masing-masing karyawan
-- berdasarkan emp_id. (pivot)
select emp_id,
sum(CASE WHEN salary_component_type='salary' then val end) as salary, 
sum(CASE WHEN salary_component_type='bonus' then val end) as bonus,
sum(CASE WHEN salary_component_type='hike_percent' then val end) as hike_percent  
from emp_compensation 
group by emp_id;

-- membuat table pivot
select emp_id
,sum(CASE WHEN salary_component_type='salary' then val end) as salary  
,sum(CASE WHEN salary_component_type='bonus' then val end) as bonus  
,sum(CASE WHEN salary_component_type='hike_percent' then val end) as hike_percent  
into emp_compensation_pivot from emp_compensation group by emp_id;

DROP TABLE IF EXISTS emp_compensation_pivot;

select * from emp_compensation_pivot;

--	create table emp_compensation_pivot (
--		emp_id int,
--		salary int,
--		bonous int,
--		hike_percent int
--	);

select * from emp_compensation_pivot;
insert into emp_compensation_pivot values (1,10000,5000,10);
insert into emp_compensation_pivot values (2,15000,7000,8);
insert into emp_compensation_pivot values (3,12000,6000,7);
select * from emp_compensation_pivot;


-- Cek jumlah emp_id yang duplikat pada pivot
select emp_id ,count(1) from emp_compensation_pivot 
group by emp_id having count(1)>1;

-- Hapus emp_id yg duplikat pada pivot, sisakan 1 (Fixed)
DELETE FROM emp_compensation_pivot
WHERE ctid IN (
  SELECT ctid
  FROM (
    SELECT ctid,
           ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY ctid) AS row_num
    FROM emp_compensation_pivot
  ) AS duplicates
  WHERE row_num > 1
);

select * from emp_compensation_pivot;

-- Membedah tabel pivot menjadi data mentah,
-- urutkan berdasarkan emp_id.
select * from (
	select emp_id, 
			'salary' as salary_component_type, 
			salary as val  
	from emp_compensation_pivot
	union all
	select emp_id, 
			'bonus' as salary_component_type, 
			bonus as val  
	from emp_compensation_pivot
	union all
	select emp_id , 
			'hike_percent' as salary_component_type, 
			hike_percent as val 
	from emp_compensation_pivot
) as a order by emp_id;


-- write a querry to provide the date for 
-- nth occurence of sunday in future from the given date

-- Contoh penerapan sederhana dari konsep pengelolaan tanggal 
-- dan waktu di dalam database, serta penggunaan variabel dan 
-- operasi tanggal di dalam blok DO di PostgreSQL.

-- Deklarasi variabel dan inisialisasi
DO $$
DECLARE 
    today_date date;
    n int;
BEGIN
    today_date := '2022-01-01'; -- Sabtu
    n := 3;
END $$;

-- 8-7=1 add in today_date
-- Inisialisasi variabel
DO $$
DECLARE 
    today_date date;
    n int;
    new_date date;
BEGIN
    today_date := '2022-01-01'; -- Sabtu
    n := 3;

    -- Tambahkan 1 minggu dan 1 hari pada tanggal
    new_date := today_date + (n - 1) * interval '1 week' + interval '1 day';
    
    -- Cetak tanggal baru
    RAISE NOTICE 'New Date: %', new_date;
END $$;

CREATE TABLE cust_orders (
    order_id serial PRIMARY KEY,
    order_date date,
    sales numeric
);

INSERT INTO cust_orders (order_date, sales) VALUES
    ('2022-01-01', 100),
    ('2022-01-15', 150),
    ('2022-02-01', 200),
    ('2022-02-15', 250),
    ('2022-03-01', 300),
    ('2022-03-15', 350);


-- or  ,sum(sales) over(order by year_order asc, month_order asc rows between 2 preceding and 0 preceding) as rolling_sum 
with year_month_sales as (
select datepart(year,order_date) as year_order, datepart(month,order_date) as month_order, sum(sales) as sales
from cust_orders 
group by datepart(year,order_date), datepart(month,order_date)
)
select *
,sum(sales) over(order by year_order asc, month_order asc rows between 1 preceding and 1 following) as rolling_sum
,avg(sales) over(order by year_order asc, month_order asc rows between 1 preceding and 1 following) as rolling_avg
,min(sales) over(order by year_order asc, month_order asc rows between 1 preceding and 1 following) as rolling_min
,max(sales) over(order by year_order asc, month_order asc rows between 1 preceding and 1 following) as rolling_max
from year_month_sales ;

-- or  ,sum(sales) over(order by year_order asc, month_order asc rows between 2 preceding and 0 preceding) as rolling_sum 
WITH year_month_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year_order, 
        EXTRACT(MONTH FROM order_date) AS month_order, 
        SUM(sales) AS sales
    FROM 
        cust_orders 
    GROUP BY 
        EXTRACT(YEAR FROM order_date), 
        EXTRACT(MONTH FROM order_date)
)
SELECT 
    *, 
    SUM(sales) OVER (ORDER BY year_order ASC, month_order ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_sum,
    AVG(sales) OVER (ORDER BY year_order ASC, month_order ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_avg,
    MIN(sales) OVER (ORDER BY year_order ASC, month_order ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_min,
    MAX(sales) OVER (ORDER BY year_order ASC, month_order ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_max
FROM 
    year_month_sales;
   
-- Clause ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING digunakan dalam 
-- konstruksi SUM() OVER untuk menentukan rentang baris yang akan 
-- dijumlahkan untuk setiap baris saat menghitung rolling_sum.
   
create table employee (
	emp_id int, 
	emp_name char(10),
	emp_salary int
);

-- drop table employee;
-- delete from employee;

select * from employee;
insert into employee values(1,'roshan',7000);
insert into employee values(2,'Moshan',6000);
insert into employee values(3,'kanti',5000);
insert into employee values(4,'gagan',2000);
select * from employee;

-- second highest salary 
-- using max
select max(emp_salary) 
from employee 
where emp_salary < 
(
	select max(emp_salary) 
	from employee
);

-- using limit,inner querry run first will give 2 highest salry, then order by ascending(default) 
select emp_salary 
from 
(
	select emp_salary 
	from employee order by emp_salary desc limit 2
)as emp 
order by emp_salary 
limit 1;

CREATE TABLE superstore_orders (
    order_id SERIAL PRIMARY KEY,
    product_id INT,
    sales NUMERIC
);

select * from superstore_orders ;
INSERT INTO superstore_orders (product_id, sales) VALUES
    (1, 100), (1, 150), (2, 200), (2, 250), (3, 300), (3, 350), (4, 400), (4, 450), (5, 500), (5, 550);
select * from superstore_orders ;


drop table superstore_orders;
-- Pareto Principle (80/20 Rule) Implementation in SQL
-- The pareto principle states that for many outcomes,roughly 80% of consequences come from 20% of causes eg:
-- 1-80% of productivity come from 20% of the employees
-- 2-80% of your sales come from 20% of your clients
-- 3-80% of decision in a meeting  are made in 20% of the time
--  we are solving the below question
-- 4-80% of your sales come from 20% of your product or servies
select sum(sales) * 0.8 from superstore_orders;  --  80% sales
-- 167401.6432799999 80% -- add the rows and see where its is matching or close to this no.
-- so we find running total ,we use window function

with 
product_wise_sales as 
(
	select  Product_ID,sum(sales) as product_sales 
	from superstore_orders
	group by Product_ID 
),
calc_sales as 
(
	select Product_ID,
			product_sales,
			sum(product_sales) over (order by product_sales desc rows between unbounded preceding and 0 preceding) as running_sales,
			0.8*sum(product_sales) over () as total_sales
	from product_wise_sales 
)
select * from calc_sales where running_sales <= total_sales;

create table person(
	person_id int,
	name char(10),
	email varchar(30),
	score int
);
--alter  table person MODIFY column person_id int;
--drop table person;

select * from person;
insert into person values(1,'Alice','alice2018@hotmail.com',88);
insert into person values(2,'bob','bob2018@hotmail.com',11);
insert into person values(3,'davis','davis2018@hotmail.com',27);
insert into person values(4,'tara','tara2018@hotmail.com',45);
insert into person values(5,'john','john2018@hotmail.com',63);

create table friend(
	personid int,
	friend_id int
);

select * from friend;
insert into friend values (1,2);
insert into friend values (1,3);
insert into friend values (2,1);
insert into friend values (2,3);
insert into friend values (3,5);
insert into friend values (4,2);
insert into friend values (4,3);
insert into friend values (4,5);
select * from friend;

--delete from friend;
--drop table friend;

select * from person;
select * from friend;

-- Tampilkan detail teman seseorang beserta nilai (score) teman tersebut
select f.personid,
	   f.friend_id,
	   p.score as friend_score 
from friend f
inner join person p on f.personid=p.person_id;

-- Cari personid, name, jumlah teman, dan jumlah nilai (marks) dari 
-- seseorang yang memiliki teman dengan total nilai (marks) lebih dari 100.
with 
score_details as 
(
	select f.personid,
		   sum(score) as total_friend_score, 
		   COUNT(1) AS no_of_friends 
	from friend f
	inner join person p on f.personid=p.person_id
	group by f.personid
	having SUM(P.SCORE) >100
) 
select s.*,
	   p.name as person_name 
from person p
inner join score_details s on p.person_id=s.personid;


CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    city VARCHAR(100)
);

select * from employees;
INSERT INTO employees (city) VALUES
    ('New York'),
    ('Los Angeles'),
    ('Chicago'),
    ('Houston'),
    ('Phoenix'),
    ('Philadelphia'),
    ('San Antonio'),
    ('San Diego'),
    ('Dallas'),
    ('San Jose');
insert into employees (city) values ('America');
INSERT INTO employees (city) VALUES
    ('Austin'),
    ('Atlanta'),
    ('Seattle');
select city from employees e ;

-- tampilkan nama city yang tidak berawalan huruf vokal
SELECT DISTINCT city 
FROM employees 
WHERE substring(city, 1, 1) NOT IN ('A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u')

-- tampilkan nama city yang tidak berawalan dan tidak berakhiran huruf vokal
SELECT DISTINCT city 
FROM employees 
WHERE 
    SUBSTRING(city, 1, 1) NOT IN ('A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u')
    AND RIGHT(city, 1) NOT IN ('A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u');

-- tampilkan nama city berawalan huruf vokal
select distinct city 
from employees 
where substring(city,1,1) IN ('A','E','I','O','U','a','e','i','o','u');

-- tampilkan data duplikat email pada table person
-- SELECT email 
-- FROM person;

SELECT email 
FROM person 
GROUP BY email 
HAVING COUNT(*) > 1;

-- tampilkan jumlah data duplikat email pada table person
SELECT email, count(1)
FROM person 
GROUP BY email 
HAVING count(1)>1;

-- NOMOR 14
-- SKIP
-- NOMOR 15
ALTER TABLE superstore_orders
ADD COLUMN order_date DATE;
select * from superstore_orders;

-- Memperbarui tanggal pesanan untuk order_id 1-2 menjadi 13-01-2021
UPDATE superstore_orders
SET order_date = '2021-01-13'
WHERE order_id BETWEEN 1 AND 2;
select * from superstore_orders;

-- Memperbarui tanggal pesanan untuk order_id 3-4 menjadi 14-01-2021
UPDATE superstore_orders
SET order_date = '2021-01-14'
WHERE order_id BETWEEN 3 AND 4;
select * from superstore_orders;

-- Memperbarui tanggal pesanan untuk order_id 5-7 menjadi 14-01-2022
UPDATE superstore_orders
SET order_date = '2022-01-14'
WHERE order_id BETWEEN 5 AND 7;
select * from superstore_orders;

-- Memperbarui tanggal pesanan untuk order_id 8-10 menjadi 15-01-2023
UPDATE superstore_orders
SET order_date = '2023-01-15'
WHERE order_id BETWEEN 8 AND 10;
select * from superstore_orders;

-- jumlahkan sales di setiap tahun (Tanpa CTE)
SELECT EXTRACT(year FROM order_date) AS order_year, 
	   SUM(sales) AS sales 
FROM superstore_orders 
GROUP BY EXTRACT(year FROM order_date)
order by order_year;

-- jumlahkan sales di setiap tahun (Dengan CTE)
WITH 
year_sales AS 
(
    SELECT EXTRACT(year FROM order_date) AS order_year, 
           SUM(sales) AS sales 
    FROM superstore_orders 
    GROUP BY EXTRACT(year FROM order_date)
)
SELECT * FROM year_sales ORDER BY order_year;

-- Fungsi LAG dalam SQL digunakan untuk mengambil nilai dari baris sebelumnya 
-- dalam suatu urutan. Ini memungkinkan Anda untuk membandingkan nilai pada baris 
-- saat ini dengan nilai pada baris sebelumnya dalam hasil kueri.

-- tampilkan jumlah sales tiap tahun, 
-- tampilkan jumlah sales tahun sebelumnya, dan
-- tampilkan selisih jumlah sales tiap tahunnya
WITH year_sales AS (
    SELECT DATE_PART('year', order_date) AS order_year, 
           SUM(sales) AS sales 
    FROM superstore_orders 
    GROUP BY DATE_PART('year', order_date)
)
SELECT *,
       LAG(sales, 1, 0) OVER (ORDER BY order_year) AS previous_year_sales,
       sales - LAG(sales, 1, 0) OVER (ORDER BY order_year) AS sales_change
FROM year_sales  
ORDER BY order_year;

-- tampilkan jumlah sales tiap tanggal yang ada, 
-- tampilkan jumlah sales tanggal sebelumnya, dan
-- tampilkan selisih jumlah sales tiap tanggal
WITH date_sales AS (
    SELECT order_date, 
           SUM(sales) AS sales 
    FROM superstore_orders 
    GROUP BY order_date
)
SELECT *,
       LAG(sales, 1, 0) OVER (ORDER BY order_date) AS previous_date_sales,
       sales - LAG(sales, 1, 0) OVER (ORDER BY order_date) AS sales_change
FROM date_sales  
ORDER BY order_date;

-- tampilkan jumlah sales tiap tahun, dan
-- tampilkan jumlah sales di tiap tahun berikutnya
WITH year_sales AS (
    SELECT EXTRACT(year FROM order_date) AS order_year, 
           SUM(sales) AS sales 
    FROM superstore_orders 
    GROUP BY EXTRACT(year FROM order_date)
)
SELECT *,
       LEAD(sales, 1, 0) OVER (ORDER BY order_year) AS next_year_sales
FROM year_sales  
ORDER BY order_year;



insert into empm values
(1, 'Ankit', '1000', 10000, 4);

select * from empm;

-- Menghapus data duplikat
WITH ranked_employees AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY emp_name, salary ORDER BY emp_id) AS row_num
    FROM empm
)
DELETE FROM empm
WHERE (emp_name, salary, emp_id) IN (
    SELECT emp_name, salary, emp_id
    FROM ranked_employees
    WHERE row_num > 1
);

-- tampilkan salary terbesar
select max(salary) 
from emp 
where salary < (select max(salary) from emp);

-- tampilkan satu baris data dengan gaji tertinggi.
SELECT * 
FROM (
    SELECT * 
    FROM emp 
    ORDER BY salary desc
    limit 1
) AS SAL_ORDER;
-- Tampilkan salary tertinggi ke dua
with 
salary_cte as
(
	SELECT * , 
		    DENSE_RANK() OVER(order by salary desc) as sal_order 
	FROM emp
)
select * from salary_cte where sal_order = 2;

-- TAmpilkan nama manager setiap employee
SELECT e.emp_id,
	   e.emp_name as employeeee,
	   m.emp_name as magr_name
FROM EMPM e 
INNER JOIN empm m on e.manager_id=m.emp_id;

-- tampilkan employee yang memiliki salary lebih dari 10000
select * from emp where salary>10000;

-- hitung rata-rata gaji per departemen
-- gunakan klausa HAVING untuk rata-rata gajinya lebih besar dari 9500.
select department_id,
	   avg(salary)
from emp group by department_id
having avg(salary) > 9500 ;

-- select * from emp;

-- hitung rata-rata gaji per departemen
-- hanya untuk karyawan yang memiliki gaji di atas 10.000
-- gunakan klausa HAVING untuk rata-rata gajinya lebih besar dari 12.000
select department_id,avg(salary) 
from emp
where salary > 10000 
group by department_id
having avg(salary) > 12000 ;


-- nalytical Functions | Lead | Lag
create table sales_table(
	year int,
	quater_name varchar(5),
	sales int
);

select * from sales_table;
insert into sales_table values (2018,'Q1',5000);
insert into sales_table values (2018,'Q2',5500);
insert into sales_table values (2018,'Q3',2500);
insert into sales_table values (2018,'Q4',10000);
insert into sales_table values (2019,'Q1',10000);
insert into sales_table values (2019,'Q2',5500);
insert into sales_table values (2019,'Q3',3000);
insert into sales_table values (2019,'Q4',6000);
select * from sales_table;

-- tampilkan laporan penjualan per kuartal. mencakup informasi tahun (years), 
-- nama kuartal (quaters), penjualan saat ini (current_sales), dan penjualan kuartal 
-- sebelumnya (previous_quater_sales).
select year as years,
	   quater_name as quaters,
	   sales as current_sales,
	   LAG(sales) OVER(partition by year order by quater_name) as previous_quater_sales
from sales_table;

-- tampilkan laporan penjualan per kuartal. mencakup informasi tahun (years), 
-- nama kuartal (quaters), penjualan saat ini (current_sales), dan penjualan kuartal 
-- sebelumnya (previous_quater_sales).
-- penjualan dua kuartal sebelumnya.
select year as years,
	   quater_name as quaters,
	   sales as current_sales,
	   LAG(sales,2) OVER(partition by year order by quater_name) as previous_quater_sales
from sales_table;

-- lead function opposite of lag
-- tampilkan laporan penjualan per kuartal. mencakup informasi tahun (years), 
-- nama kuartal (quaters), penjualan saat ini (current_sales), dan penjualan kuartal 
-- sebelumnya (previous_quater_sales).
-- DESC
select year as years,
	   quater_name as quaters,
	   sales as current_sales,
	   Lead(sales) OVER(partition by year order by quater_name desc) as previous_quater_sales
from sales_table;

create table empy2(
	emp_id int,
	name varchar(20)
);

select * from empy2;
insert into empy2 values (1,'Owens, Adams');
insert into empy2 values (2,'Hopkins, David');
insert into empy2 values (1,'Jonas, Mary');
insert into empy2 values (1,'Rhodes, Susssan');

UPDATE empy2
SET emp_id = '2'
WHERE name like '%Hopkins%';
select * from empy2;

UPDATE empy2
SET emp_id = '3'
WHERE name like '%Jonas%';
select * from empy2;

UPDATE empy2
SET emp_id = '4'
WHERE name like '%Rhodes%';
select * from empy2;

-- Cari posisi koma pada string ke berapa
SELECT name, POSITION(',' IN name) AS position_of_comma FROM empy2;

-- tampikan nama sebelum koma
SELECT name, LEFT(name, POSITION(',' IN name) - 1) AS last_name FROM empy2;

-- pisahkan isi name dari koma, tempatkan pada
-- kolom last name(kiri) dan first name(kanan)
SELECT 
    name, 
    LEFT(name, POSITION(',' IN name) - 1) AS last_name,
    RIGHT(name, LENGTH(name) - POSITION(',' IN name)) AS first_name
FROM 
    empy2;
   
-- Pisahkan nama depan dan belakang dari koma, tampung pada tabel bernama value
SELECT unnest(string_to_array('Owens, Adams', ',')) AS value;

-- Pisahkan nama depan dan belakang dari koma, menggunakan CROSS JOIN
SELECT emp_id, value,
       row_number() OVER(PARTITION BY emp_id ORDER BY emp_id ) AS row_num
FROM empy2
CROSS JOIN LATERAL unnest(string_to_array(name, ',')) AS value;

-- Dari kueri diatas/sebelumnya buat dalam bentuk pivot
WITH NAME_CTE AS (
    SELECT emp_id, 
           value AS value,
           row_number() OVER(PARTITION BY emp_id ORDER BY emp_id ) AS row_num
    FROM empy2
    CROSS JOIN LATERAL unnest(string_to_array(name, ',')) AS value
)
SELECT emp_id,
       MAX(CASE WHEN row_num = 1 THEN value END) AS last_name,
       MAX(CASE WHEN row_num = 2 THEN value END) AS first_name
FROM NAME_CTE
GROUP BY emp_id;


SELECT * FROM superstore_orders;
-- tampilkan hari dari tanggal yang ada pada order date
SELECT TO_CHAR(order_date, 'Day') AS day_of_week, order_date FROM superstore_orders;

-- tampilkan hari ke berapa dalam week
SELECT EXTRACT(DOW FROM order_date) AS day_of_week, order_date 
FROM superstore_orders;

-- tampilkan hari ke berapa dalam week
SELECT 
    CASE 
        WHEN EXTRACT(DOW FROM order_date) = 0 THEN 7
        ELSE EXTRACT(DOW FROM order_date)
    END AS day_of_week,
    order_date 
FROM 
    superstore_orders;
   
create table emp_mgr_age
(
	emp_id int,
	emp_name Varchar(20),
	department_id Varchar(20),
	salary int,
	manager_id int,
	emp_age int
);

INSERT INTO emp_mgr_age values(1,'Ankit',100,10000,4,39);
INSERT INTO emp_mgr_age values(2,'Mohit',100,15000,5,48);
INSERT INTO emp_mgr_age values(3,'Vikas',100,10000,4,37);
INSERT INTO emp_mgr_age values(4,'Rohit',100,5000,2,16);
INSERT INTO emp_mgr_age values(5,'Mudit',200,12000,6,55);
insert INTO emp_mgr_age values(6,'Agam',200,12000,2,14);
INSERT INTO emp_mgr_age values(7,'Sanjay',200,9000,2,13);
INSERT INTO emp_mgr_age values(8,'Ashish',200,5000,2,12);
INSERT INTO emp_mgr_age values(9,'Rakesh',300,5000,6,51);
INSERT INTO emp_mgr_age values(10,'Mukesh',300,5000,6,50);
select * from emp_mgr_age;

-- tampilkan usia setiap karyawan
-- usia kurang dari 20 = Kids
-- usia 20 sampai 40 = Adult
-- usia lebih dari 40 = old
select  * ,
		CASE 
			when emp_age < 20 then 'Kids'
		    when emp_age >= 20 and emp_age <=40 then 'Adult'
		    else 'old'
		End as emp_age_bracket
from emp_mgr_age
order by emp_age;


CREATE TABLE dept (
    dept_id INT PRIMARY KEY,
    dep_name VARCHAR(100)
);

INSERT INTO dept VALUES (100, 'Data Analytics');
INSERT INTO dept VALUES (200, 'Business Analytics');
INSERT INTO dept VALUES (300, 'Marketing Analytics');
INSERT INTO dept VALUES (400, 'Text Analytics');
select * from dept;

--truncate table dept;

-- ganti nilai dep_name yang berisi "Analytics" dengan "Mining"
-- dan ganti isi nilai string emp_name dari string ke 1 sampai ke 4
-- dengan "demo" 
SELECT *,
       REPLACE(dep_name, 'Analytics', 'Mining') AS replace_string,
       CONCAT('demo', SUBSTRING(dep_name FROM 4)) AS stuff_string
FROM dept;
select * from dept;

-- ganti nilai dep_name yang berisi "Analytics" dengan "Mining"
-- dan ganti isi nilai string emp_name dari string ke 1 sampai ke 4
-- dengan "demo".
-- Tampilkan string apa yang diganti dari string 1 sampai ke 4.
SELECT *,
       REPLACE(dep_name, 'Analytics', 'Mining') AS replace_string,
       CONCAT('demo', SUBSTRING(dep_name FROM 4)) AS stuff_string,
       SUBSTRING(dep_name from 1 for 4) AS substring_string
FROM dept;

SELECT *,
       REPLACE(dep_name, 'Analytics', 'Mining') AS replace_string,
       CONCAT('demo', SUBSTRING(dep_name FROM 4)) AS stuff_string,
       SUBSTRING(dep_name FROM 2 FOR 3) AS substring_string,
       REPLACE(dep_name, 'A', 'S') AS translate_string
FROM dept;

SELECT *,
       REPLACE(dep_name, 'Analytics', 'Mining') AS replace_string,
       CONCAT('demo', SUBSTRING(dep_name FROM 4)) AS stuff_string,
       SUBSTRING(dep_name FROM 2 FOR 3) AS substring_string,
       REPLACE(REPLACE(dep_name, 'A', 'S'), 'R', 'T') AS translate_string
FROM dept;

SELECT dept_id,
       dep_name,
       REPLACE(dep_name, 'Analytics', 'Mining') AS replace_string,
       CONCAT('demo', SUBSTRING(dep_name FROM 4)) AS stuff_string,
       SUBSTRING(dep_name FROM 2 FOR 3) AS substring_string,
       REPLACE(REPLACE(REPLACE(dep_name, 'A', 'S'), 'a', 's'), 'R', 'r') AS translate_string
FROM dept;


CREATE TABLE returns (
    order_id INT PRIMARY KEY,
    return_reason VARCHAR(100)
);
INSERT INTO returns (order_id, return_reason) VALUES
(3, 'Wrong item received'),
(6, 'Defective product'),
(8, 'Item not as described');
SELECT * FROM returns;

SELECT * FROM Superstore_orders;

UPDATE superstore_orders
SET city = 'New York'
WHERE order_id BETWEEN 1 AND 4;

UPDATE superstore_orders
SET city = 'London'
WHERE order_id BETWEEN 5 AND 8;

UPDATE superstore_orders
SET city = 'Japan'
WHERE order_id BETWEEN 9 AND 10;

-- tampilkan jumlah returns dari negara yang mengalami return.
select city,
	   sum(sor.sales) 
from Superstore_orders as sor 
inner join returns ru on sor.order_ID=ru.Order_ID
group by city;

-- tampilkan orderr yang tidak mengalami returns
select sor.order_id,
	   ru.order_id,
	   sor.sales 
from Superstore_orders as sor 
left join returns ru on sor.order_ID=ru.Order_ID
where ru.Order_ID is null;

-- tampilkan order yang mengalami returns
select sor.order_id,
	   ru.order_id,
	   sor.sales
from Superstore_orders as sor 
right join returns ru on sor.order_ID=ru.Order_ID;

-- UNSOLVED DOCUMENTATION
SELECT COALESCE(sor.order_id, ru.order_id) AS order_id_final,
       sor.sales AS sales
FROM superstore_orders AS sor 
CROSS JOIN returns ru
WHERE sor.order_ID = ru.Order_ID;

create table empl
(
	emp_id int,
	emp_name Varchar(20),
	department_id Varchar(20),
	salary int,
	manager_id int,
	emp_age int
);

INSERT INTO empl values(1,'Ankit',100,10000,4,39);
INSERT INTO empl values(2,'Mohit',100,15000,5,48);
INSERT INTO empl values(3,'Vikas',100,10000,4,37);
INSERT INTO empl values(4,'Rohit',100,5000,2,16);
INSERT INTO empl values(5,'Mudit',200,12000,6,55);
INSERT INTO empl values(6,'Agam',200,12000,2,14);
INSERT INTO empl values(7,'Sanjay',200,9000,2,13);
INSERT INTO empl values(8,'Ashish',200,5000,2,12);
INSERT INTO empl values(9,'Mukesh',300,6000,6,51);
INSERT INTO empl values(10,'Rakesh',300,7000,6,50);
select * from empl;

-- tampilkan salary karyawan yang lebih dari rata rata gaji semua karyawan.
-- pakai sub-kueri
select * from empl 
where salary>(select avg(salary) from empl);

-- tampilkan salary karyawan yang lebih dari rata rata gaji semua karyawan.
-- pakai CTE
with avg_salary as 
(
	select avg(salary) as avg_sal 
	from empl
)
select * from empl
inner join avg_salary on salary > avg_sal;

-- tampilkan rata rata gaji menggunakan 2 cte
with avg_salary as 
(
	select avg(salary) as avg_sal from empl
),
max_sal as 
(
	select max( avg_sal) as  "max_sal a.k.a avg_sal" from avg_salary 
)
select * from max_sal;

-- UNSOLVED DOCUMENTATION
with value_S as (
    select *,
        row_number() over (order by emp_age asc) as rn_asc,
        row_number() over (order by emp_age desc) as rn_desc
    from empl
--    where EMP_ID < 10
)
select avg(emp_age)
from value_S
where abs(rn_asc - rn_desc) <= 1;

create table tasks (
	date_value date,
	state varchar(10)
);

insert into tasks  values 
('2019-01-01','success'),
('2019-01-02','success'),
('2019-01-03','success'),
('2019-01-04','fail'),
('2019-01-05','fail'),
('2019-01-06','success');

-- tampiilkan row number/urutan tasks sukses dan fail
select *,
	   row_number() over(partition by state order by date_value) as  rn
from tasks
order by date_value;

-- KUERI POSTGRESQL
-- Tampilkan waktu mulai dan akhir setiap state yang ada
WITH all_dates AS 
(
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY state ORDER BY date_value) AS rn
    FROM tasks
)
SELECT state,
       MIN(date_value) AS start_date,
       MAX(date_value) AS end_date
FROM (
    SELECT *,
           date_value - interval '1' day * (rn - 1) AS group_date
    FROM all_dates
) as subquery
GROUP BY group_date, state
ORDER BY start_date;

-- KUERI SSMS
-- with all_dates as 
-- (
-- 	select *,
-- 		row_number() over(partition by state order by date_value) as  rn,
-- 		dateadd(day,-1*row_number() over(partition by state order by date_value) as group_date)
-- 	from tasks
-- )
-- select state,
-- 	   min(date_value) as start_date,
-- 	   max(date_value) as end_date,
-- 	   state 
-- from all_date 
-- group by group_date,state
-- order by start_date;

-- KUERI MYSQL
-- WITH all_dates AS (
--     SELECT *,
--            ROW_NUMBER() OVER(PARTITION BY state ORDER BY date_value) AS rn,
--            DATE_SUB(date_value, INTERVAL (ROW_NUMBER() OVER(PARTITION BY state ORDER BY date_value) - 1) DAY) AS group_date
--     FROM tasks
-- )
-- SELECT state,
--        MIN(date_value) AS start_date,
--        MAX(date_value) AS end_date
-- FROM all_dates
-- GROUP BY group_date, state
-- ORDER BY start_date;

create table activity (
	player_id int,device_id int, 
	event_date date, 
	games_played  int 
);

insert into activity values 
(1,2,'2016-03-01',5 ),
(1,2,'2016-03-02',6 ),
(2,3,'2017-06-25',1 ),
(3,1,'2016-03-02',0 ),
(3,4,'2018-07-03',5 );

select * from activity;

-- Tampilkan laporan pertama kali login untuk semua player
select player_id, 
	   min(event_date) as first_time_login 
from activity 
group by player_id;

-- Tampilkan laporan device id yang dipakai login oleh player untuk pertama kalinya,
-- untuk semua player.
select * 
from (select *,
		     rank() over(partition by player_id order by event_date) as rn
	  from activity
) as a
where rn=1;

-- tampilkan laporan dari setiap player
-- berapa kali game yang telah dimainkan oleh player
-- setiap tanggal diperoleh total keseluruhan dari awal.
select *,
	   sum(games_played) over(partition by player_id order by event_date) as total_played
from activity;

-- cari kejadian di mana seorang pemain telah masuk kembali ke dalam permainan 
-- tepat pada hari setelah hari pertama mereka masuk.
WITH mindate AS (
    SELECT player_id, MIN(event_date) AS first_date 
    FROM activity 
    GROUP BY player_id
)
SELECT a.*, md.first_date
FROM activity a
INNER JOIN mindate md ON a.player_id = md.player_id
WHERE a.event_date - md.first_date = 1;

-- KUERI MYSQL
-- WITH mindate AS (
--     SELECT player_id, MIN(event_date) AS first_date 
--     FROM activity 
--     GROUP BY player_id
-- )
-- SELECT a.*, md.first_date
-- FROM activity a
-- INNER JOIN mindate md ON a.player_id = md.player_id
-- WHERE DATEDIFF(a.event_date, md.first_date) = 1;

create table customern (
	customer_id int,
	customer_name varchar(10),
	gender varchar(2),
	dob date,
	age int
);

alter table customern
	drop column dob,
	add column dob timestamp default current_timestamp;

alter table customern
	drop column dob,
	add column dob int;

truncate table customern;

select * from customern;
insert into customern (customer_id, customer_name, gender, dob, age) values 
(1,'Rahul','M',current_date(),22),
(2,'Shilpa','F',current_date(),18),
(3,'Ramesh','M',current_date(),19),
(4,'Katrina','F',current_date(),17),
(5,'Alia','F',current_date(),30),
(6,'All','M',null,null);

insert into customern values (1,'Rahul','M',22);
insert into customern values (2,'Shilpa','F',18);
insert into customern values (3,'Ramesh','M',19);
insert into customern values (4,'Katrina','F',17);
insert into customern values (5,'Alia','F',30);
insert into customern values (6,'All','M',null,null);

-- Kueri untuk filterring data, yang berhubungan dengan null
select * FROM  customern where null=null;
select * FROM  customern where dob is null;
select * FROM  customern where dob is not null;

-- tampilkan semua data, jika data age null, tampilkan age(null age) 11
select *, coalesce(age, 11)as "age(null age)" from customern;

-- tampilkan semua data, jika data dob null, tampilkan col '2020-01-01'
select *,coalesce(dob, '2020-01-01') as col from customern;

-- gabungan dari kueri diatas
select *,
	   coalesce(age, 11)as "age(null age)",
	   coalesce(dob, '2020-01-01') as col
from customern;

-- tampilkan jumlah data age yang terisi
select count(age) from customern;

-- tampilkan jumlah data age (termasuk data age yang null)
select count(coalesce(age,0)) from customern;

-- tampilkan rata rata data age (kecuali data age yang null)
select avg(age) from customern;

-- tampilkan rata rata data age (termasuk data age yang null=0)
select avg(coalesce(age,0)) from customern;

-- Coba untuk membuat kueri yang berjalan, tanpa menggunakan table apapun,
-- gunakan CTE untuk menampung data.
with emp as 
(
	select 1 as emp_id,1000 as emp_salary,1 as dep_id
	union all select 2 as emp_id,2000 as emp_salary,2 as dep_id
	union all select 3 as emp_id,3000 as emp_salary,3 as dep_id
	union all select 4 as emp_id,4000 as emp_salary,4 as dep_id
),
dep as 
(
	select 1 as dep_id,'d1' as dep_name
	union all select 2 as dep_id,'d2' as dep_name
	union all select 3 as dep_id,'d3' as dep_name
	union all select 4 as dep_id,'d4' as dep_name
)
SELECT emp.*, dep.*
FROM emp
JOIN dep ON emp.dep_id = dep.dep_id;

