--
-- PostgreSQL database dump
--

\restrict lLUAv4F0nwb2hb8zOLpJOpTSjVbTozykakmp0HPyZHDogBqqNxcBuPVf9kMhEcZ

-- Dumped from database version 18.6 (Homebrew)
-- Dumped by pg_dump version 18.6 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.batch_step_execution_context DROP CONSTRAINT IF EXISTS step_exec_ctx_fk;
ALTER TABLE IF EXISTS ONLY public.batch_job_execution DROP CONSTRAINT IF EXISTS job_inst_exec_fk;
ALTER TABLE IF EXISTS ONLY public.batch_step_execution DROP CONSTRAINT IF EXISTS job_exec_step_fk;
ALTER TABLE IF EXISTS ONLY public.batch_job_execution_params DROP CONSTRAINT IF EXISTS job_exec_params_fk;
ALTER TABLE IF EXISTS ONLY public.batch_job_execution_context DROP CONSTRAINT IF EXISTS job_exec_ctx_fk;
ALTER TABLE IF EXISTS ONLY public.estados_cuenta DROP CONSTRAINT IF EXISTS uq_estado_cuenta;
ALTER TABLE IF EXISTS ONLY public.transacciones DROP CONSTRAINT IF EXISTS transacciones_pkey;
ALTER TABLE IF EXISTS ONLY public.retiros_atm DROP CONSTRAINT IF EXISTS retiros_atm_pkey;
ALTER TABLE IF EXISTS ONLY public.resumen_transacciones_diarias DROP CONSTRAINT IF EXISTS resumen_transacciones_diarias_pkey;
ALTER TABLE IF EXISTS ONLY public.resumen_anual DROP CONSTRAINT IF EXISTS resumen_anual_pkey;
ALTER TABLE IF EXISTS ONLY public.batch_job_instance DROP CONSTRAINT IF EXISTS job_inst_un;
ALTER TABLE IF EXISTS ONLY public.intereses DROP CONSTRAINT IF EXISTS intereses_pkey;
ALTER TABLE IF EXISTS ONLY public.estados_cuenta DROP CONSTRAINT IF EXISTS estados_cuenta_pkey;
ALTER TABLE IF EXISTS ONLY public.batch_step_execution DROP CONSTRAINT IF EXISTS batch_step_execution_pkey;
ALTER TABLE IF EXISTS ONLY public.batch_step_execution_context DROP CONSTRAINT IF EXISTS batch_step_execution_context_pkey;
ALTER TABLE IF EXISTS ONLY public.batch_job_instance DROP CONSTRAINT IF EXISTS batch_job_instance_pkey;
ALTER TABLE IF EXISTS ONLY public.batch_job_execution DROP CONSTRAINT IF EXISTS batch_job_execution_pkey;
ALTER TABLE IF EXISTS ONLY public.batch_job_execution_context DROP CONSTRAINT IF EXISTS batch_job_execution_context_pkey;
ALTER TABLE IF EXISTS public.retiros_atm ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.transacciones;
DROP SEQUENCE IF EXISTS public.retiros_atm_id_seq;
DROP TABLE IF EXISTS public.retiros_atm;
DROP TABLE IF EXISTS public.resumen_transacciones_diarias;
DROP TABLE IF EXISTS public.resumen_anual;
DROP TABLE IF EXISTS public.intereses;
DROP TABLE IF EXISTS public.estados_cuenta;
DROP SEQUENCE IF EXISTS public.batch_step_execution_seq;
DROP TABLE IF EXISTS public.batch_step_execution_context;
DROP TABLE IF EXISTS public.batch_step_execution;
DROP SEQUENCE IF EXISTS public.batch_job_seq;
DROP TABLE IF EXISTS public.batch_job_instance;
DROP SEQUENCE IF EXISTS public.batch_job_execution_seq;
DROP TABLE IF EXISTS public.batch_job_execution_params;
DROP TABLE IF EXISTS public.batch_job_execution_context;
DROP TABLE IF EXISTS public.batch_job_execution;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: batch_job_execution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_job_execution (
    job_execution_id bigint NOT NULL,
    version bigint,
    job_instance_id bigint NOT NULL,
    create_time timestamp without time zone NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    status character varying(10),
    exit_code character varying(2500),
    exit_message character varying(2500),
    last_updated timestamp without time zone
);


--
-- Name: batch_job_execution_context; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_job_execution_context (
    job_execution_id bigint NOT NULL,
    short_context character varying(2500) NOT NULL,
    serialized_context text
);


--
-- Name: batch_job_execution_params; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_job_execution_params (
    job_execution_id bigint NOT NULL,
    parameter_name character varying(100) NOT NULL,
    parameter_type character varying(100) NOT NULL,
    parameter_value character varying(2500),
    identifying character(1) NOT NULL
);


--
-- Name: batch_job_execution_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.batch_job_execution_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: batch_job_instance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_job_instance (
    job_instance_id bigint NOT NULL,
    version bigint,
    job_name character varying(100) NOT NULL,
    job_key character varying(32) NOT NULL
);


--
-- Name: batch_job_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.batch_job_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: batch_step_execution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_step_execution (
    step_execution_id bigint NOT NULL,
    version bigint NOT NULL,
    step_name character varying(100) NOT NULL,
    job_execution_id bigint NOT NULL,
    create_time timestamp without time zone NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    status character varying(10),
    commit_count bigint,
    read_count bigint,
    filter_count bigint,
    write_count bigint,
    read_skip_count bigint,
    write_skip_count bigint,
    process_skip_count bigint,
    rollback_count bigint,
    exit_code character varying(2500),
    exit_message character varying(2500),
    last_updated timestamp without time zone
);


--
-- Name: batch_step_execution_context; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_step_execution_context (
    step_execution_id bigint NOT NULL,
    short_context character varying(2500) NOT NULL,
    serialized_context text
);


--
-- Name: batch_step_execution_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.batch_step_execution_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estados_cuenta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estados_cuenta (
    cuenta_id bigint NOT NULL,
    fecha date NOT NULL,
    transaccion character varying(50) NOT NULL,
    monto numeric(15,2) NOT NULL,
    descripcion character varying(255),
    movimiento character varying(50) NOT NULL,
    anomalia boolean NOT NULL,
    motivo character varying(255)
);


--
-- Name: intereses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.intereses (
    cuenta_id bigint NOT NULL,
    nombre character varying(150) NOT NULL,
    saldo numeric(15,2) NOT NULL,
    edad integer NOT NULL,
    tipo character varying(50) NOT NULL,
    interes numeric(15,2) NOT NULL,
    saldo_final numeric(15,2) NOT NULL,
    anomalia boolean NOT NULL,
    motivo character varying(255)
);


--
-- Name: resumen_anual; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resumen_anual (
    cuenta_id bigint NOT NULL,
    cantidad_movimientos integer NOT NULL,
    total_ingresos numeric(15,2) NOT NULL,
    total_egresos numeric(15,2) NOT NULL,
    saldo_neto numeric(15,2) NOT NULL,
    cantidad_anomalias integer NOT NULL
);


--
-- Name: resumen_transacciones_diarias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resumen_transacciones_diarias (
    fecha date NOT NULL,
    cantidad_transacciones integer NOT NULL,
    monto_total numeric(15,2) NOT NULL,
    cantidad_anomalias integer NOT NULL
);


--
-- Name: retiros_atm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.retiros_atm (
    id bigint NOT NULL,
    cuenta_id bigint NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    monto numeric(15,2) NOT NULL
);


--
-- Name: retiros_atm_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.retiros_atm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: retiros_atm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.retiros_atm_id_seq OWNED BY public.retiros_atm.id;


--
-- Name: transacciones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transacciones (
    id bigint NOT NULL,
    fecha date NOT NULL,
    monto numeric(15,2) NOT NULL,
    tipo character varying(50) NOT NULL,
    anomalia boolean NOT NULL,
    motivo character varying(255)
);


--
-- Name: retiros_atm id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retiros_atm ALTER COLUMN id SET DEFAULT nextval('public.retiros_atm_id_seq'::regclass);


