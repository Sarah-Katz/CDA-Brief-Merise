--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.0

-- Started on 2023-12-20 15:27:41

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
-- TOC entry 3438 (class 1262 OID 16384)
-- Name: brief_merise; Type: DATABASE; Schema: -; Owner: sarah
--

CREATE DATABASE brief_merise WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE brief_merise OWNER TO sarah;

\connect brief_merise

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


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 240 (class 1255 OID 32780)
-- Name: getmoviesbydirector(character varying); Type: FUNCTION; Schema: public; Owner: sarah
--

CREATE FUNCTION public.getmoviesbydirector(director character varying) RETURNS TABLE(title character varying)
    LANGUAGE sql
    AS $$
SELECT title
FROM Public."Direct" dr
INNER JOIN Public."Director" d
ON d.id_director = dr.id_director
INNER JOIN Public."Movie" m
ON m.id_movie = dr.id_movie
WHERE director = d.director_lastname
$$;


ALTER FUNCTION public.getmoviesbydirector(director character varying) OWNER TO sarah;

--
-- TOC entry 241 (class 1255 OID 24599)
-- Name: log_user_changes(); Type: FUNCTION; Schema: public; Owner: sarah
--

CREATE FUNCTION public.log_user_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
old_last VARCHAR(255);
new_last VARCHAR(255);
old_first VARCHAR(255);
new_first VARCHAR(255);
old_email VARCHAR(255);
new_email VARCHAR(255);
old_password VARCHAR(255);
new_password VARCHAR(255);
old_role VARCHAR(255);
new_role VARCHAR(255);

BEGIN old_last := OLD.user_lastname;
new_last := NEW.user_lastname;
old_first := OLD.user_firstname;
new_first := NEW.user_firstname;
old_email := OLD.email;
new_email := NEW.email;
old_password := OLD.password;
new_password := NEW.password;
old_role := OLD.role;
new_role := NEW.role;

-- Insert into Log table if there is a change in the value
IF old_last IS DISTINCT
FROM
    new_last THEN
INSERT INTO
    Public."Log" (id_user, changed_value, old_value, new_value)
VALUES
    (NEW.id_user, 'user_lastname', old_last, new_last);
END IF;

IF old_first IS DISTINCT
FROM
    new_first THEN
INSERT INTO
    Public."Log" (id_user, changed_value, old_value, new_value)
VALUES
    (NEW.id_user, 'user_firstname', old_first, new_first);
END IF;

IF old_email IS DISTINCT
FROM
    new_email THEN
INSERT INTO
    Public."Log" (id_user, changed_value, old_value, new_value)
VALUES
    (NEW.id_user, 'email', old_email, new_email);
END IF;

IF old_password IS DISTINCT
FROM
    new_password THEN
INSERT INTO
    Public."Log" (id_user, changed_value, old_value, new_value)
VALUES
    (NEW.id_user, 'password', old_password, new_password);
END IF;

IF old_role IS DISTINCT
FROM
    new_role THEN
INSERT INTO
    Public."Log" (id_user, changed_value, old_value, new_value)
VALUES
    (NEW.id_user, 'role', old_role, new_role);
END IF;

RETURN NEW;

END;$$;


ALTER FUNCTION public.log_user_changes() OWNER TO sarah;

--
-- TOC entry 228 (class 1255 OID 24591)
-- Name: update_modification_date(); Type: FUNCTION; Schema: public; Owner: sarah
--

CREATE FUNCTION public.update_modification_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.modified_at = current_timestamp;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modification_date() OWNER TO sarah;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16402)
-- Name: Act; Type: TABLE; Schema: public; Owner: sarah
--

CREATE TABLE public."Act" (
    id_actor integer NOT NULL,
    id_movie integer NOT NULL,
    role character varying(50) NOT NULL
);


ALTER TABLE public."Act" OWNER TO sarah;

--
-- TOC entry 218 (class 1259 OID 16396)
-- Name: Actor; Type: TABLE; Schema: public; Owner: sarah
--

CREATE TABLE public."Actor" (
    id_actor integer NOT NULL,
    actor_lastname character varying(50) NOT NULL,
    actor_firstname character varying(50) NOT NULL,
    birth_date date NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    modified_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Actor" OWNER TO sarah;

--
-- TOC entry 217 (class 1259 OID 16395)
-- Name: Actor_id_actor_seq; Type: SEQUENCE; Schema: public; Owner: sarah
--

ALTER TABLE public."Actor" ALTER COLUMN id_actor ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Actor_id_actor_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16423)
-- Name: Direct; Type: TABLE; Schema: public; Owner: sarah
--

