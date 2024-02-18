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

create table orderss (
	order_id int,
	customer_id int,
	product_id int
);
insert into orderss VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products(
	id int,
	name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

select * from products;
select * from orderss;

-- UNRESOLVED DOCUMENTATION
select o1.order_id,
	   o1.product_id as p1,
	   o2.product_id as p2 
from orderss o1
inner join orderss o2 on o1.order_id = o2.order_id
where o1.order_id = 1 and o1.product_id != o2.product_id and o1.product_id != o2.product_id ;

-- select o1.product_id as p1,o2.product_id as p2 ,count(1) as purchase_frequency from orderss o1
-- inner join orderss o2 on o1.order_id=o2.order_id
-- where o1.product_id < o2.product_id 
-- group by  o1.product_id ,o2.product_id ;
-- 
-- select pr1.name as p1,pr2.name as p2,count(1) as purchase_frequency from orderss o1
-- inner join orderss o2 on o1.order_id=o2.order_id
-- inner join products pr1 on pr1.id=o1.product_id
-- inner join products pr2 on pr2.id=o2.product_id
-- where o1.product_id < o2.product_id 
-- group by  pr1.name ,pr2.name;

-- hapus nol di depan dan di belakang angka pecahan (float) dalam kolom sales
select * from superstore_orders;
select sales,
	   cast(sales as float) as Amount_trailed 
from superstore_orders;


CREATE TABLE employe (
    id INT,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    DepartmentName VARCHAR(50),
    Salary DECIMAL(10, 2),
    HireDate DATE
);

INSERT INTO employe (id, firstname, lastname, DepartmentName, Salary, HireDate) VALUES
(1, 'John', 'Doe', 'HR', 50000.00, '2019-01-15'),
(2, 'Jane', 'Smith', 'Finance', 60000.00, '2020-03-20'),
(3, 'Michael', 'Johnson', 'IT', 55000.00, '2018-11-10'),
(4, 'Emily', 'Williams', 'Marketing', 48000.00, '2019-09-05'),
(5, 'Christopher', 'Brown', 'Operations', 52000.00, '2021-02-28');

select * from employe;

-- select *,
-- 	   datediff(YEAR,HireDAate,'2020-12-31') from employe 
-- WHERE datediff(YEAR,HireDate,'2020-12-31');

-- Tampilkan karyawan yang telah bekerja selama minimal dua tahun perusahaan 
-- pada tanggal tertentu, dalam hal ini tanggal 31 Desember 2020.
SELECT *, 
       EXTRACT(YEAR FROM AGE('2020-12-31', HireDate)) AS YearsWithCompany
FROM employe 
WHERE EXTRACT(YEAR FROM AGE('2020-12-31', HireDate)) >= 2;

-- KUERI MYSQL
SELECT *, 
	   TIMESTAMPDIFF(YEAR, HireDate, '2020-12-31') AS YearsWithCompany
FROM employe 
WHERE TIMESTAMPDIFF(YEAR, HireDate, '2020-12-31') >= 2;


-- Naikkan salary  karyawan yang telah bekerja selama minimal dua tahun perusahaan 
-- pada tanggal tertentu, dalam hal ini tanggal 31 Desember 2020.
SELECT *, 
	   Salary * 1.15 AS incrementedSalary,
       EXTRACT(YEAR FROM AGE('2020-12-31', HireDate)) AS YearsWithCompany
FROM employe 
WHERE EXTRACT(YEAR FROM AGE('2020-12-31', HireDate)) >= 2;

-- KUERI MYSQL
SELECT *,
   	   Salary * 1.15 AS incrementedSalary, 
       TIMESTAMPDIFF(YEAR, HireDate, '2020-12-31') AS yearsWithCompany
FROM employe 
WHERE TIMESTAMPDIFF(YEAR, HireDate, '2020-12-31') >= 2;

CREATE TABLE saless (
    category varchar(15),
    "2015" int,
    "2016" int,
    "2017" int,
    "2018" int,
    "2019" int,
    "2020" int
);

insert into saless values ('Hot Drinks',20000,15000,28000,12000,40000,10000);
insert into saless values ('Cold Drinks',18000,36000,10000,12000,8000,2000);
select * from saless;

-- lakukan unpivot dengan menggunakan UNION ALL untuk menggabungkan hasil 
-- dari setiap tahun ke dalam satu kolom Sales.

SELECT Category, Year, Sales
FROM (
    SELECT Category, '2015' AS Year, "2015" AS Sales FROM saless
    UNION ALL
    SELECT Category, '2016' AS Year, "2016" AS Sales FROM saless
    UNION ALL
    SELECT Category, '2017' AS Year, "2017" AS Sales FROM saless
    UNION ALL
    SELECT Category, '2018' AS Year, "2018" AS Sales FROM saless
    UNION ALL
    SELECT Category, '2019' AS Year, "2019" AS Sales FROM saless
    UNION ALL
    SELECT Category, '2020' AS Year, "2020" AS Sales FROM saless
) AS UNPIVT_SALES;

create table pemp(
	Name varchar(10),
	Value varchar(10),
	ID int
);
select * from pemp;
insert into pemp values ('Name','Adam',1);
insert into pemp values ('Gender','Male',1);
insert into pemp values ('Salary','50000',1);
insert into pemp values ('Name','Adam',2);
insert into pemp values ('Gender','Male',2);
insert into pemp values ('Salary','50000',2);
select * from pemp;

-- ubah bentuk data baris ke bentuk kolom 
SELECT 
    ID,
    MAX(CASE WHEN Name = 'Name' THEN Value END) AS Name,
    MAX(CASE WHEN Name = 'Gender' THEN Value END) AS Gender,
    MAX(CASE WHEN Name = 'Salary' THEN Value END) AS Salary
FROM pemp
GROUP BY ID;

create table Dpemp(
	Name varchar(10),
	Value varchar(10),
	ID int
);

select * from Dpemp;
insert into Dpemp values ('Name','Adam',1);
insert into dpemp values ('Gender','Male',1);
insert into dpemp values ('Salary','50000',1);
insert into dpemp values ('Name','Mila',2);
insert into dpemp values ('Gender','FeMale',2);
insert into dpemp values ('Salary','50000',2);
select * from Dpemp;

-- tampilkan baris yang akan dijadikan kolom
SELECT STRING_AGG(Name, ',') 
FROM (
    SELECT DISTINCT Name 
    FROM Dpemp
) AS dp;

CREATE TABLE Empp(
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	HireDate date NULL 
);
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Alice',	'Ciccu','2024-01-07');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Paula',	'Barreto de Mattos','2024-01-06');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Alejandro',	'McGuel','2023-12-06');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Kendall',	'Keil',	'2024-01-05');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Ivo',	'Salmre','2023-10-04');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Paul',	'Komosinski','2023-08-04');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Ashvini',	'Sharma','2023-07-04');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Zheng',	'Mu','2024-01-03');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Stuart',	'Munson','2021-11-02');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('Greg',	'Alderson','2024-01-02');
INSERT INTO Empp (FirstName,LastName,HireDate) VALUES ('David',	'Johnson','2023-01-02');
select * from empp;
-- truncate table empp;

