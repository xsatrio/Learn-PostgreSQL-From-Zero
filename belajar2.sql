--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity (
    player_id integer,
    device_id integer,
    event_date date,
    games_played integer
);


ALTER TABLE public.activity OWNER TO postgres;

--
-- Name: activityy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activityy (
    user_id character(20),
    event_name character(20),
    event_date date,
    country character(20)
);


ALTER TABLE public.activityy OWNER TO postgres;

--
-- Name: billings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billings (
    emp_name character varying(10),
    bill_date date,
    bill_rate integer
);


ALTER TABLE public.billings OWNER TO postgres;

--
-- Name: bms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bms (
    seat_no integer,
    is_empty character varying(10)
);


ALTER TABLE public.bms OWNER TO postgres;

--
-- Name: challenges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenges (
    challenge_id integer,
    college_id integer
);


ALTER TABLE public.challenges OWNER TO postgres;

--
-- Name: cityy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cityy (
    cityname character varying(20),
    citypop integer,
    state character varying(20)
);


ALTER TABLE public.cityy OWNER TO postgres;

--
-- Name: colleges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.colleges (
    college_id integer,
    contest_id integer
);


ALTER TABLE public.colleges OWNER TO postgres;

--
-- Name: company_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_users (
    company_id integer,
    user_id integer,
    language character varying(20)
);


ALTER TABLE public.company_users OWNER TO postgres;

--
-- Name: contests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contests (
    contest_id integer,
    hacker_id integer,
    name character varying(200)
);


ALTER TABLE public.contests OWNER TO postgres;

--
-- Name: counntry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.counntry (
    country_id integer,
    countrynames character varying(20)
);


ALTER TABLE public.counntry OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    countryname character varying(20)
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: covid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.covid (
    city character varying(50),
    days date,
    cases integer
);


ALTER TABLE public.covid OWNER TO postgres;

--
-- Name: cust_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cust_orders (
    order_id integer NOT NULL,
    order_date date,
    sales numeric
);


ALTER TABLE public.cust_orders OWNER TO postgres;

--
-- Name: cust_orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cust_orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cust_orders_order_id_seq OWNER TO postgres;

--
-- Name: cust_orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cust_orders_order_id_seq OWNED BY public.cust_orders.order_id;


--
-- Name: customer_dob; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_dob (
    customer_id integer,
    customer_name character varying(20),
    gender character varying(7),
    dob date
);


ALTER TABLE public.customer_dob OWNER TO postgres;

--
-- Name: customer_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_orders (
    order_id integer,
    customer_id integer,
    order_date date,
    order_amount integer
);


ALTER TABLE public.customer_orders OWNER TO postgres;

--
-- Name: customer_orders_dates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_orders_dates (
    order_id integer,
    customer_id integer,
    order_date date,
    ship_date date
);


ALTER TABLE public.customer_orders_dates OWNER TO postgres;