CREATE TABLE public."Direct" (
    id_director integer NOT NULL,
    id_movie integer NOT NULL
);


ALTER TABLE public."Direct" OWNER TO sarah;

--
-- TOC entry 221 (class 1259 OID 16418)
-- Name: Director; Type: TABLE; Schema: public; Owner: sarah
--

CREATE TABLE public."Director" (
    id_director integer NOT NULL,
    director_lastname character varying(50) NOT NULL,
    director_firstname character varying(50) NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    modified_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Director" OWNER TO sarah;

--
-- TOC entry 220 (class 1259 OID 16417)
-- Name: Director_id_director_seq; Type: SEQUENCE; Schema: public; Owner: sarah
--

ALTER TABLE public."Director" ALTER COLUMN id_director ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Director_id_director_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 16460)
-- Name: Log; Type: TABLE; Schema: public; Owner: sarah
--

CREATE TABLE public."Log" (
    id_log integer NOT NULL,
    changed_value character varying(20) NOT NULL,
    old_value character varying(255) NOT NULL,
    new_value character varying(255) NOT NULL,
    id_user integer NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Log" OWNER TO sarah;

--
-- TOC entry 227 (class 1259 OID 24602)
-- Name: Log_id_log_seq; Type: SEQUENCE; Schema: public; Owner: sarah
--

ALTER TABLE public."Log" ALTER COLUMN id_log ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Log_id_log_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 16390)
-- Name: Movie; Type: TABLE; Schema: public; Owner: sarah
--

CREATE TABLE public."Movie" (
    id_movie integer NOT NULL,
    title character varying(255) NOT NULL,
    duration integer NOT NULL,
    release_date date NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    modified_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Movie" OWNER TO sarah;

--
-- TOC entry 215 (class 1259 OID 16389)
-- Name: Movie_id_movie_seq; Type: SEQUENCE; Schema: public; Owner: sarah
--

ALTER TABLE public."Movie" ALTER COLUMN id_movie ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Movie_id_movie_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 16445)
-- Name: Prefer; Type: TABLE; Schema: public; Owner: sarah
--

