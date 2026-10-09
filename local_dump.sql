--
-- PostgreSQL database dump
--

\restrict wcx4fkXZhJnFRWXt2MytzPdKyxdSYV1F2SK0NJUpZo36lM8lf3dDaSCqeZdeqUv

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

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

ALTER TABLE ONLY public.users DROP CONSTRAINT users_tenant_id_fkey;
ALTER TABLE ONLY public.stores DROP CONSTRAINT stores_tenant_id_fkey;
ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_tenant_id_fkey;
ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_store_id_fkey;
ALTER TABLE ONLY public.sale_payments DROP CONSTRAINT sale_payments_sale_id_fkey;
ALTER TABLE ONLY public.sale_items DROP CONSTRAINT sale_items_variant_id_fkey;
ALTER TABLE ONLY public.sale_items DROP CONSTRAINT sale_items_sale_id_fkey;
ALTER TABLE ONLY public.products DROP CONSTRAINT products_tenant_id_fkey;
ALTER TABLE ONLY public.product_variants DROP CONSTRAINT product_variants_tenant_id_fkey;
ALTER TABLE ONLY public.product_variants DROP CONSTRAINT product_variants_product_id_fkey;
ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_sale_id_fkey;
ALTER TABLE ONLY public.invoices DROP CONSTRAINT invoices_tenant_id_fkey;
ALTER TABLE ONLY public.invoices DROP CONSTRAINT invoices_sale_id_fkey;
ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_variant_id_fkey;
ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_tenant_id_fkey;
ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_store_id_fkey;
ALTER TABLE ONLY public.inventory_movements DROP CONSTRAINT inventory_movements_variant_id_fkey;
ALTER TABLE ONLY public.inventory_movements DROP CONSTRAINT inventory_movements_tenant_id_fkey;
ALTER TABLE ONLY public.inventory_movements DROP CONSTRAINT inventory_movements_store_id_fkey;
ALTER TABLE ONLY public.purchase_items DROP CONSTRAINT fk_purchaseitem_purchase;
ALTER TABLE ONLY public.purchases DROP CONSTRAINT fk_purchase_supplier;
ALTER TABLE ONLY public.products DROP CONSTRAINT fk_products_category;
ALTER TABLE ONLY public.products DROP CONSTRAINT fk_products_brand;
ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_tenant_id_fkey;
ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_tenant_id_fkey;
ALTER TABLE ONLY public.cash_transactions DROP CONSTRAINT cash_transactions_cash_session_id_fkey;
ALTER TABLE ONLY public.cash_sessions DROP CONSTRAINT cash_sessions_cash_register_id_fkey;
ALTER TABLE ONLY public.brands DROP CONSTRAINT brands_tenant_id_fkey;
ALTER TABLE ONLY public.audit_logs DROP CONSTRAINT audit_logs_tenant_id_fkey;
DROP INDEX public.uq_variant_barcode;
DROP INDEX public.idx_stores_tenant;
DROP INDEX public.flyway_schema_history_s_idx;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_tenant_id_email_key;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.tenants DROP CONSTRAINT tenants_pkey;
ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pkey;
ALTER TABLE ONLY public.stores DROP CONSTRAINT stores_pkey;
ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_pkey;
ALTER TABLE ONLY public.sale_payments DROP CONSTRAINT sale_payments_pkey;
ALTER TABLE ONLY public.sale_items DROP CONSTRAINT sale_items_pkey;
ALTER TABLE ONLY public.purchases DROP CONSTRAINT purchases_pkey;
ALTER TABLE ONLY public.purchase_items DROP CONSTRAINT purchase_items_pkey;
ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
ALTER TABLE ONLY public.product_variants DROP CONSTRAINT product_variants_tenant_id_sku_key;
ALTER TABLE ONLY public.product_variants DROP CONSTRAINT product_variants_pkey;
ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_pkey;
ALTER TABLE ONLY public.invoices DROP CONSTRAINT invoices_pkey;
ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_store_id_variant_id_key;
ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_pkey;
ALTER TABLE ONLY public.inventory_movements DROP CONSTRAINT inventory_movements_pkey;
ALTER TABLE ONLY public.flyway_schema_history DROP CONSTRAINT flyway_schema_history_pk;
ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pkey;
ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_pkey;
ALTER TABLE ONLY public.cash_transactions DROP CONSTRAINT cash_transactions_pkey;
ALTER TABLE ONLY public.cash_sessions DROP CONSTRAINT cash_sessions_pkey;
ALTER TABLE ONLY public.cash_registers DROP CONSTRAINT cash_registers_pkey;
ALTER TABLE ONLY public.brands DROP CONSTRAINT brands_pkey;
ALTER TABLE ONLY public.audit_logs DROP CONSTRAINT audit_logs_pkey;
DROP TABLE public.users;
DROP TABLE public.tenants;
DROP TABLE public.suppliers;
DROP TABLE public.stores;
DROP TABLE public.sales;
DROP TABLE public.sale_payments;
DROP TABLE public.sale_items;
DROP TABLE public.purchases;
DROP TABLE public.purchase_items;
DROP TABLE public.products;
DROP TABLE public.product_variants;
DROP TABLE public.payments;
DROP TABLE public.invoices;
DROP TABLE public.inventory_movements;
DROP TABLE public.inventory;
DROP TABLE public.flyway_schema_history;
DROP TABLE public.customers;
DROP TABLE public.categories;
DROP TABLE public.cash_transactions;
DROP TABLE public.cash_sessions;
DROP TABLE public.cash_registers;
DROP TABLE public.brands;
DROP TABLE public.audit_logs;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.audit_logs (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    user_id uuid NOT NULL,
    action character varying(100) NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id uuid,
    old_value jsonb,
    new_value jsonb,
    ip_address inet,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO pos_user;

--
-- Name: brands; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.brands (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.brands OWNER TO pos_user;

--
-- Name: cash_registers; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.cash_registers (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    store_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cash_registers OWNER TO pos_user;

--
-- Name: cash_sessions; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.cash_sessions (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    store_id uuid NOT NULL,
    cash_register_id uuid NOT NULL,
    opened_by uuid NOT NULL,
    opened_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    closed_by uuid,
    closed_at timestamp with time zone,
    opening_balance numeric(10,2) NOT NULL,
    closing_balance_expected numeric(10,2),
    closing_balance_actual numeric(10,2),
    status character varying(50) NOT NULL,
    closing_notes text
);


ALTER TABLE public.cash_sessions OWNER TO pos_user;

--
-- Name: cash_transactions; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.cash_transactions (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    cash_session_id uuid NOT NULL,
    type character varying(50) NOT NULL,
    amount numeric(10,2) NOT NULL,
    reason character varying(255),
    reference_type character varying(100),
    reference_id uuid,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cash_transactions OWNER TO pos_user;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.categories (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.categories OWNER TO pos_user;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.customers (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    full_name character varying(200) NOT NULL,
    whatsapp character varying(50),
    email character varying(200),
    birthday date,
    marketing_consent boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    document_type character varying(20),
    document_number character varying(50)
);


ALTER TABLE public.customers OWNER TO pos_user;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO pos_user;

--
-- Name: inventory; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.inventory (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    store_id uuid NOT NULL,
    variant_id uuid NOT NULL,
    quantity numeric(14,3) DEFAULT 0 NOT NULL,
    average_cost numeric(14,2) DEFAULT 0 NOT NULL,
    min_stock numeric(14,3) DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.inventory OWNER TO pos_user;

--
-- Name: inventory_movements; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.inventory_movements (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    store_id uuid NOT NULL,
    variant_id uuid NOT NULL,
    movement_type character varying(40) NOT NULL,
    quantity numeric(14,3) NOT NULL,
    unit_cost numeric(14,2),
    reference_type character varying(50),
    reference_id uuid,
    reason character varying(300),
    created_by uuid NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.inventory_movements OWNER TO pos_user;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.invoices (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    sale_id uuid NOT NULL,
    invoice_number character varying(100),
    status character varying(50) NOT NULL,
    external_id character varying(100),
    issued_at timestamp without time zone
);


ALTER TABLE public.invoices OWNER TO pos_user;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.payments (
    id uuid NOT NULL,
    sale_id uuid NOT NULL,
    payment_method character varying(40) NOT NULL,
    amount numeric(14,2) NOT NULL,
    reference character varying(150),
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.payments OWNER TO pos_user;

--
-- Name: product_variants; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.product_variants (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    product_id uuid NOT NULL,
    sku character varying(80) NOT NULL,
    barcode character varying(80),
    price numeric(14,2) NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    size character varying(50),
    color character varying(50)
);


ALTER TABLE public.product_variants OWNER TO pos_user;

--
-- Name: products; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.products (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    category_id uuid,
    brand_id uuid,
    name character varying(200) NOT NULL,
    description text,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    base_price numeric(10,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.products OWNER TO pos_user;

--
-- Name: purchase_items; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.purchase_items (
    id uuid NOT NULL,
    purchase_id uuid NOT NULL,
    variant_id uuid NOT NULL,
    quantity numeric(19,2) NOT NULL,
    unit_cost numeric(19,2) NOT NULL,
    total_cost numeric(19,2) NOT NULL
);


ALTER TABLE public.purchase_items OWNER TO pos_user;

--
-- Name: purchases; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.purchases (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    store_id uuid NOT NULL,
    supplier_id uuid NOT NULL,
    status character varying(50) NOT NULL,
    total_amount numeric(19,2) NOT NULL,
    reference_invoice character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.purchases OWNER TO pos_user;

--
-- Name: sale_items; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.sale_items (
    id uuid NOT NULL,
    sale_id uuid NOT NULL,
    variant_id uuid NOT NULL,
    quantity numeric(14,3) NOT NULL,
    unit_price numeric(14,2) NOT NULL,
    discount numeric(14,2) DEFAULT 0 NOT NULL,
    unit_cost numeric(14,2),
    total numeric(14,2) NOT NULL
);


ALTER TABLE public.sale_items OWNER TO pos_user;

--
-- Name: sale_payments; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.sale_payments (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    sale_id uuid NOT NULL,
    payment_method character varying(50) NOT NULL,
    amount numeric(10,2) NOT NULL
);


ALTER TABLE public.sale_payments OWNER TO pos_user;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.sales (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    store_id uuid NOT NULL,
    customer_id uuid,
    status character varying(30) NOT NULL,
    subtotal numeric(14,2) NOT NULL,
    discount numeric(14,2) DEFAULT 0 NOT NULL,
    total numeric(14,2) NOT NULL,
    completed_at timestamp with time zone,
    created_by uuid NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.sales OWNER TO pos_user;

--
-- Name: stores; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.stores (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    name character varying(150) NOT NULL,
    address character varying(300),
    phone character varying(50),
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.stores OWNER TO pos_user;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.suppliers (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    document_number character varying(100) NOT NULL,
    email character varying(255),
    whatsapp character varying(50),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.suppliers OWNER TO pos_user;

--
-- Name: tenants; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.tenants (
    id uuid NOT NULL,
    name character varying(150) NOT NULL,
    legal_name character varying(200),
    tax_id character varying(50),
    status character varying(30) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.tenants OWNER TO pos_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: pos_user
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    email character varying(200) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO pos_user;

--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.audit_logs (id, tenant_id, user_id, action, entity_type, entity_id, old_value, new_value, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.brands (id, tenant_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: cash_registers; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.cash_registers (id, tenant_id, store_id, name, active, created_at, updated_at) FROM stdin;
44444444-4444-4444-4444-444444444444	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	Caja Principal	t	2026-10-06 15:50:38.749869+00	2026-10-06 15:50:38.749869+00
\.


--
-- Data for Name: cash_sessions; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.cash_sessions (id, tenant_id, store_id, cash_register_id, opened_by, opened_at, closed_by, closed_at, opening_balance, closing_balance_expected, closing_balance_actual, status, closing_notes) FROM stdin;
c444d8b3-9467-4df4-b77f-607e4fb8fbcd	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	44444444-4444-4444-4444-444444444444	33333333-3333-3333-3333-333333333333	2026-10-06 17:46:40.7855+00	\N	\N	0.00	\N	\N	OPEN	\N
\.


--
-- Data for Name: cash_transactions; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.cash_transactions (id, tenant_id, cash_session_id, type, amount, reason, reference_type, reference_id, created_by, created_at) FROM stdin;
405c4889-3ad0-4f95-b55b-8d26a4c1a14e	11111111-1111-1111-1111-111111111111	c444d8b3-9467-4df4-b77f-607e4fb8fbcd	IN	200000.00	Pago en Efectivo - Venta #a65e8bf1-4862-4ac4-ba52-6f642acfccdb	SALE	a65e8bf1-4862-4ac4-ba52-6f642acfccdb	33333333-3333-3333-3333-333333333333	2026-10-06 17:47:21.721004+00
2788ee4c-573c-430e-a01e-ffdfb6bb93d8	11111111-1111-1111-1111-111111111111	c444d8b3-9467-4df4-b77f-607e4fb8fbcd	IN	450000.00	Pago en Efectivo - Venta #8319a321-a476-406d-97cb-202a163d2c34	SALE	8319a321-a476-406d-97cb-202a163d2c34	33333333-3333-3333-3333-333333333333	2026-10-06 20:05:14.593657+00
bbe3ac1e-1cf5-4e0e-9743-f4169328b392	11111111-1111-1111-1111-111111111111	c444d8b3-9467-4df4-b77f-607e4fb8fbcd	IN	270000.00	Pago en Efectivo - Venta #0761810d-f160-477d-a428-ad7773633d9d	SALE	0761810d-f160-477d-a428-ad7773633d9d	33333333-3333-3333-3333-333333333333	2026-10-06 20:05:41.376984+00
f6d25ee4-2398-4315-97ea-515ed958bb5b	11111111-1111-1111-1111-111111111111	c444d8b3-9467-4df4-b77f-607e4fb8fbcd	IN	140000.00	Pago en Efectivo - Venta #6a5dc074-c0bd-4395-864e-28e061f66daf	SALE	6a5dc074-c0bd-4395-864e-28e061f66daf	33333333-3333-3333-3333-333333333333	2026-10-06 20:06:27.807983+00
8d9ecf15-f407-4bdc-9ef0-fedaf548f43b	11111111-1111-1111-1111-111111111111	c444d8b3-9467-4df4-b77f-607e4fb8fbcd	IN	450000.00	Pago en Efectivo - Venta #8ebf57d4-1fed-49ad-af25-e81141cf02d2	SALE	8ebf57d4-1fed-49ad-af25-e81141cf02d2	33333333-3333-3333-3333-333333333333	2026-10-06 20:21:48.67767+00
fd43e631-c175-49ff-bb16-a8547592ecca	11111111-1111-1111-1111-111111111111	c444d8b3-9467-4df4-b77f-607e4fb8fbcd	IN	50000.00	Pago en Efectivo - Venta #f698bb84-2fbe-4854-b3df-fcb22d02dad6	SALE	f698bb84-2fbe-4854-b3df-fcb22d02dad6	33333333-3333-3333-3333-333333333333	2026-10-06 21:17:08.308768+00
8fa5a9af-2545-418d-8a2b-47c070bd5314	11111111-1111-1111-1111-111111111111	c444d8b3-9467-4df4-b77f-607e4fb8fbcd	IN	100000.00	Pago en Efectivo - Venta #a3340750-c9b8-46eb-8fb0-bbc71daca981	SALE	a3340750-c9b8-46eb-8fb0-bbc71daca981	33333333-3333-3333-3333-333333333333	2026-10-07 01:02:55.211914+00
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.categories (id, tenant_id, name, description, created_at, updated_at) FROM stdin;
b26d2173-34ea-484d-a007-508ca599cdeb	11111111-1111-1111-1111-111111111111	Camisetas	camisetas	2026-10-06 12:11:33.779183	2026-10-06 12:11:33.779183
01c7a004-beef-4117-adb5-427985f63692	11111111-1111-1111-1111-111111111111	Jogger	Jogger	2026-10-06 14:31:30.811239	2026-10-06 14:31:30.811239
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.customers (id, tenant_id, full_name, whatsapp, email, birthday, marketing_consent, created_at, updated_at, document_type, document_number) FROM stdin;
e39b817c-3867-4a25-8d7d-4ee4dc34c7d8	11111111-1111-1111-1111-111111111111	John Rios	321677	alex@gmail.com	\N	f	2026-10-06 17:02:52.076654+00	2026-10-06 17:02:52.076654+00	CC	1017233
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	init schema	SQL	V1__init_schema.sql	1866401723	pos_user	2026-10-06 10:50:38.653707	39	t
2	2	create users table	SQL	V2__create_users_table.sql	-984595158	pos_user	2026-10-06 10:50:38.709663	6	t
3	3	create catalog tables	SQL	V3__create_catalog_tables.sql	1764331048	pos_user	2026-10-06 10:50:38.722949	10	t
4	5	insert seed data	SQL	V5__insert_seed_data.sql	1048329676	pos_user	2026-10-06 10:50:38.739445	3	t
5	6	create cash management tables	SQL	V6__create_cash_management_tables.sql	-733571537	pos_user	2026-10-06 10:50:38.747796	6	t
6	7	add payments and cash notes	SQL	V7__add_payments_and_cash_notes.sql	-1714909167	pos_user	2026-10-06 10:50:38.760131	5	t
7	8	add customer fields	SQL	V8__add_customer_fields.sql	-544320681	pos_user	2026-10-06 10:50:38.771332	4	t
8	9	create purchasing tables	SQL	V9__create_purchasing_tables.sql	496023158	pos_user	2026-10-06 13:12:57.136303	16	t
9	10	create billing tables	SQL	V10__create_billing_tables.sql	-357859046	pos_user	2026-10-06 15:04:51.151357	13	t
10	11	update admin password	SQL	V11__update_admin_password.sql	135745277	pos_user	2026-10-06 21:01:28.519819	12	t
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.inventory (id, tenant_id, store_id, variant_id, quantity, average_cost, min_stock, updated_at) FROM stdin;
f3126c49-24a7-45e8-951c-3ca0e8a28ca4	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	5678d657-15ae-4ead-b42d-f85386c88cac	16.000	0.00	0.000	2026-10-06 19:33:49.112849+00
89b38e90-9446-4830-9340-bc2c764e33f1	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	c84ca2b0-98ea-45e3-9d16-7924bb44feac	6.000	0.00	0.000	2026-10-06 20:21:48.678077+00
d8b7a418-d3bc-4e9b-ab88-67d3b5dd8a6c	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	939284b4-c1ee-4981-80b0-16e024940f1a	7.000	0.00	0.000	2026-10-06 21:17:08.309474+00
5581c5ff-4e5c-4c3d-a1ec-c6580d8e7b7b	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	37fbd860-3d7e-4280-a7bc-3add12ca020b	7.000	0.00	0.000	2026-10-07 01:02:55.212265+00
\.


--
-- Data for Name: inventory_movements; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.inventory_movements (id, tenant_id, store_id, variant_id, movement_type, quantity, unit_cost, reference_type, reference_id, reason, created_by, created_at) FROM stdin;
2f2d080e-dbf1-4edd-82dd-105a443bac0c	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	5678d657-15ae-4ead-b42d-f85386c88cac	IN	10.000	\N	\N	\N	Inicialización de Stock	33333333-3333-3333-3333-333333333333	2026-10-06 17:24:50.213993+00
46220835-5c20-4afb-bca3-30d219e02691	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	37fbd860-3d7e-4280-a7bc-3add12ca020b	IN	10.000	\N	\N	\N	Inicialización de Stock	33333333-3333-3333-3333-333333333333	2026-10-06 17:24:55.000304+00
80a427e6-fef7-4a75-91de-73d22ab7ab2f	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	939284b4-c1ee-4981-80b0-16e024940f1a	IN	10.000	\N	\N	\N	Inicialización de Stock	33333333-3333-3333-3333-333333333333	2026-10-06 17:25:02.232232+00
d32f3f35-5e6f-42e6-89c1-af68d1cb6263	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	5678d657-15ae-4ead-b42d-f85386c88cac	OUT	2.000	\N	SALE	a65e8bf1-4862-4ac4-ba52-6f642acfccdb	SALE	33333333-3333-3333-3333-333333333333	2026-10-06 17:47:21.691082+00
441b495d-c33f-41c4-8907-35ca169f8a7d	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	939284b4-c1ee-4981-80b0-16e024940f1a	OUT	2.000	\N	SALE	a65e8bf1-4862-4ac4-ba52-6f642acfccdb	SALE	33333333-3333-3333-3333-333333333333	2026-10-06 17:47:21.715009+00
54b8b3ba-5050-4458-9ff5-44e7f38c5193	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	5678d657-15ae-4ead-b42d-f85386c88cac	IN	10.000	25000.00	PURCHASE	723fd90f-0004-4941-b064-500e26869447	PURCHASE	33333333-3333-3333-3333-333333333333	2026-10-06 18:47:42.633341+00
d321e772-1772-4243-a038-94f5d6ea7161	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	c84ca2b0-98ea-45e3-9d16-7924bb44feac	IN	10.000	\N	\N	\N	Inicialización de Stock	33333333-3333-3333-3333-333333333333	2026-10-06 19:32:55.927644+00
5bd9dcff-57ce-46fd-b8d6-383761b6df1c	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	c84ca2b0-98ea-45e3-9d16-7924bb44feac	IN	10.000	60000.00	PURCHASE	d4ef25b1-4ad6-4eb0-ad36-e8a3dfb6322f	PURCHASE	33333333-3333-3333-3333-333333333333	2026-10-06 19:33:24.764192+00
5f84ee2b-ba9a-4c45-8a12-93ece07f38f4	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	5678d657-15ae-4ead-b42d-f85386c88cac	OUT	2.000	\N	\N	\N	merma	33333333-3333-3333-3333-333333333333	2026-10-06 19:33:49.112489+00
220cdce1-afd6-4262-b2ab-02ee2ee5b158	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	c84ca2b0-98ea-45e3-9d16-7924bb44feac	OUT	5.000	\N	SALE	8319a321-a476-406d-97cb-202a163d2c34	SALE	33333333-3333-3333-3333-333333333333	2026-10-06 20:05:14.586835+00
dfe9fb4f-012f-4c5d-b192-12a2a103d59a	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	c84ca2b0-98ea-45e3-9d16-7924bb44feac	OUT	2.000	\N	SALE	0761810d-f160-477d-a428-ad7773633d9d	SALE	33333333-3333-3333-3333-333333333333	2026-10-06 20:05:41.361148+00
5f6e25ba-42cb-49ac-bb70-f8d5a2f2b816	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	c84ca2b0-98ea-45e3-9d16-7924bb44feac	OUT	1.000	\N	SALE	0761810d-f160-477d-a428-ad7773633d9d	SALE	33333333-3333-3333-3333-333333333333	2026-10-06 20:05:41.373977+00
2e7a1633-8378-44f3-8881-44fc9fd655d7	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	c84ca2b0-98ea-45e3-9d16-7924bb44feac	OUT	1.000	\N	SALE	6a5dc074-c0bd-4395-864e-28e061f66daf	SALE	33333333-3333-3333-3333-333333333333	2026-10-06 20:06:27.792813+00
b91a2c91-685a-4500-98fd-89df4b9c533e	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	37fbd860-3d7e-4280-a7bc-3add12ca020b	OUT	1.000	\N	SALE	6a5dc074-c0bd-4395-864e-28e061f66daf	SALE	33333333-3333-3333-3333-333333333333	2026-10-06 20:06:27.805871+00
84176c1e-5186-4eb7-a3bf-ecfdf47eaf3c	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	c84ca2b0-98ea-45e3-9d16-7924bb44feac	OUT	5.000	\N	SALE	8ebf57d4-1fed-49ad-af25-e81141cf02d2	SALE	33333333-3333-3333-3333-333333333333	2026-10-06 20:21:48.675428+00
e83eb7d1-7739-46e4-a39d-fecbca13fe0d	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	939284b4-c1ee-4981-80b0-16e024940f1a	OUT	1.000	\N	SALE	f698bb84-2fbe-4854-b3df-fcb22d02dad6	SALE	33333333-3333-3333-3333-333333333333	2026-10-06 21:17:08.302847+00
7d65e47d-e709-4911-a352-bb088eada5a7	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	37fbd860-3d7e-4280-a7bc-3add12ca020b	OUT	2.000	\N	SALE	a3340750-c9b8-46eb-8fb0-bbc71daca981	SALE	33333333-3333-3333-3333-333333333333	2026-10-07 01:02:55.210024+00
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.invoices (id, tenant_id, sale_id, invoice_number, status, external_id, issued_at) FROM stdin;
94425521-e442-4ff0-8b97-86bc66c7061a	11111111-1111-1111-1111-111111111111	6a5dc074-c0bd-4395-864e-28e061f66daf	INV-204346	APPROVED	a6ad1c54-d66e-44a7-8c14-3fe5c8830afd	2026-10-06 15:16:47.118471
223871ef-5989-43f4-b51a-d54fbdd13ae7	11111111-1111-1111-1111-111111111111	f698bb84-2fbe-4854-b3df-fcb22d02dad6	INV-7849	APPROVED	f67070c5-a7f5-4b2b-ab5b-5d7967305eb3	2026-10-06 21:17:10.249775
6421e45e-ac19-402d-99a5-548fb57d96d9	11111111-1111-1111-1111-111111111111	a3340750-c9b8-46eb-8fb0-bbc71daca981	INV-346768	APPROVED	06582854-d50a-4071-81e7-79271735cb81	2026-10-07 01:03:02.194709
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.payments (id, sale_id, payment_method, amount, reference, created_at) FROM stdin;
\.


--
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.product_variants (id, tenant_id, product_id, sku, barcode, price, active, created_at, updated_at, size, color) FROM stdin;
5678d657-15ae-4ead-b42d-f85386c88cac	11111111-1111-1111-1111-111111111111	60f5d89a-00af-4c73-a51b-3a586c124f5c	SKU-498PSG	\N	50000.00	t	2026-10-06 17:12:01.691863+00	2026-10-06 17:12:01.691863+00	L	Negra
939284b4-c1ee-4981-80b0-16e024940f1a	11111111-1111-1111-1111-111111111111	60f5d89a-00af-4c73-a51b-3a586c124f5c	SKU-TMUZHX	\N	50000.00	t	2026-10-06 17:24:12.552642+00	2026-10-06 17:24:12.552642+00	L	balnca
37fbd860-3d7e-4280-a7bc-3add12ca020b	11111111-1111-1111-1111-111111111111	60f5d89a-00af-4c73-a51b-3a586c124f5c	SKU-MO4F2W	\N	50000.00	t	2026-10-06 17:24:25.553049+00	2026-10-06 17:24:25.553049+00	S	amarilla
c84ca2b0-98ea-45e3-9d16-7924bb44feac	11111111-1111-1111-1111-111111111111	6fd047c1-68c3-4b67-83e9-b74478347125	SKU-QC7ZKJ	\N	90000.00	t	2026-10-06 19:32:24.653095+00	2026-10-06 19:32:24.653095+00	L	Negro
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.products (id, tenant_id, category_id, brand_id, name, description, active, created_at, updated_at, base_price) FROM stdin;
60f5d89a-00af-4c73-a51b-3a586c124f5c	11111111-1111-1111-1111-111111111111	b26d2173-34ea-484d-a007-508ca599cdeb	\N	basica	camisetas basicas	t	2026-10-06 17:11:53.701941+00	2026-10-06 17:11:53.701941+00	50000.00
6fd047c1-68c3-4b67-83e9-b74478347125	11111111-1111-1111-1111-111111111111	01c7a004-beef-4117-adb5-427985f63692	\N	cargo	jogger cargo	t	2026-10-06 19:32:02.117098+00	2026-10-06 19:32:02.117098+00	90000.00
\.


--
-- Data for Name: purchase_items; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.purchase_items (id, purchase_id, variant_id, quantity, unit_cost, total_cost) FROM stdin;
3ce6cf38-4bf9-4924-9d6d-e603f2322df8	723fd90f-0004-4941-b064-500e26869447	5678d657-15ae-4ead-b42d-f85386c88cac	10.00	25000.00	250000.00
551349af-25b7-43c4-8ef3-8ccd7b505f69	d4ef25b1-4ad6-4eb0-ad36-e8a3dfb6322f	c84ca2b0-98ea-45e3-9d16-7924bb44feac	10.00	60000.00	600000.00
\.


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.purchases (id, tenant_id, store_id, supplier_id, status, total_amount, reference_invoice, created_at, updated_at) FROM stdin;
723fd90f-0004-4941-b064-500e26869447	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	d04cf4af-da55-488e-8f63-8551ef422963	COMPLETED	250000.00		2026-10-06 13:47:42.558342	2026-10-06 13:47:42.558358
d4ef25b1-4ad6-4eb0-ad36-e8a3dfb6322f	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	d04cf4af-da55-488e-8f63-8551ef422963	COMPLETED	600000.00		2026-10-06 14:33:24.753239	2026-10-06 14:33:24.753251
\.


--
-- Data for Name: sale_items; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.sale_items (id, sale_id, variant_id, quantity, unit_price, discount, unit_cost, total) FROM stdin;
4f101de8-74c3-40ac-9e0c-1752cc3a150a	a65e8bf1-4862-4ac4-ba52-6f642acfccdb	5678d657-15ae-4ead-b42d-f85386c88cac	2.000	50000.00	0.00	\N	100000.00
07d08afe-e870-4b43-a481-c834070fea74	a65e8bf1-4862-4ac4-ba52-6f642acfccdb	939284b4-c1ee-4981-80b0-16e024940f1a	2.000	50000.00	0.00	\N	100000.00
094e682f-63d6-4000-b998-a1893f0ddf3b	8319a321-a476-406d-97cb-202a163d2c34	c84ca2b0-98ea-45e3-9d16-7924bb44feac	5.000	90000.00	0.00	\N	450000.00
de2b7069-6926-4309-9789-2ae6ab53dff8	0761810d-f160-477d-a428-ad7773633d9d	c84ca2b0-98ea-45e3-9d16-7924bb44feac	2.000	90000.00	0.00	\N	180000.00
0614fcfe-4e36-4dbc-bd1c-2b4d78c66867	0761810d-f160-477d-a428-ad7773633d9d	c84ca2b0-98ea-45e3-9d16-7924bb44feac	1.000	90000.00	0.00	\N	90000.00
c1d68b91-610a-4a6c-b093-dd0ebfa63b22	6a5dc074-c0bd-4395-864e-28e061f66daf	c84ca2b0-98ea-45e3-9d16-7924bb44feac	1.000	90000.00	0.00	\N	90000.00
e26d92f4-a2bb-4d63-ab15-3adcf5efb0dd	6a5dc074-c0bd-4395-864e-28e061f66daf	37fbd860-3d7e-4280-a7bc-3add12ca020b	1.000	50000.00	0.00	\N	50000.00
f40c246f-8655-4237-a999-1a9abfe7c2da	8ebf57d4-1fed-49ad-af25-e81141cf02d2	c84ca2b0-98ea-45e3-9d16-7924bb44feac	5.000	90000.00	0.00	\N	450000.00
35d1dbe0-4cdd-4d6c-8564-7e2fe49b0f9e	f698bb84-2fbe-4854-b3df-fcb22d02dad6	939284b4-c1ee-4981-80b0-16e024940f1a	1.000	50000.00	0.00	\N	50000.00
6d8bda98-c5b8-47fa-9709-9287b180eb9c	a3340750-c9b8-46eb-8fb0-bbc71daca981	37fbd860-3d7e-4280-a7bc-3add12ca020b	2.000	50000.00	0.00	\N	100000.00
\.


--
-- Data for Name: sale_payments; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.sale_payments (id, tenant_id, sale_id, payment_method, amount) FROM stdin;
56b5a95d-5057-4ba0-92f2-be387ce03561	11111111-1111-1111-1111-111111111111	a65e8bf1-4862-4ac4-ba52-6f642acfccdb	CASH	200000.00
0be3da03-5fe6-45fb-9a8f-c54f475de903	11111111-1111-1111-1111-111111111111	8319a321-a476-406d-97cb-202a163d2c34	CASH	450000.00
d67e2059-5cf2-4728-8113-ac621732c270	11111111-1111-1111-1111-111111111111	0761810d-f160-477d-a428-ad7773633d9d	CASH	270000.00
1bd4f615-ee5c-4e67-84b4-8ee9df586626	11111111-1111-1111-1111-111111111111	6a5dc074-c0bd-4395-864e-28e061f66daf	CASH	140000.00
5ad1ccb3-e009-4c11-8a26-43ab90e629cf	11111111-1111-1111-1111-111111111111	8ebf57d4-1fed-49ad-af25-e81141cf02d2	CASH	450000.00
5aebe993-983e-4800-b645-99e7e8a201d2	11111111-1111-1111-1111-111111111111	f698bb84-2fbe-4854-b3df-fcb22d02dad6	CASH	50000.00
c90b16db-ecf6-406f-932c-1dbb1662fda7	11111111-1111-1111-1111-111111111111	a3340750-c9b8-46eb-8fb0-bbc71daca981	CASH	100000.00
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.sales (id, tenant_id, store_id, customer_id, status, subtotal, discount, total, completed_at, created_by, created_at) FROM stdin;
a65e8bf1-4862-4ac4-ba52-6f642acfccdb	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	\N	COMPLETED	200000.00	0.00	200000.00	2026-10-06 17:47:21.670737+00	33333333-3333-3333-3333-333333333333	2026-10-06 17:47:21.67849+00
8319a321-a476-406d-97cb-202a163d2c34	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	\N	COMPLETED	450000.00	0.00	450000.00	2026-10-06 20:05:14.525202+00	33333333-3333-3333-3333-333333333333	2026-10-06 20:05:14.552202+00
0761810d-f160-477d-a428-ad7773633d9d	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	e39b817c-3867-4a25-8d7d-4ee4dc34c7d8	COMPLETED	270000.00	0.00	270000.00	2026-10-06 20:05:41.349144+00	33333333-3333-3333-3333-333333333333	2026-10-06 20:05:41.353662+00
6a5dc074-c0bd-4395-864e-28e061f66daf	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	\N	COMPLETED	140000.00	0.00	140000.00	2026-10-06 20:06:27.781938+00	33333333-3333-3333-3333-333333333333	2026-10-06 20:06:27.786213+00
8ebf57d4-1fed-49ad-af25-e81141cf02d2	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	e39b817c-3867-4a25-8d7d-4ee4dc34c7d8	COMPLETED	450000.00	0.00	450000.00	2026-10-06 20:21:48.665064+00	33333333-3333-3333-3333-333333333333	2026-10-06 20:21:48.667881+00
f698bb84-2fbe-4854-b3df-fcb22d02dad6	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	\N	COMPLETED	50000.00	0.00	50000.00	2026-10-06 21:17:08.258459+00	33333333-3333-3333-3333-333333333333	2026-10-06 21:17:08.280851+00
a3340750-c9b8-46eb-8fb0-bbc71daca981	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	\N	COMPLETED	100000.00	0.00	100000.00	2026-10-07 01:02:55.199965+00	33333333-3333-3333-3333-333333333333	2026-10-07 01:02:55.203026+00
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.stores (id, tenant_id, name, address, phone, active, created_at, updated_at) FROM stdin;
22222222-2222-2222-2222-222222222222	11111111-1111-1111-1111-111111111111	Main Store	\N	\N	t	2026-10-06 15:50:38.742119+00	2026-10-06 15:50:38.742119+00
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.suppliers (id, tenant_id, name, document_number, email, whatsapp, created_at, updated_at) FROM stdin;
d04cf4af-da55-488e-8f63-8551ef422963	11111111-1111-1111-1111-111111111111	raven	12334131	alece@asfef.com	3216772	2026-10-06 13:13:49.140744	2026-10-06 13:13:49.140767
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.tenants (id, name, legal_name, tax_id, status, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	Default Tenant	\N	\N	ACTIVE	2026-10-06 15:50:38.742119+00	2026-10-06 15:50:38.742119+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pos_user
--

COPY public.users (id, tenant_id, email, password_hash, role, created_at, updated_at) FROM stdin;
33333333-3333-3333-3333-333333333333	11111111-1111-1111-1111-111111111111	admin@store.com	$2a$12$x21vltTOyIBE/bcljdSVd.fyUlRPtI0ByzmZIDMKhFDRMWyQ2ldE2	ADMIN	2026-10-06 15:50:38.742119+00	2026-10-06 15:50:38.742119+00
\.


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: cash_registers cash_registers_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.cash_registers
    ADD CONSTRAINT cash_registers_pkey PRIMARY KEY (id);


--
-- Name: cash_sessions cash_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.cash_sessions
    ADD CONSTRAINT cash_sessions_pkey PRIMARY KEY (id);


--
-- Name: cash_transactions cash_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.cash_transactions
    ADD CONSTRAINT cash_transactions_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: inventory_movements inventory_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_store_id_variant_id_key; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_store_id_variant_id_key UNIQUE (store_id, variant_id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);


--
-- Name: product_variants product_variants_tenant_id_sku_key; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_tenant_id_sku_key UNIQUE (tenant_id, sku);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: purchase_items purchase_items_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_pkey PRIMARY KEY (id);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: sale_items sale_items_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT sale_items_pkey PRIMARY KEY (id);


--
-- Name: sale_payments sale_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.sale_payments
    ADD CONSTRAINT sale_payments_pkey PRIMARY KEY (id);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_tenant_id_email_key; Type: CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_tenant_id_email_key UNIQUE (tenant_id, email);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: pos_user
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_stores_tenant; Type: INDEX; Schema: public; Owner: pos_user
--

CREATE INDEX idx_stores_tenant ON public.stores USING btree (tenant_id);


--
-- Name: uq_variant_barcode; Type: INDEX; Schema: public; Owner: pos_user
--

CREATE UNIQUE INDEX uq_variant_barcode ON public.product_variants USING btree (tenant_id, barcode) WHERE (barcode IS NOT NULL);


--
-- Name: audit_logs audit_logs_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: brands brands_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: cash_sessions cash_sessions_cash_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.cash_sessions
    ADD CONSTRAINT cash_sessions_cash_register_id_fkey FOREIGN KEY (cash_register_id) REFERENCES public.cash_registers(id);


--
-- Name: cash_transactions cash_transactions_cash_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.cash_transactions
    ADD CONSTRAINT cash_transactions_cash_session_id_fkey FOREIGN KEY (cash_session_id) REFERENCES public.cash_sessions(id);


--
-- Name: categories categories_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: customers customers_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: products fk_products_brand; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_brand FOREIGN KEY (brand_id) REFERENCES public.brands(id);


--
-- Name: products fk_products_category; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: purchases fk_purchase_supplier; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT fk_purchase_supplier FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: purchase_items fk_purchaseitem_purchase; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT fk_purchaseitem_purchase FOREIGN KEY (purchase_id) REFERENCES public.purchases(id);


--
-- Name: inventory_movements inventory_movements_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: inventory_movements inventory_movements_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: inventory_movements inventory_movements_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(id);


--
-- Name: inventory inventory_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: inventory inventory_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: inventory inventory_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(id);


--
-- Name: invoices invoices_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: invoices invoices_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: payments payments_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: product_variants product_variants_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_variants product_variants_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: products products_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: sale_items sale_items_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT sale_items_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: sale_items sale_items_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT sale_items_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(id);


--
-- Name: sale_payments sale_payments_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.sale_payments
    ADD CONSTRAINT sale_payments_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: sales sales_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: sales sales_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: stores stores_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: users users_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- PostgreSQL database dump complete
--

\unrestrict wcx4fkXZhJnFRWXt2MytzPdKyxdSYV1F2SK0NJUpZo36lM8lf3dDaSCqeZdeqUv