-- tampilkan empp yang di hire kurang dari  2 bulan
SELECT * FROM Empp
WHERE 
    (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM HireDate)) * 12 +
    (EXTRACT(MONTH FROM CURRENT_DATE) - EXTRACT(MONTH FROM HireDate)) < 2;

   -- tampilkan lama bekerja setiap empp dari awal di hire
SELECT *,
       (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM HireDate)) * 12 +
       (EXTRACT(MONTH FROM CURRENT_DATE) - EXTRACT(MONTH FROM HireDate)) AS months_since_hire
FROM Empp
order by months_since_hire DESC;

-- tampilkan karyawan yang bekerja kurang dari 12 bulan sebagai junior
SELECT *,
    CASE 
        WHEN (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM HireDate)) * 12 +
             (EXTRACT(MONTH FROM CURRENT_DATE) - EXTRACT(MONTH FROM HireDate)) < 12
        THEN 'Junior' 
        ELSE 'Senior' 
    END AS hired_last_2_month
FROM Empp
order by hired_last_2_month DESC;

-- buat huruf pertama dari firstname menjadi huruf kecil
Select Lower(LEFT(FirstName, 1))
from Empp;

-- buat huruf pertama dari firstname menjadi huruf kecil
-- dan tampilkan nama lengkapnya setelah menjadi huruf kecil
SELECT FirstName, 
       LOWER(LEFT(FirstName, 1)) || SUBSTRING(FirstName, 2, LENGTH(FirstName)) || 
       ' ' || lastname as Name 
FROM Empp;

create table dimEmp (
	first_name varchar(15),
	last_name varchar(15),
	Birth_Date date
);
select * from dimEmp;
insert into dimEmp values ('Gey','Gilbent','1981-11-12');
insert into dimEmp values ('kevin','brown','1960-02-29');
insert into dimEmp values ('Roberto','Tombunelo','1961-03-01');
insert into dimEmp values ('Gey','Gilbent','1971-07-23');
insert into dimEmp values ('Rob','Walters','1974-07-23');
insert into dimEmp values ('Rob','Walters','1974-07-23');
insert into dimEmp values ('therry','deheris','1961-02-26');
insert into dimEmp values ('David','Bradley','1974-10-17');
insert into dimEmp values ('David','Bradley','1974-10-17');
insert into dimEmp values ('jolyn','dobley','1961-02-16');
insert into dimEmp values ('ruth','book','1961-02-28');

-- tampilkan tahun lahir yang baru, dengan interval 60 tahun
SELECT 
    first_name, 
    last_name, 
    Birth_Date, 
    Birth_Date + INTERVAL '60 year' AS New_Birth_Date
FROM 
    dimEmp