--
-- Data for Name: batch_job_execution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.batch_job_execution (job_execution_id, version, job_instance_id, create_time, start_time, end_time, status, exit_code, exit_message, last_updated) FROM stdin;
43	2	41	2026-08-30 19:19:46.272685	2026-08-30 19:19:46.291271	2026-08-30 19:19:46.388454	COMPLETED	COMPLETED		2026-08-30 19:19:46.388654
1	2	1	2026-08-16 23:42:51.798465	2026-08-16 23:42:51.817904	2026-08-16 23:42:51.866766	COMPLETED	COMPLETED		2026-08-16 23:42:51.866811
24	2	22	2026-08-24 22:12:58.512706	2026-08-24 22:12:58.532422	2026-08-24 22:12:58.606799	COMPLETED	COMPLETED		2026-08-24 22:12:58.606952
2	2	1	2026-08-17 18:18:45.86206	2026-08-17 18:18:45.873363	2026-08-17 18:18:45.885015	COMPLETED	NOOP	All steps already completed or no steps configured for this job.	2026-08-17 18:18:45.885089
3	2	2	2026-08-17 18:20:50.926494	2026-08-17 18:20:50.940561	2026-08-17 18:20:50.974925	COMPLETED	COMPLETED		2026-08-17 18:20:50.974963
36	2	34	2026-08-30 18:43:15.695298	2026-08-30 18:43:15.731288	2026-08-30 18:43:17.108457	COMPLETED	COMPLETED		2026-08-30 18:43:17.109268
4	2	3	2026-08-17 18:29:46.333304	2026-08-17 18:29:46.345655	2026-08-17 18:29:46.379966	COMPLETED	COMPLETED		2026-08-17 18:29:46.380007
25	2	23	2026-08-24 22:18:41.561297	2026-08-24 22:18:41.578233	2026-08-24 22:18:41.632478	COMPLETED	COMPLETED		2026-08-24 22:18:41.632665
5	2	4	2026-08-17 18:32:11.487843	2026-08-17 18:32:11.502399	2026-08-17 18:32:11.532754	COMPLETED	COMPLETED		2026-08-17 18:32:11.532811
6	2	5	2026-08-17 18:41:16.104971	2026-08-17 18:41:16.115351	2026-08-17 18:41:16.149463	COMPLETED	COMPLETED		2026-08-17 18:41:16.149506
7	2	6	2026-08-17 18:41:42.875252	2026-08-17 18:41:42.886005	2026-08-17 18:41:42.915056	COMPLETED	COMPLETED		2026-08-17 18:41:42.915102
26	2	24	2026-08-24 22:21:37.45578	2026-08-24 22:21:37.472015	2026-08-24 22:21:37.515719	FAILED	FAILED	org.springframework.retry.ExhaustedRetryException: Retry exhausted after last attempt in recovery path, but exception is not skippable.\n\tat org.springframework.batch.core.step.item.FaultTolerantChunkProcessor.lambda$write$4(FaultTolerantChunkProcessor.java:401)\n\tat org.springframework.retry.support.RetryTemplate.handleRetryExhausted(RetryTemplate.java:573)\n\tat org.springframework.retry.support.RetryTemplate.doExecute(RetryTemplate.java:418)\n\tat org.springframework.retry.support.RetryTemplate.execute(RetryTemplate.java:276)\n\tat org.springframework.batch.core.step.item.BatchRetryTemplate.execute(BatchRetryTemplate.java:216)\n\tat org.springframework.batch.core.step.item.FaultTolerantChunkProcessor.write(FaultTolerantChunkProcessor.java:414)\n\tat org.springframework.batch.core.step.item.SimpleChunkProcessor.process(SimpleChunkProcessor.java:227)\n\tat org.springframework.batch.core.step.item.ChunkOrientedTasklet.execute(ChunkOrientedTasklet.java:75)\n\tat org.springframework.batch.core.step.tasklet.TaskletStep$ChunkTransactionCallback.doInTransaction(TaskletStep.java:383)\n\tat org.springframework.batch.core.step.tasklet.TaskletStep$ChunkTransactionCallback.doInTransaction(TaskletStep.java:307)\n\tat org.springframework.transaction.support.TransactionTemplate.execute(TransactionTemplate.java:140)\n\tat org.springframework.batch.core.step.tasklet.TaskletStep$2.doInChunkContext(TaskletStep.java:250)\n\tat org.springframework.batch.core.scope.context.StepContextRepeatCallback.doInIteration(StepContextRepeatCallback.java:82)\n\tat org.springframework.batch.repeat.support.TaskExecutorRepeatTemplate$ExecutingRunnable.run(TaskExecutorRepeatTemplate.java:261)\n\tat java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1136)\n\tat java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:635)\n\tat java.base/java.lang.Thread.run(Thread.java:840)\nCaused by: org.springframework.jdbc.BadSqlGrammarException: PreparedStatementCallback; bad SQL grammar [INSERT INTO estados_cuenta\n(\n    cuenta_id,\n    fecha,\n    transaccion,\n    monto,\n    descripcion,\n    movimiento,\n    anomalia,\n    motivo\n)\nVALUES (?, ?, ?, ?, ?, ?, ?, ?)\nON CONFLICT (cuenta_id, fecha, transaccion, monto)\nDO NOTHING\n]\n\tat org.springframework.jdbc.support.SQLStateSQLExceptionTranslator.doTranslate(SQLStateSQLExceptionTranslator.java:134)\n\tat org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:107)\n\t	2026-08-24 22:21:37.515962
8	2	7	2026-08-17 19:00:55.250091	2026-08-17 19:00:55.263805	2026-08-17 19:00:55.308647	COMPLETED	COMPLETED		2026-08-17 19:00:55.308691
9	2	8	2026-08-17 19:09:39.503476	2026-08-17 19:09:39.51818	2026-08-17 19:09:39.567422	COMPLETED	COMPLETED		2026-08-17 19:09:39.567614
10	2	1	2026-08-17 19:15:45.052629	2026-08-17 19:15:45.062141	2026-08-17 19:15:45.08634	COMPLETED	COMPLETED		2026-08-17 19:15:45.08638
27	2	25	2026-08-24 22:23:58.349099	2026-08-24 22:23:58.368404	2026-08-24 22:23:58.441578	COMPLETED	COMPLETED		2026-08-24 22:23:58.441784
11	2	9	2026-08-17 19:16:38.777281	2026-08-17 19:16:38.787201	2026-08-17 19:16:38.831736	COMPLETED	COMPLETED		2026-08-17 19:16:38.831782
12	2	10	2026-08-17 19:18:23.950963	2026-08-17 19:18:23.962658	2026-08-17 19:18:24.001492	COMPLETED	COMPLETED		2026-08-17 19:18:24.00158
37	2	35	2026-08-30 18:48:54.475471	2026-08-30 18:48:54.609164	2026-08-30 18:48:54.705987	COMPLETED	COMPLETED		2026-08-30 18:48:54.706365
13	2	11	2026-08-17 19:21:13.79228	2026-08-17 19:21:13.804034	2026-08-17 19:21:13.86367	COMPLETED	COMPLETED		2026-08-17 19:21:13.863712
28	2	26	2026-08-24 22:26:14.652117	2026-08-24 22:26:14.664046	2026-08-24 22:26:14.71373	COMPLETED	COMPLETED		2026-08-24 22:26:14.713896
14	2	12	2026-08-17 19:22:45.908889	2026-08-17 19:22:45.933074	2026-08-17 19:22:46.029556	COMPLETED	COMPLETED		2026-08-17 19:22:46.029596
15	2	13	2026-08-24 21:44:58.354189	2026-08-24 21:44:58.371174	2026-08-24 21:44:58.475772	COMPLETED	COMPLETED		2026-08-24 21:44:58.475862
16	2	14	2026-08-24 21:45:45.9077	2026-08-24 21:45:45.91931	2026-08-24 21:45:45.973421	COMPLETED	COMPLETED		2026-08-24 21:45:45.973509
29	2	27	2026-08-24 22:29:30.682599	2026-08-24 22:29:30.704764	2026-08-24 22:29:30.788824	COMPLETED	COMPLETED		2026-08-24 22:29:30.789041
17	2	15	2026-08-24 21:46:19.845136	2026-08-24 21:46:19.855454	2026-08-24 21:46:19.894989	COMPLETED	COMPLETED		2026-08-24 21:46:19.895027
18	2	16	2026-08-24 21:51:06.003085	2026-08-24 21:51:06.019631	2026-08-24 21:51:06.066357	COMPLETED	COMPLETED		2026-08-24 21:51:06.066491
48	2	46	2026-08-30 19:22:33.525865	2026-08-30 19:22:33.541368	2026-08-30 19:22:33.625736	COMPLETED	COMPLETED		2026-08-30 19:22:33.625926
19	2	17	2026-08-24 21:51:47.501595	2026-08-24 21:51:47.517593	2026-08-24 21:51:47.56794	COMPLETED	COMPLETED		2026-08-24 21:51:47.568092
30	2	28	2026-08-24 22:30:49.040842	2026-08-24 22:30:49.05212	2026-08-24 22:30:49.101586	COMPLETED	COMPLETED		2026-08-24 22:30:49.101807
20	2	18	2026-08-24 21:53:21.206223	2026-08-24 21:53:21.220371	2026-08-24 21:53:21.269612	COMPLETED	COMPLETED		2026-08-24 21:53:21.269732
21	2	19	2026-08-24 22:05:03.206462	2026-08-24 22:05:03.222136	2026-08-24 22:05:03.271822	COMPLETED	COMPLETED		2026-08-24 22:05:03.271966
38	2	36	2026-08-30 18:52:22.499698	2026-08-30 18:52:22.514791	2026-08-30 18:52:22.599936	COMPLETED	COMPLETED		2026-08-30 18:52:22.600112
22	2	20	2026-08-24 22:09:13.964541	2026-08-24 22:09:13.980379	2026-08-24 22:09:14.03983	COMPLETED	COMPLETED		2026-08-24 22:09:14.03997
31	2	29	2026-08-24 22:32:00.148184	2026-08-24 22:32:00.162084	2026-08-24 22:32:00.219997	COMPLETED	COMPLETED		2026-08-24 22:32:00.220183
23	2	21	2026-08-24 22:11:36.226695	2026-08-24 22:11:36.300872	2026-08-24 22:11:36.401664	COMPLETED	COMPLETED		2026-08-24 22:11:36.401791
32	2	30	2026-08-30 18:24:16.768241	2026-08-30 18:24:16.798532	2026-08-30 18:24:18.333243	COMPLETED	COMPLETED		2026-08-30 18:24:18.333917
44	2	42	2026-08-30 19:20:21.196856	2026-08-30 19:20:21.217452	2026-08-30 19:20:21.343035	COMPLETED	COMPLETED		2026-08-30 19:20:21.343229
33	2	31	2026-08-30 18:27:26.675385	2026-08-30 18:27:26.700461	2026-08-30 18:27:27.073863	COMPLETED	COMPLETED		2026-08-30 18:27:27.07507
39	2	37	2026-08-30 18:57:05.138829	2026-08-30 18:57:05.152717	2026-08-30 18:57:06.121209	COMPLETED	COMPLETED		2026-08-30 18:57:06.121526
34	2	32	2026-08-30 18:30:32.030189	2026-08-30 18:30:32.051687	2026-08-30 18:30:32.924213	COMPLETED	COMPLETED		2026-08-30 18:30:32.924514
35	2	33	2026-08-30 18:31:20.391335	2026-08-30 18:31:20.410327	2026-08-30 18:31:20.496553	COMPLETED	COMPLETED		2026-08-30 18:31:20.496807
40	2	38	2026-08-30 19:01:45.883197	2026-08-30 19:01:45.898221	2026-08-30 19:01:47.063298	COMPLETED	COMPLETED		2026-08-30 19:01:47.063558
41	2	39	2026-08-30 19:18:31.866522	2026-08-30 19:18:31.883368	2026-08-30 19:18:32.924362	COMPLETED	COMPLETED		2026-08-30 19:18:32.924568
45	2	43	2026-08-30 19:21:20.806292	2026-08-30 19:21:20.822216	2026-08-30 19:21:20.923609	COMPLETED	COMPLETED		2026-08-30 19:21:20.923791
42	2	40	2026-08-30 19:19:07.435082	2026-08-30 19:19:07.450405	2026-08-30 19:19:07.529125	COMPLETED	COMPLETED		2026-08-30 19:19:07.529338
51	2	49	2026-08-30 19:25:34.217476	2026-08-30 19:25:34.228181	2026-08-30 19:25:34.326108	COMPLETED	COMPLETED		2026-08-30 19:25:34.326407
49	2	47	2026-08-30 19:24:36.993375	2026-08-30 19:24:37.008492	2026-08-30 19:24:38.077582	COMPLETED	COMPLETED		2026-08-30 19:24:38.077801
46	2	44	2026-08-30 19:21:41.08652	2026-08-30 19:21:41.117467	2026-08-30 19:21:41.235005	COMPLETED	COMPLETED		2026-08-30 19:21:41.235635
47	2	45	2026-08-30 19:22:08.688249	2026-08-30 19:22:08.701825	2026-08-30 19:22:08.787986	COMPLETED	COMPLETED		2026-08-30 19:22:08.788285
53	2	51	2026-08-30 19:34:30.760754	2026-08-30 19:34:30.776316	2026-08-30 19:34:30.862656	COMPLETED	COMPLETED		2026-08-30 19:34:30.862888
50	2	48	2026-08-30 19:25:03.842839	2026-08-30 19:25:03.853703	2026-08-30 19:25:03.987177	COMPLETED	COMPLETED		2026-08-30 19:25:03.987842
52	2	50	2026-08-30 19:25:56.481353	2026-08-30 19:25:56.497088	2026-08-30 19:25:56.625897	COMPLETED	COMPLETED		2026-08-30 19:25:56.626196
55	2	53	2026-08-30 19:43:53.212341	2026-08-30 19:43:53.227481	2026-08-30 19:43:54.003638	COMPLETED	COMPLETED		2026-08-30 19:43:54.003821
54	2	52	2026-08-30 19:40:44.741394	2026-08-30 19:40:44.758926	2026-08-30 19:40:45.804714	COMPLETED	COMPLETED		2026-08-30 19:40:45.804949
56	2	54	2026-08-30 19:55:52.035992	2026-08-30 19:55:52.056286	2026-08-30 19:55:53.034538	COMPLETED	COMPLETED		2026-08-30 19:55:53.034966
57	2	55	2026-08-30 19:59:02.734083	2026-08-30 19:59:02.793399	2026-08-30 19:59:03.007328	COMPLETED	COMPLETED		2026-08-30 19:59:03.0082
\.


