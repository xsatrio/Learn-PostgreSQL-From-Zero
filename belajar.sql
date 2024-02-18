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

--
-- Name: cd; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA cd;


ALTER SCHEMA cd OWNER TO postgres;

--
-- Name: contoh; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contoh;


ALTER SCHEMA contoh OWNER TO postgres;

--
-- Name: product_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.product_category AS ENUM (
    'makanan',
    'minuman',
    'lain-lain'
);


ALTER TYPE public.product_category OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: barang; Type: TABLE; Schema: cd; Owner: postgres
--

CREATE TABLE cd.barang (
    kode integer,
    nama character varying(100),
    harga integer,
    jumlah integer,
    nama_column text
);


ALTER TABLE cd.barang OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: contoh; Owner: postgres
--

CREATE TABLE contoh.products (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE contoh.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: contoh; Owner: postgres
--

CREATE SEQUENCE contoh.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contoh.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: contoh; Owner: postgres
--

ALTER SEQUENCE contoh.products_id_seq OWNED BY contoh.products.id;


--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100)
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_id_seq OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id character varying(10) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: contoh_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contoh_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contoh_sequence OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id integer NOT NULL,
    email character varying(100) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100)
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_id_seq OWNER TO postgres;

--
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;


--
-- Name: guestbook; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.guestbook (
    id integer NOT NULL,
    email character varying(100) NOT NULL,
    title character varying(100) NOT NULL,
    content text
);


ALTER TABLE public.guestbook OWNER TO postgres;

--
-- Name: guestbook_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.guestbook_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.guestbook_id_seq OWNER TO postgres;

--
-- Name: guestbook_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.guestbook_id_seq OWNED BY public.guestbook.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    total integer NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_detail (
    id_product character varying(10) NOT NULL,
    id_order integer NOT NULL,
    price integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.orders_detail OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    price integer NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id_categories character varying(10),
    CONSTRAINT price_check CHECK ((price > 1000)),
    CONSTRAINT quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: seller; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seller (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL
);


ALTER TABLE public.seller OWNER TO postgres;

--
-- Name: seller_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seller_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seller_id_seq OWNER TO postgres;

--
-- Name: seller_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seller_id_seq OWNED BY public.seller.id;


--
-- Name: wallet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallet (
    id integer NOT NULL,
    id_customer integer NOT NULL,
    balance integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.wallet OWNER TO postgres;

--
-- Name: wallet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wallet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wallet_id_seq OWNER TO postgres;

--
-- Name: wallet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wallet_id_seq OWNED BY public.wallet.id;


--
-- Name: wishlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wishlist (
    id integer NOT NULL,
    id_product character varying(10) NOT NULL,
    description text,
    id_customer integer
);


ALTER TABLE public.wishlist OWNER TO postgres;

--
-- Name: wishlist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wishlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wishlist_id_seq OWNER TO postgres;

--
-- Name: wishlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wishlist_id_seq OWNED BY public.wishlist.id;


--
-- Name: products id; Type: DEFAULT; Schema: contoh; Owner: postgres
--

ALTER TABLE ONLY contoh.products ALTER COLUMN id SET DEFAULT nextval('contoh.products_id_seq'::regclass);


--
-- Name: admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);


--
-- Name: customer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);


--
-- Name: guestbook id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guestbook ALTER COLUMN id SET DEFAULT nextval('public.guestbook_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: seller id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller ALTER COLUMN id SET DEFAULT nextval('public.seller_id_seq'::regclass);


--
-- Name: wallet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet ALTER COLUMN id SET DEFAULT nextval('public.wallet_id_seq'::regclass);


--
-- Name: wishlist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlist ALTER COLUMN id SET DEFAULT nextval('public.wishlist_id_seq'::regclass);


--
-- Data for Name: barang; Type: TABLE DATA; Schema: cd; Owner: postgres
--

COPY cd.barang (kode, nama, harga, jumlah, nama_column) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: contoh; Owner: postgres
--

COPY contoh.products (id, name) FROM stdin;
1	bakso
2	sate
3	naspad
\.


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, first_name, last_name) FROM stdin;
1	satrio	mukti
2	xsat	\N
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name) FROM stdin;
C0001	makanan
C0002	minuman
C0003	laptop
C0004	gadget
C0005	pulsa
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, email, first_name, last_name) FROM stdin;
3	mukti@mail.com	satrio	\N
1	satrio@mail.com	satrio	mukti
\.


--
-- Data for Name: guestbook; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.guestbook (id, email, title, content) FROM stdin;
1	mukti@mail.com	feedback mukti	feedback mukti
2	mukti@mail.com	feedback mukti	feedback mukti
3	satrio@mail.com	feedback satrio	feedback satrio
4	satrio@mail.com	feedback satrio	feedback satrio
5	prayoga@mail.com	feedback prayoga	feedback prayoga
6	eko@mail.com	feedback eko	feedback eko
9	transaction@mail.com	transaction	transaction1
10	transaction@mail.com	transaction	transaction2
11	transaction@mail.com	transaction	transaction3
12	transaction@mail.com	transaction	transaction4
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, total, order_date) FROM stdin;
1	1	2024-01-20 16:33:01.81428
2	1	2024-01-20 16:33:01.81428
3	1	2024-01-20 16:33:01.81428
\.