WHERE 
    Birth_Date + INTERVAL '60 year' <= (SELECT DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' - INTERVAL '1 day');

   
create table survey (
	surveyid int,
	response varchar(150)
);
-- DROP TABLE survey;
select * from survey;
insert into survey values (1,'ZZZZZXXXXCCCVVVBBNNMMLLKHJFGDFSDASASSAAQWEWERETRTYRYIYYIOIPUT');
insert into survey values (2,'QWPDHBCNFDHFFGALSDDCS');
truncate survey;

-- mengganti semua kemunculan karakter 'Y' dengan string kosong, 
-- dan menghitung panjang (length) dari string hasil penggantian.
SELECT surveyid,
	   response,
	   length(response), 
	   replace(response,'Y',''), 
	   length(replace(response,'Y',''))
 from survey;
 
-- Mengambil surveyid, response, dan menghitung berapa kali karakter 'Y' 
-- muncul dalam setiap baris kolom response.
SELECT surveyid,
	   response,
	   length(response) - length(replace(response,'Y','')) as stringoccured
 from survey;
 
CREATE TABLE superstore_orderss (
    Order_ID int,
    Customer_Name varchar(100),
    Product_Name varchar(100)
);
INSERT INTO superstore_orderss (Order_ID, Customer_Name, Product_Name) VALUES
(1, 'Alice Smith', 'Office Chair'),
(2, 'Bob Johnson', 'Desk Lamp'),
(3, 'Charlie Brown', 'Bookshelf'),
(4, 'David Anderson', 'Computer Desk'),
(5, 'Eva Garcia', 'Printer'),
(6, 'Adam Lee', 'Desk Organizer'),
(7, 'Catherine White', 'Paper Shredder'),
(8, 'Diana Martin', 'Scanner'),
(9, 'Alex Thompson', 'Coffee Table'),
(10, 'Carl Davis', 'Filing Cabinet'),
(11, 'Emily Wilson', 'Desk Chair'),
(12, 'Brian Taylor', 'Bookcase'),
(13, 'Emma Harris', 'Desk Mat'),
(14, 'Olivia Clark', 'File Cabinet'),
(15, 'Frank Rodriguez', 'Stapler');
select * from superstore_orderss;

-- start with A
select Customer_Name from superstore_orderss
where Customer_Name like 'A%';
-- end with A
select Customer_Name from superstore_orderss
where Customer_Name like '%A';

select ORDER_ID from superstore_orderss;

-- Kapitalkan semua huruf pada firstname.
SELECT UPPER(FirstName) AS uper_first, FirstName
FROM Empp;

select COUNT(*) from Empp;
select COUNT(1) from Empp;
select COUNT(lastname) from Empp;

select category,
	   max(saless)
from (values([2015]),([2016]),([2017]),([2018]),([2019]),([2020]) as salestable(sales) ) as maxSales
 from saless;

select * from saless;

-- cari harga termahal dari setiap produk pada saless
SELECT category,
       GREATEST("2015", "2016", "2017", "2018", "2019", "2020") AS max_sales
FROM saless;

-- No sales for n consecutive days | Identify date gaps
select order_date from superstore_orders
order by order_date;

-- Tampilkan tanggal pesanan (order_date) dan 
-- tanggal pesanan berikutnya (Lead_date) dalam tabel superstore_orders. 
select order_date,
	   lead(order_date) over(order by order_date) as Lead_date
from superstore_orders
order by order_date;

-- Tampilkan gap/selisih hari tanggal pesanan berikutnya 
-- dalam tabel superstore_orders. 
SELECT 
    order_date,
    EXTRACT(DAY FROM LEAD(order_date) OVER (ORDER BY order_date)) - EXTRACT(DAY FROM order_date) AS Gap
FROM superstore_orders
ORDER BY order_date;

-- tampilkan order yang memiliki gap/selisih 1 hari
SELECT * FROM (
    SELECT 
        order_date,
        EXTRACT(DAY FROM LEAD(order_date) OVER (ORDER BY order_date)) - EXTRACT(DAY FROM order_date) AS gap
    FROM superstore_orders
) AS NoSales
WHERE NoSales.gap > 0;

-- Hari pertama minggu ini
SELECT date_trunc('week', CURRENT_DATE) AS first_day_of_week;

-- Hari terakhir minggu ini
SELECT date_trunc('week', CURRENT_DATE) + INTERVAL '6 days' AS last_day_of_week;


-- Subquery untuk mendapatkan dua gaji tertinggi untuk setiap departemen
WITH top_salaries AS (
    SELECT emp_name, department_id, salary,
           RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS maxsal
    FROM empm
)
-- Menggabungkan dua gaji tertinggi dengan 'others' untuk sisa gaji
SELECT emp_name, department_id, salary
FROM (
    SELECT emp_name, department_id, salary, maxsal
    FROM top_salaries
    WHERE maxsal <= 2 -- Top 2 gaji tertinggi
    UNION ALL
    SELECT 'others' AS emp_name, department_id, SUM(salary) AS salary, 3 AS maxsal -- Jika lebih dari 2 gaji tertinggi
    FROM top_salaries
    WHERE maxsal > 2
    GROUP BY department_id
) AS final_result
ORDER BY department_id, maxsal;

select order_date,sales
from superstore_orders;

-- Total penjualan setiap bulan dari tahun-tahun yang berbeda, LAG: membawa data dari baris sebelumnya
-- Untuk membandingkan data bulan per bulan, bandingkan data bulan tersebut dengan data bulan sebelumnya
SELECT
    EXTRACT(YEAR FROM order_date) AS "Year",
    EXTRACT(MONTH FROM order_date) AS "Month",
    SUM(sales),
    LAG(SUM(sales)) OVER(ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date))
FROM superstore_orders
WHERE EXTRACT(YEAR FROM order_date) IN (2021, 2022)
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date);

select * from entries;
-- Ekstrak domain dari alamat email dengan menggunakan POSITION untuk mendapatkan posisi '@'
SELECT POSITION('@' IN email) AS at_position, email FROM entries;

-- Ekstrak string setelah '@' dengan menggunakan fungsi SUBSTRING
SELECT SUBSTRING(email FROM POSITION('@' IN email) + 1) AS domain FROM entries;

-- Menemukan jumlah email dari domain yang sama dengan mengelompokkan berdasarkan domain
SELECT COUNT(*), SUBSTRING(email FROM POSITION('@' IN email) + 1) AS domain
FROM entries
GROUP BY SUBSTRING(email FROM POSITION('@' IN email) + 1);


-- How to find all levels of Employee Manager Hierarchy | Recursion
-- manager id is null then he is the top most manager in orgz
create table emmp(
	emp_id int,
	emp_name varchar(20),
	department_id int,
	manager_id int
);
select * from emmp;
insert into emmp values(1,'Adam Owens',103,3);
insert into emmp values(2,'Smith Jones',102,5);
insert into emmp values(3,'Hilary Riles',101,4);
insert into emmp values(4,'Richard Robinson',103,3);
insert into emmp values(5,'Samuel Pitt',103,3);
insert into emmp values(6,'Mark Miles',null,7);
insert into emmp values(7,'Jenny Jeff',999,null);
select * from emmp;

-- Menggunakan INNER JOIN untuk menggabungkan tabel karyawan dengan tabel manajer
SELECT emp.emp_name AS EmployeeName, mgr.emp_name AS ManagerName
FROM emmp emp
INNER JOIN emmp mgr ON emp.manager_id = mgr.emp_id;

-- Menggunakan window function untuk menghitung total berjalan atau jumlah kumulatif
SELECT *, 
       SUM(salary) OVER (ORDER BY emp_id) AS RunningTotal
FROM empm;

-- Menggunakan TRANSLATE
SELECT TRANSLATE('xxx1234567891zzz', '123456789', 'abcdefghi');