--
-- Data for Name: batch_job_execution_context; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.batch_job_execution_context (job_execution_id, short_context, serialized_context) FROM stdin;
1	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
2	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
3	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
4	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
5	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
6	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
7	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
26	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
8	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
18	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
9	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
10	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
11	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
12	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
13	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
19	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
14	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
15	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
31	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
16	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
20	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
17	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
27	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
21	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
22	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
23	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
28	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
24	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
25	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
34	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
29	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
30	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
32	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
33	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
39	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
36	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
35	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
37	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
38	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
40	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
41	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
42	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
56	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
43	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
44	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
45	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
57	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
46	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
47	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
48	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
49	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
50	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
51	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
52	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
53	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
54	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
55	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAABdAANYmF0Y2gudmVyc2lvbnQABTUuMi40eA==	\N
\.


--
-- Data for Name: batch_job_execution_params; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.batch_job_execution_params (job_execution_id, parameter_name, parameter_type, parameter_value, identifying) FROM stdin;
3	run.id	java.lang.String	2	Y
5	run.id	java.lang.String	2	Y
7	run.id	java.lang.String	2	Y
8	run.id	java.lang.String	3	Y
9	run.id	java.lang.String	4	Y
11	run.id	java.lang.String	10	Y
12	run.id	java.lang.String	9	Y
13	run.id	java.lang.String	10	Y
14	run.id	java.lang.String	10	Y
15	run.id	java.lang.String	20	Y
16	run.id	java.lang.String	21	Y
17	run.id	java.lang.String	22	Y
18	run.id	java.lang.String	23	Y
19	run.id	java.lang.String	24	Y
20	run.id	java.lang.String	25	Y
21	run.id	java.lang.String	30	Y
22	run.id	java.lang.String	31	Y
23	run.id	java.lang.String	32	Y
24	run.id	java.lang.String	33	Y
25	run.id	java.lang.String	40	Y
26	run.id	java.lang.String	50	Y
27	run.id	java.lang.String	51	Y
28	run.id	java.lang.String	60	Y
29	run.id	java.lang.String	61	Y
30	run.id	java.lang.String	60	Y
31	run.id	java.lang.String	60	Y
32	run.id	java.lang.String	101	Y
33	run.id	java.lang.String	102	Y
34	run.id	java.lang.String	103	Y
35	run.id	java.lang.String	104	Y
36	run.id	java.lang.String	201	Y
37	run.id	java.lang.String	202	Y
38	run.id	java.lang.String	203	Y
39	run.id	java.lang.String	204	Y
40	run.id	java.lang.String	205	Y
41	run.id	java.lang.String	301	Y
42	run.id	java.lang.String	302	Y
43	run.id	java.lang.String	303	Y
44	run.id	java.lang.String	304	Y
45	run.id	java.lang.String	305	Y
46	run.id	java.lang.String	306	Y
47	run.id	java.lang.String	307	Y
48	run.id	java.lang.String	308	Y
49	run.id	java.lang.String	309	Y
50	run.id	java.lang.String	310	Y
51	run.id	java.lang.String	311	Y
52	run.id	java.lang.String	312	Y
53	run.id	java.lang.String	401	Y
54	run.id	java.lang.String	402	Y
55	run.id	java.lang.String	403	Y
56	run.id	java.lang.String	501	Y
57	run.id	java.lang.String	502	Y
\.


--
-- Data for Name: batch_job_instance; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.batch_job_instance (job_instance_id, version, job_name, job_key) FROM stdin;
1	0	transactionJob	d41d8cd98f00b204e9800998ecf8427e
2	0	transactionJob	9d7b6e9fade575c8c63d78c40ae15a3b
3	0	interestJob	d41d8cd98f00b204e9800998ecf8427e
4	0	interestJob	9d7b6e9fade575c8c63d78c40ae15a3b
5	0	statementJob	d41d8cd98f00b204e9800998ecf8427e
6	0	statementJob	9d7b6e9fade575c8c63d78c40ae15a3b
7	0	statementJob	7bdb69b8f015a742549fc6b8e5a7e327
8	0	transactionJob	87a49d169444658263490ac10be84b90
9	0	transactionJob	0670251ed5482f5668d3914ba995028e
10	0	transactionJob	15059900c108197e1a51389138b39e28
11	0	interestJob	0670251ed5482f5668d3914ba995028e
12	0	statementJob	0670251ed5482f5668d3914ba995028e
13	0	transactionJob	97b0b5767d87a1a64a246440e8e15ad8
14	0	transactionJob	e5e35e1e556aefb0e09a7ad3b468d829
15	0	transactionJob	d3e5e60bd9726f175995c307fc66a1f6
16	0	transactionJob	3ae1485b584ad0f233bbc9976d7e20f1
17	0	transactionJob	c941ce7699d709bc235c712dda81fcf0
18	0	transactionJob	990830dd37661df9e45e2db904864951
19	0	transactionJob	49ac1e74e8ad03326920b35d7111dfc5
20	0	transactionJob	e9c860d21b55e737528eb61fcfa035fe
21	0	transactionJob	c9f9aacf8d0fc67b10c881e561f0eb0d
22	0	transactionJob	45ae36488b2551481fafc2cae772f574
23	0	interestJob	4083ec5d0c1a6a14e44751d40dc91d65
24	0	statementJob	74c10eea9772178bef180ab82f4910a6
25	0	statementJob	3861f4d0e083f222fd9639cc4853ede1
26	0	transactionJob	946ac04a6207049a3aab3e7060d325b6
27	0	transactionJob	bc310f486fd931e6f07af956cd7603f1
28	0	interestJob	946ac04a6207049a3aab3e7060d325b6
29	0	statementJob	946ac04a6207049a3aab3e7060d325b6
30	0	transactionJob	e019a60d899ae2820fd42efaaffff616
31	0	interestJob	2b37290c88aae173d8b86aba1e87da83
32	0	statementJob	8b6a07aa21a91d10fecffa626bc61302
33	0	transactionJob	fec215c3b9add9d39b2302493056b712
34	0	transactionJob	7121bd5779ec25f335a7a34e31985e0c
35	0	transactionJob	4c51585554530583678db1069ad68f6c
36	0	transactionJob	5a0eee319376ee311f7d526ee498f587
37	0	interestJob	28ddde52a03323c5d0b872094ac99821
38	0	statementJob	71ecfc4c32b405a87ad1f616ccef5085
39	0	transactionJob	799cd80c253be3e5745c2be0271f2190
40	0	transactionJob	328df64c08ce9ed6d60bd24a425e4df7
41	0	transactionJob	6e4b4b7f64992d6c01519338e124624f
42	0	transactionJob	9e78ee133bbc04f124e35e900f7aed9d
43	0	transactionJob	6052d24a17c2391ab873ccc78f688219
44	0	transactionJob	a1dd37dce8ee697be1f2e5f9690adffc
45	0	transactionJob	300aceeb6327c726912bd8b5b5836165
46	0	transactionJob	d54f0747651308ae891d9ed89db7ff4d
47	0	transactionJob	338c9e3e74d4635ca4e81fbdcc6ca612
48	0	transactionJob	59cb652656f47191bb6b4ada6d1f595f
49	0	transactionJob	23d4b11b8a9fe0b82529dca8f6ca95a3
50	0	transactionJob	66810ca199ad6e872224901738298525
51	0	transactionJob	5f321e297679939f812f8d83290fdcf6
52	0	transactionJob	5e5f9d3e792bba7dc97c37f30a1b6c64
53	0	transactionJob	d510021acbef6f7836d580ba929fa10e
54	0	transactionJob	5f6ff01186b0d1d9198f9dd79ac3567b
55	0	transactionJob	4ed393fea21edd3d4ce288b00a050ac2
\.