--
-- Data for Name: orders_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_detail (id_product, id_order, price, quantity) FROM stdin;
P0001	1	1000	2
P0002	1	1000	2
P0003	1	1000	2
P0002	2	1000	2
P0003	2	1000	2
P0004	2	1000	2
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, description, price, quantity, created_at, id_categories) FROM stdin;
P0001	Mie Ayam	\N	10000	5	2024-01-18 17:41:46.673381	C0001
P0004	Tahu	\N	5500	5	2024-01-18 17:41:49.738224	C0001
P0003	Bakso Tahu	Bakso Gehu	7000	5	2024-01-18 17:41:49.738224	C0001
P0002	Mie Ayam Bakso Tahu	Mie Ayam Original + Bakso Tahu	15000	5	2024-01-18 17:41:48.157422	C0001
P0005	pocari	\N	7000	9	2024-01-18 18:19:51.24398	C0002
P0006	kelapa	\N	10000	3	2024-01-18 18:19:51.24398	C0002
XXX1	tea jus	\N	1500	0	2024-01-19 16:40:43.652417	C0002
P0007	contoh1	\N	10000	10	2024-01-20 16:49:35.720347	\N
P0008	contoh2	\N	10000	10	2024-01-20 16:49:35.720347	\N
P0009	contoh3	\N	10000	10	2024-01-20 16:49:35.720347	\N
\.


--
-- Data for Name: seller; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seller (id, name, email) FROM stdin;
1	Galeri Olahraga	galeri@email.com
2	Toko tono	tono@email.com
3	Toko budi	budi@email.com
4	Toko ruly	ruly@email.com
\.


--
-- Data for Name: wallet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet (id, id_customer, balance) FROM stdin;
2	1	1000
1	3	2000
\.


--
-- Data for Name: wishlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wishlist (id, id_product, description, id_customer) FROM stdin;
3	P0001	Mie ayam loved	1
\.


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: contoh; Owner: postgres
--

SELECT pg_catalog.setval('contoh.products_id_seq', 3, true);


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 2, true);


--
-- Name: contoh_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contoh_sequence', 2, true);


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_id_seq', 8, true);


--
-- Name: guestbook_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.guestbook_id_seq', 16, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 3, true);


--
-- Name: seller_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seller_id_seq', 4, true);


--
-- Name: wallet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wallet_id_seq', 3, true);


--
-- Name: wishlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wishlist_id_seq', 3, true);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: contoh; Owner: postgres
--

ALTER TABLE ONLY contoh.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: seller email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller
    ADD CONSTRAINT email_unique UNIQUE (email);


--
-- Name: guestbook guestbook_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guestbook
    ADD CONSTRAINT guestbook_pkey PRIMARY KEY (id);


--
-- Name: orders_detail orders_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_detail
    ADD CONSTRAINT orders_detail_pkey PRIMARY KEY (id_product, id_order);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: seller seller_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_pkey PRIMARY KEY (id);


--
-- Name: customer unique_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- Name: wallet wallet_customer_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallet_customer_unique UNIQUE (id_customer);


--
-- Name: wallet wallet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallet_pkey PRIMARY KEY (id);


--
-- Name: wishlist wishlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_pkey PRIMARY KEY (id);


--
-- Name: products_description_search; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX products_description_search ON public.products USING gin (to_tsvector('indonesian'::regconfig, description));


--
-- Name: products_name_search; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX products_name_search ON public.products USING gin (to_tsvector('indonesian'::regconfig, (name)::text));


--
-- Name: seller_email_and_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX seller_email_and_name_index ON public.seller USING btree (email, name);


--
-- Name: seller_id_and_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX seller_id_and_name_index ON public.seller USING btree (id, name);


--
-- Name: seller_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX seller_name_index ON public.seller USING btree (name);


--
-- Name: orders_detail fk_orders_detail_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_detail
    ADD CONSTRAINT fk_orders_detail_order FOREIGN KEY (id_order) REFERENCES public.orders(id);


--
-- Name: orders_detail fk_orders_detail_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_detail
    ADD CONSTRAINT fk_orders_detail_product FOREIGN KEY (id_product) REFERENCES public.products(id);


--
-- Name: products fk_product_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_product_category FOREIGN KEY (id_categories) REFERENCES public.categories(id);


--
-- Name: wallet fk_wallet_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT fk_wallet_customer FOREIGN KEY (id_customer) REFERENCES public.customer(id);


--
-- Name: wishlist fk_wishlist_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT fk_wishlist_customer FOREIGN KEY (id_customer) REFERENCES public.customer(id);


--
-- Name: wishlist fk_wishlist_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT fk_wishlist_product FOREIGN KEY (id_product) REFERENCES public.products(id);


--
-- Name: SCHEMA cd; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA cd TO xsatrio;


--
-- Name: TABLE admin; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.admin TO kasir;


--
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.categories TO kasir;


--
-- Name: TABLE customer; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.customer TO kasir;


--
-- Name: TABLE guestbook; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.guestbook TO kasir;


--
-- Name: TABLE orders; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.orders TO kasir;


--
-- Name: TABLE orders_detail; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.orders_detail TO kasir;


--
-- Name: TABLE products; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.products TO kasir;


--
-- Name: TABLE seller; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.seller TO kasir;


--
-- Name: TABLE wallet; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.wallet TO kasir;


--
-- Name: TABLE wishlist; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.wishlist TO kasir;


--
-- PostgreSQL database dump complete
--

