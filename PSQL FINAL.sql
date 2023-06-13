--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23
-- Dumped by pg_dump version 10.23

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
-- Name: bus_reservation; Type: SCHEMA; Schema: -; Owner: super_admin
--

CREATE SCHEMA bus_reservation;


ALTER SCHEMA bus_reservation OWNER TO super_admin;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: cancel_ticket(); Type: FUNCTION; Schema: bus_reservation; Owner: super_admin
--

CREATE FUNCTION bus_reservation.cancel_ticket() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO ticket (reservation_id, ticket_status)
    VALUES (OLD.reservation_id, 'cancelled');
    RETURN OLD;
END;
$$;


ALTER FUNCTION bus_reservation.cancel_ticket() OWNER TO super_admin;

--
-- Name: countactivetickets(); Type: FUNCTION; Schema: bus_reservation; Owner: postgres
--

CREATE FUNCTION bus_reservation.countactivetickets() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
    count INT;
BEGIN
    SELECT COUNT(*) INTO count 
    FROM ticket
    WHERE ticket_status = 'Active';
    
    RETURN count;
END;
$$;


ALTER FUNCTION bus_reservation.countactivetickets() OWNER TO postgres;

--
-- Name: countavailablebuses(); Type: FUNCTION; Schema: bus_reservation; Owner: postgres
--

CREATE FUNCTION bus_reservation.countavailablebuses() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
    count INT;
BEGIN
    SELECT COUNT(*) INTO count 
    FROM bus
    WHERE status = 'Available';
    
    RETURN count;
END;
$$;


ALTER FUNCTION bus_reservation.countavailablebuses() OWNER TO super_admin;

--
-- Name: countcancelledtickets(); Type: FUNCTION; Schema: bus_reservation; Owner: postgres
--

CREATE FUNCTION bus_reservation.countcancelledtickets() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
    count INT;
BEGIN
    SELECT COUNT(*) INTO count 
    FROM ticket
    WHERE ticket_status = 'cancelled';
    
    RETURN count;
END;
$$;


ALTER FUNCTION bus_reservation.countcancelledtickets() OWNER TO super_admin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bus; Type: TABLE; Schema: bus_reservation; Owner: bus_manager
--