--
-- Data for Name: batch_step_execution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.batch_step_execution (step_execution_id, version, step_name, job_execution_id, create_time, start_time, end_time, status, commit_count, read_count, filter_count, write_count, read_skip_count, write_skip_count, process_skip_count, rollback_count, exit_code, exit_message, last_updated) FROM stdin;
16	3	interestStep	13	2026-08-17 19:21:13.810745	2026-08-17 19:21:13.839456	2026-08-17 19:21:13.861101	COMPLETED	1	8	0	8	0	0	0	0	COMPLETED		2026-08-17 19:21:13.861906
1	4	transactionStep	1	2026-08-16 23:42:51.830617	2026-08-16 23:42:51.834611	2026-08-16 23:42:51.864103	COMPLETED	2	10	0	10	0	0	0	0	COMPLETED		2026-08-16 23:42:51.86497
10	3	dailySummaryStep	9	2026-08-17 19:09:39.550289	2026-08-17 19:09:39.551819	2026-08-17 19:09:39.562765	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-17 19:09:39.564316
21	4	transactionStep	16	2026-08-24 21:45:45.928354	2026-08-24 21:45:45.932381	2026-08-24 21:45:45.955057	COMPLETED	2	10	0	9	0	0	1	1	COMPLETED		2026-08-24 21:45:45.956132
2	4	transactionStep	3	2026-08-17 18:20:50.947124	2026-08-17 18:20:50.949268	2026-08-17 18:20:50.970954	COMPLETED	2	10	0	10	0	0	0	0	COMPLETED		2026-08-17 18:20:50.972218
11	3	dailySummaryStep	10	2026-08-17 19:15:45.070842	2026-08-17 19:15:45.073654	2026-08-17 19:15:45.082307	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-17 19:15:45.083761
3	3	interestStep	4	2026-08-17 18:29:46.353168	2026-08-17 18:29:46.355763	2026-08-17 18:29:46.376875	COMPLETED	1	8	0	8	0	0	0	0	COMPLETED		2026-08-17 18:29:46.377918
17	3	statementStep	14	2026-08-17 19:22:45.989859	2026-08-17 19:22:45.992794	2026-08-17 19:22:46.013415	COMPLETED	1	9	0	9	0	0	0	0	COMPLETED		2026-08-17 19:22:46.014491
4	3	interestStep	5	2026-08-17 18:32:11.508461	2026-08-17 18:32:11.511213	2026-08-17 18:32:11.529222	COMPLETED	1	8	0	8	0	0	0	0	COMPLETED		2026-08-17 18:32:11.530226
33	7	transactionStep	22	2026-08-24 22:09:13.992893	2026-08-24 22:09:13.995725	2026-08-24 22:09:14.025858	COMPLETED	5	10	0	10	0	0	0	0	COMPLETED		2026-08-24 22:09:14.026896
5	3	statementStep	6	2026-08-17 18:41:16.123182	2026-08-17 18:41:16.125271	2026-08-17 18:41:16.146378	COMPLETED	1	9	0	9	0	0	0	0	COMPLETED		2026-08-17 18:41:16.147568
12	4	transactionStep	11	2026-08-17 19:16:38.793908	2026-08-17 19:16:38.798501	2026-08-17 19:16:38.816461	COMPLETED	2	10	0	10	0	0	0	0	COMPLETED		2026-08-17 19:16:38.817268
6	3	statementStep	7	2026-08-17 18:41:42.891949	2026-08-17 18:41:42.895429	2026-08-17 18:41:42.912456	COMPLETED	1	9	0	9	0	0	0	0	COMPLETED		2026-08-17 18:41:42.913285
25	4	transactionStep	18	2026-08-24 21:51:06.028086	2026-08-24 21:51:06.03068	2026-08-24 21:51:06.050693	COMPLETED	2	10	0	10	0	0	0	0	COMPLETED		2026-08-24 21:51:06.051798
18	3	annualSummaryStep	14	2026-08-17 19:22:46.017752	2026-08-17 19:22:46.019336	2026-08-17 19:22:46.02628	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-17 19:22:46.027409
7	3	statementStep	8	2026-08-17 19:00:55.270816	2026-08-17 19:00:55.27307	2026-08-17 19:00:55.290736	COMPLETED	1	9	0	9	0	0	0	0	COMPLETED		2026-08-17 19:00:55.291785
13	3	dailySummaryStep	11	2026-08-17 19:16:38.820858	2026-08-17 19:16:38.822698	2026-08-17 19:16:38.828143	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-17 19:16:38.829976
8	3	annualSummaryStep	8	2026-08-17 19:00:55.295094	2026-08-17 19:00:55.296825	2026-08-17 19:00:55.306368	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-17 19:00:55.307079
22	3	dailySummaryStep	16	2026-08-24 21:45:45.960364	2026-08-24 21:45:45.961776	2026-08-24 21:45:45.970044	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 21:45:45.970949
9	4	transactionStep	9	2026-08-17 19:09:39.525217	2026-08-17 19:09:39.527613	2026-08-17 19:09:39.54652	COMPLETED	2	10	0	10	0	0	0	0	COMPLETED		2026-08-17 19:09:39.54732
14	4	transactionStep	12	2026-08-17 19:18:23.969035	2026-08-17 19:18:23.971354	2026-08-17 19:18:23.988818	COMPLETED	2	10	0	10	0	0	0	0	COMPLETED		2026-08-17 19:18:23.98968
19	4	transactionStep	15	2026-08-24 21:44:58.382408	2026-08-24 21:44:58.386234	2026-08-24 21:44:58.443106	COMPLETED	2	10	0	10	0	0	0	0	COMPLETED		2026-08-24 21:44:58.444504
15	3	dailySummaryStep	12	2026-08-17 19:18:23.992474	2026-08-17 19:18:23.994341	2026-08-17 19:18:23.99914	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-17 19:18:23.99984
32	3	dailySummaryStep	21	2026-08-24 22:05:03.262522	2026-08-24 22:05:03.263906	2026-08-24 22:05:03.269171	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 22:05:03.269887
23	3	transactionStep	17	2026-08-24 21:46:19.861725	2026-08-24 21:46:19.864213	2026-08-24 21:46:19.880974	COMPLETED	1	9	0	9	1	0	0	0	COMPLETED		2026-08-24 21:46:19.881692
20	3	dailySummaryStep	15	2026-08-24 21:44:58.44804	2026-08-24 21:44:58.450458	2026-08-24 21:44:58.46539	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 21:44:58.469403
28	3	dailySummaryStep	19	2026-08-24 21:51:47.554952	2026-08-24 21:51:47.557355	2026-08-24 21:51:47.564691	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 21:51:47.566119
26	3	dailySummaryStep	18	2026-08-24 21:51:06.055655	2026-08-24 21:51:06.05721	2026-08-24 21:51:06.063976	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 21:51:06.064685
24	3	dailySummaryStep	17	2026-08-24 21:46:19.885153	2026-08-24 21:46:19.88717	2026-08-24 21:46:19.891985	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 21:46:19.893313
30	3	dailySummaryStep	20	2026-08-24 21:53:21.258866	2026-08-24 21:53:21.260192	2026-08-24 21:53:21.267244	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 21:53:21.267881
27	4	transactionStep	19	2026-08-24 21:51:47.52496	2026-08-24 21:51:47.527509	2026-08-24 21:51:47.550394	COMPLETED	2	10	0	10	0	0	0	0	COMPLETED		2026-08-24 21:51:47.551394
29	4	transactionStep	20	2026-08-24 21:53:21.229779	2026-08-24 21:53:21.233449	2026-08-24 21:53:21.254358	COMPLETED	2	10	0	9	0	0	1	1	COMPLETED		2026-08-24 21:53:21.255878
31	7	transactionStep	21	2026-08-24 22:05:03.229069	2026-08-24 22:05:03.231251	2026-08-24 22:05:03.257221	COMPLETED	5	10	0	10	0	0	0	0	COMPLETED		2026-08-24 22:05:03.258623
34	3	dailySummaryStep	22	2026-08-24 22:09:14.029549	2026-08-24 22:09:14.030652	2026-08-24 22:09:14.037361	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 22:09:14.038125
36	3	dailySummaryStep	23	2026-08-24 22:11:36.390638	2026-08-24 22:11:36.392201	2026-08-24 22:11:36.39863	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 22:11:36.399708
35	7	transactionStep	23	2026-08-24 22:11:36.351567	2026-08-24 22:11:36.355097	2026-08-24 22:11:36.381229	COMPLETED	5	10	0	10	0	0	0	0	COMPLETED		2026-08-24 22:11:36.382755
37	7	transactionStep	24	2026-08-24 22:12:58.544995	2026-08-24 22:12:58.548907	2026-08-24 22:12:58.587589	COMPLETED	5	10	0	10	0	0	0	0	COMPLETED		2026-08-24 22:12:58.589254
38	3	dailySummaryStep	24	2026-08-24 22:12:58.595605	2026-08-24 22:12:58.597114	2026-08-24 22:12:58.602468	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 22:12:58.604016
39	7	interestStep	25	2026-08-24 22:18:41.586496	2026-08-24 22:18:41.589408	2026-08-24 22:18:41.627517	COMPLETED	5	8	0	8	0	0	0	0	COMPLETED		2026-08-24 22:18:41.629417
40	2	statementStep	26	2026-08-24 22:21:37.480104	2026-08-24 22:21:37.482467	2026-08-24 22:21:37.510551	FAILED	0	9	0	0	0	0	0	6	FAILED	org.springframework.retry.ExhaustedRetryException: Retry exhausted after last attempt in recovery path, but exception is not skippable.\n\tat org.springframework.batch.core.step.item.FaultTolerantChunkProcessor.lambda$write$4(FaultTolerantChunkProcessor.java:401)\n\tat org.springframework.retry.support.RetryTemplate.handleRetryExhausted(RetryTemplate.java:573)\n\tat org.springframework.retry.support.RetryTemplate.doExecute(RetryTemplate.java:418)\n\tat org.springframework.retry.support.RetryTemplate.execute(RetryTemplate.java:276)\n\tat org.springframework.batch.core.step.item.BatchRetryTemplate.execute(BatchRetryTemplate.java:216)\n\tat org.springframework.batch.core.step.item.FaultTolerantChunkProcessor.write(FaultTolerantChunkProcessor.java:414)\n\tat org.springframework.batch.core.step.item.SimpleChunkProcessor.process(SimpleChunkProcessor.java:227)\n\tat org.springframework.batch.core.step.item.ChunkOrientedTasklet.execute(ChunkOrientedTasklet.java:75)\n\tat org.springframework.batch.core.step.tasklet.TaskletStep$ChunkTransactionCallback.doInTransaction(TaskletStep.java:383)\n\tat org.springframework.batch.core.step.tasklet.TaskletStep$ChunkTransactionCallback.doInTransaction(TaskletStep.java:307)\n\tat org.springframework.transaction.support.TransactionTemplate.execute(TransactionTemplate.java:140)\n\tat org.springframework.batch.core.step.tasklet.TaskletStep$2.doInChunkContext(TaskletStep.java:250)\n\tat org.springframework.batch.core.scope.context.StepContextRepeatCallback.doInIteration(StepContextRepeatCallback.java:82)\n\tat org.springframework.batch.repeat.support.TaskExecutorRepeatTemplate$ExecutingRunnable.run(TaskExecutorRepeatTemplate.java:261)\n\tat java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1136)\n\tat java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:635)\n\tat java.base/java.lang.Thread.run(Thread.java:840)\nCaused by: org.springframework.jdbc.BadSqlGrammarException: PreparedStatementCallback; bad SQL grammar [INSERT INTO estados_cuenta\n(\n    cuenta_id,\n    fecha,\n    transaccion,\n    monto,\n    descripcion,\n    movimiento,\n    anomalia,\n    motivo\n)\nVALUES (?, ?, ?, ?, ?, ?, ?, ?)\nON CONFLICT (cuenta_id, fecha, transaccion, monto)\nDO NOTHING\n]\n\tat org.springframework.jdbc.support.SQLStateSQLExceptionTranslator.doTranslate(SQLStateSQLExceptionTranslator.java:134)\n\tat org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:107)\n\t	2026-08-24 22:21:37.512753
58	3	transactionWorkerStep:partition2	36	2026-08-30 18:43:15.78156	2026-08-30 18:43:15.801335	2026-08-30 18:43:17.070263	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 18:43:17.075882
59	3	transactionWorkerStep:partition0	36	2026-08-30 18:43:15.786458	2026-08-30 18:43:15.801472	2026-08-30 18:43:17.072166	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 18:43:17.077049
46	3	dailySummaryStep	29	2026-08-24 22:29:30.771925	2026-08-24 22:29:30.777121	2026-08-24 22:29:30.785764	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 22:29:30.786707
56	3	dailySummaryStep	35	2026-08-30 18:31:20.480138	2026-08-30 18:31:20.482318	2026-08-30 18:31:20.492143	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 18:31:20.494118
41	7	statementStep	27	2026-08-24 22:23:58.380603	2026-08-24 22:23:58.384393	2026-08-24 22:23:58.424086	COMPLETED	5	9	0	9	0	0	0	0	COMPLETED		2026-08-24 22:23:58.425686
53	7	statementStep	34	2026-08-30 18:30:32.063641	2026-08-30 18:30:32.068491	2026-08-30 18:30:32.885887	COMPLETED	5	9	0	9	0	0	0	0	COMPLETED		2026-08-30 18:30:32.887842
42	3	annualSummaryStep	27	2026-08-24 22:23:58.429457	2026-08-24 22:23:58.430988	2026-08-24 22:23:58.439044	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 22:23:58.439843
50	8	transactionStep	32	2026-08-30 18:24:16.820008	2026-08-30 18:24:16.831465	2026-08-30 18:24:18.148785	COMPLETED	6	10	0	10	0	0	0	0	COMPLETED		2026-08-30 18:24:18.169792
47	7	interestStep	30	2026-08-24 22:30:49.062344	2026-08-24 22:30:49.064934	2026-08-24 22:30:49.098653	COMPLETED	5	8	0	8	0	0	0	0	COMPLETED		2026-08-24 22:30:49.099747
43	7	transactionStep	28	2026-08-24 22:26:14.669394	2026-08-24 22:26:14.671849	2026-08-24 22:26:14.699542	COMPLETED	5	10	0	10	0	0	0	0	COMPLETED		2026-08-24 22:26:14.700496
51	3	dailySummaryStep	32	2026-08-30 18:24:18.220486	2026-08-30 18:24:18.235262	2026-08-30 18:24:18.295336	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 18:24:18.303954
44	3	dailySummaryStep	28	2026-08-24 22:26:14.703238	2026-08-24 22:26:14.704598	2026-08-24 22:26:14.710702	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 22:26:14.711822
54	3	annualSummaryStep	34	2026-08-30 18:30:32.892885	2026-08-30 18:30:32.894722	2026-08-30 18:30:32.916376	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 18:30:32.917565
48	7	statementStep	31	2026-08-24 22:32:00.168224	2026-08-24 22:32:00.1709	2026-08-24 22:32:00.200281	COMPLETED	5	9	0	9	0	0	0	0	COMPLETED		2026-08-24 22:32:00.201965
45	7	transactionStep	29	2026-08-24 22:29:30.712463	2026-08-24 22:29:30.718535	2026-08-24 22:29:30.762382	COMPLETED	5	10	0	9	0	0	1	1	COMPLETED		2026-08-24 22:29:30.764226
49	3	annualSummaryStep	31	2026-08-24 22:32:00.206872	2026-08-24 22:32:00.210222	2026-08-24 22:32:00.216636	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-24 22:32:00.217973
57	2	transactionPartitionStep	36	2026-08-30 18:43:15.758921	2026-08-30 18:43:15.766811	2026-08-30 18:43:17.080739	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 18:43:17.084641
52	7	interestStep	33	2026-08-30 18:27:26.7138	2026-08-30 18:27:26.718445	2026-08-30 18:27:27.063487	COMPLETED	5	8	0	8	0	0	0	0	COMPLETED		2026-08-30 18:27:27.06647
62	2	transactionPartitionStep	37	2026-08-30 18:48:54.621392	2026-08-30 18:48:54.624099	2026-08-30 18:48:54.688745	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 18:48:54.689649
55	9	transactionStep	35	2026-08-30 18:31:20.421603	2026-08-30 18:31:20.425191	2026-08-30 18:31:20.471883	COMPLETED	7	10	0	10	0	0	0	0	COMPLETED		2026-08-30 18:31:20.474378
60	3	transactionWorkerStep:partition1	36	2026-08-30 18:43:15.78346	2026-08-30 18:43:15.801755	2026-08-30 18:43:17.070863	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 18:43:17.074934
61	3	dailySummaryStep	36	2026-08-30 18:43:17.092661	2026-08-30 18:43:17.094677	2026-08-30 18:43:17.103679	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 18:43:17.105079
66	3	dailySummaryStep	37	2026-08-30 18:48:54.692989	2026-08-30 18:48:54.694663	2026-08-30 18:48:54.7024	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 18:48:54.703696
64	3	transactionWorkerStep:partition1	37	2026-08-30 18:48:54.633407	2026-08-30 18:48:54.640273	2026-08-30 18:48:54.684525	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 18:48:54.686109
65	3	transactionWorkerStep:partition0	37	2026-08-30 18:48:54.634154	2026-08-30 18:48:54.64025	2026-08-30 18:48:54.684862	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 18:48:54.686934
63	3	transactionWorkerStep:partition2	37	2026-08-30 18:48:54.631696	2026-08-30 18:48:54.640312	2026-08-30 18:48:54.684525	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 18:48:54.687929
70	3	transactionWorkerStep:partition1	38	2026-08-30 18:52:22.533325	2026-08-30 18:52:22.539804	2026-08-30 18:52:22.582187	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 18:52:22.583371
69	3	transactionWorkerStep:partition2	38	2026-08-30 18:52:22.532375	2026-08-30 18:52:22.539922	2026-08-30 18:52:22.582502	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 18:52:22.583661
68	3	transactionWorkerStep:partition0	38	2026-08-30 18:52:22.533912	2026-08-30 18:52:22.539827	2026-08-30 18:52:22.582182	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 18:52:22.583981
67	2	transactionPartitionStep	38	2026-08-30 18:52:22.523109	2026-08-30 18:52:22.526843	2026-08-30 18:52:22.585009	COMPLETED	3	11	0	11	0	0	0	0	COMPLETED		2026-08-30 18:52:22.586867
71	3	dailySummaryStep	38	2026-08-30 18:52:22.590585	2026-08-30 18:52:22.591765	2026-08-30 18:52:22.596606	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 18:52:22.597968
72	2	interestPartitionStep	39	2026-08-30 18:57:05.161834	2026-08-30 18:57:05.166133	2026-08-30 18:57:06.117011	COMPLETED	3	8	0	8	0	0	0	0	COMPLETED		2026-08-30 18:57:06.117981
82	5	transactionWorkerStep:partition0	41	2026-08-30 19:18:32.833738	2026-08-30 19:18:32.840386	2026-08-30 19:18:32.9065	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:18:32.907966
81	2	transactionPartitionStep	41	2026-08-30 19:18:31.897003	2026-08-30 19:18:31.900756	2026-08-30 19:18:32.909238	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:18:32.910226
73	3	interestWorkerStep:partition1	39	2026-08-30 18:57:06.061214	2026-08-30 18:57:06.072388	2026-08-30 18:57:06.113787	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 18:57:06.115243
74	3	interestWorkerStep:partition2	39	2026-08-30 18:57:06.05924	2026-08-30 18:57:06.072474	2026-08-30 18:57:06.113787	COMPLETED	1	2	0	2	0	0	0	0	COMPLETED		2026-08-30 18:57:06.115606
75	3	interestWorkerStep:partition0	39	2026-08-30 18:57:06.062347	2026-08-30 18:57:06.072661	2026-08-30 18:57:06.114761	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 18:57:06.115977
83	3	dailySummaryStep	41	2026-08-30 19:18:32.914078	2026-08-30 19:18:32.916033	2026-08-30 19:18:32.921573	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:18:32.922394
77	3	statementWorkerStep:partition1	40	2026-08-30 19:01:46.957137	2026-08-30 19:01:46.969683	2026-08-30 19:01:47.027883	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:01:47.028965
79	3	statementWorkerStep:partition0	40	2026-08-30 19:01:46.95886	2026-08-30 19:01:46.969627	2026-08-30 19:01:47.027569	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:01:47.029793
78	3	statementWorkerStep:partition2	40	2026-08-30 19:01:46.953738	2026-08-30 19:01:46.969627	2026-08-30 19:01:47.02845	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:01:47.030379
76	2	statementPartitionStep	40	2026-08-30 19:01:45.908039	2026-08-30 19:01:45.914813	2026-08-30 19:01:47.031305	COMPLETED	3	9	0	9	0	0	0	0	COMPLETED		2026-08-30 19:01:47.032363
100	3	transactionWorkerStep:partition0	45	2026-08-30 19:21:20.8472	2026-08-30 19:21:20.852014	2026-08-30 19:21:20.899633	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 19:21:20.901764
80	3	annualSummaryStep	40	2026-08-30 19:01:47.035682	2026-08-30 19:01:47.037568	2026-08-30 19:01:47.056392	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:01:47.057789
102	3	dailySummaryStep	45	2026-08-30 19:21:20.913861	2026-08-30 19:21:20.915821	2026-08-30 19:21:20.921401	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:21:20.922192
97	3	dailySummaryStep	44	2026-08-30 19:20:21.327002	2026-08-30 19:20:21.329504	2026-08-30 19:20:21.340704	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:20:21.341499
89	3	transactionWorkerStep:partition1	43	2026-08-30 19:19:46.311408	2026-08-30 19:19:46.320901	2026-08-30 19:19:46.364292	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:19:46.365851
90	3	transactionWorkerStep:partition0	43	2026-08-30 19:19:46.313377	2026-08-30 19:19:46.320664	2026-08-30 19:19:46.364292	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 19:19:46.36621
91	3	transactionWorkerStep:partition2	43	2026-08-30 19:19:46.309144	2026-08-30 19:19:46.320514	2026-08-30 19:19:46.36457	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:19:46.366585
85	4	transactionWorkerStep:partition1	42	2026-08-30 19:19:07.470543	2026-08-30 19:19:07.474991	2026-08-30 19:19:07.511787	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:19:07.513053
86	4	transactionWorkerStep:partition0	42	2026-08-30 19:19:07.471504	2026-08-30 19:19:07.474956	2026-08-30 19:19:07.511726	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:19:07.513276
84	2	transactionPartitionStep	42	2026-08-30 19:19:07.459728	2026-08-30 19:19:07.465432	2026-08-30 19:19:07.514255	COMPLETED	4	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:19:07.514842
88	2	transactionPartitionStep	43	2026-08-30 19:19:46.29949	2026-08-30 19:19:46.30286	2026-08-30 19:19:46.368109	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:19:46.369414
87	3	dailySummaryStep	42	2026-08-30 19:19:07.517061	2026-08-30 19:19:07.518723	2026-08-30 19:19:07.523744	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:19:07.525465
92	3	dailySummaryStep	43	2026-08-30 19:19:46.373511	2026-08-30 19:19:46.375314	2026-08-30 19:19:46.382827	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:19:46.385199
95	3	transactionWorkerStep:partition2	44	2026-08-30 19:20:21.245221	2026-08-30 19:20:21.254812	2026-08-30 19:20:21.317737	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:20:21.319337
96	3	transactionWorkerStep:partition1	44	2026-08-30 19:20:21.246681	2026-08-30 19:20:21.25447	2026-08-30 19:20:21.317753	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:20:21.319724
94	3	transactionWorkerStep:partition0	44	2026-08-30 19:20:21.247526	2026-08-30 19:20:21.254682	2026-08-30 19:20:21.31812	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 19:20:21.320444
93	2	transactionPartitionStep	44	2026-08-30 19:20:21.233978	2026-08-30 19:20:21.23849	2026-08-30 19:20:21.322236	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:20:21.323588
98	2	transactionPartitionStep	45	2026-08-30 19:21:20.834395	2026-08-30 19:21:20.838499	2026-08-30 19:21:20.902972	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:21:20.906568
99	3	transactionWorkerStep:partition1	45	2026-08-30 19:21:20.84649	2026-08-30 19:21:20.852095	2026-08-30 19:21:20.89849	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:21:20.900762
101	3	transactionWorkerStep:partition2	45	2026-08-30 19:21:20.845408	2026-08-30 19:21:20.852026	2026-08-30 19:21:20.898492	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:21:20.901208
105	3	transactionWorkerStep:partition1	46	2026-08-30 19:21:41.134682	2026-08-30 19:21:41.154014	2026-08-30 19:21:41.20892	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:21:41.210245
103	2	transactionPartitionStep	46	2026-08-30 19:21:41.125188	2026-08-30 19:21:41.127634	2026-08-30 19:21:41.216473	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:21:41.217605
104	3	transactionWorkerStep:partition2	46	2026-08-30 19:21:41.133779	2026-08-30 19:21:41.154138	2026-08-30 19:21:41.209478	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:21:41.214124
106	3	transactionWorkerStep:partition0	46	2026-08-30 19:21:41.135374	2026-08-30 19:21:41.153984	2026-08-30 19:21:41.209952	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 19:21:41.215091
107	3	dailySummaryStep	46	2026-08-30 19:21:41.221615	2026-08-30 19:21:41.22326	2026-08-30 19:21:41.229002	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:21:41.230545
108	2	transactionPartitionStep	47	2026-08-30 19:22:08.709007	2026-08-30 19:22:08.71189	2026-08-30 19:22:08.773465	COMPLETED	4	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:22:08.77423
136	2	transactionPartitionStep	54	2026-08-30 19:40:44.766839	2026-08-30 19:40:44.769489	2026-08-30 19:40:45.789542	COMPLETED	4	11	0	10	1	0	1	1	COMPLETED		2026-08-30 19:40:45.790621
117	3	dailySummaryStep	49	2026-08-30 19:24:38.066678	2026-08-30 19:24:38.068544	2026-08-30 19:24:38.07364	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:24:38.075541
110	4	transactionWorkerStep:partition0	47	2026-08-30 19:22:08.722821	2026-08-30 19:22:08.729488	2026-08-30 19:22:08.769873	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:22:08.771909
109	4	transactionWorkerStep:partition1	47	2026-08-30 19:22:08.720648	2026-08-30 19:22:08.729533	2026-08-30 19:22:08.770124	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:22:08.772212
111	3	dailySummaryStep	47	2026-08-30 19:22:08.777745	2026-08-30 19:22:08.779442	2026-08-30 19:22:08.784741	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:22:08.785527
124	3	transactionWorkerStep:partition2	51	2026-08-30 19:25:34.24721	2026-08-30 19:25:34.254992	2026-08-30 19:25:34.292863	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:25:34.296741
125	3	transactionWorkerStep:partition1	51	2026-08-30 19:25:34.248338	2026-08-30 19:25:34.254924	2026-08-30 19:25:34.295652	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:25:34.297086
123	3	transactionWorkerStep:partition0	51	2026-08-30 19:25:34.249232	2026-08-30 19:25:34.254956	2026-08-30 19:25:34.296685	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 19:25:34.302923
122	2	transactionPartitionStep	51	2026-08-30 19:25:34.236898	2026-08-30 19:25:34.23919	2026-08-30 19:25:34.30557	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:25:34.307097
113	5	transactionWorkerStep:partition0	48	2026-08-30 19:22:33.558343	2026-08-30 19:22:33.561695	2026-08-30 19:22:33.60592	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:22:33.607704
112	2	transactionPartitionStep	48	2026-08-30 19:22:33.549325	2026-08-30 19:22:33.551865	2026-08-30 19:22:33.609369	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:22:33.610366
120	4	transactionWorkerStep:partition0	50	2026-08-30 19:25:03.873978	2026-08-30 19:25:03.880242	2026-08-30 19:25:03.923213	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:25:03.925645
114	3	dailySummaryStep	48	2026-08-30 19:22:33.614627	2026-08-30 19:22:33.61789	2026-08-30 19:22:33.62242	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:22:33.623464
119	4	transactionWorkerStep:partition1	50	2026-08-30 19:25:03.871881	2026-08-30 19:25:03.880314	2026-08-30 19:25:03.924784	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:25:03.926171
118	2	transactionPartitionStep	50	2026-08-30 19:25:03.86265	2026-08-30 19:25:03.865195	2026-08-30 19:25:03.927325	COMPLETED	4	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:25:03.928627
132	2	transactionPartitionStep	53	2026-08-30 19:34:30.783847	2026-08-30 19:34:30.787227	2026-08-30 19:34:30.845264	COMPLETED	4	11	0	10	0	0	1	1	COMPLETED		2026-08-30 19:34:30.845858
129	3	transactionWorkerStep:partition1	52	2026-08-30 19:25:56.515969	2026-08-30 19:25:56.523421	2026-08-30 19:25:56.600538	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:25:56.602197
116	5	transactionWorkerStep:partition0	49	2026-08-30 19:24:37.990892	2026-08-30 19:24:37.999779	2026-08-30 19:24:38.054181	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:24:38.055546
115	2	transactionPartitionStep	49	2026-08-30 19:24:37.017788	2026-08-30 19:24:37.023916	2026-08-30 19:24:38.057961	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:24:38.059297
121	3	dailySummaryStep	50	2026-08-30 19:25:03.933641	2026-08-30 19:25:03.935502	2026-08-30 19:25:03.98241	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:25:03.98383
128	3	transactionWorkerStep:partition2	52	2026-08-30 19:25:56.514759	2026-08-30 19:25:56.523522	2026-08-30 19:25:56.600534	COMPLETED	1	3	0	3	0	0	0	0	COMPLETED		2026-08-30 19:25:56.602633
130	3	transactionWorkerStep:partition0	52	2026-08-30 19:25:56.517585	2026-08-30 19:25:56.523531	2026-08-30 19:25:56.60109	COMPLETED	1	4	0	4	0	0	0	0	COMPLETED		2026-08-30 19:25:56.603251
127	2	transactionPartitionStep	52	2026-08-30 19:25:56.506767	2026-08-30 19:25:56.509987	2026-08-30 19:25:56.604479	COMPLETED	3	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:25:56.606794
126	3	dailySummaryStep	51	2026-08-30 19:25:34.31039	2026-08-30 19:25:34.312388	2026-08-30 19:25:34.31999	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:25:34.322452
135	3	dailySummaryStep	53	2026-08-30 19:34:30.848949	2026-08-30 19:34:30.851593	2026-08-30 19:34:30.85941	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:34:30.860159
131	3	dailySummaryStep	52	2026-08-30 19:25:56.611601	2026-08-30 19:25:56.613376	2026-08-30 19:25:56.620262	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:25:56.621533
134	4	transactionWorkerStep:partition0	53	2026-08-30 19:34:30.795748	2026-08-30 19:34:30.7999	2026-08-30 19:34:30.84316	COMPLETED	2	6	0	6	0	0	0	0	COMPLETED		2026-08-30 19:34:30.844068
133	4	transactionWorkerStep:partition1	53	2026-08-30 19:34:30.794669	2026-08-30 19:34:30.799918	2026-08-30 19:34:30.84316	COMPLETED	2	5	0	4	0	0	1	1	COMPLETED		2026-08-30 19:34:30.844355
138	4	transactionWorkerStep:partition0	54	2026-08-30 19:40:45.721818	2026-08-30 19:40:45.730866	2026-08-30 19:40:45.785727	COMPLETED	2	6	0	6	0	0	0	0	COMPLETED		2026-08-30 19:40:45.787178
137	4	transactionWorkerStep:partition1	54	2026-08-30 19:40:45.720028	2026-08-30 19:40:45.730975	2026-08-30 19:40:45.7861	COMPLETED	2	5	0	4	1	0	1	1	COMPLETED		2026-08-30 19:40:45.7876
139	3	dailySummaryStep	54	2026-08-30 19:40:45.794545	2026-08-30 19:40:45.796572	2026-08-30 19:40:45.801947	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:40:45.802827
140	2	transactionPartitionStep	55	2026-08-30 19:43:53.239431	2026-08-30 19:43:53.24291	2026-08-30 19:43:53.98812	COMPLETED	4	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:43:53.989361
143	3	dailySummaryStep	55	2026-08-30 19:43:53.992551	2026-08-30 19:43:53.994115	2026-08-30 19:43:54.000865	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:43:54.001733
141	4	transactionWorkerStep:partition1	55	2026-08-30 19:43:53.919722	2026-08-30 19:43:53.932692	2026-08-30 19:43:53.983108	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:43:53.985199
142	4	transactionWorkerStep:partition0	55	2026-08-30 19:43:53.921838	2026-08-30 19:43:53.932224	2026-08-30 19:43:53.984225	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:43:53.986159
144	2	transactionPartitionStep	56	2026-08-30 19:55:52.067028	2026-08-30 19:55:52.070674	2026-08-30 19:55:53.015332	COMPLETED	4	10	0	10	0	0	0	0	COMPLETED		2026-08-30 19:55:53.017095
145	4	transactionWorkerStep:partition0	56	2026-08-30 19:55:52.943082	2026-08-30 19:55:52.955542	2026-08-30 19:55:53.011496	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:55:53.013481
146	4	transactionWorkerStep:partition1	56	2026-08-30 19:55:52.939644	2026-08-30 19:55:52.955592	2026-08-30 19:55:53.01163	COMPLETED	2	5	0	5	0	0	0	0	COMPLETED		2026-08-30 19:55:53.013806
147	3	dailySummaryStep	56	2026-08-30 19:55:53.021686	2026-08-30 19:55:53.023596	2026-08-30 19:55:53.030686	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:55:53.031885
150	4	transactionWorkerStep:partition0	57	2026-08-30 19:59:02.859325	2026-08-30 19:59:02.867117	2026-08-30 19:59:02.968357	COMPLETED	2	6	0	6	0	0	0	0	COMPLETED		2026-08-30 19:59:02.973141
149	4	transactionWorkerStep:partition1	57	2026-08-30 19:59:02.857429	2026-08-30 19:59:02.867225	2026-08-30 19:59:02.973276	COMPLETED	2	5	0	4	1	0	1	1	COMPLETED		2026-08-30 19:59:02.975439
148	2	transactionPartitionStep	57	2026-08-30 19:59:02.823777	2026-08-30 19:59:02.841731	2026-08-30 19:59:02.980608	COMPLETED	4	11	0	10	1	0	1	1	COMPLETED		2026-08-30 19:59:02.983239
151	3	dailySummaryStep	57	2026-08-30 19:59:02.988668	2026-08-30 19:59:02.991658	2026-08-30 19:59:03.002192	COMPLETED	1	0	0	0	0	0	0	0	COMPLETED		2026-08-30 19:59:03.004156
\.