--
-- Name: customern; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customern (
    customer_id integer,
    customer_name character varying(10),
    gender character varying(2),
    age integer,
    dob timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customern OWNER TO postgres;

--
-- Name: dept; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dept (
    dept_id integer NOT NULL,
    dep_name character varying(100)
);


ALTER TABLE public.dept OWNER TO postgres;

--
-- Name: dimemp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dimemp (
    first_name character varying(15),
    last_name character varying(15),
    birth_date date
);


ALTER TABLE public.dimemp OWNER TO postgres;

--
-- Name: dpemp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dpemp (
    name character varying(10),
    value character varying(10),
    id integer
);


ALTER TABLE public.dpemp OWNER TO postgres;

--
-- Name: emmp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emmp (
    emp_id integer,
    emp_name character varying(20),
    department_id integer,
    manager_id integer
);


ALTER TABLE public.emmp OWNER TO postgres;

--
-- Name: emp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp (
    emp_id integer,
    emp_name character varying(20),
    department_id character varying(20),
    salary integer
);


ALTER TABLE public.emp OWNER TO postgres;

--
-- Name: emp_2020; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_2020 (
    emp_id integer,
    designation character varying(20)
);


ALTER TABLE public.emp_2020 OWNER TO postgres;

--
-- Name: emp_2021; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_2021 (
    emp_id integer,
    designation character varying(20)
);


ALTER TABLE public.emp_2021 OWNER TO postgres;

--
-- Name: emp_compensation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_compensation (
    emp_id integer,
    salary_component_type character varying(20),
    val integer
);


ALTER TABLE public.emp_compensation OWNER TO postgres;

--
-- Name: emp_compensation_pivot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_compensation_pivot (
    emp_id integer,
    salary bigint,
    bonus bigint,
    hike_percent bigint
);


ALTER TABLE public.emp_compensation_pivot OWNER TO postgres;

--
-- Name: emp_emails_string; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_emails_string (
    empid integer,
    gender character varying(3),
    emailid character varying(30),
    deptid integer
);


ALTER TABLE public.emp_emails_string OWNER TO postgres;

--
-- Name: emp_mgr_age; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_mgr_age (
    emp_id integer,
    emp_name character varying(20),
    department_id character varying(20),
    salary integer,
    manager_id integer,
    emp_age integer
);


ALTER TABLE public.emp_mgr_age OWNER TO postgres;

--
-- Name: empl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empl (
    emp_id integer,
    emp_name character varying(20),
    department_id character varying(20),
    salary integer,
    manager_id integer,
    emp_age integer
);


ALTER TABLE public.empl OWNER TO postgres;

--
-- Name: employe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employe (
    id integer,
    firstname character varying(50),
    lastname character varying(50),
    departmentname character varying(50),
    salary numeric(10,2),
    hiredate date
);


ALTER TABLE public.employe OWNER TO postgres;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    emp_id integer,
    emp_name character(10),
    emp_salary integer
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    city character varying(100)
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_employee_id_seq OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- Name: employeess; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employeess (
    employeeid smallint NOT NULL,
    name character varying(50) NOT NULL,
    deptid integer,
    salary integer
);


ALTER TABLE public.employeess OWNER TO postgres;

--
-- Name: empm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empm (
    emp_id integer,
    emp_name character varying(20),
    department_id character varying(20),
    salary integer,
    manager_id integer
);


ALTER TABLE public.empm OWNER TO postgres;

--
-- Name: empp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empp (
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    hiredate date
);


ALTER TABLE public.empp OWNER TO postgres;

--
-- Name: empt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empt (
    emp_id integer,
    emp_name character varying(20),
    department_id character varying(20),
    salary integer,
    manager_id integer,
    "time" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.empt OWNER TO postgres;

--
-- Name: empy2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empy2 (
    emp_id integer,
    name character varying(20)
);


ALTER TABLE public.empy2 OWNER TO postgres;

--
-- Name: entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entries (
    name character varying(20),
    address character varying(20),
    email character varying(20),
    floor integer,
    resources character varying(10)
);


ALTER TABLE public.entries OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    user_id integer,
    type character varying(10),
    access_date date
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: exams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exams (
    student_id integer,
    subject character varying(20),
    marks integer
);


ALTER TABLE public.exams OWNER TO postgres;

--
-- Name: friend; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.friend (
    personid integer,
    friend_id integer
);


ALTER TABLE public.friend OWNER TO postgres;

--
-- Name: gendersort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gendersort (
    name character varying(10),
    age integer,
    gender character varying(10)
);


ALTER TABLE public.gendersort OWNER TO postgres;

--
-- Name: hoursworked; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hoursworked (
    emp_name character varying(20),
    work_date date,
    bill_hrs integer
);


ALTER TABLE public.hoursworked OWNER TO postgres;

--
-- Name: itemsp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itemsp (
    item_id integer,
    item_brand character varying(50)
);


ALTER TABLE public.itemsp OWNER TO postgres;

--
-- Name: list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.list (
    id character varying(5)
);


ALTER TABLE public.list OWNER TO postgres;

--
-- Name: matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matches (
    match_id integer,
    first_player integer,
    second_player integer,
    first_score integer,
    second_score integer
);


ALTER TABLE public.matches OWNER TO postgres;

--
-- Name: mcustomer_budget; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mcustomer_budget (
    customer_id integer,
    budget integer
);


ALTER TABLE public.mcustomer_budget OWNER TO postgres;

--
-- Name: min_max_seq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.min_max_seq (
    groupss character varying(20),
    sequence integer
);


ALTER TABLE public.min_max_seq OWNER TO postgres;

--
-- Name: mode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mode (
    id integer
);


ALTER TABLE public.mode OWNER TO postgres;

--
-- Name: mproducts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mproducts (
    product_id character varying(20),
    cost integer
);


ALTER TABLE public.mproducts OWNER TO postgres;

--
-- Name: order_tbl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_tbl (
    order_day date,
    order_id character varying(10),
    product_id character varying(10),
    quantity integer,
    price integer
);


ALTER TABLE public.order_tbl OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    customer_name character varying(20),
    order_date date,
    order_amount integer,
    customer_gender character varying(7)
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: ordersp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ordersp (
    order_id integer,
    order_date date,
    item_id integer,
    buyer_id integer,
    seller_id integer
);


ALTER TABLE public.ordersp OWNER TO postgres;

--
-- Name: orderss; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderss (
    order_id integer,
    customer_id integer,
    product_id integer
);


ALTER TABLE public.orderss OWNER TO postgres;

--
-- Name: pemp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pemp (
    name character varying(10),
    value character varying(10),
    id integer
);


ALTER TABLE public.pemp OWNER TO postgres;

--
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    person_id integer,
    name character(10),
    email character varying(30),
    score integer
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: players; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.players (
    player_id integer,
    group_id integer
);


ALTER TABLE public.players OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer,
    name character varying(10)
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: returns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.returns (
    order_id integer NOT NULL,
    return_reason character varying(100)
);


ALTER TABLE public.returns OWNER TO postgres;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    product_id integer,
    period_start date,
    period_end date,
    average_daily_sales integer
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: sales_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_table (
    year integer,
    quater_name character varying(5),
    sales integer
);


ALTER TABLE public.sales_table OWNER TO postgres;

--
-- Name: saless; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saless (
    category character varying(15),
    "2015" integer,
    "2016" integer,
    "2017" integer,
    "2018" integer,
    "2019" integer,
    "2020" integer
);


ALTER TABLE public.saless OWNER TO postgres;

--
-- Name: spending; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spending (
    user_id integer,
    spend_date date,
    platform character varying(10),
    amount integer
);


ALTER TABLE public.spending OWNER TO postgres;

--
-- Name: stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stores (
    store character varying(10),
    quarter character varying(10),
    amount integer
);


ALTER TABLE public.stores OWNER TO postgres;

--
-- Name: submission_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submission_stats (
    challenge_id integer,
    total_submissions integer,
    total_accepted_submissions integer
);


ALTER TABLE public.submission_stats OWNER TO postgres;

--
-- Name: subscriber; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriber (
    sms_date date,
    sender character varying(20),
    receiver character varying(20),
    sms_no integer
);


ALTER TABLE public.subscriber OWNER TO postgres;

--
-- Name: superstore_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.superstore_orders (
    order_id integer NOT NULL,
    product_id integer,
    sales numeric,
    order_date date,
    city character varying(20)
);


ALTER TABLE public.superstore_orders OWNER TO postgres;

--
-- Name: superstore_orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.superstore_orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.superstore_orders_order_id_seq OWNER TO postgres;

--
-- Name: superstore_orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.superstore_orders_order_id_seq OWNED BY public.superstore_orders.order_id;


--
-- Name: superstore_orderss; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.superstore_orderss (
    order_id integer,
    customer_name character varying(100),
    product_name character varying(100)
);


ALTER TABLE public.superstore_orderss OWNER TO postgres;

--
-- Name: survey; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.survey (
    surveyid integer,
    response character varying(150)
);


ALTER TABLE public.survey OWNER TO postgres;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    date_value date,
    state character varying(10)
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction (
    order_id integer,
    order_date date,
    product_name character varying(6),
    order_amount integer,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.transaction OWNER TO postgres;

--
-- Name: transaction_tbl_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction_tbl_1 (
    custid integer,
    tranid integer,
    tranamt double precision,
    trandate date
);


ALTER TABLE public.transaction_tbl_1 OWNER TO postgres;

--
-- Name: transactionss; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactionss (
    order_id integer,
    cust_id integer,
    order_date date,
    amount integer
);


ALTER TABLE public.transactionss OWNER TO postgres;

--
-- Name: trips; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trips (
    id integer,
    client_id integer,
    driver_id integer,
    city_id integer,
    status character varying(50),
    request_at character varying(50)
);


ALTER TABLE public.trips OWNER TO postgres;

--
-- Name: useractivity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.useractivity (
    username character varying(20),
    activity character varying(20),
    startdate date,
    enddate date
);


ALTER TABLE public.useractivity OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    users_id integer,
    banned character varying(50),
    role character varying(50)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: usersp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usersp (
    user_id integer,
    join_date date,
    favorite_brand character varying(50)
);


ALTER TABLE public.usersp OWNER TO postgres;

--
-- Name: userss; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userss (
    user_id integer,
    name character varying(20),
    join_date date
);


ALTER TABLE public.userss OWNER TO postgres;

--
-- Name: view_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_stats (
    challenge_id integer,
    total_views integer,
    total_unique_views integer
);


ALTER TABLE public.view_stats OWNER TO postgres;

--
-- Name: cust_orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cust_orders ALTER COLUMN order_id SET DEFAULT nextval('public.cust_orders_order_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- Name: superstore_orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.superstore_orders ALTER COLUMN order_id SET DEFAULT nextval('public.superstore_orders_order_id_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity (player_id, device_id, event_date, games_played) FROM stdin;
1	2	2016-03-01	5
1	2	2016-03-02	6
2	3	2017-06-25	1
3	1	2016-03-02	0
3	4	2018-07-03	5
\.


--
-- Data for Name: activityy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activityy (user_id, event_name, event_date, country) FROM stdin;
1                   	app-installed       	2022-01-01	India               
1                   	app-purchase        	2022-01-02	India               
2                   	app-installed       	2022-01-01	USA                 
3                   	app-installed       	2022-01-01	USA                 
3                   	app-purchase        	2022-01-03	USA                 
4                   	app-installed       	2022-01-03	India               
4                   	app-purchase        	2022-01-03	India               
5                   	app-installed       	2022-01-03	SL                  
5                   	app-purchase        	2022-01-03	SL                  
6                   	app-installed       	2022-01-04	Pakistan            
6                   	app-purchase        	2022-01-04	Pakistan            
\.


--
-- Data for Name: billings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billings (emp_name, bill_date, bill_rate) FROM stdin;
Sachin	1990-01-01	25
Sehwag	1989-01-01	15
Dhoni	1989-01-01	20
Sachin	1991-02-05	30
\.


--
-- Data for Name: bms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bms (seat_no, is_empty) FROM stdin;
1	N
2	Y
3	N
4	Y
5	Y
6	Y
7	N
8	Y
9	Y
10	Y
11	Y
12	N
13	Y
14	Y
\.


--
-- Data for Name: challenges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenges (challenge_id, college_id) FROM stdin;
18765	11219
47127	11219
60292	32473
72974	56685
\.


--
-- Data for Name: cityy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cityy (cityname, citypop, state) FROM stdin;
Howrah	10000	West Bengal
Kolkata	70000	West Bengal
noida	15000	UP
ghaziabad	80000	UP
Howrah	10000	West Bengal
Kolkata	70000	West Bengal
noida	15000	UP
ghaziabad	80000	UP
Howrah	10000	West Bengal
Kolkata	70000	West Bengal
noida	15000	UP
ghaziabad	80000	UP
\.


--
-- Data for Name: colleges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.colleges (college_id, contest_id) FROM stdin;
11219	66406
32473	66556
56685	94828
\.


--
-- Data for Name: company_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company_users (company_id, user_id, language) FROM stdin;
1	1	English
1	1	German
1	2	English
1	3	German
1	3	English
1	4	English
2	5	English
2	5	German
2	5	Spanish
2	6	German
2	6	Spanish
2	7	English
\.


--
-- Data for Name: contests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contests (contest_id, hacker_id, name) FROM stdin;
66406	17973	Rose
66556	79153	Angela
94828	80275	Frank
\.


--
-- Data for Name: counntry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.counntry (country_id, countrynames) FROM stdin;
1	Afganistan
2	Australia
3	China
1	France
1	Germany
1	India
1	Italy
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (countryname) FROM stdin;
NewZealand
Australia
England
NewZealand
\.


--
-- Data for Name: covid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.covid (city, days, cases) FROM stdin;
DELHI	2022-01-01	100
DELHI	2022-01-02	200
DELHI	2022-01-03	300
MUMBAI	2022-01-01	100
MUMBAI	2022-01-02	100
MUMBAI	2022-01-03	300
CHENNAI	2022-01-01	100
CHENNAI	2022-01-02	200
CHENNAI	2022-01-03	150
BANGALORE	2022-01-01	100
BANGALORE	2022-01-02	300
BANGALORE	2022-01-03	200
BANGALORE	2022-01-04	400
\.


--
-- Data for Name: cust_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cust_orders (order_id, order_date, sales) FROM stdin;
1	2022-01-01	100
2	2022-01-15	150
3	2022-02-01	200
4	2022-02-15	250
5	2022-03-01	300
6	2022-03-15	350
\.


--
-- Data for Name: customer_dob; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_dob (customer_id, customer_name, gender, dob) FROM stdin;
1	Rahul	M	2000-01-05
2	Shilpa	F	2004-04-05
3	Ramesh	M	2003-07-07
4	katrina	F	2005-02-05
5	Alia	F	1992-01-01
\.


--
-- Data for Name: customer_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_orders (order_id, customer_id, order_date, order_amount) FROM stdin;
1	100	2022-01-01	2000
2	200	2022-01-01	2500
3	300	2022-01-01	2100
4	100	2022-01-02	2000
5	400	2022-01-02	2200
6	500	2022-01-02	2700
7	100	2022-01-03	3000
8	400	2022-01-03	1000
9	600	2022-01-03	3000
\.


--
-- Data for Name: customer_orders_dates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_orders_dates (order_id, customer_id, order_date, ship_date) FROM stdin;
1000	1	2022-01-05	2022-01-11
1001	2	2022-02-04	2022-02-16
1002	3	2022-01-01	2022-01-19
1003	4	2022-01-06	2022-01-30
1004	1	2022-02-07	2022-02-13
1005	4	2022-01-07	2022-01-31
1006	3	2022-02-08	2022-02-26
1007	2	2022-02-09	2022-02-21
1008	4	2022-02-10	2022-03-06
\.


--
-- Data for Name: customern; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customern (customer_id, customer_name, gender, age, dob) FROM stdin;
1	Rahul	M	22	2024-02-15 18:00:29.377316
2	Shilpa	F	18	2024-02-15 18:00:29.382471
3	Ramesh	M	19	2024-02-15 18:00:29.385656
4	Katrina	F	17	2024-02-15 18:00:29.388149
5	Alia	F	30	2024-02-15 18:00:29.390329
6	All	M	\N	\N
\.


--
-- Data for Name: dept; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dept (dept_id, dep_name) FROM stdin;
100	Data Analytics
200	Business Analytics
300	Marketing Analytics
400	Text Analytics
\.


--
-- Data for Name: dimemp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dimemp (first_name, last_name, birth_date) FROM stdin;
Gey	Gilbent	1981-11-12
kevin	brown	1960-02-29
Roberto	Tombunelo	1961-03-01
Gey	Gilbent	1971-07-23
Rob	Walters	1974-07-23
Rob	Walters	1974-07-23
therry	deheris	1961-02-26
David	Bradley	1974-10-17
David	Bradley	1974-10-17
jolyn	dobley	1961-02-16
ruth	book	1961-02-28
\.


--
-- Data for Name: dpemp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dpemp (name, value, id) FROM stdin;
Name	Adam	1
Gender	Male	1
Salary	50000	1
Name	Mila	2
Gender	FeMale	2
Salary	50000	2
\.


--
-- Data for Name: emmp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emmp (emp_id, emp_name, department_id, manager_id) FROM stdin;
1	Adam Owens	103	3
2	Smith Jones	102	5
3	Hilary Riles	101	4
4	Richard Robinson	103	3
5	Samuel Pitt	103	3
6	Mark Miles	\N	7
7	Jenny Jeff	999	\N
\.


--
-- Data for Name: emp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp (emp_id, emp_name, department_id, salary) FROM stdin;
1	Ankit	100	10000
2	Mohit	100	15000
3	Vikas	100	10000
4	Rohit	100	5000
5	Mudit	200	12000
6	Agam	200	12000
7	Sanjay	200	9000
8	Ashish	200	5000
\.


--
-- Data for Name: emp_2020; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_2020 (emp_id, designation) FROM stdin;
1	Trainee
2	Developer
3	Senior Developer
4	Manager
\.


--
-- Data for Name: emp_2021; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_2021 (emp_id, designation) FROM stdin;
1	Developer
2	Developer
3	Manager
5	Trainee
\.


--
-- Data for Name: emp_compensation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_compensation (emp_id, salary_component_type, val) FROM stdin;
1	salary	10000
1	bonus	5000
1	hike_percent	10
2	salary	15000
2	bonus	7000
2	hike_percent	8
3	salary	12000
3	bonus	6000
3	hike_percent	7
\.


--
-- Data for Name: emp_compensation_pivot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_compensation_pivot (emp_id, salary, bonus, hike_percent) FROM stdin;
3	12000	6000	7
2	15000	7000	8
1	10000	5000	10
\.


--
-- Data for Name: emp_emails_string; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_emails_string (empid, gender, emailid, deptid) FROM stdin;
1001	M	YYYYY@gmaix.com	104
1002	M	ZZZ@gmaix.com	103
1003	F	AAAAA@gmaix.com	102
1004	F	PP@gmaix.com	104
1005	M	CCCC@yahu.com	101
1006	M	DDDDD@yahu.com	100
1007	F	E@yahu.com	102
1008	M	M@yahu.com	102
1009	F	SS@yahu.com	100
\.


--
-- Data for Name: emp_mgr_age; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_mgr_age (emp_id, emp_name, department_id, salary, manager_id, emp_age) FROM stdin;
1	Ankit	100	10000	4	39
2	Mohit	100	15000	5	48
3	Vikas	100	10000	4	37
4	Rohit	100	5000	2	16
5	Mudit	200	12000	6	55
6	Agam	200	12000	2	14
7	Sanjay	200	9000	2	13
8	Ashish	200	5000	2	12
9	Rakesh	300	5000	6	51
10	Mukesh	300	5000	6	50
\.


--
-- Data for Name: empl; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empl (emp_id, emp_name, department_id, salary, manager_id, emp_age) FROM stdin;
1	Ankit	100	10000	4	39
2	Mohit	100	15000	5	48
3	Vikas	100	10000	4	37
4	Rohit	100	5000	2	16
5	Mudit	200	12000	6	55
6	Agam	200	12000	2	14
7	Sanjay	200	9000	2	13
8	Ashish	200	5000	2	12
9	Mukesh	300	6000	6	51
10	Rakesh	300	7000	6	50
\.


--
-- Data for Name: employe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employe (id, firstname, lastname, departmentname, salary, hiredate) FROM stdin;
1	John	Doe	HR	50000.00	2019-01-15
2	Jane	Smith	Finance	60000.00	2020-03-20
3	Michael	Johnson	IT	55000.00	2018-11-10
4	Emily	Williams	Marketing	48000.00	2019-09-05
5	Christopher	Brown	Operations	52000.00	2021-02-28
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (emp_id, emp_name, emp_salary) FROM stdin;
1	roshan    	7000
2	Moshan    	6000
3	kanti     	5000
4	gagan     	2000
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, city) FROM stdin;
1	New York
2	Los Angeles
3	Chicago
4	Houston
5	Phoenix
6	Philadelphia
7	San Antonio
8	San Diego
9	Dallas
10	San Jose
11	America
12	Austin
13	Atlanta
14	Seattle
\.


--
-- Data for Name: employeess; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employeess (employeeid, name, deptid, salary) FROM stdin;
12	David	5	60000
1	Mia	5	50000
2	Adam	2	50000
3	Sean	5	60000
4	Robert	2	50000
5	Jack	2	45000
6	Neo	5	60000
7	Jennifer	2	55000
8	Lisa	2	85000
9	Martin	2	35000
10	Terry	5	90000
\.


--
-- Data for Name: empm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empm (emp_id, emp_name, department_id, salary, manager_id) FROM stdin;
2	Mohit	100	15000	5
3	Vikas	100	10000	4
4	Rohit	100	5000	2
5	Mudit	200	12000	6
6	Agam	200	12000	2
7	Sanjay	200	9000	2
8	Ashish	200	5000	2
1	Ankit	1000	12000	4
\.


--
-- Data for Name: empp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empp (firstname, lastname, hiredate) FROM stdin;
Alice	Ciccu	2024-01-07
Paula	Barreto de Mattos	2024-01-06
Alejandro	McGuel	2023-12-06
Kendall	Keil	2024-01-05
Ivo	Salmre	2023-10-04
Paul	Komosinski	2023-08-04
Ashvini	Sharma	2023-07-04
Zheng	Mu	2024-01-03
Stuart	Munson	2021-11-02
Greg	Alderson	2024-01-02
David	Johnson	2023-01-02
\.


--
-- Data for Name: empt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empt (emp_id, emp_name, department_id, salary, manager_id, "time") FROM stdin;
1	Ankit	100	10000	4	2024-01-30 14:49:53.981272
2	Mohit	100	15000	5	2024-01-30 14:49:54.474932
3	Vikas	100	10000	4	2024-01-30 14:49:54.95001
4	Rohit	100	5000	2	2024-01-30 14:49:55.439652
5	Mudit	200	12000	6	2024-01-30 14:49:55.912554
6	Agam	200	12000	2	2024-01-30 14:49:56.37661
7	Sanjay	200	9000	2	2024-01-30 14:49:56.824045
8	Ashish	200	5000	2	2024-01-30 14:49:57.265997
\.


--
-- Data for Name: empy2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empy2 (emp_id, name) FROM stdin;
1	Owens, Adams
2	Hopkins, David
3	Jonas, Mary
4	Rhodes, Susssan
\.


--
-- Data for Name: entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entries (name, address, email, floor, resources) FROM stdin;
A	Bangalore	A@gmail.com	1	CPU
A	Bangalore	A1@gmail.com	1	CPU
A	Bangalore	A2@gmail.com	2	DESKTOP
B	Bangalore	B@gmail.com	2	DESKTOP
B	Bangalore	B1@gmail.com	2	DESKTOP
B	Bangalore	B2@yahoo.com	1	MONITOR
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (user_id, type, access_date) FROM stdin;
1	Pay	2020-03-01
2	Music	2020-03-02
2	P	2020-03-12
3	Music	2020-03-15
4	Music	2020-03-15
1	P	2020-03-16
3	P	2020-03-22
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exams (student_id, subject, marks) FROM stdin;
1	Chemistry	91
1	Physics	91
2	Chemistry	80
2	Physics	90
3	Chemistry	80
4	Chemistry	71
4	Physics	54
5	Chemistry	71
5	Physics	71
\.


--
-- Data for Name: friend; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.friend (personid, friend_id) FROM stdin;
1	2
1	3
2	1
2	3
3	5
4	2
4	3
4	5
\.


--
-- Data for Name: gendersort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gendersort (name, age, gender) FROM stdin;
A	30	M
B	20	M
C	50	M
D	40	M
E	10	M
G	20	F
H	10	F
I	30	F
J	50	F
K	20	F
\.


--
-- Data for Name: hoursworked; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hoursworked (emp_name, work_date, bill_hrs) FROM stdin;
Sachin	1990-07-01	3
Sachin	1990-08-01	5
Sehwag	1990-07-01	2
Sachin	1991-07-01	4
\.


--
-- Data for Name: itemsp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itemsp (item_id, item_brand) FROM stdin;
1	Samsung
2	Lenovo
3	LG
4	HP
\.


--
-- Data for Name: list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.list (id) FROM stdin;
a
a
b
c
c
c
d
d
e
\.


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matches (match_id, first_player, second_player, first_score, second_score) FROM stdin;
1	15	45	3	0
2	30	25	1	2
3	30	15	2	0
4	40	20	5	2
5	35	50	1	1
\.


--
-- Data for Name: mcustomer_budget; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mcustomer_budget (customer_id, budget) FROM stdin;
100	400
200	800
300	1500
\.


--
-- Data for Name: min_max_seq; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.min_max_seq (groupss, sequence) FROM stdin;
A	1
A	2
A	3
A	5
A	6
A	8
A	9
B	11
C	1
C	2
C	3
\.


--
-- Data for Name: mode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mode (id) FROM stdin;
1
2
2
3
3
3
3
4
5
4
\.


--
-- Data for Name: mproducts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mproducts (product_id, cost) FROM stdin;
P1	200
P2	300
P3	500
P4	800
\.


--
-- Data for Name: order_tbl; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_tbl (order_day, order_id, product_id, quantity, price) FROM stdin;
2015-05-01	ODR1	PROD1	5	5
2015-05-01	ODR2	PROD2	2	10
2015-05-01	ODR3	PROD3	10	25
2015-05-01	ODR4	PROD1	20	5
2015-05-02	ODR5	PROD3	5	25
2015-05-02	ODR6	PROD4	6	20
2015-05-02	ODR7	PROD1	2	5
2015-05-02	ODR8	PROD5	1	50
2015-05-02	ODR9	PROD6	2	50
2015-05-02	ODR10	PROD2	4	10
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (customer_name, order_date, order_amount, customer_gender) FROM stdin;
Shilpa	2020-01-01	10000	Male
Rahul	2020-01-02	12000	Female
SHILPA	2020-01-01	12000	Male
Rohit	2020-01-03	15000	Female
Shilpa	2020-01-03	14000	Male
\.


--
-- Data for Name: ordersp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ordersp (order_id, order_date, item_id, buyer_id, seller_id) FROM stdin;
1	2019-08-01	4	1	2
2	2019-08-02	2	1	3
3	2019-08-03	3	2	3
4	2019-08-04	1	4	2
5	2019-08-04	1	3	4
6	2019-08-05	2	2	4
\.


--
-- Data for Name: orderss; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orderss (order_id, customer_id, product_id) FROM stdin;
1	1	1
1	1	2
1	1	3
2	2	1
2	2	2
2	2	4
3	1	5
\.


--
-- Data for Name: pemp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pemp (name, value, id) FROM stdin;
Name	Adam	1
Gender	Male	1
Salary	50000	1
Name	Adam	2
Gender	Male	2
Salary	50000	2
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (person_id, name, email, score) FROM stdin;
1	Alice     	alice2018@hotmail.com	88
2	bob       	bob2018@hotmail.com	11
3	davis     	davis2018@hotmail.com	27
4	tara      	tara2018@hotmail.com	45
5	john      	john2018@hotmail.com	63
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.players (player_id, group_id) FROM stdin;
15	1
25	1
30	1
45	1
10	2
35	2
50	2
20	3
40	3
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name) FROM stdin;
1	A
2	B
3	C
4	D
5	E
\.


--
-- Data for Name: returns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.returns (order_id, return_reason) FROM stdin;
3	Wrong item received
6	Defective product
8	Item not as described
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales (product_id, period_start, period_end, average_daily_sales) FROM stdin;
1	2019-01-25	2019-02-28	100
2	2018-12-01	2020-01-01	10
3	2019-12-01	2020-01-31	1
\.


--
-- Data for Name: sales_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_table (year, quater_name, sales) FROM stdin;
2018	Q1	5000
2018	Q2	5500
2018	Q3	2500
2018	Q4	10000
2019	Q1	10000
2019	Q2	5500
2019	Q3	3000
2019	Q4	6000
\.


--
-- Data for Name: saless; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.saless (category, "2015", "2016", "2017", "2018", "2019", "2020") FROM stdin;
Hot Drinks	20000	15000	28000	12000	40000	10000
Cold Drinks	18000	36000	10000	12000	8000	2000
\.


--
-- Data for Name: spending; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spending (user_id, spend_date, platform, amount) FROM stdin;
1	2019-07-01	mobile	100
1	2019-07-01	desktop	100
2	2019-07-01	mobile	100
2	2019-07-02	mobile	100
3	2019-07-01	desktop	100
3	2019-07-02	desktop	100
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stores (store, quarter, amount) FROM stdin;
S1	Q1	200
S1	Q2	300
S1	Q4	400
S2	Q1	500
S2	Q3	600
S2	Q4	700
S3	Q1	800
S3	Q2	750
S3	Q3	900
\.


--
-- Data for Name: submission_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.submission_stats (challenge_id, total_submissions, total_accepted_submissions) FROM stdin;
75516	34	12
47127	27	10
47127	56	18
75516	74	12
75516	83	8
72974	68	24
72974	82	14
47127	28	11
\.


--
-- Data for Name: subscriber; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriber (sms_date, sender, receiver, sms_no) FROM stdin;
2020-04-01	Avinash	Vibhor	10
2020-04-01	Vibhor	Avinash	20
2020-04-01	Avinash	Pawan	30
2020-04-01	Pawan	Avinash	20
2020-04-01	Vibhor	Pawan	5
2020-04-01	Pawan	Vibhor	8
2020-04-01	Vibhor	Deepak	50
\.


--
-- Data for Name: superstore_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.superstore_orders (order_id, product_id, sales, order_date, city) FROM stdin;
1	1	100	2021-01-13	New York
2	1	150	2021-01-13	New York
3	2	200	2021-01-14	New York
4	2	250	2021-01-14	New York
5	3	300	2022-01-14	London
6	3	350	2022-01-14	London
7	4	400	2022-01-14	London
8	4	450	2023-01-15	London
9	5	500	2023-01-15	Japan
10	5	550	2023-01-15	Japan
\.


--
-- Data for Name: superstore_orderss; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.superstore_orderss (order_id, customer_name, product_name) FROM stdin;
1	Alice Smith	Office Chair
2	Bob Johnson	Desk Lamp
3	Charlie Brown	Bookshelf
4	David Anderson	Computer Desk
5	Eva Garcia	Printer
6	Adam Lee	Desk Organizer
7	Catherine White	Paper Shredder
8	Diana Martin	Scanner
9	Alex Thompson	Coffee Table
10	Carl Davis	Filing Cabinet
11	Emily Wilson	Desk Chair
12	Brian Taylor	Bookcase
13	Emma Harris	Desk Mat
14	Olivia Clark	File Cabinet
15	Frank Rodriguez	Stapler
\.


--
-- Data for Name: survey; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey (surveyid, response) FROM stdin;
1	ZZZZZXXXXCCCVVVBBNNMMLLKHJFGDFSDASASSAAQWEWERETRTYRYIYYIOIPUT
2	QWPDHBCNFDHFFGALSDDCS
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (date_value, state) FROM stdin;
2019-01-01	success
2019-01-02	success
2019-01-03	success
2019-01-04	fail
2019-01-05	fail
2019-01-06	success
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction (order_id, order_date, product_name, order_amount, create_time) FROM stdin;
1	2022-03-03	P1	150	2024-02-17 14:16:21.372988
3	2022-03-03	P3	300	2024-02-17 14:16:21.380087
2	2022-03-03	P2	200	2024-02-17 14:16:45.67626
1	2022-03-03	P1	150	2024-02-17 14:16:21.372988
2	2022-03-03	P2	200	2024-02-17 14:16:45.67626
3	2022-03-03	P3	300	2024-02-17 14:16:21.380087
\.


--
-- Data for Name: transaction_tbl_1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction_tbl_1 (custid, tranid, tranamt, trandate) FROM stdin;
1001	20001	10000	2020-04-25
1001	20002	15000	2020-04-25
1001	20003	80000	2020-04-25
1001	20004	20000	2020-04-25
1002	30001	7000	2020-04-25
1002	30002	15000	2020-04-25
1002	30003	22000	2020-04-25
\.


--
-- Data for Name: transactionss; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactionss (order_id, cust_id, order_date, amount) FROM stdin;
1	1	2020-01-15	150
2	1	2020-02-10	150
3	2	2020-01-16	150
4	2	2020-02-25	150
5	3	2020-01-10	150
6	3	2020-02-20	150
7	4	2020-01-20	150
8	5	2020-02-20	150
\.


--
-- Data for Name: trips; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trips (id, client_id, driver_id, city_id, status, request_at) FROM stdin;
1	1	10	1	completed	2013-10-01
2	2	11	1	cancelled_by_driver	2013-10-01
3	3	12	6	completed	2013-10-01
4	4	13	6	cancelled_by_client	2013-10-01
5	1	10	1	completed	2013-10-02
6	2	11	6	completed	2013-10-02
7	3	12	6	completed	2013-10-02
8	2	12	12	completed	2013-10-03
9	3	10	12	completed	2013-10-03
10	4	13	12	cancelled_by_driver	2013-10-03
7	3	12	6	completed	2013-10-02
\.


--
-- Data for Name: useractivity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.useractivity (username, activity, startdate, enddate) FROM stdin;
Alice	Travel	2020-02-12	2020-02-20
Alice	Dancing	2020-02-21	2020-02-23
Alice	Travel	2020-02-24	2020-02-28
Bob	Travel	2020-02-11	2020-02-18
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (users_id, banned, role) FROM stdin;
1	No	client
2	Yes	client
3	No	client
4	No	client
10	No	driver
11	No	driver
12	No	driver
13	No	driver
\.


--
-- Data for Name: usersp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usersp (user_id, join_date, favorite_brand) FROM stdin;
1	2019-01-01	Lenovo
2	2019-02-09	Samsung
3	2019-01-19	LG
4	2019-05-21	HP
\.


--
-- Data for Name: userss; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userss (user_id, name, join_date) FROM stdin;
1	Jon	2020-02-14
2	Jane	2020-02-14
3	Jill	2020-02-15
4	Josh	2020-02-15
5	Jean	2020-02-16
6	Justin	2020-02-17
7	Jeremy	2020-02-18
\.


--
-- Data for Name: view_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_stats (challenge_id, total_views, total_unique_views) FROM stdin;
47127	26	19
47127	15	14
18765	43	10
18765	72	13
75516	35	17
60292	11	10
72974	41	15
75516	75	11
\.


--
-- Name: cust_orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cust_orders_order_id_seq', 6, true);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 14, true);


--
-- Name: superstore_orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.superstore_orders_order_id_seq', 10, true);


--
-- Name: cust_orders cust_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cust_orders
    ADD CONSTRAINT cust_orders_pkey PRIMARY KEY (order_id);


--
-- Name: dept dept_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dept
    ADD CONSTRAINT dept_pkey PRIMARY KEY (dept_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: returns returns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returns
    ADD CONSTRAINT returns_pkey PRIMARY KEY (order_id);


--
-- Name: superstore_orders superstore_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.superstore_orders
    ADD CONSTRAINT superstore_orders_pkey PRIMARY KEY (order_id);


--
-- PostgreSQL database dump complete
--