-- Menggunakan REPLACE
SELECT REPLACE('1234567891', '123456789', 'abcdefghi');

-- Jika kita ingin mengganti seluruh string dengan satu karakter
SELECT REPLACE('1234567891', '123456789', 'a');

-- Hitung total YTD (Year-To-Date)
SELECT order_id,
       order_date,
       sales AS total_due,
       SUM(sales) OVER (PARTITION BY EXTRACT(YEAR FROM order_date) ORDER BY order_id) AS YTD
FROM superstore_orders
ORDER BY order_id;

-- Hitung total MTD (Month-To-Date)
SELECT order_id,
       order_date,
       sales AS total_due,
       SUM(sales) OVER (PARTITION BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date) ORDER BY order_id) AS MTD
FROM superstore_orders
ORDER BY order_id;

-- MTD untuk 3 baris akhir
SELECT order_id,
       order_date,
       sales AS total_due,
       SUM(sales) OVER (PARTITION BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date) ORDER BY order_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MTD_3
FROM superstore_orders
ORDER BY order_id;

-- kueri untuk menghitung nilai order pertama dan terakhir
SELECT 
    order_id,
    order_date,
    sales AS Total_due,
    FIRST_VALUE(order_id) OVER (PARTITION BY EXTRACT(YEAR FROM order_date) ORDER BY order_id, order_date) AS first_order,
    FIRST_VALUE(order_id) OVER (PARTITION BY EXTRACT(YEAR FROM order_date) ORDER BY order_id, order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_order_frm,
    LAST_VALUE(order_id) OVER (PARTITION BY EXTRACT(YEAR FROM order_date) ORDER BY order_id, order_date) AS last_order,
    LAST_VALUE(order_id) OVER (PARTITION BY EXTRACT(YEAR FROM order_date) ORDER BY order_id, order_date ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS last_order_frm
FROM 
    superstore_orders;

-- Temukan pegawai dengan gaji lebih tinggi dari rata-rata departemen dan kurang dari rata-rata perusahaan
SELECT emp_id, emp_name, e.department_id, salary
FROM emp e
INNER JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM emp
    GROUP BY department_id
) AS avg_emp_sal 
ON e.department_id = avg_emp_sal.department_id AND e.salary > avg_emp_sal.avg_salary;


select * from empm;

-- Tampilkan gaji karyawan beserta tiap manager karyawan
SELECT e.emp_name AS "employee name",
	   e.salary as "employee salary",
	   m.emp_name AS "manager name",
	   m.salary as "manager salary"
FROM empm e
LEFT JOIN empm m ON e.manager_id = m.emp_id ;

-- Tampilkan karyawan yang memilki gaji lebih besar dari managernya
select emp_id,emp_name,department_id,salary from empm e
where salary > (
	select salary from empm 
	where emp_id = e.manager_id
);

select * from emp;

-- contains only alphanumeric values
SELECT emp_name  FROM emp
WHERE emp_name IS NOT NULL AND emp_name ~ '^[a-zA-Z0-9]*$';

-- contains only alphanumeric values or spaces
SELECT DISTINCT emp_name FROM emp
WHERE emp_name IS NOT NULL AND emp_name ~ '^[a-zA-Z0-9 ]*$';

-- contains only alphanumeric values, spaces, hyphens, and forward slashes
SELECT DISTINCT emp_name FROM emp
WHERE emp_name IS NOT NULL AND emp_name ~ '^[a-zA-Z0-9/ -]*$';

-- contains only non-alphanumeric values
SELECT DISTINCT emp_name FROM emp
WHERE emp_name IS NOT NULL AND emp_name ~ '[^a-zA-Z0-9]';

-- contains spaces
SELECT DISTINCT emp_name FROM emp
WHERE emp_name IS NOT NULL AND emp_name ~ '[[:space:]]';

-- contains hyphens
SELECT DISTINCT emp_name FROM emp
WHERE emp_name IS NOT NULL AND emp_name ~ '-';

-- contains forward slashes
SELECT DISTINCT emp_name FROM emp
WHERE emp_name IS NOT NULL AND emp_name ~ '/';

create table transaction (
	order_id int,
	order_date date,
	product_name varchar(6),
	order_amount int,
	create_time timestamp default current_timestamp
); 
drop table transaction;
select * from transaction;
insert into transaction values(1,'2022-03-03','P1',150);
insert into transaction values(2,'2022-03-03','P2',200);
insert into transaction values(2,'2022-03-03','P2',200);
insert into transaction values(3,'2022-03-03','P3',300);
select * from transaction;

-- How to Delete Duplicates in PRODUCTION ENVIRONTMENT
-- Step 1: Backup original table
CREATE TABLE transaction_table_backup AS
SELECT * FROM transaction;

-- Step 2: Delete duplicates using DELETE
-- Identify duplicates
SELECT order_id, MIN(create_time) AS no_of_records
FROM transaction 
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- Delete duplicates
DELETE FROM transaction 
WHERE (order_id, create_time) IN 
(SELECT order_id, MIN(create_time)
FROM transaction 
GROUP BY order_id 
HAVING COUNT(*) > 1);

-- Step 3: Using ROW_NUMBER to identify duplicates
SELECT *,
       ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY create_time DESC) AS rn
FROM transaction;

-- Step 4: Insert into original table from backup
INSERT INTO transaction
SELECT order_id, order_date, product_name, order_amount, create_time 
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY create_time DESC) AS rn
    FROM transaction
) AS a
WHERE rn = 1;

-- Step 5: Delete pure duplicates
-- Take backup
CREATE TABLE transaction_backup AS
SELECT DISTINCT * FROM transaction;

-- Insert distinct records into original table
TRUNCATE TABLE transaction;
INSERT INTO transaction
SELECT * FROM transaction_backup;

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

-- temukan siapa yang mengakses amazon music
select * from userss
where user_id in (select user_id from events where type='Music');