--
-- Data for Name: batch_step_execution_context; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.batch_step_execution_context (step_execution_id, short_context, serialized_context) FROM stdin;
4	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAdaW50ZXJlc3RJdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACXQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
7	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAec3RhdGVtZW50SXRlbVJlYWRlci5yZWFkLmNvdW50c3IAEWphdmEubGFuZy5JbnRlZ2VyEuKgpPeBhzgCAAFJAAV2YWx1ZXhyABBqYXZhLmxhbmcuTnVtYmVyhqyVHQuU4IsCAAB4cAAAAAp0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
1	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
5	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAec3RhdGVtZW50SXRlbVJlYWRlci5yZWFkLmNvdW50c3IAEWphdmEubGFuZy5JbnRlZ2VyEuKgpPeBhzgCAAFJAAV2YWx1ZXhyABBqYXZhLmxhbmcuTnVtYmVyhqyVHQuU4IsCAAB4cAAAAAp0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
2	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
9	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
3	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAdaW50ZXJlc3RJdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACXQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
6	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAec3RhdGVtZW50SXRlbVJlYWRlci5yZWFkLmNvdW50c3IAEWphdmEubGFuZy5JbnRlZ2VyEuKgpPeBhzgCAAFJAAV2YWx1ZXhyABBqYXZhLmxhbmcuTnVtYmVyhqyVHQuU4IsCAAB4cAAAAAp0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
8	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AFtjb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnN0YXRlbWVudC5TdGF0ZW1lbnRKb2JDb25maWckJExhbWJkYSQ2MjUvMHgwMDAwMDBkMDAxMmNlNGEwdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
15	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI3LzB4MDAwMDAwNzgwMTJjZWMyMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
11	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI3LzB4MDAwMDAwNzAwMTJjZWMyMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
10	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI3LzB4MDAwMDAwYTAwMTJjZWMyMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
12	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
14	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
13	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI3LzB4MDAwMDAwZTgwMTJjZWMyMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
26	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI4LzB4MDAwMDAwNzAwMTJkMDIyMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
16	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAdaW50ZXJlc3RJdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACXQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
20	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI4LzB4MDAwMDAwMDYwMTJjZjc2OHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
17	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAec3RhdGVtZW50SXRlbVJlYWRlci5yZWFkLmNvdW50c3IAEWphdmEubGFuZy5JbnRlZ2VyEuKgpPeBhzgCAAFJAAV2YWx1ZXhyABBqYXZhLmxhbmcuTnVtYmVyhqyVHQuU4IsCAAB4cAAAAAp0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
23	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
18	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AFtjb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnN0YXRlbWVudC5TdGF0ZW1lbnRKb2JDb25maWckJExhbWJkYSQ2MjUvMHgwMDAwMDA4ODAxMmNlNGEwdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
25	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
21	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
19	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
24	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI4LzB4MDAwMDAwNzAwMTJjZjc2OHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
22	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI4LzB4MDAwMDAwZTAwMTJjZjc2OHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
27	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
28	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI4LzB4MDAwMDAwYjAwMTJkMDIyMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
29	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
30	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjI4LzB4MDAwMDAwNzAwMTJkMDIyMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
41	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
38	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA1LzB4MDAwMDAwMDcwMTJjYWZjMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
33	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAD3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
36	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA1LzB4MDAwMDAwNzAwMTJjYWZjMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
31	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAEdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAADHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
34	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA1LzB4MDAwMDAwMDMwMTJjYWQ2MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
32	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA1LzB4MDAwMDAwNzAwMTJjYWRhMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
40	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
46	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA1LzB4MDAwMDAwMDcwMTJjYThiOHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
47	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
37	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
35	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
42	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AFtjb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnN0YXRlbWVudC5TdGF0ZW1lbnRKb2JDb25maWckJExhbWJkYSQ2MDMvMHgwMDAwMDA3MDAxMmNkMjQ4dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
39	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
44	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA1LzB4MDAwMDAwNzAwMTJjZDljOHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
45	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
43	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
48	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
49	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AFtjb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnN0YXRlbWVudC5TdGF0ZW1lbnRKb2JDb25maWckJExhbWJkYSQ2MDMvMHgwMDAwMDAwNDAxMmNhMTM4dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
52	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
60	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAB3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
50	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
58	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAB3QAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
59	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
51	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA2LzB4MDAwMDAwNzAwMTJjZTViOHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
57	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
53	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
55	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
54	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AFtjb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnN0YXRlbWVudC5TdGF0ZW1lbnRKb2JDb25maWckJExhbWJkYSQ2MDQvMHgwMDAwMDA3MDAxMmNkZTM4dAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
56	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA2LzB4MDAwMDAwMDMwMTJjZTViOHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
61	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA3LzB4MDAwMDAwMDQwMTJkNTUyOHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
65	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
62	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
68	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
67	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
64	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAB3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
63	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAB3QAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
74	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAdaW50ZXJlc3RJdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABnQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAhaW50ZXJlc3RJdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
66	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA3LzB4MDAwMDAwNzAwMTJkNTUyOHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
72	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
150	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
70	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
69	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAACHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
71	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA3LzB4MDAwMDAwZjAwMTJkMzllMHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
151	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwYTgwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
75	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAdaW50ZXJlc3RJdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAA3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAhaW50ZXJlc3RJdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
73	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAdaW50ZXJlc3RJdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAA3QAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAhaW50ZXJlc3RJdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
87	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwOTgwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
76	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
82	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
81	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAXQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
80	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AFtjb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnN0YXRlbWVudC5TdGF0ZW1lbnRKb2JDb25maWckJExhbWJkYSQ2MDMvMHgwMDAwMDA3MDAxMmQ0M2UwdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAOYmF0Y2guc3RlcFR5cGV0ADdvcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC50YXNrbGV0LlRhc2tsZXRTdGVweA==	\N
77	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAAFc3RhcnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAA3QAA2VuZHNxAH4ABQAAAAZ0AA1iYXRjaC52ZXJzaW9udAAFNS4yLjR0AB5zdGF0ZW1lbnRJdGVtUmVhZGVyLnJlYWQuY291bnRxAH4ACXQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHQAInN0YXRlbWVudEl0ZW1SZWFkZXIucmVhZC5jb3VudC5tYXhxAH4ACXg=	\N
79	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAAFc3RhcnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAAHQAA2VuZHNxAH4ABQAAAAN0AA1iYXRjaC52ZXJzaW9udAAFNS4yLjR0AB5zdGF0ZW1lbnRJdGVtUmVhZGVyLnJlYWQuY291bnRxAH4ACXQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHQAInN0YXRlbWVudEl0ZW1SZWFkZXIucmVhZC5jb3VudC5tYXhxAH4ACXg=	\N
78	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAARYmF0Y2gudGFza2xldFR5cGV0AD1vcmcuc3ByaW5nZnJhbWV3b3JrLmJhdGNoLmNvcmUuc3RlcC5pdGVtLkNodW5rT3JpZW50ZWRUYXNrbGV0dAAFc3RhcnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABnQAA2VuZHNxAH4ABQAAAAl0AA1iYXRjaC52ZXJzaW9udAAFNS4yLjR0AB5zdGF0ZW1lbnRJdGVtUmVhZGVyLnJlYWQuY291bnRxAH4ACXQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHQAInN0YXRlbWVudEl0ZW1SZWFkZXIucmVhZC5jb3VudC5tYXhxAH4ACXg=	\N
84	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAnQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
86	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABXQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
83	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwZTAwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
85	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABXQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
88	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
98	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
89	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAB3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
90	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
91	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAB3QAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
95	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAB3QAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
92	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwOTgwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
96	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAB3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
94	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
97	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwZjAwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
93	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
99	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAB3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
101	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAB3QAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
100	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
104	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAB3QAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
106	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
102	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwOTgwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
107	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwNzAwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
103	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
105	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAB3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
110	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABXQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
108	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAnQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
111	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwOTAwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
114	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwNzAwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
109	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABXQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
119	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABXQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
118	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAnQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
117	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwNzAwMTJkM2NkOHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
113	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
112	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAXQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
121	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwMDYwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
116	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
115	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAXQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
120	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABXQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
122	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
124	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAB3QAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
125	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAB3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
123	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
130	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
127	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAA3QADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
126	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwMDcwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
132	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAnQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
134	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
133	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAC3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABnQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
129	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAAB3QAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
128	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAB3QAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
131	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwYzgwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
135	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwMDQwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
136	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAnQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
140	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAnQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
146	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABXQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
144	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAnQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
138	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
137	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAADHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABnQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
143	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwYjAwMTJkNDk0MHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
139	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwNzAwMTJkM2NkOHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
141	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAACnQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABXQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
142	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABXQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
148	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAAlU2ltcGxlU3RlcEV4ZWN1dGlvblNwbGl0dGVyLkdSSURfU0laRXNyAA5qYXZhLmxhbmcuTG9uZzuL5JDMjyPfAgABSgAFdmFsdWV4cgAQamF2YS5sYW5nLk51bWJlcoaslR0LlOCLAgAAeHAAAAAAAAAAAnQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA+b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnBhcnRpdGlvbi5zdXBwb3J0LlBhcnRpdGlvblN0ZXB4	\N
147	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAADdAARYmF0Y2gudGFza2xldFR5cGV0AF9jb20uZXhhbXBsZS5iYW5rbGVnYWN5bWlncmF0aW9uLnRyYW5zYWN0aW9uLlRyYW5zYWN0aW9uSm9iQ29uZmlnJCRMYW1iZGEkNjA0LzB4MDAwMDAwNzAwMTJkM2NkOHQADWJhdGNoLnZlcnNpb250AAU1LjIuNHQADmJhdGNoLnN0ZXBUeXBldAA3b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAudGFza2xldC5UYXNrbGV0U3RlcHg=	\N
145	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAABXQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAAAHQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
149	rO0ABXNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAx3CAAAABAAAAAHdAAgdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnRzcgARamF2YS5sYW5nLkludGVnZXIS4qCk94GHOAIAAUkABXZhbHVleHIAEGphdmEubGFuZy5OdW1iZXKGrJUdC5TgiwIAAHhwAAAADHQAEWJhdGNoLnRhc2tsZXRUeXBldAA9b3JnLnNwcmluZ2ZyYW1ld29yay5iYXRjaC5jb3JlLnN0ZXAuaXRlbS5DaHVua09yaWVudGVkVGFza2xldHQABXN0YXJ0c3EAfgADAAAABnQAA2VuZHEAfgAFdAANYmF0Y2gudmVyc2lvbnQABTUuMi40dAAkdHJhbnNhY3Rpb25JdGVtUmVhZGVyLnJlYWQuY291bnQubWF4cQB+AAV0AA5iYXRjaC5zdGVwVHlwZXQAN29yZy5zcHJpbmdmcmFtZXdvcmsuYmF0Y2guY29yZS5zdGVwLnRhc2tsZXQuVGFza2xldFN0ZXB4	\N
\.


