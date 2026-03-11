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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: cancer_type_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cancer_type_codes (
    id bigint NOT NULL,
    cancer_type_id bigint NOT NULL,
    code_system_id character varying(20) NOT NULL,
    code character varying(50) NOT NULL,
    display character varying(200),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: cancer_type_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cancer_type_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cancer_type_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cancer_type_codes_id_seq OWNED BY public.cancer_type_codes.id;


--
-- Name: cancer_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cancer_types (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: cancer_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cancer_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cancer_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cancer_types_id_seq OWNED BY public.cancer_types.id;


--
-- Name: code_systems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.code_systems (
    id character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    uri character varying(255) NOT NULL,
    version character varying(20),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: drug_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_codes (
    id bigint NOT NULL,
    drug_id bigint NOT NULL,
    code_system_id character varying(20) NOT NULL,
    code character varying(50) NOT NULL,
    display character varying(200),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: drug_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drug_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drug_codes_id_seq OWNED BY public.drug_codes.id;


--
-- Name: drugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drugs (
    id bigint NOT NULL,
    generic_name character varying(200) NOT NULL,
    brand_name character varying(200),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    abbreviation character varying(20)
);


--
-- Name: drugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drugs_id_seq OWNED BY public.drugs.id;


--
-- Name: reference_editions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reference_editions (
    id bigint NOT NULL,
    reference_source_id bigint NOT NULL,
    edition_number character varying(20) NOT NULL,
    publication_date date,
    effective_date date,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: reference_editions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reference_editions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_editions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reference_editions_id_seq OWNED BY public.reference_editions.id;


--
-- Name: reference_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reference_sources (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    source_type character varying(20) NOT NULL,
    publisher character varying(100),
    isbn character varying(20),
    url character varying(255),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: reference_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reference_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reference_sources_id_seq OWNED BY public.reference_sources.id;


--
-- Name: regimen_drug_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regimen_drug_schedules (
    id bigint NOT NULL,
    regimen_drug_id bigint NOT NULL,
    start_day integer NOT NULL,
    end_day integer NOT NULL,
    interval_days integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: regimen_drug_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regimen_drug_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regimen_drug_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regimen_drug_schedules_id_seq OWNED BY public.regimen_drug_schedules.id;


--
-- Name: regimen_drugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regimen_drugs (
    id bigint NOT NULL,
    regimen_id bigint NOT NULL,
    drug_id bigint NOT NULL,
    route character varying(10) NOT NULL,
    duration_min integer,
    duration_max integer,
    sequence_number integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: regimen_drugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regimen_drugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regimen_drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regimen_drugs_id_seq OWNED BY public.regimen_drugs.id;


--
-- Name: regimen_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regimen_templates (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: regimen_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regimen_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regimen_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regimen_templates_id_seq OWNED BY public.regimen_templates.id;


--
-- Name: regimens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regimens (
    id bigint NOT NULL,
    regimen_template_id bigint NOT NULL,
    cancer_type_id bigint NOT NULL,
    reference_edition_id bigint NOT NULL,
    line_of_therapy character varying(20),
    cycle_days integer,
    total_cycles integer,
    evidence_level character varying(10),
    page_reference character varying(50),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: regimens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regimens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regimens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regimens_id_seq OWNED BY public.regimens.id;


--
-- Name: schedule_timings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule_timings (
    id bigint NOT NULL,
    regimen_drug_schedule_id bigint NOT NULL,
    timing_code_id bigint,
    dose_per_time numeric(10,2) NOT NULL,
    dose_unit character varying(20) NOT NULL,
    sequence integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schedule_timings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedule_timings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_timings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedule_timings_id_seq OWNED BY public.schedule_timings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: timing_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timing_codes (
    id bigint NOT NULL,
    code character varying(20) NOT NULL,
    display character varying(50) NOT NULL,
    fhir_when_code character varying(20),
    sort_order integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: timing_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timing_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timing_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.timing_codes_id_seq OWNED BY public.timing_codes.id;


--
-- Name: cancer_type_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cancer_type_codes ALTER COLUMN id SET DEFAULT nextval('public.cancer_type_codes_id_seq'::regclass);


--
-- Name: cancer_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cancer_types ALTER COLUMN id SET DEFAULT nextval('public.cancer_types_id_seq'::regclass);


--
-- Name: drug_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_codes ALTER COLUMN id SET DEFAULT nextval('public.drug_codes_id_seq'::regclass);


--
-- Name: drugs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drugs ALTER COLUMN id SET DEFAULT nextval('public.drugs_id_seq'::regclass);


--
-- Name: reference_editions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_editions ALTER COLUMN id SET DEFAULT nextval('public.reference_editions_id_seq'::regclass);


--
-- Name: reference_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_sources ALTER COLUMN id SET DEFAULT nextval('public.reference_sources_id_seq'::regclass);


--
-- Name: regimen_drug_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimen_drug_schedules ALTER COLUMN id SET DEFAULT nextval('public.regimen_drug_schedules_id_seq'::regclass);


--
-- Name: regimen_drugs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimen_drugs ALTER COLUMN id SET DEFAULT nextval('public.regimen_drugs_id_seq'::regclass);


--
-- Name: regimen_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimen_templates ALTER COLUMN id SET DEFAULT nextval('public.regimen_templates_id_seq'::regclass);


--
-- Name: regimens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimens ALTER COLUMN id SET DEFAULT nextval('public.regimens_id_seq'::regclass);


--
-- Name: schedule_timings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_timings ALTER COLUMN id SET DEFAULT nextval('public.schedule_timings_id_seq'::regclass);


--
-- Name: timing_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timing_codes ALTER COLUMN id SET DEFAULT nextval('public.timing_codes_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: cancer_type_codes cancer_type_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cancer_type_codes
    ADD CONSTRAINT cancer_type_codes_pkey PRIMARY KEY (id);


--
-- Name: cancer_types cancer_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cancer_types
    ADD CONSTRAINT cancer_types_pkey PRIMARY KEY (id);


--
-- Name: code_systems code_systems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_systems
    ADD CONSTRAINT code_systems_pkey PRIMARY KEY (id);


--
-- Name: drug_codes drug_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_codes
    ADD CONSTRAINT drug_codes_pkey PRIMARY KEY (id);


--
-- Name: drugs drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: reference_editions reference_editions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_editions
    ADD CONSTRAINT reference_editions_pkey PRIMARY KEY (id);


--
-- Name: reference_sources reference_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_sources
    ADD CONSTRAINT reference_sources_pkey PRIMARY KEY (id);


--
-- Name: regimen_drug_schedules regimen_drug_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimen_drug_schedules
    ADD CONSTRAINT regimen_drug_schedules_pkey PRIMARY KEY (id);


--
-- Name: regimen_drugs regimen_drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimen_drugs
    ADD CONSTRAINT regimen_drugs_pkey PRIMARY KEY (id);


--
-- Name: regimen_templates regimen_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimen_templates
    ADD CONSTRAINT regimen_templates_pkey PRIMARY KEY (id);


--
-- Name: regimens regimens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimens
    ADD CONSTRAINT regimens_pkey PRIMARY KEY (id);


--
-- Name: schedule_timings schedule_timings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_timings
    ADD CONSTRAINT schedule_timings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: timing_codes timing_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timing_codes
    ADD CONSTRAINT timing_codes_pkey PRIMARY KEY (id);


--
-- Name: idx_cancer_type_codes_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_cancer_type_codes_unique ON public.cancer_type_codes USING btree (cancer_type_id, code_system_id, code);


--
-- Name: idx_drug_codes_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_drug_codes_unique ON public.drug_codes USING btree (drug_id, code_system_id, code);


--
-- Name: idx_reference_editions_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_reference_editions_unique ON public.reference_editions USING btree (reference_source_id, edition_number);


--
-- Name: idx_regimens_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_regimens_unique ON public.regimens USING btree (regimen_template_id, cancer_type_id, reference_edition_id, line_of_therapy);


--
-- Name: idx_schedule_timings_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_schedule_timings_unique ON public.schedule_timings USING btree (regimen_drug_schedule_id, sequence);


--
-- Name: index_cancer_type_codes_on_cancer_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cancer_type_codes_on_cancer_type_id ON public.cancer_type_codes USING btree (cancer_type_id);


--
-- Name: index_cancer_type_codes_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cancer_type_codes_on_code ON public.cancer_type_codes USING btree (code);


--
-- Name: index_cancer_type_codes_on_code_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cancer_type_codes_on_code_system_id ON public.cancer_type_codes USING btree (code_system_id);


--
-- Name: index_cancer_types_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cancer_types_on_name ON public.cancer_types USING btree (name);


--
-- Name: index_code_systems_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_code_systems_on_uri ON public.code_systems USING btree (uri);


--
-- Name: index_drug_codes_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drug_codes_on_code ON public.drug_codes USING btree (code);


--
-- Name: index_drug_codes_on_code_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drug_codes_on_code_system_id ON public.drug_codes USING btree (code_system_id);


--
-- Name: index_drug_codes_on_drug_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drug_codes_on_drug_id ON public.drug_codes USING btree (drug_id);


--
-- Name: index_drugs_on_abbreviation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drugs_on_abbreviation ON public.drugs USING btree (abbreviation);


--
-- Name: index_drugs_on_generic_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drugs_on_generic_name ON public.drugs USING btree (generic_name);


--
-- Name: index_reference_editions_on_publication_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_editions_on_publication_date ON public.reference_editions USING btree (publication_date);


--
-- Name: index_reference_editions_on_reference_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_editions_on_reference_source_id ON public.reference_editions USING btree (reference_source_id);


--
-- Name: index_reference_sources_on_source_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_sources_on_source_type ON public.reference_sources USING btree (source_type);


--
-- Name: index_regimen_drug_schedules_on_regimen_drug_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regimen_drug_schedules_on_regimen_drug_id ON public.regimen_drug_schedules USING btree (regimen_drug_id);


--
-- Name: index_regimen_drugs_on_drug_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regimen_drugs_on_drug_id ON public.regimen_drugs USING btree (drug_id);


--
-- Name: index_regimen_drugs_on_regimen_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regimen_drugs_on_regimen_id ON public.regimen_drugs USING btree (regimen_id);


--
-- Name: index_regimen_drugs_on_regimen_id_and_sequence_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regimen_drugs_on_regimen_id_and_sequence_number ON public.regimen_drugs USING btree (regimen_id, sequence_number);


--
-- Name: index_regimen_templates_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regimen_templates_on_name ON public.regimen_templates USING btree (name);


--
-- Name: index_regimens_on_cancer_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regimens_on_cancer_type_id ON public.regimens USING btree (cancer_type_id);


--
-- Name: index_regimens_on_reference_edition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regimens_on_reference_edition_id ON public.regimens USING btree (reference_edition_id);


--
-- Name: index_regimens_on_regimen_template_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regimens_on_regimen_template_id ON public.regimens USING btree (regimen_template_id);


--
-- Name: index_schedule_timings_on_regimen_drug_schedule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedule_timings_on_regimen_drug_schedule_id ON public.schedule_timings USING btree (regimen_drug_schedule_id);


--
-- Name: index_schedule_timings_on_timing_code_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedule_timings_on_timing_code_id ON public.schedule_timings USING btree (timing_code_id);


--
-- Name: index_timing_codes_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_timing_codes_on_code ON public.timing_codes USING btree (code);


--
-- Name: index_timing_codes_on_sort_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_timing_codes_on_sort_order ON public.timing_codes USING btree (sort_order);


--
-- Name: regimen_drugs fk_rails_07340bb010; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimen_drugs
    ADD CONSTRAINT fk_rails_07340bb010 FOREIGN KEY (regimen_id) REFERENCES public.regimens(id);


--
-- Name: schedule_timings fk_rails_0a17c38d65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_timings
    ADD CONSTRAINT fk_rails_0a17c38d65 FOREIGN KEY (regimen_drug_schedule_id) REFERENCES public.regimen_drug_schedules(id);


--
-- Name: cancer_type_codes fk_rails_19604fc237; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cancer_type_codes
    ADD CONSTRAINT fk_rails_19604fc237 FOREIGN KEY (cancer_type_id) REFERENCES public.cancer_types(id);


--
-- Name: regimen_drug_schedules fk_rails_28fdab9571; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimen_drug_schedules
    ADD CONSTRAINT fk_rails_28fdab9571 FOREIGN KEY (regimen_drug_id) REFERENCES public.regimen_drugs(id);


--
-- Name: drug_codes fk_rails_44237a7fa2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_codes
    ADD CONSTRAINT fk_rails_44237a7fa2 FOREIGN KEY (drug_id) REFERENCES public.drugs(id);


--
-- Name: schedule_timings fk_rails_5a359a36a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_timings
    ADD CONSTRAINT fk_rails_5a359a36a3 FOREIGN KEY (timing_code_id) REFERENCES public.timing_codes(id);


--
-- Name: regimens fk_rails_79e3653a4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimens
    ADD CONSTRAINT fk_rails_79e3653a4d FOREIGN KEY (cancer_type_id) REFERENCES public.cancer_types(id);


--
-- Name: regimen_drugs fk_rails_81cce8d8b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimen_drugs
    ADD CONSTRAINT fk_rails_81cce8d8b6 FOREIGN KEY (drug_id) REFERENCES public.drugs(id);


--
-- Name: reference_editions fk_rails_8b36f27f8e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_editions
    ADD CONSTRAINT fk_rails_8b36f27f8e FOREIGN KEY (reference_source_id) REFERENCES public.reference_sources(id);


--
-- Name: cancer_type_codes fk_rails_99f7841e56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cancer_type_codes
    ADD CONSTRAINT fk_rails_99f7841e56 FOREIGN KEY (code_system_id) REFERENCES public.code_systems(id);


--
-- Name: drug_codes fk_rails_9f8bf09fbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_codes
    ADD CONSTRAINT fk_rails_9f8bf09fbd FOREIGN KEY (code_system_id) REFERENCES public.code_systems(id);


--
-- Name: regimens fk_rails_b22ccd520c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimens
    ADD CONSTRAINT fk_rails_b22ccd520c FOREIGN KEY (regimen_template_id) REFERENCES public.regimen_templates(id);


--
-- Name: regimens fk_rails_e01d8c3294; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regimens
    ADD CONSTRAINT fk_rails_e01d8c3294 FOREIGN KEY (reference_edition_id) REFERENCES public.reference_editions(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260122090318'),
('20250120000013'),
('20250120000012'),
('20250120000011'),
('20250120000010'),
('20250120000009'),
('20250120000008'),
('20250120000007'),
('20250120000006'),
('20250120000005'),
('20250120000004'),
('20250120000003'),
('20250120000002'),
('20250120000001');