--CREATE TABLE t1(id1 int );
--CREATE TABLE t2(id2 int );
--
--drop table t1,t2;

--create table transactionss(
--	order_id int,
--	cust_id int,
--	order_date date,
--	amount int
--);

--insert into transactionss values 
--(1,1,'2020-01-15',150),
--(2,1,'2020-02-10',150 ,
--(3,2,'2020-01-16',150),
--(4,2,'2020-02-25',150),
--(5,3,'2020-01-10',150),
--(6,3,'2020-02-20',150),
--(7,4,'2020-01-20',150),
--(8,5,'2020-02-20',150);
--select * from transactionss;

CREATE TABLE mode (
    id INT
);
insert into mode values (1),(2),(2),(3),(3),(3),(3),(4),(5);
insert into mode values (4);
select * from mode;

-- tampilkan nilai atau nilai-nilai yang paling sering muncul 
-- dalam kumpulan data dari tabel mode.
with freq_cte as
(
	select id,
		   count(*) as freq 
	from mode 
	group by id 
)
select * from freq_cte 
where freq = (select max(freq) from freq_cte);

-- tampilkan nilai atau nilai-nilai yang paling sering muncul 
-- dalam kumpulan data dari tabel mode.
-- pakai rank.
with freq_cte as 
(
	select id,
		   count(*) as freq 
	from mode 
	group by id 
),
rnk_cte as
(
	select  *,
		    RANK() OVER(order by freq desc) as rn -- max freq will be give rank 1
	from freq_cte
)
select * from rnk_cte where rn=1;

create table UserActivity
(
	username varchar(20),
	activity varchar(20),
	startDate Date,
	endDate Date
);
insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20'),
('Alice','Dancing','2020-02-21','2020-02-23'),
('Alice','Travel','2020-02-24','2020-02-28'),
('Bob','Travel','2020-02-11','2020-02-18');

-- - Kolom total_activities: Menunjukkan jumlah total aktivitas yang dilakukan 
--   oleh setiap pengguna.
-- - Kolom rnk: Menunjukkan peringkat aktivitas berdasarkan tanggal mulai 
--   secara descending (terbalik), yang berguna untuk menentukan urutan 
--   aktivitas terbaru.
select *,
	   COUNT(1) over(partition by username) as total_activities,
	   rank() over(partition by username order by startdate desc) as rnk
from UserActivity;

with cte as 
(
	select *,
		   COUNT(1) over(partition by username) as total_activities,
		   rank() over(partition by username order by startdate desc) as rnk
	from UserActivity
)
select * from cte where total_activities=1 or rnk=2;

create table emp_2020(
	emp_id int,
	designation varchar(20)
);
create table emp_2021(
	emp_id int,
	designation varchar(20)
);

insert into emp_2020 values 
(1,'Trainee'),
(2,'Developer'),
(3,'Senior Developer'),
(4,'Manager');
insert into emp_2021 values 
(1,'Developer'),
(2,'Developer'),
(3,'Manager'),
(5,'Trainee');
select * from emp_2021;
select * from emp_2020;
--truncate table emp_2020;
--truncate table emp_2021;

-- lihat perubahan dari jabatan,
-- semua emp_id
select e20.*,
	   e21.* 
from emp_2020 e20 
full outer join emp_2021 e21 on e21.emp_id = e20.emp_id;

-- UNRESOLVED DOCUMENTATION
select e20.* ,
	   e21.* 
from emp_2020 e20 
full outer join emp_2021 e21 on e21.emp_id = e20.emp_id
where e20.designation != e21.designation;

-- gabungkan dua tabel emp_2020 dan emp_2021 menggunakan full outer join 
-- berdasarkan emp_id.
-- filter baris-baris di mana kolom designation dari kedua tahun berbeda.
SELECT e20.*, e21.*
FROM emp_2020 e20 
FULL OUTER JOIN emp_2021 e21 ON e21.emp_id = e20.emp_id
WHERE COALESCE(e20.designation, 'xxx') != COALESCE(e21.designation, 'yyy');


-- buatkan indikator untuk semua emp_id
-- tetap, promoted, resigned, dan new.
select e20.emp_id as before,
	   e21.emp_id as after,
	   case 
		   when e20.designation = e21.designation then 'Tetap'
		   when e20.designation != e21.designation then 'Promoted'
		   when e21.designation is null then 'Resigned'
		   else 'New' 
	   end as comment 
from emp_2020 e20 
full outer join emp_2021 e21 on e21.emp_id = e20.emp_id;
where coalesce(e20.designation,'xxx') != coalesce(e21.designation,'yyy');

-- daftar karyawan beserta status mereka, dipromosikan, 
-- mengundurkan diri, atau baru.
select coalesce(e20.emp_id ,e21.emp_id) as emp_id, -- if e20 is null put e21 value
	   case 
		   when e20.designation!=e21.designation then 'Promoted'
		   when e21.designation is null then 'Resigned'
		   else 'New' 
	   end as comment 
from emp_2020 e20 
full outer join emp_2021 e21 on e21.emp_id = e20.emp_id
where coalesce(e20.designation,'xxx') != coalesce(e21.designation,'yyy');

create table list (id varchar(5));
insert into list values ('a');
insert into list values ('a');
insert into list values ('b');
insert into list values ('c');
insert into list values ('c');
insert into list values ('c');
insert into list values ('d');
insert into list values ('d');
insert into list values ('e');

-- tandai duplikat dalam tabel list
WITH cte_dupl AS 
(
    SELECT id 
    FROM list 
    GROUP BY id 
    HAVING COUNT(1) > 1
),
cte_rank AS 
(
    SELECT *, 
           RANK() OVER(ORDER BY id ASC) AS rn 
    FROM cte_dupl
)
SELECT l.*, 
       'DUP' || CAST(cr.rn AS VARCHAR(2)) AS output  
FROM list l
LEFT JOIN cte_rank cr ON l.id = cr.id;


CREATE table activityy(
	user_id char(20),
	event_name char(20),
	event_date date,
	country char(20)
);
insert into activityy values 
(1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');
select * from activityy;

-- tampilkan jumlah user active harian
select event_date,
	   count(distinct user_id) from activityy a 
group by event_date;

-- hitung jumlah pengguna yang melakukan pembelian pada 
-- hari yang sama dengan instalasi aplikasi mereka.
select user_id,event_date,
	   count(distinct event_name) as no_of_events 
from activityy 
group by user_id,event_date 
having (count(distinct event_name)) = 2;

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

CREATE TABLE Employeess
  (EmployeeID smallint NOT NULL,
  Name varchar(50) NOT NULL,
  DeptID int NULL,
  Salary integer NULL
 );

INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(1,'Mia',5,50000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(2,'Adam',2,50000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(3,'Sean',5,60000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(4,'Robert',2,50000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(5,'Jack',2,45000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(6,'Neo',5,60000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(7,'Jennifer',2,55000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(8,'Lisa',2,85000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(9,'Martin',2,35000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(10,'Terry',5,90000);
  INSERT INTO Employeess(EmployeeID,Name,DeptID,Salary) VALUES(12,'David',5,60000);
  
-- RowNumber, Rank and Dense_Rank
Select EmployeeID,
	   Name, 
	   DeptID, 
	   Salary ,
  	   Row_Number() OVER (PARTITION BY DEPTID ORDER BY SALARY) AS RoowNumber,
  	   RANK() OVER (PARTITION BY DEPTID ORDER BY SALARY) AS RANK2,
  	   DENSE_RANK() OVER (PARTITION BY DEPTID ORDER BY SALARY) AS densee_RANK
FROM EMPLOYEEss;

-- RANK
-- setelah ada dua nilai yang sama dengan peringkat 1, peringkat berikutnya akan menjadi peringkat 3 (melewatkan peringkat 2).
-- DENSE RANK
-- setelah ada dua nilai yang sama dengan peringkat 1, peringkat berikutnya akan menjadi peringkat 2 (tanpa melewatkan peringkat).
Select EmployeeID, 
	   Name, 
	   DeptID, 
	   Salary ,
	   Row_Number() OVER (PARTITION BY DEPTID ORDER BY SALARY) AS RoowNumber,
	   RANK() OVER (PARTITION BY DEPTID ORDER BY SALARY,EmployeeID) AS RANK2,
	   DENSE_RANK() OVER (PARTITION BY DEPTID ORDER BY SALARY,EmployeeID) AS densee_RANK
 FROM EMPLOYEEss;
 
create table countries (countryname varchar(20));
truncate table countries;
insert into countries values('NewZealand'),('Australia'),('England'),('NewZealand');
select * from countries;

-- UNRESOLVED DOCUMENTATION
select * from countries a 
inner join Countries b on a.countryname < b.countryname;


CREATE TABLE STORES (
	Store varchar(10),
	Quarter varchar(10),
	Amount int
);
INSERT INTO STORES (Store, Quarter, Amount)
VALUES 
('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);
select * from STORES;

-- cari quarter yang hilang pada setiap store
SELECT store, 
	   10 - SUM(CAST(RIGHT(quarter, 1) AS INTEGER)) AS q_no 
FROM STORES
GROUP BY store;

-- cari quarter yang hilang pada setiap store
select store,
	   'Q' || cast(10-sum(cast(right(quarter,1) as int)) as char(2)) as q_no from STORES
group by store;

-- cari quarter yang hilang pada setiap store (Rekursif)
WITH recursive ctq as
(
	select distinct store, 1 as q_no from stores
	union all
	select store, q_no+1 as q_no from ctq 
	where q_no < 4
), 
q as 
(
	select  store,'Q' || cast(q_no  as char(1)) as q_no from ctq
)
select  q.* from q 
left join stores s on q.store = s.store and q.q_no = s.quarter
where s.store is null;

-- cari quarter yang hilang pada setiap store (Cross Join)
WITH ctq AS (
    SELECT DISTINCT s1.store, s2.quarter
    FROM stores s1, stores s2
)
SELECT q.*
FROM ctq q
LEFT JOIN stores s ON q.store = s.store AND q.quarter = s.quarter
WHERE s.store IS NULL;

-- Mendefinisikan variabel dan menginisialisasinya dengan nilai
DO $$
DECLARE
    var TEXT := 'abc,,def,,,,,,,,ghi,jkl,,,,,mno';
    result TEXT;
BEGIN
    -- Melakukan penggantian
    result := REPLACE(REPLACE(REPLACE(var, ',', '*,'), ',*', ''), '*,', ',');
    -- Menampilkan hasil
    RAISE NOTICE 'Hasil: %', result;
END $$;

-- OUTPUT:
-- NOTICE:  Hasil: abc,def,ghi,jkl,mno
-- DO

create table exams (
	student_id int, 
	subject varchar(20), 
	marks int
);
insert into exams values 
(1,'Chemistry',91),
(1,'Physics',91),
(2,'Chemistry',80),
(2,'Physics',90),
(3,'Chemistry',80),
(4,'Chemistry',71),
(4,'Physics',54),
(5,'Chemistry',71),
(5,'Physics',71);

truncate table exams;

-- tampilkan siswa yang memiliki nilai yang sama di kedua mata pelajaran 'Physics', 'Chemistry'
SELECT student_id
FROM exams
WHERE subject IN ('Physics', 'Chemistry')
GROUP BY student_id
HAVING COUNT(DISTINCT subject) = 2 AND COUNT(DISTINCT marks) = 1;

-- create table counntry (
-- 	country_id int,
-- 	countrynames varchar(20)
-- );
-- insert into counntry values 
-- (1,'Afganistan'),
-- (2,'Australia'),
-- (3,'China'),
-- (1,'France'),
-- (1,'Germany'),
-- (1,'India'),
-- (1,'Italy');
-- 
-- select * from counntry
-- ORDER BY 
-- (CASE WHEN countrynames='India' then 0
--  	  WHEN countrynames='China' then 1 
--  	  else 2 
--  end), countrynames;

CREATE TABLE Transaction_Tbl_1(
	 CustID int ,
	 TranID int ,
	 TranAmt float,
	 TranDate date 
);
INSERT into Transaction_Tbl_1 VALUES (1001, 20001, 10000, CAST('2020-04-25' AS Date));
INSERT into Transaction_Tbl_1 VALUES (1001, 20002, 15000, CAST('2020-04-25' AS Date));
INSERT into Transaction_Tbl_1 VALUES (1001, 20003, 80000, CAST('2020-04-25' AS Date));
INSERT into Transaction_Tbl_1 VALUES (1001, 20004, 20000, CAST('2020-04-25' AS Date));
INSERT into Transaction_Tbl_1 VALUES (1002, 30001, 7000, CAST('2020-04-25' AS Date));
INSERT into Transaction_Tbl_1 VALUES (1002, 30002, 15000, CAST('2020-04-25' AS Date));
INSERT into Transaction_Tbl_1 VALUES (1002, 30003, 22000, CAST('2020-04-25' AS Date));
select * from Transaction_Tbl_1;

-- UNRESOLVED DOCUMENTATION
select *,
	   TranAmt/maximum_TranAmt
from(
	select *,
		   max(TranAmt) over(partition by CustID ) as maximum_TranAmt
	from Transaction_Tbl_1
) t;

create table covid(city varchar(50),days date,cases int);

-- delete from covid;
insert into covid values('DELHI','2022-01-01',100);
insert into covid values('DELHI','2022-01-02',200);
insert into covid values('DELHI','2022-01-03',300);
insert into covid values('MUMBAI','2022-01-01',100);
insert into covid values('MUMBAI','2022-01-02',100);
insert into covid values('MUMBAI','2022-01-03',300);
insert into covid values('CHENNAI','2022-01-01',100);
insert into covid values('CHENNAI','2022-01-02',200);
insert into covid values('CHENNAI','2022-01-03',150);
insert into covid values('BANGALORE','2022-01-01',100);
insert into covid values('BANGALORE','2022-01-02',300);
insert into covid values('BANGALORE','2022-01-03',200);
insert into covid values('BANGALORE','2022-01-04',400);
select * from covid;

select * ,
	   rank() over(partition by city order by days asc) as rn_days,
	   rank() over(partition by city order by cases asc) as rn_cases
from covid
order by city,cases;
/*
 rn_days menunjukkan urutan kronologis terjadinya kasus COVID-19 di setiap kota, 
 rn_cases menunjukkan urutan jumlah kasus COVID-19 dari yang paling sedikit 
 hingga yang paling banyak di setiap kota.
 */

-- Tampilkan kota yang casenya terus meningkat secara continuos
with abcd as
(
	select *,
		   rank() over(partition by city order by days asc) - rank() over(partition by city order by cases asc) as diff
	from covid 
)
select city from abcd 
group by city
having count(distinct diff) = 1 and max(diff)=0;


create table company_users (
	company_id int,
	user_id int,
	language varchar(20)
);
insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');

-- tamplkan id company yang memiliki lebih dari 1 user 
-- yang bisa menggunakan bahasa english dan german.
select company_id,
	   count(1) as num_of_users 
from (
	select company_id,
		   user_id
	from company_users 
	where language in('English','German')
	group by company_id,user_id
	having count(1)=2 
) as a 
group by company_id
having count(1)>=2 ;

-- tamplkan id company yang memiliki lebih dari 1 user 
-- yang bisa menggunakan bahasa english dan german.
-- CTE.
with temp as 
(
    select *, 
    	   row_number() over (partition by user_id) as rn
    from company_users
    where language in('English','German')
)
select company_id, 
	   count(user_id) as num_of_users
from temp
where rn > 1
group by company_id
having count(user_id) > 1;

-- CREATE TABLE MIN_MAX_SEQ (
-- 	groupss varchar(20),
-- 	Sequence  int
-- );
-- INSERT INTO MIN_MAX_SEQ VALUES('A',1);
-- INSERT INTO MIN_MAX_SEQ VALUES('A',2);
-- INSERT INTO MIN_MAX_SEQ VALUES('A',3);
-- INSERT INTO MIN_MAX_SEQ VALUES('A',5);
-- INSERT INTO MIN_MAX_SEQ VALUES('A',6);
-- INSERT INTO MIN_MAX_SEQ VALUES('A',8);
-- INSERT INTO MIN_MAX_SEQ VALUES('A',9);
-- INSERT INTO MIN_MAX_SEQ VALUES('B',11);
-- INSERT INTO MIN_MAX_SEQ VALUES('C',1);
-- INSERT INTO MIN_MAX_SEQ VALUES('C',2);
-- INSERT INTO MIN_MAX_SEQ VALUES('C',3);
-- 
-- select GROUPSS, 
-- 	   SEQUENCE ,
-- 	   ROW_NUMBER() OVER(PARTITION BY GROUPSS ORDER BY SEQUENCE) as rnk
-- from MIN_MAX_SEQ;

--CREATE TABLE Emp_emails_string (
--	EMPID int,
--	Gender varchar(3),
--	EmailID varchar(30),
--	DeptID int
--);
--INSERT INTO Emp_emails_string VALUES (1001,'M','YYYYY@gmaix.com',104);
--INSERT INTO Emp_emails_string VALUES (1002,'M','ZZZ@gmaix.com',103);
--INSERT INTO Emp_emails_string VALUES (1003,'F','AAAAA@gmaix.com',102);
--INSERT INTO Emp_emails_string VALUES (1004,'F','PP@gmaix.com',104);
--INSERT INTO Emp_emails_string VALUES (1005,'M','CCCC@yahu.com',101);
--INSERT INTO Emp_emails_string VALUES (1006,'M','DDDDD@yahu.com',100);
--INSERT INTO Emp_emails_string VALUES (1007,'F','E@yahu.com',102);
--INSERT INTO Emp_emails_string VALUES (1008,'M','M@yahu.com',102);
--INSERT INTO Emp_emails_string VALUES (1009,'F','SS@yahu.com',100);
--
--select * from Emp_emails_string; 

CREATE TABLE Order_Tbl(
	ORDER_DAY date,
	ORDER_ID varchar(10) ,
	PRODUCT_ID varchar(10) ,
	QUANTITY int ,
	PRICE int 
);
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR1', 'PROD1', 5, 5);
INSERT INTO Order_Tbl   VALUES ('2015-05-01','ODR2', 'PROD2', 2, 10);
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR3', 'PROD3', 10, 25);
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR4', 'PROD1', 20, 5);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR5', 'PROD3', 5, 25);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR6', 'PROD4', 6, 20);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR7', 'PROD1', 2, 5);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR8', 'PROD5', 1, 50);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR9', 'PROD6', 2, 50);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR10','PROD2', 4, 10);

select * from Order_Tbl;

-- tulis kueri sql untuk mendapatkan semua produk yang terjual 
-- pada kedua hari dan berapa kali produk tersebut terjual
select product_id,
	   count(product_id) as COUNT_n,
	   count(distinct ORDER_dAY)
from Order_Tbl
GROUP BY product_id
HAVING COUNT(distinct ORDER_dAY) > 1;

-- tampilkan semua product ter-order pada tanggal 2 mei
select product_id  from Order_Tbl
where order_day = '2015-05-02'
EXCEPT
select product_id  from Order_Tbl
where order_day = '2015-05-01';

-- subquerry
select distinct(product_id)  from Order_Tbl
where order_day = '2015-05-02' 
and product_id not in (select product_id  from Order_Tbl
where order_day = '2015-05-01' );

-- join
select A.product_id,B.product_id 
FROM(
	select product_id  from Order_Tbl
	where order_day = '2015-05-02' ) as A
LEFT JOIN (
	select product_id  from Order_Tbl
	where order_day = '2015-05-01') as  B
ON A.PRODUCT_ID = B.PRODUCT_ID
WHERE B.PRODUCT_ID IS null;

create table mproducts(
	product_id varchar(20) ,
	cost int
);
insert into mproducts values ('P1',200),('P2',300),('P3',500),('P4',800);

create table mcustomer_budget(
	customer_id int,
	budget int
);
insert into mcustomer_budget values (100,400),(200,800),(300,1500);

select * from mproducts;
select * from mcustomer_budget;

-- find how many products falls in customer budget aong with its list of product
with runinng_cost as (
select *,
sum(cost) over(order by cost asc) as runing_cst
from mproducts 
) 
select customer_id,budget,count(1) as no_of_products,GROUP_CONCAT(product_id,',') as list_of_product from mcustomer_budget cb
left join runinng_cost rc on
rc.runing_cst <  cb.budget
group by customer_id,budget

/*
 Temukan jumlah produk yang cocok dengan anggaran masing-masing pelanggan, 
 bersama dengan daftar produk yang dapat dibeli oleh masing-masing pelanggan.
 */
WITH running_cost AS 
(
    SELECT *,
           SUM(cost) OVER (ORDER BY cost ASC) AS running_cost
    FROM mproducts 
) 
SELECT cb.customer_id,
       cb.budget,
       COUNT(1) AS no_of_products,
       STRING_AGG(rc.product_id, ',') AS list_of_product
FROM mcustomer_budget cb
LEFT JOIN running_cost rc ON rc.running_cost < cb.budget
GROUP BY cb.customer_id, cb.budget;

CREATE TABLE subscriber (
	sms_date date ,
	sender varchar(20) ,
	receiver varchar(20) ,
	sms_no int
);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);

/*
Hitung total jumlah pesan SMS antara pasangan pengirim 
dan penerima tertentu pada tanggal tertentu.
*/
select sms_date, 
	   p1,
	   p2, 
	   sum(sms_no) as total_sms 
from (
	select sms_date,
		   case when sender<receiver then sender else  receiver end as p1,
		   case when sender>receiver then sender else  receiver end as p2,
		   sms_no
	from subscriber )as A
group by sms_date,p1,p2;

CREATE TABLE cityy (
	cityname varchar(20),
	citypop int ,
	state varchar(20)
);

INSERT INTO cityy VALUES ('Howrah',10000,'West Bengal');
INSERT INTO cityy VALUES ('Kolkata',70000,'West Bengal');
INSERT INTO cityy VALUES ('noida',15000,'UP');
INSERT INTO cityy VALUES ('ghaziabad',80000,'UP');

-- temukan persentase kontribusi kota terhadap total penduduk negara bagian
SELECT cityname,
       citypop,
       p.state,
       CAST(ROUND(((citypop / "total") * 100), 0) AS FLOAT) AS "Percentage contribution of city to state's total population"
FROM cityy p
JOIN (
    SELECT state,
           SUM(citypop) AS "total"
    FROM cityy
    GROUP BY state
) t ON p.state = t.state
ORDER BY p.state, citypop DESC;

Create Table gendersort(
	Name varchar(10),
	Age int,
	Gender varchar(10)
);

Insert Into gendersort Values('A', 30, 'M'),('B', 20, 'M'),('C', 50, 'M'),('D', 40, 'M'),('E', 10, 'M'),('G', 20, 'F'),('H', 10, 'F'),('I', 30, 'F'),('J', 50, 'F'),('K', 20, 'F')

-- tampilkan semua data, 
-- gender M ascending,
-- gender F descending.
Select * From gendersort
Order By 
Case When Gender = 'M' Then Age End Asc,
Case When Gender = 'F' Then Age End desc;