--
-- Data for Name: estados_cuenta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.estados_cuenta (cuenta_id, fecha, transaccion, monto, descripcion, movimiento, anomalia, motivo) FROM stdin;
101	2024-01-01	deposito	1000.00	Ingreso mensual	INGRESO	f	\N
101	2024-03-15	retiro	-500.00	Retiro parcial	EGRESO	f	\N
102	2024-05-22	deposito	1500.00	Ingreso mensual	INGRESO	f	\N
103	2024-07-10	deposito	2000.00	Ingreso mensual	INGRESO	f	\N
104	2024-09-05	compra	-100.00	Compra en tienda	EGRESO	f	\N
105	2024-10-01	deposito	2500.00	Ingreso extra	INGRESO	f	\N
106	2024-11-20	deposito	3000.00	Ingreso mensual	INGRESO	f	\N
107	2024-12-25	deposito	0.00	Ingreso navideño	SIN_MOVIMIENTO	t	Monto igual a cero
108	2024-12-31	deposito	2000.00	Ingreso de fin de año	INGRESO	f	\N
\.


--
-- Data for Name: intereses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.intereses (cuenta_id, nombre, saldo, edad, tipo, interes, saldo_final, anomalia, motivo) FROM stdin;
104	Alice Brown	0.00	45	ahorro	0.00	0.00	t	Saldo menor o igual a cero
108	Steve Rogers	10000.00	80	ahorro	100.00	10100.00	f	\N
102	Jane Smith	8000.00	25	prestamo	160.00	8140.00	f	\N
103	Bob Johnson	12000.00	30	prestamo	240.00	12220.00	f	\N
105	Charlie Green	7000.00	35	hipoteca	0.00	6980.00	t	Tipo de cuenta no contemplado
106	John Doe	5000.00	30	ahorro	50.00	5030.00	f	\N
107	Diana Prince	15000.00	40	prestamo	300.00	15280.00	f	\N
101	John Doe	5000.00	30	ahorro	50.00	4621.00	f	\N
\.