CREATE TABLE public."Prefer" (
    id_movie integer NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE public."Prefer" OWNER TO sarah;

--
-- TOC entry 223 (class 1259 OID 16438)
-- Name: User; Type: TABLE; Schema: public; Owner: sarah
--

CREATE TABLE public."User" (
    id_user integer NOT NULL,
    user_lastname character varying(50) NOT NULL,
    user_firstname character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    modified_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."User" OWNER TO sarah;

--
-- TOC entry 226 (class 1259 OID 24596)
-- Name: User_id_user_seq; Type: SEQUENCE; Schema: public; Owner: sarah
--

ALTER TABLE public."User" ALTER COLUMN id_user ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."User_id_user_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3424 (class 0 OID 16402)
-- Dependencies: 219
-- Data for Name: Act; Type: TABLE DATA; Schema: public; Owner: sarah
--

COPY public."Act" (id_actor, id_movie, role) FROM stdin;
21	21	Jack Johnson
2	2	Alice Carter
3	3	Michael Williams
4	4	Olivia Jones
5	5	John Brown
6	6	Sophia Davis
7	7	Ethan Miller
8	8	Ava Moore
9	9	Liam Taylor
10	10	Isabella Anderson
11	11	Daniel Thomas
12	12	Emily White
13	13	Noah Jackson
14	14	Benjamin Harris
15	15	Ella Martin
16	16	William Thompson
17	17	Grace Young
18	18	James Hall
19	19	Scarlett King
20	20	Henry Wright
\.


--
-- TOC entry 3423 (class 0 OID 16396)
-- Dependencies: 218
-- Data for Name: Actor; Type: TABLE DATA; Schema: public; Owner: sarah
--

COPY public."Actor" (id_actor, actor_lastname, actor_firstname, birth_date, created_at, modified_at) FROM stdin;
3	Johnson	Emily	1985-09-23	2023-12-19	2023-12-19 00:00:00
4	Williams	Daniel	1982-12-10	2023-12-19	2023-12-19 00:00:00
5	Jones	Olivia	1995-03-28	2023-12-19	2023-12-19 00:00:00
6	Brown	Michael	1988-07-07	2023-12-19	2023-12-19 00:00:00
7	Davis	Sophia	1992-11-14	2023-12-19	2023-12-19 00:00:00
8	Miller	Ethan	1980-04-02	2023-12-19	2023-12-19 00:00:00
9	Moore	Ava	1998-08-18	2023-12-19	2023-12-19 00:00:00
10	Taylor	Liam	1993-06-20	2023-12-19	2023-12-19 00:00:00
11	Anderson	Isabella	1987-01-05	2023-12-19	2023-12-19 00:00:00
12	Thomas	Mia	1991-12-03	2023-12-19	2023-12-19 00:00:00
13	White	Noah	1983-09-12	2023-12-19	2023-12-19 00:00:00
14	Jackson	Amelia	1997-04-30	2023-12-19	2023-12-19 00:00:00
15	Harris	Benjamin	1984-08-25	2023-12-19	2023-12-19 00:00:00
16	Martin	Ella	1994-02-17	2023-12-19	2023-12-19 00:00:00
17	Thompson	William	1989-10-08	2023-12-19	2023-12-19 00:00:00
18	Young	Grace	1996-07-11	2023-12-19	2023-12-19 00:00:00
19	Hall	James	1981-03-04	2023-12-19	2023-12-19 00:00:00
20	King	Scarlett	1999-09-28	2023-12-19	2023-12-19 00:00:00
21	Wright	Henry	1986-05-22	2023-12-19	2023-12-19 00:00:00
2	Doe	John	1990-05-15	2023-12-19	2023-12-19 00:00:00
\.


--
-- TOC entry 3427 (class 0 OID 16423)
-- Dependencies: 222
-- Data for Name: Direct; Type: TABLE DATA; Schema: public; Owner: sarah
--

COPY public."Direct" (id_director, id_movie) FROM stdin;
11	2
2	4
3	8
4	10
5	12
6	14
7	16
8	18
9	20
10	6
\.


--
-- TOC entry 3426 (class 0 OID 16418)
-- Dependencies: 221
-- Data for Name: Director; Type: TABLE DATA; Schema: public; Owner: sarah
--

COPY public."Director" (id_director, director_lastname, director_firstname, created_at, modified_at) FROM stdin;
2	Nolan	Christopher	2023-12-19	2023-12-19 00:00:00
3	Tarantino	Quentin	2023-12-19	2023-12-19 00:00:00
4	Spielberg	Steven	2023-12-19	2023-12-19 00:00:00
5	Coppola	Francis	2023-12-19	2023-12-19 00:00:00
6	Fincher	David	2023-12-19	2023-12-19 00:00:00
7	Scorsese	Martin	2023-12-19	2023-12-19 00:00:00
8	Kubrick	Stanley	2023-12-19	2023-12-19 00:00:00
9	Cameron	James	2023-12-19	2023-12-19 00:00:00
10	Anderson	Paul Thomas	2023-12-19	2023-12-19 00:00:00
11	Coen	Joel	2023-12-19	2023-12-19 00:00:00
\.


--
-- TOC entry 3430 (class 0 OID 16460)
-- Dependencies: 225
-- Data for Name: Log; Type: TABLE DATA; Schema: public; Owner: sarah
--

COPY public."Log" (id_log, changed_value, old_value, new_value, id_user, created_at) FROM stdin;
1	password	test	dfghjkmunbgerlkimj	1	2023-12-19 00:00:00
2	email	john.doe@email.com	Tamer	1	2023-12-19 00:00:00
3	email	Tamer	Tonperr	1	2023-12-19 00:00:00
4	password	,jlmivrdfgj	password	1	2023-12-19 00:00:00
5	email	Tonperr	email	1	2023-12-19 00:00:00
6	password	password	mdp	1	2023-12-19 00:00:00
7	email	email	email0	1	2023-12-19 12:58:04
8	password	mdp	mdpsdfggs	1	2023-12-19 12:58:04
9	password	mdpsdfggs	lhjkvbdfgsrbhksgdf	1	2023-12-19 13:47:30
10	password	lhjkvbdfgsrbhksgdf	test	1	2023-12-19 13:50:39
\.


--
-- TOC entry 3421 (class 0 OID 16390)
-- Dependencies: 216
-- Data for Name: Movie; Type: TABLE DATA; Schema: public; Owner: sarah
--

COPY public."Movie" (id_movie, title, duration, release_date, created_at, modified_at) FROM stdin;
2	The Lost City	120	2023-01-15	2023-12-19	2023-12-19 00:00:00
3	Inception	148	2010-07-16	2023-12-19	2023-12-19 00:00:00
4	The Dark Knight	152	2008-07-18	2023-12-19	2023-12-19 00:00:00
5	Pulp Fiction	154	1994-10-14	2023-12-19	2023-12-19 00:00:00
6	Forrest Gump	142	1994-07-06	2023-12-19	2023-12-19 00:00:00
7	The Matrix	136	1999-03-31	2023-12-19	2023-12-19 00:00:00
8	Interstellar	169	2014-11-07	2023-12-19	2023-12-19 00:00:00
9	Titanic	195	1997-12-19	2023-12-19	2023-12-19 00:00:00
10	The Shawshank Redemption	142	1994-09-23	2023-12-19	2023-12-19 00:00:00
11	Fight Club	139	1999-10-15	2023-12-19	2023-12-19 00:00:00
12	The Godfather	175	1972-03-24	2023-12-19	2023-12-19 00:00:00
13	Jurassic Park	127	1993-06-11	2023-12-19	2023-12-19 00:00:00
14	Avatar	162	2009-12-18	2023-12-19	2023-12-19 00:00:00
15	The Silence of the Lambs	118	1991-02-14	2023-12-19	2023-12-19 00:00:00
16	The Lord of the Rings: The Fellowship of the Ring	178	2001-12-19	2023-12-19	2023-12-19 00:00:00
17	The Great Gatsby	143	2013-05-10	2023-12-19	2023-12-19 00:00:00
18	The Revenant	156	2015-12-25	2023-12-19	2023-12-19 00:00:00
19	The Social Network	120	2010-10-01	2023-12-19	2023-12-19 00:00:00
20	La La Land	128	2016-12-09	2023-12-19	2023-12-19 00:00:00
21	The Grand Budapest Hotel	100	2014-03-07	2023-12-19	2023-12-19 00:00:00
\.


--
-- TOC entry 3429 (class 0 OID 16445)
-- Dependencies: 224
-- Data for Name: Prefer; Type: TABLE DATA; Schema: public; Owner: sarah
--

COPY public."Prefer" (id_movie, id_user) FROM stdin;
21	1
2	2
3	3
4	4
5	5
6	6
7	7
8	8
9	9
10	10
11	11
12	12
13	13
14	14
15	15
16	16
17	17
18	18
19	19
20	20
\.


--
-- TOC entry 3428 (class 0 OID 16438)
-- Dependencies: 223
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: sarah
--

COPY public."User" (id_user, user_lastname, user_firstname, email, password, role, created_at, modified_at) FROM stdin;
2	Smith	Emily	emily.smith@email.com	pass456	user	2023-12-19	2023-12-19 00:00:00
3	Johnson	Michael	michael.johnson@email.com	securepass	user	2023-12-19	2023-12-19 00:00:00
4	Williams	Olivia	olivia.williams@email.com	pass123	admin	2023-12-19	2023-12-19 00:00:00
5	Jones	Daniel	daniel.jones@email.com	adminpass	user	2023-12-19	2023-12-19 00:00:00
6	Brown	Sophia	sophia.brown@email.com	password456	user	2023-12-19	2023-12-19 00:00:00
7	Davis	Ethan	ethan.davis@email.com	pass789	user	2023-12-19	2023-12-19 00:00:00
8	Miller	Ava	ava.miller@email.com	admin123	admin	2023-12-19	2023-12-19 00:00:00
9	Moore	Liam	liam.moore@email.com	userpass	user	2023-12-19	2023-12-19 00:00:00
10	Taylor	Isabella	isabella.taylor@email.com	passadmin	user	2023-12-19	2023-12-19 00:00:00
11	Anderson	Mia	mia.anderson@email.com	admin456	user	2023-12-19	2023-12-19 00:00:00
12	Thomas	Noah	noah.thomas@email.com	useradmin	admin	2023-12-19	2023-12-19 00:00:00
13	White	Amelia	amelia.white@email.com	passuser	user	2023-12-19	2023-12-19 00:00:00
14	Jackson	Benjamin	benjamin.jackson@email.com	adminpass123	user	2023-12-19	2023-12-19 00:00:00
15	Harris	Ella	ella.harris@email.com	passadmin456	user	2023-12-19	2023-12-19 00:00:00
16	Martin	William	william.martin@email.com	adminuserpass	admin	2023-12-19	2023-12-19 00:00:00
17	Thompson	Grace	grace.thompson@email.com	userpassadmin	user	2023-12-19	2023-12-19 00:00:00
18	Young	James	james.young@email.com	adminpassuser	user	2023-12-19	2023-12-19 00:00:00
19	Hall	Scarlett	scarlett.hall@email.com	useradminpass	admin	2023-12-19	2023-12-19 00:00:00
20	King	Henry	henry.king@email.com	passuseradmin	user	2023-12-19	2023-12-19 00:00:00
1	Doe	John	email0	test	user	2023-12-19	2023-12-19 13:50:39
\.


--
-- TOC entry 3448 (class 0 OID 0)
-- Dependencies: 217
-- Name: Actor_id_actor_seq; Type: SEQUENCE SET; Schema: public; Owner: sarah
--

SELECT pg_catalog.setval('public."Actor_id_actor_seq"', 21, true);


--
-- TOC entry 3449 (class 0 OID 0)
-- Dependencies: 220
-- Name: Director_id_director_seq; Type: SEQUENCE SET; Schema: public; Owner: sarah
--

SELECT pg_catalog.setval('public."Director_id_director_seq"', 11, true);


--
-- TOC entry 3450 (class 0 OID 0)
-- Dependencies: 227
-- Name: Log_id_log_seq; Type: SEQUENCE SET; Schema: public; Owner: sarah
--

SELECT pg_catalog.setval('public."Log_id_log_seq"', 10, true);


--
-- TOC entry 3451 (class 0 OID 0)
-- Dependencies: 215
-- Name: Movie_id_movie_seq; Type: SEQUENCE SET; Schema: public; Owner: sarah
--

SELECT pg_catalog.setval('public."Movie_id_movie_seq"', 21, true);


--
-- TOC entry 3452 (class 0 OID 0)
-- Dependencies: 226
-- Name: User_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: sarah
--

SELECT pg_catalog.setval('public."User_id_user_seq"', 20, true);


--
-- TOC entry 3252 (class 2606 OID 16406)
-- Name: Act Act_pkey; Type: CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Act"
    ADD CONSTRAINT "Act_pkey" PRIMARY KEY (id_actor, id_movie);


--
-- TOC entry 3250 (class 2606 OID 16401)
-- Name: Actor Actor_pkey; Type: CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Actor"
    ADD CONSTRAINT "Actor_pkey" PRIMARY KEY (id_actor);


--
-- TOC entry 3256 (class 2606 OID 16427)
-- Name: Direct Direct_pkey; Type: CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Direct"
    ADD CONSTRAINT "Direct_pkey" PRIMARY KEY (id_movie, id_director);


--
-- TOC entry 3254 (class 2606 OID 16422)
-- Name: Director Director_pkey; Type: CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Director"
    ADD CONSTRAINT "Director_pkey" PRIMARY KEY (id_director);


--
-- TOC entry 3264 (class 2606 OID 16466)
-- Name: Log Log_pkey; Type: CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Log"
    ADD CONSTRAINT "Log_pkey" PRIMARY KEY (id_log);


--
-- TOC entry 3248 (class 2606 OID 16394)
-- Name: Movie Movie_pkey; Type: CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Movie"
    ADD CONSTRAINT "Movie_pkey" PRIMARY KEY (id_movie);


--
-- TOC entry 3262 (class 2606 OID 16449)
-- Name: Prefer Prefer_pkey; Type: CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Prefer"
    ADD CONSTRAINT "Prefer_pkey" PRIMARY KEY (id_movie, id_user);


--
-- TOC entry 3258 (class 2606 OID 16444)
-- Name: User user_email_key; Type: CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- TOC entry 3260 (class 2606 OID 16442)
-- Name: User user_pkey; Type: CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id_user);


--
-- TOC entry 3275 (class 2620 OID 24601)
-- Name: User log_changes; Type: TRIGGER; Schema: public; Owner: sarah
--

CREATE TRIGGER log_changes AFTER UPDATE ON public."User" FOR EACH ROW EXECUTE FUNCTION public.log_user_changes();


--
-- TOC entry 3273 (class 2620 OID 24592)
-- Name: Actor trigger_update_modification_date; Type: TRIGGER; Schema: public; Owner: sarah
--

CREATE TRIGGER trigger_update_modification_date BEFORE UPDATE ON public."Actor" FOR EACH ROW EXECUTE FUNCTION public.update_modification_date();


--
-- TOC entry 3274 (class 2620 OID 24593)
-- Name: Director trigger_update_modification_date; Type: TRIGGER; Schema: public; Owner: sarah
--

CREATE TRIGGER trigger_update_modification_date BEFORE UPDATE ON public."Director" FOR EACH ROW EXECUTE FUNCTION public.update_modification_date();


--
-- TOC entry 3272 (class 2620 OID 24594)
-- Name: Movie trigger_update_modification_date; Type: TRIGGER; Schema: public; Owner: sarah
--

CREATE TRIGGER trigger_update_modification_date BEFORE UPDATE ON public."Movie" FOR EACH ROW EXECUTE FUNCTION public.update_modification_date();


--
-- TOC entry 3276 (class 2620 OID 24595)
-- Name: User trigger_update_modification_date; Type: TRIGGER; Schema: public; Owner: sarah
--

CREATE TRIGGER trigger_update_modification_date BEFORE UPDATE ON public."User" FOR EACH ROW EXECUTE FUNCTION public.update_modification_date();


--
-- TOC entry 3265 (class 2606 OID 16407)
-- Name: Act Act_id_actor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Act"
    ADD CONSTRAINT "Act_id_actor_fkey" FOREIGN KEY (id_actor) REFERENCES public."Actor"(id_actor);


--
-- TOC entry 3266 (class 2606 OID 16412)
-- Name: Act Act_id_movie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Act"
    ADD CONSTRAINT "Act_id_movie_fkey" FOREIGN KEY (id_movie) REFERENCES public."Movie"(id_movie);


--
-- TOC entry 3267 (class 2606 OID 16428)
-- Name: Direct Direct_id_director_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Direct"
    ADD CONSTRAINT "Direct_id_director_fkey" FOREIGN KEY (id_director) REFERENCES public."Director"(id_director);


--
-- TOC entry 3268 (class 2606 OID 16433)
-- Name: Direct Direct_id_movie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Direct"
    ADD CONSTRAINT "Direct_id_movie_fkey" FOREIGN KEY (id_movie) REFERENCES public."Movie"(id_movie);


--
-- TOC entry 3271 (class 2606 OID 16467)
-- Name: Log Log_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Log"
    ADD CONSTRAINT "Log_id_user_fkey" FOREIGN KEY (id_user) REFERENCES public."User"(id_user);


--
-- TOC entry 3269 (class 2606 OID 16450)
-- Name: Prefer Prefer_id_movie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Prefer"
    ADD CONSTRAINT "Prefer_id_movie_fkey" FOREIGN KEY (id_movie) REFERENCES public."Movie"(id_movie);


--
-- TOC entry 3270 (class 2606 OID 16455)
-- Name: Prefer Prefer_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarah
--

ALTER TABLE ONLY public."Prefer"
    ADD CONSTRAINT "Prefer_id_user_fkey" FOREIGN KEY (id_user) REFERENCES public."User"(id_user);


CREATE ROLE "Client" WITH PASSWORD 'clientPassword';

--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE "Act"; Type: ACL; Schema: public; Owner: sarah
--

GRANT SELECT ON TABLE public."Act" TO "Client";


--
-- TOC entry 3441 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE "Actor"; Type: ACL; Schema: public; Owner: sarah
--

GRANT SELECT ON TABLE public."Actor" TO "Client";


--
-- TOC entry 3442 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE "Direct"; Type: ACL; Schema: public; Owner: sarah
--

GRANT SELECT ON TABLE public."Direct" TO "Client";


--
-- TOC entry 3443 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE "Director"; Type: ACL; Schema: public; Owner: sarah
--

GRANT SELECT ON TABLE public."Director" TO "Client";


--
-- TOC entry 3444 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE "Log"; Type: ACL; Schema: public; Owner: sarah
--

GRANT SELECT ON TABLE public."Log" TO "Client";


--
-- TOC entry 3445 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE "Movie"; Type: ACL; Schema: public; Owner: sarah
--

GRANT SELECT ON TABLE public."Movie" TO "Client";


--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE "Prefer"; Type: ACL; Schema: public; Owner: sarah
--

GRANT SELECT ON TABLE public."Prefer" TO "Client";


--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE "User"; Type: ACL; Schema: public; Owner: sarah
--

GRANT SELECT ON TABLE public."User" TO "Client";


-- Completed on 2023-12-20 15:27:42

--
-- PostgreSQL database dump complete
--