CREATE TABLE bus_reservation.bus (
    plate_number character varying(100) NOT NULL,
    bus_name character varying(100) NOT NULL,
    capacity character varying(100) NOT NULL,
    model character varying(100) NOT NULL,
    manufacturer character varying(100) NOT NULL,
    color character varying(100) NOT NULL,
    fueltype character varying(100) NOT NULL,
    status character varying(100) NOT NULL,
    driver_id integer NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE bus_reservation.bus OWNER TO bus_manager;

--
-- Name: driver_driver_id_seq; Type: SEQUENCE; Schema: bus_reservation; Owner: super_admin
--

CREATE SEQUENCE bus_reservation.driver_driver_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bus_reservation.driver_driver_id_seq OWNER TO super_admin;

--
-- Name: driver; Type: TABLE; Schema: bus_reservation; Owner: bus_driver
--

CREATE TABLE bus_reservation.driver (
    driver_id integer DEFAULT nextval('bus_reservation.driver_driver_id_seq'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    license_number character varying(100) NOT NULL,
    contact_number character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    address character varying(100) NOT NULL,
    experience character varying(100) NOT NULL,
    availability character varying(100) NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE bus_reservation.driver OWNER TO bus_driver;

--
-- Name: passenger_passenger_id_seq; Type: SEQUENCE; Schema: bus_reservation; Owner: super_admin
--

CREATE SEQUENCE bus_reservation.passenger_passenger_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bus_reservation.passenger_passenger_id_seq OWNER TO super_admin;

--
-- Name: passenger; Type: TABLE; Schema: bus_reservation; Owner: super_admin
--

CREATE TABLE bus_reservation.passenger (
    passenger_id integer DEFAULT nextval('bus_reservation.passenger_passenger_id_seq'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    age integer NOT NULL,
    gender character varying(100) NOT NULL,
    contact integer NOT NULL,
    email character varying(100) NOT NULL,
    address character varying(100) NOT NULL,
    nationality character varying(100) NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE bus_reservation.passenger OWNER TO super_admin;

--
-- Name: reservation_reservation_id_seq; Type: SEQUENCE; Schema: bus_reservation; Owner: super_admin
--

CREATE SEQUENCE bus_reservation.reservation_reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bus_reservation.reservation_reservation_id_seq OWNER TO super_admin;

--
-- Name: reservation; Type: TABLE; Schema: bus_reservation; Owner: super_admin
--

CREATE TABLE bus_reservation.reservation (
    reservation_id integer DEFAULT nextval('bus_reservation.reservation_reservation_id_seq'::regclass) NOT NULL,
    passenger_id integer NOT NULL,
    schedule_id integer NOT NULL,
    seat_number integer NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE bus_reservation.reservation OWNER TO super_admin;

--
-- Name: routes_route_id_seq; Type: SEQUENCE; Schema: bus_reservation; Owner: super_admin
--

CREATE SEQUENCE bus_reservation.routes_route_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bus_reservation.routes_route_id_seq OWNER TO super_admin;

--
-- Name: routes; Type: TABLE; Schema: bus_reservation; Owner: route_manager
--

CREATE TABLE bus_reservation.routes (
    route_id integer DEFAULT nextval('bus_reservation.routes_route_id_seq'::regclass) NOT NULL,
    source character varying(100) NOT NULL,
    destination character varying(100) NOT NULL,
    distance character varying(100) NOT NULL,
    duration character varying(100) NOT NULL,
    fare integer NOT NULL,
    stops character varying(100) NOT NULL,
    departure time without time zone NOT NULL,
    arrival_time time without time zone NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE bus_reservation.routes OWNER TO route_manager;

--
-- Name: schedule_schedule_id_seq; Type: SEQUENCE; Schema: bus_reservation; Owner: super_admin
--

CREATE SEQUENCE bus_reservation.schedule_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bus_reservation.schedule_schedule_id_seq OWNER TO super_admin;

--
-- Name: schedule; Type: TABLE; Schema: bus_reservation; Owner: scheduler
--

CREATE TABLE bus_reservation.schedule (
    schedule_id integer DEFAULT nextval('bus_reservation.schedule_schedule_id_seq'::regclass) NOT NULL,
    plate_number character varying(100) NOT NULL,
    route_id integer NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE bus_reservation.schedule OWNER TO scheduler;

--
-- Name: reservation_details_view; Type: VIEW; Schema: bus_reservation; Owner: super_admin
--

CREATE VIEW bus_reservation.reservation_details_view AS
 SELECT p.name,
    p.contact,
    r.source,
    r.destination,
    r.departure,
    r.arrival_time,
    res.seat_number,
    res.created
   FROM (((bus_reservation.reservation res
     JOIN bus_reservation.passenger p ON ((res.passenger_id = p.passenger_id)))
     JOIN bus_reservation.schedule s ON ((res.schedule_id = s.schedule_id)))
     JOIN bus_reservation.routes r ON ((s.route_id = r.route_id)));


ALTER TABLE bus_reservation.reservation_details_view OWNER TO super_admin;

--
-- Name: schedule_view; Type: VIEW; Schema: bus_reservation; Owner: super_admin
--

CREATE VIEW bus_reservation.schedule_view AS
 SELECT s.plate_number,
    r.departure,
    r.arrival_time,
    r.source,
    r.destination
   FROM ((bus_reservation.schedule s
     JOIN bus_reservation.bus b ON (((s.plate_number)::text = (b.plate_number)::text)))
     JOIN bus_reservation.routes r ON ((s.route_id = r.route_id)));


ALTER TABLE bus_reservation.schedule_view OWNER TO super_admin;

--
-- Name: ticket; Type: TABLE; Schema: bus_reservation; Owner: super_admin
--

CREATE TABLE bus_reservation.ticket (
    ticket_number integer NOT NULL,
    reservation_id integer NOT NULL,
    ticket_status character varying(100) NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE bus_reservation.ticket OWNER TO super_admin;

--
-- Name: ticket_view; Type: VIEW; Schema: bus_reservation; Owner: super_admin
--

CREATE VIEW bus_reservation.ticket_view AS
 SELECT p.name AS passenger_name,
    b.bus_name,
    r.source,
    r.destination,
    r.departure,
    r.arrival_time,
    r.fare,
    t.ticket_status AS status
   FROM (((((bus_reservation.ticket t
     JOIN bus_reservation.reservation res ON ((t.reservation_id = res.reservation_id)))
     JOIN bus_reservation.passenger p ON ((res.passenger_id = p.passenger_id)))
     JOIN bus_reservation.schedule s ON ((res.schedule_id = s.schedule_id)))
     JOIN bus_reservation.bus b ON (((s.plate_number)::text = (b.plate_number)::text)))
     JOIN bus_reservation.routes r ON ((s.route_id = r.route_id)));


ALTER TABLE bus_reservation.ticket_view OWNER TO super_admin;

--
-- Data for Name: bus; Type: TABLE DATA; Schema: bus_reservation; Owner: bus_manager
--

COPY bus_reservation.bus (plate_number, bus_name, capacity, model, manufacturer, color, fueltype, status, driver_id, created) FROM stdin;
XXXX-12345	Metro Shuttle A	80	Old	Ford INC.	Red	Diesel	Available	1	2023-06-11 11:19:43.677679
XXXX-12346	Maharlika	98	New	Mitsubishi INC.	Pink	Diesel	NA	2	2023-06-11 11:19:43.677679
XXXX-12347	Nissan	48	New	Mitsubishi INC.	Brown	Diesel	Available	3	2023-06-11 11:19:43.677679
\.


--
-- Data for Name: driver; Type: TABLE DATA; Schema: bus_reservation; Owner: bus_driver
--

COPY bus_reservation.driver (driver_id, name, license_number, contact_number, email, address, experience, availability, created) FROM stdin;
1	John Doe	AAAA-11111	1234567890	johndoe@example.com	123 Main St	5 years	Available	2023-06-11 11:11:15.186799
2	Ford Ulbata Jr.	AAAA-12345	0936415272	ulbata@gmail.com	Fatima General Santos City	2 years	Available	2023-06-11 11:11:15.186799
3	Richard Bangoy	AAAA-12346	09664267189	bangoy@gmail.com	Lagao General Santos City	10 years	Available	2023-06-11 11:11:15.186799
4	John Doe	AAAA-11111	1234567890	johndoe@example.com	123 Main St	5 years	Available	2023-06-11 11:11:15.186799
5	Jane Smith	BBBB-22222	0987654321	janesmith@example.com	456 Elm St	3 years	Not Available	2023-06-11 11:11:15.186799
6	David Johnson	CCCC-33333	9876543210	davidjohnson@example.com	789 Oak Ave	7 years	Available	2023-06-11 11:11:15.186799
7	Emily Davis	DDDD-44444	0123456789	emilydavis@example.com	321 Maple Rd	2 years	Not Available	2023-06-11 11:11:15.186799
8	Michael Wilson	EEEE-55555	6789012345	michaelwilson@example.com	654 Pine Ln	6 years	Available	2023-06-11 11:11:15.186799
9	Sarah Anderson	FFFF-66666	5432167890	sarahanderson@example.com	987 Cedar St	4 years	Not Available	2023-06-11 11:11:15.186799
10	Matthew Thomas	GGGG-77777	8901234567	matthewthomas@example.com	876 Birch Ave	8 years	Available	2023-06-11 11:11:15.186799
\.


--
-- Data for Name: passenger; Type: TABLE DATA; Schema: bus_reservation; Owner: super_admin
--

COPY bus_reservation.passenger (passenger_id, name, age, gender, contact, email, address, nationality, created) FROM stdin;
1	Jessie Conn Ralph M. Sam	21	Male	981821721	sam@gmail.com	Fatima General Santos City	Filipino	2023-06-11 11:26:06.794942
2	Matthew Fang Bilaos	20	Male	981821729	bilaos@gmail.com	Zone 4 Block 6 General Santos City	Filipino	2023-06-11 11:26:06.794942
3	Mateo Cortez	24	Male	981672162	cortez@gmail.com	Fatima General Santos City	Filipino	2023-06-11 11:26:06.794942
4	Richard Joshua Bangoy Jr.	24	Male	981672162	bangoy@gmail.com	Fatima General Santos City	Filipino	2023-06-11 11:26:06.794942
5	Dave Panizal	24	Male	981672162	panizal@gmail.com	Fatima General Santos City	Filipino	2023-06-11 11:26:06.794942
6	John Doe	30	Male	123456789	john@example.com	123 Main St	USA	2023-06-13 03:13:05.708927
\.


--
-- Data for Name: reservation; Type: TABLE DATA; Schema: bus_reservation; Owner: super_admin
--

COPY bus_reservation.reservation (reservation_id, passenger_id, schedule_id, seat_number, created) FROM stdin;
1	1	1	34	2023-06-11 11:58:00.176348
2	2	2	76	2023-06-11 11:58:00.176348
3	3	3	45	2023-06-11 11:58:00.176348
4	4	1	23	2023-06-11 11:58:00.176348
5	5	1	12	2023-06-11 11:58:00.176348
6	1	3	8	2023-06-11 15:55:14.671315
7	1	3	8	2023-06-11 15:58:28.983866
8	1	3	8	2023-06-11 16:34:23.795239
9	1	3	8	2023-06-11 16:46:11.67831
10	1	3	8	2023-06-11 16:50:32.109519
11	1	3	8	2023-06-11 16:54:09.067018
12	1	1	45	2023-06-12 07:07:51.369431
\.


--
-- Data for Name: routes; Type: TABLE DATA; Schema: bus_reservation; Owner: route_manager
--

COPY bus_reservation.routes (route_id, source, destination, distance, duration, fare, stops, departure, arrival_time, created) FROM stdin;
1	Gensan	Davao City	2 km	20 Minutes	200	Davao City Terminal	04:30:00	04:50:00	2023-06-11 11:35:34.633901
2	Polomolok	Davao City	30 km	1 Hour	500	Davao City Terminal	11:00:00	12:00:00	2023-06-11 11:35:34.633901
4	Tupi	Davao City	200 km	3 Hours	350	Davao City Terminal	07:30:00	09:50:00	2023-06-11 11:48:45.34577
\.


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: bus_reservation; Owner: scheduler
--

COPY bus_reservation.schedule (schedule_id, plate_number, route_id, created) FROM stdin;
1	XXXX-12345	1	2023-06-11 11:51:56.964765
2	XXXX-12346	2	2023-06-11 11:51:56.964765
3	XXXX-12347	4	2023-06-11 11:51:56.964765
\.


--
-- Data for Name: ticket; Type: TABLE DATA; Schema: bus_reservation; Owner: super_admin
--

COPY bus_reservation.ticket (ticket_number, reservation_id, ticket_status, created) FROM stdin;
\.


--
-- Name: driver_driver_id_seq; Type: SEQUENCE SET; Schema: bus_reservation; Owner: super_admin
--

SELECT pg_catalog.setval('bus_reservation.driver_driver_id_seq', 11, true);


--
-- Name: passenger_passenger_id_seq; Type: SEQUENCE SET; Schema: bus_reservation; Owner: super_admin
--

SELECT pg_catalog.setval('bus_reservation.passenger_passenger_id_seq', 6, true);


--
-- Name: reservation_reservation_id_seq; Type: SEQUENCE SET; Schema: bus_reservation; Owner: super_admin
--

SELECT pg_catalog.setval('bus_reservation.reservation_reservation_id_seq', 12, true);


--
-- Name: routes_route_id_seq; Type: SEQUENCE SET; Schema: bus_reservation; Owner: super_admin
--

SELECT pg_catalog.setval('bus_reservation.routes_route_id_seq', 4, true);


--
-- Name: schedule_schedule_id_seq; Type: SEQUENCE SET; Schema: bus_reservation; Owner: super_admin
--

SELECT pg_catalog.setval('bus_reservation.schedule_schedule_id_seq', 4, true);


--
-- Name: bus bus_pkey; Type: CONSTRAINT; Schema: bus_reservation; Owner: bus_manager
--

ALTER TABLE ONLY bus_reservation.bus
    ADD CONSTRAINT bus_pkey PRIMARY KEY (plate_number);


--
-- Name: driver driver_pkey; Type: CONSTRAINT; Schema: bus_reservation; Owner: bus_driver
--

ALTER TABLE ONLY bus_reservation.driver
    ADD CONSTRAINT driver_pkey PRIMARY KEY (driver_id);


--
-- Name: passenger passenger_pkey; Type: CONSTRAINT; Schema: bus_reservation; Owner: super_admin
--

ALTER TABLE ONLY bus_reservation.passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (passenger_id);


--
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: bus_reservation; Owner: super_admin
--

ALTER TABLE ONLY bus_reservation.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: bus_reservation; Owner: route_manager
--

ALTER TABLE ONLY bus_reservation.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (route_id);


--
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: bus_reservation; Owner: scheduler
--

ALTER TABLE ONLY bus_reservation.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (schedule_id);


--
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: bus_reservation; Owner: super_admin
--

ALTER TABLE ONLY bus_reservation.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (ticket_number);


--
-- Name: bus_driver_id_index; Type: INDEX; Schema: bus_reservation; Owner: bus_manager
--

CREATE INDEX bus_driver_id_index ON bus_reservation.bus USING btree (driver_id);


--
-- Name: index_bus_plate_number; Type: INDEX; Schema: bus_reservation; Owner: bus_manager
--

CREATE INDEX index_bus_plate_number ON bus_reservation.bus USING btree (plate_number);


--
-- Name: index_passenger_passenger_id; Type: INDEX; Schema: bus_reservation; Owner: super_admin
--

CREATE INDEX index_passenger_passenger_id ON bus_reservation.passenger USING btree (passenger_id);


--
-- Name: index_routes_route_id; Type: INDEX; Schema: bus_reservation; Owner: route_manager
--

CREATE INDEX index_routes_route_id ON bus_reservation.routes USING btree (route_id);


--
-- Name: index_schedule_schedule_id; Type: INDEX; Schema: bus_reservation; Owner: scheduler
--

CREATE INDEX index_schedule_schedule_id ON bus_reservation.schedule USING btree (schedule_id);


--
-- Name: index_ticket_reservation_id; Type: INDEX; Schema: bus_reservation; Owner: super_admin
--

CREATE INDEX index_ticket_reservation_id ON bus_reservation.ticket USING btree (reservation_id);


--
-- Name: bus fk_bus_driver; Type: FK CONSTRAINT; Schema: bus_reservation; Owner: bus_manager
--

ALTER TABLE ONLY bus_reservation.bus
    ADD CONSTRAINT fk_bus_driver FOREIGN KEY (driver_id) REFERENCES bus_reservation.driver(driver_id);


--
-- Name: reservation fk_reservation_passenger; Type: FK CONSTRAINT; Schema: bus_reservation; Owner: super_admin
--

ALTER TABLE ONLY bus_reservation.reservation
    ADD CONSTRAINT fk_reservation_passenger FOREIGN KEY (passenger_id) REFERENCES bus_reservation.passenger(passenger_id);


--
-- Name: reservation fk_reservation_schedule; Type: FK CONSTRAINT; Schema: bus_reservation; Owner: super_admin
--

ALTER TABLE ONLY bus_reservation.reservation
    ADD CONSTRAINT fk_reservation_schedule FOREIGN KEY (schedule_id) REFERENCES bus_reservation.schedule(schedule_id);


--
-- Name: schedule fk_schedule_bus; Type: FK CONSTRAINT; Schema: bus_reservation; Owner: scheduler
--

ALTER TABLE ONLY bus_reservation.schedule
    ADD CONSTRAINT fk_schedule_bus FOREIGN KEY (plate_number) REFERENCES bus_reservation.bus(plate_number);


--
-- Name: schedule fk_schedule_routes; Type: FK CONSTRAINT; Schema: bus_reservation; Owner: scheduler
--

ALTER TABLE ONLY bus_reservation.schedule
    ADD CONSTRAINT fk_schedule_routes FOREIGN KEY (route_id) REFERENCES bus_reservation.routes(route_id);


--
-- Name: ticket fk_ticket_reservation; Type: FK CONSTRAINT; Schema: bus_reservation; Owner: super_admin
--

ALTER TABLE ONLY bus_reservation.ticket
    ADD CONSTRAINT fk_ticket_reservation FOREIGN KEY (reservation_id) REFERENCES bus_reservation.reservation(reservation_id);


--
-- Name: bus drop_table_policy; Type: POLICY; Schema: bus_reservation; Owner: bus_manager
--

CREATE POLICY drop_table_policy ON bus_reservation.bus TO super_admin USING (true);


--
-- Name: driver drop_table_policy; Type: POLICY; Schema: bus_reservation; Owner: bus_driver
--

CREATE POLICY drop_table_policy ON bus_reservation.driver TO super_admin USING (true);


--
-- Name: passenger drop_table_policy; Type: POLICY; Schema: bus_reservation; Owner: super_admin
--

CREATE POLICY drop_table_policy ON bus_reservation.passenger TO super_admin USING (true);


--
-- Name: reservation drop_table_policy; Type: POLICY; Schema: bus_reservation; Owner: super_admin
--

CREATE POLICY drop_table_policy ON bus_reservation.reservation TO super_admin USING (true);


--
-- Name: routes drop_table_policy; Type: POLICY; Schema: bus_reservation; Owner: route_manager
--

CREATE POLICY drop_table_policy ON bus_reservation.routes TO super_admin USING (true);


--
-- Name: schedule drop_table_policy; Type: POLICY; Schema: bus_reservation; Owner: scheduler
--

CREATE POLICY drop_table_policy ON bus_reservation.schedule TO super_admin USING (true);


--
-- Name: ticket drop_table_policy; Type: POLICY; Schema: bus_reservation; Owner: super_admin
--

CREATE POLICY drop_table_policy ON bus_reservation.ticket TO super_admin USING (true);


--
-- Name: SCHEMA bus_reservation; Type: ACL; Schema: -; Owner: super_admin
--

GRANT USAGE ON SCHEMA bus_reservation TO customer_support;
GRANT USAGE ON SCHEMA bus_reservation TO booking_agent;
GRANT USAGE ON SCHEMA bus_reservation TO passenger;
GRANT USAGE ON SCHEMA bus_reservation TO bus_driver;
GRANT USAGE ON SCHEMA bus_reservation TO bus_manager;
GRANT USAGE ON SCHEMA bus_reservation TO route_manager;
GRANT USAGE ON SCHEMA bus_reservation TO scheduler;
GRANT USAGE ON SCHEMA bus_reservation TO ticketing_manager;


--
-- Name: SEQUENCE driver_driver_id_seq; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT USAGE ON SEQUENCE bus_reservation.driver_driver_id_seq TO bus_driver;


--
-- Name: SEQUENCE passenger_passenger_id_seq; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT USAGE ON SEQUENCE bus_reservation.passenger_passenger_id_seq TO passenger;
GRANT USAGE ON SEQUENCE bus_reservation.passenger_passenger_id_seq TO customer_support;


--
-- Name: TABLE passenger; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE bus_reservation.passenger TO passenger;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE bus_reservation.passenger TO customer_support;


--
-- Name: COLUMN passenger.passenger_id; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT SELECT(passenger_id) ON TABLE bus_reservation.passenger TO booking_agent;


--
-- Name: COLUMN passenger.name; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT SELECT(name) ON TABLE bus_reservation.passenger TO booking_agent;


--
-- Name: SEQUENCE reservation_reservation_id_seq; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT ALL ON SEQUENCE bus_reservation.reservation_reservation_id_seq TO passenger;
GRANT USAGE ON SEQUENCE bus_reservation.reservation_reservation_id_seq TO booking_agent;


--
-- Name: TABLE reservation; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE bus_reservation.reservation TO booking_agent;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE bus_reservation.reservation TO passenger;


--
-- Name: SEQUENCE routes_route_id_seq; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT USAGE ON SEQUENCE bus_reservation.routes_route_id_seq TO route_manager;


--
-- Name: SEQUENCE schedule_schedule_id_seq; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT USAGE ON SEQUENCE bus_reservation.schedule_schedule_id_seq TO scheduler;


--
-- Name: TABLE ticket; Type: ACL; Schema: bus_reservation; Owner: super_admin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE bus_reservation.ticket TO ticketing_manager;


--
-- PostgreSQL database dump complete
--