--
-- Data for Name: resumen_anual; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resumen_anual (cuenta_id, cantidad_movimientos, total_ingresos, total_egresos, saldo_neto, cantidad_anomalias) FROM stdin;
103	1	2000.00	0.00	2000.00	0
105	1	2500.00	0.00	2500.00	0
101	2	1000.00	500.00	500.00	0
106	1	3000.00	0.00	3000.00	0
104	1	0.00	100.00	-100.00	0
107	1	0.00	0.00	0.00	1
102	1	1500.00	0.00	1500.00	0
108	1	2000.00	0.00	2000.00	0
\.


--
-- Data for Name: resumen_transacciones_diarias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resumen_transacciones_diarias (fecha, cantidad_transacciones, monto_total, cantidad_anomalias) FROM stdin;
2024-01-04	1	800.00	0
2024-01-07	1	3000.00	0
2024-01-02	1	1500.00	0
2024-01-05	2	1400.00	0
2024-01-08	1	1000.00	0
2024-01-01	1	1000.00	0
2024-01-03	2	-200.00	2
2024-01-06	1	1200.00	0
\.


--
-- Data for Name: retiros_atm; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.retiros_atm (id, cuenta_id, fecha_hora, monto) FROM stdin;
1	101	2026-09-05 19:25:41.569838	100.00
2	101	2026-09-07 08:01:18.654571	1.00
3	101	2026-09-07 19:26:29.605879	1.00
4	101	2026-09-07 19:27:11.315445	1.00
5	101	2026-09-12 12:32:10.123975	1.00
6	101	2026-09-12 12:41:53.174777	1.00
7	101	2026-09-12 12:42:44.485803	1.00
8	101	2026-09-12 16:12:23.135203	10.00
9	101	2026-09-12 16:59:05.740284	10.00
10	101	2026-09-12 18:12:12.788899	1.00
11	101	2026-09-12 20:43:41.435342	10.00
12	101	2026-09-26 12:27:32.957228	10.00
13	101	2026-09-27 20:51:08.309591	10.00
14	101	2026-09-27 21:12:17.72842	10.00
15	102	2026-09-27 21:12:17.830373	10.00
16	103	2026-09-27 21:12:17.872909	10.00
17	105	2026-09-27 21:12:17.90784	10.00
18	106	2026-09-27 21:12:17.951669	10.00
19	107	2026-09-27 21:12:17.984972	10.00
20	101	2026-09-27 21:13:34.859771	10.00
21	101	2026-09-27 21:13:34.91612	10.00
22	101	2026-09-27 21:13:34.947581	10.00
23	101	2026-09-28 18:59:41.046759	100.00
24	101	2026-09-28 19:08:18.387181	120.00
25	101	2026-09-28 19:15:29.266164	10.00
26	102	2026-09-28 19:15:29.345692	10.00
27	103	2026-09-28 19:15:29.393907	10.00
28	105	2026-09-28 19:15:29.435627	10.00
29	106	2026-09-28 19:15:29.472801	10.00
30	107	2026-09-28 19:15:29.511234	10.00
33	101	2026-10-04 01:52:53.198079	1.00
34	101	2026-10-04 01:52:58.775144	1.00
35	101	2026-10-04 01:53:10.544958	1.00
36	101	2026-10-04 01:54:05.869507	1.00
\.


--
-- Data for Name: transacciones; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transacciones (id, fecha, monto, tipo, anomalia, motivo) FROM stdin;
1	2024-01-01	1000.00	debito	f	\N
2	2024-01-02	1500.00	credito	f	\N
3	2024-01-03	-200.00	debito	t	Monto negativo
4	2024-01-03	0.00	debito	t	Monto igual a cero
5	2024-01-04	800.00	credito	f	\N
6	2024-01-05	700.00	debito	f	\N
7	2024-01-06	1200.00	credito	f	\N
8	2024-01-05	700.00	debito	f	\N
9	2024-01-07	3000.00	debito	f	\N
10	2024-01-08	1000.00	credito	f	\N
\.


--
-- Name: batch_job_execution_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.batch_job_execution_seq', 57, true);


--
-- Name: batch_job_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.batch_job_seq', 55, true);


--
-- Name: batch_step_execution_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.batch_step_execution_seq', 151, true);


--
-- Name: retiros_atm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.retiros_atm_id_seq', 36, true);


--
-- Name: batch_job_execution_context batch_job_execution_context_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_job_execution_context
    ADD CONSTRAINT batch_job_execution_context_pkey PRIMARY KEY (job_execution_id);


--
-- Name: batch_job_execution batch_job_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_job_execution
    ADD CONSTRAINT batch_job_execution_pkey PRIMARY KEY (job_execution_id);


--
-- Name: batch_job_instance batch_job_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_job_instance
    ADD CONSTRAINT batch_job_instance_pkey PRIMARY KEY (job_instance_id);


--
-- Name: batch_step_execution_context batch_step_execution_context_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_step_execution_context
    ADD CONSTRAINT batch_step_execution_context_pkey PRIMARY KEY (step_execution_id);


--
-- Name: batch_step_execution batch_step_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_step_execution
    ADD CONSTRAINT batch_step_execution_pkey PRIMARY KEY (step_execution_id);


--
-- Name: estados_cuenta estados_cuenta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estados_cuenta
    ADD CONSTRAINT estados_cuenta_pkey PRIMARY KEY (cuenta_id, fecha, transaccion);


--
-- Name: intereses intereses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.intereses
    ADD CONSTRAINT intereses_pkey PRIMARY KEY (cuenta_id);


--
-- Name: batch_job_instance job_inst_un; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_job_instance
    ADD CONSTRAINT job_inst_un UNIQUE (job_name, job_key);


--
-- Name: resumen_anual resumen_anual_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumen_anual
    ADD CONSTRAINT resumen_anual_pkey PRIMARY KEY (cuenta_id);


--
-- Name: resumen_transacciones_diarias resumen_transacciones_diarias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumen_transacciones_diarias
    ADD CONSTRAINT resumen_transacciones_diarias_pkey PRIMARY KEY (fecha);


--
-- Name: retiros_atm retiros_atm_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retiros_atm
    ADD CONSTRAINT retiros_atm_pkey PRIMARY KEY (id);


--
-- Name: transacciones transacciones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transacciones
    ADD CONSTRAINT transacciones_pkey PRIMARY KEY (id);


--
-- Name: estados_cuenta uq_estado_cuenta; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estados_cuenta
    ADD CONSTRAINT uq_estado_cuenta UNIQUE (cuenta_id, fecha, transaccion, monto);


--
-- Name: batch_job_execution_context job_exec_ctx_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_job_execution_context
    ADD CONSTRAINT job_exec_ctx_fk FOREIGN KEY (job_execution_id) REFERENCES public.batch_job_execution(job_execution_id);


--
-- Name: batch_job_execution_params job_exec_params_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_job_execution_params
    ADD CONSTRAINT job_exec_params_fk FOREIGN KEY (job_execution_id) REFERENCES public.batch_job_execution(job_execution_id);


--
-- Name: batch_step_execution job_exec_step_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_step_execution
    ADD CONSTRAINT job_exec_step_fk FOREIGN KEY (job_execution_id) REFERENCES public.batch_job_execution(job_execution_id);


--
-- Name: batch_job_execution job_inst_exec_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_job_execution
    ADD CONSTRAINT job_inst_exec_fk FOREIGN KEY (job_instance_id) REFERENCES public.batch_job_instance(job_instance_id);


--
-- Name: batch_step_execution_context step_exec_ctx_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_step_execution_context
    ADD CONSTRAINT step_exec_ctx_fk FOREIGN KEY (step_execution_id) REFERENCES public.batch_step_execution(step_execution_id);


--
-- PostgreSQL database dump complete
--

\unrestrict lLUAv4F0nwb2hb8zOLpJOpTSjVbTozykakmp0HPyZHDogBqqNxcBuPVf9kMhEcZ

