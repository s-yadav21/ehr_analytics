
-- =====================================================
-- SECTION 1: CREATE SCHEMA
-- =====================================================

-- Create following three schemas: 
-- RAW: direct CSV import, we preserve all the information stored in CSV
-- CORE: clean version of raw tables
-- ANALYTICS: for views and reusable query outputs

/* we will first create database */
CREATE DATABASE ehr_sandbox;

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS analytics;


-- =====================================================
-- SECTION 2: CREATE RAW Tables
-- =====================================================

-- Import all the columns AS text to preserve the information


--- Table: Patients ---

CREATE TABLE raw.patients (
    id text,
    birthdate text,
    deathdate text,
    ssn text,
    drivers text,
    passport text,
    prefix text,
    first text,
    last text,
    suffix text,
    maiden text,
    marital text,
    race text,
    ethnicity text,
    gender text,
    birthplace text,
    address text,
    city text,
    state text,
    county text,
    zip text,
    lat text,
    lon text,
    healthcare_expenses text,
    healthcare_coverage text
);


--- Table: Providers ---

CREATE TABLE raw.providers (
    id text,
    organization text,
    name text,
    gender text,
    speciality text,
    address text,
    city text,
    state text,
    zip text,
    lat text,
    lon text,
    utilization text
);


--- Table: Organizations ---

CREATE TABLE raw.organizations (
    id text,
    name text,
    address text,
    city text,
    state text,
    zip text,
    lat text,
    lon text,
    phone text,
    revenue text,
    utilization text
);


--- Table: Encounters ---

CREATE TABLE raw.encounters (
    id text,
    start text,
    stop text,
    patient text,
    organization text,
    provider text,
    payer text,
    encounterclass text,
    code text,
    description text,
    base_encounter_cost text,
    total_claim_cost text,
    payer_coverage text,
    reasoncode text,
    reasondescription text
);


--- Table: Conditions ---

CREATE TABLE raw.conditions (
    start text,
    stop text,
    patient text,
    encounter text,
    code text,
    description text
);


--- Table: Medications ---

CREATE TABLE raw.medications (
    start text,
    stop text,
    patient text,
    payer text,
    encounter text,
    code text,
    description text,
    base_cost text,
    payer_coverage text,
    dispenses text,
    totalcost text,
    reasoncode text,
    reasondescription text
);


--- Table: Observations ---

CREATE TABLE raw.observations (
    date text,
    patient text,
    encounter text,
    category text,
    code text,
    description text,
    value text,
    units text,
    type text
);


--- Table: Procedures ---

CREATE TABLE raw.procedures (
    start text,
    stop text,
    patient text,
    encounter text,
    code text,
    description text,
    base_cost text,
    reasoncode text,
    reasondescription text
);


--- Table: Immunizations ---

CREATE TABLE raw.immunizations (
    date text,
    patient text,
    encounter text,
    code text,
    description text,
    base_cost text
);


--- Table: Payers ---

CREATE TABLE raw.payers (
    id text,
    name text,
    address text,
    city text,
    state_headquartered text,
    zip text,
    phone text,
    amount_covered text,
    amount_uncovered text,
    revenue text,
    covered_encounters text,
    uncovered_encounters text,
    covered_medications text,
    uncovered_medications text,
    covered_procedures text,
    uncovered_procedures text,
    covered_immunizations text,
    uncovered_immunizations text,
    unique_customers text,
    qols_average text,
    member_months text
);


--- Table: Payers Transitions ---

CREATE TABLE raw.payer_transitions (
    patient text,
    memberid text,
    start_year text,
    end_year text,
    payer text,
    secondary_payer text,
    ownership text,
    ownername text
);


--- Table: Claims ---

CREATE TABLE raw.claims (
    id text,
    patientid text,
    providerid text,
    primarypatientinsuranceid text,
    secondarypatientinsuranceid text,
    departmentid text,
    patientdepartmentid text,
    diagnosis1 text,
    diagnosis2 text,
    diagnosis3 text,
    diagnosis4 text,
    diagnosis5 text,
    diagnosis6 text,
    diagnosis7 text,
    diagnosis8 text,
    referringproviderid text,
    appointmentid text,
    currentillnessdate text,
    servicedate text,
    supervisingproviderid text,
    status1 text,
    status2 text,
    statusp text,
    outstanding1 text,
    outstanding2 text,
    outstandingp text,
    lastbilleddate1 text,
    lastbilleddate2 text,
    lastbilleddatep text,
    healthcareclaimtypeid1 text,
    healthcareclaimtypeid2 text
);


--- Table: Claims Transactions ---

CREATE TABLE raw.claims_transactions (
	id text,
	claimid text,
	chargeid text,
	patientid text,
	type text,
	amount text,
	method text,
	fromdate text,
	todate text,
	placeofservice text,
	procedurecode text,
	modifier1 text,
	modifier2 text,
	diagnosisref1 text,
	diagnosisref2 text,
	diagnosisref3 text,
	diagnosisref4 text,
	units text,
	departmentid text,
	notes text,
	unitamount text,
	transferoutid text,
	transfertype text,
	payments text,
	adjustments text,
	transfers text,
	outstanding text,
	appointmentid text,
	linenote text,
	patientinsuranceid text,
	feescheduleid text,
	providerid text,
	supervisingproviderid text
);


-- =====================================================
-- SECTION 3: IMPORT Data in RAW Tables
-- =====================================================

COPY raw.patients
FROM '/data/patient_raw_data/patients.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.providers
FROM '/data/patient_raw_data/providers.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.organizations
FROM '/data/patient_raw_data/organizations.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.encounters
FROM '/data/patient_raw_data/encounters.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.conditions
FROM '/data/patient_raw_data/conditions.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.medications
FROM '/data/patient_raw_data/medications.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.observations
FROM '/data/patient_raw_data/observations.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.procedures
FROM '/data/patient_raw_data/procedures.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.immunizations
FROM '/data/patient_raw_data/immunizations.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.payers
FROM '/data/patient_raw_data/payers.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.payer_transitions
FROM '/data/patient_raw_data/payer_transitions.csv'
WITH (FORMAT csv, HEADER true);

COPY raw.claims
FROM '/data/patient_raw_data/claims.csv'
WITH (FORMAT csv, HEADER true);


COPY raw.claims_transactions
FROM '/data/patient_raw_data/claims_transactions.csv'
WITH (FORMAT csv, HEADER true);


-- =====================================================
-- SECTION 3: IMPORT Data in RAW Tables
-- =====================================================

-- Create clean version of raw tables
-- Change data type wherever required
-- Drop columns- personal identifiers- drivers license #, passport #, ssn etc.
-- Drop columns that are usually not used in data analysis
-- Drop columns where all the rows are null


--- Table: Patients ---
CREATE TABLE core.patients AS
SELECT
    id AS patient_id,
    NULLIF(birthdate, '')::date AS birth_date,
    NULLIF(deathdate, '')::date AS death_date,
    first AS first_name,
    last AS last_name,
    marital AS marital_status,
    race,
    ethnicity,
    gender,
    city,
    state,
    zip,
    NULLIF(lat, '')::numeric AS lat,
    NULLIF(lon, '')::numeric AS lon,
    NULLIF(healthcare_expenses, '')::numeric AS healthcare_expenses,
    NULLIF(healthcare_coverage, '')::numeric AS healthcare_coverage
FROM raw.patients;


--- Table: Provider ---
CREATE TABLE core.providers AS
SELECT
    id AS provider_id,
    organization AS organization_id,
    name,
    gender,
    speciality,
    city,
    state,
    zip,
    NULLIF(lat, '')::numeric AS lat,
    NULLIF(lon, '')::numeric AS lon,
    NULLIF(utilization, '')::integer AS utilization
FROM raw.providers;


--- Table: Organizations ---

CREATE TABLE core.organizations AS 
SELECT
	id AS organization_id,
    name,
    city,
    state,
    zip,
    NULLIF(lat, '')::numeric AS lat,
    NULLIF(lon, '')::numeric AS lon,
    NULLIF(revenue, '')::numeric AS revenue,
    NULLIF(utilization, '')::integer AS utilization
FROM raw.organizations;


--- Table: Encounters ---

CREATE TABLE core.encounters AS
SELECT
    id AS encounter_id,
    NULLIF(start, '')::TIMESTAMPTZ AS start_date,
    NULLIF(stop, '')::TIMESTAMPTZ AS stop_date,
    patient AS patient_id,
    organization AS organization_id,
    provider AS provider_id,
    payer AS payer_id,
    encounterclass AS encounter_class,
    code AS encounter_code,
    description AS encounter_description,
    NULLIF(base_encounter_cost, '')::numeric AS base_encounter_cost,
    NULLIF(total_claim_cost, '')::numeric AS total_claim_cost,
    NULLIF(payer_coverage, '')::numeric AS payer_coverage,
    reasoncode as reason_code,
    reasondescription AS reason_description
FROM raw.encounters;


--- Table: Conditions ---

CREATE TABLE core.conditions AS
SELECT
    NULLIF(start, '')::date AS start_date,
    NULLIF(stop, '')::date AS stop_date,
	id AS patient_id,
    encounter AS encounter_id,
    code AS condition_code,
    description AS condition_description
FROM raw.conditions;


--- Table: Medications ---

CREATE TABLE core.medications AS
SELECT
    NULLIF(start, '')::TIMESTAMPTZ AS start_ts,
    NULLIF(stop, '')::TIMESTAMPTZ AS stop_ts,
    patient AS patient_id,
    payer AS payer_id,
    encounter AS encounter_id,
    code AS medication_code,
    description AS medication_description,
    NULLIF(base_cost, '')::numeric AS base_cost,
    NULLIF(payer_coverage, '')::numeric AS payer_coverage,
    NULLIF(dispenses, '')::integer AS dispenses,
    NULLIF(totalcost, '')::numeric AS total_cost,
    reasoncode AS reason_code,
    reasondescription AS reason_description
FROM raw.medications;


--- Table: Observations ---
CREATE TABLE core.observations AS
SELECT
    NULLIF(date, '')::TIMESTAMPTZ AS date,
   	patient AS patient_id,
    encounter AS encounter_id,
    category AS category,
    code AS observation_code,
    description AS observation_description,
    value AS observation_value,
    units AS observation_unit,
    type AS observation_value_type
FROM raw.observations;


--- Table: Procedures ---

CREATE TABLE core.procedures AS
SELECT
    NULLIF(start, '')::TIMESTAMPTZ AS start_ts,
    NULLIF(stop, '')::TIMESTAMPTZ AS stop_ts,
    patient AS patient_id,
    encounter AS encounter_id,
    code AS procedure_code,
    description AS procedure_description,
    NULLIF(base_cost, '')::numeric AS base_cost,
    reasoncode AS reason_code,
    reasondescription AS reason_description
FROM raw.procedures;


--- Table: Immunizations ---

CREATE TABLE core.immunizations AS
SELECT
    NULLIF(date, '')::TIMESTAMPTZ AS date_ts,
    patient AS patient_id,
    encounter AS encounter_id,
    code AS immunization_code,
    description AS immunization_description,
    NULLIF(base_cost, '')::numeric AS base_cost
FROM raw.immunizations;


--- Table: Payers ---

CREATE TABLE core.payers AS
SELECT
    id as payer_id,
    name,
    city,
    state_headquartered,
    zip,
    phone,
    NULLIF(amount_covered, '')::numeric AS amount_covered,
    NULLIF(amount_uncovered, '')::numeric AS amount_uncovered,
    NULLIF(revenue, '')::numeric AS revenue,
    NULLIF(covered_encounters, '')::integer AS covered_encounters,
    NULLIF(uncovered_encounters, '')::integer AS uncovered_encounters,
    NULLIF(covered_medications, '')::integer AS covered_medications,
    NULLIF(uncovered_medications, '')::integer AS uncovered_medications,
    NULLIF(covered_procedures, '')::integer AS covered_procedures,
    NULLIF(uncovered_procedures, '')::integer AS uncovered_procedures,
    NULLIF(covered_immunizations, '')::integer AS covered_immunizations,
    NULLIF(uncovered_immunizations, '')::integer AS uncovered_immunizations,
    NULLIF(unique_customers, '')::integer AS unique_customers,
    NULLIF(qols_average, '')::numeric AS qols_average,
    NULLIF(member_months, '')::integer AS member_months
FROM raw.payers;


--- Table: Payer-Transitions ---

CREATE TABLE core.payer_transitions AS
SELECT
    patient AS patient_id,
    memberid AS member_id,
    NULLIF(start_year, '')::TIMESTAMPTZ AS start_ts,
    NULLIF(end_year, '')::TIMESTAMPTZ AS end_ts,
    payer AS payer,
    secondary_payer AS secondary_payer,
    ownership AS ownership,
    ownername AS ownername
FROM raw.payer_transitions;


--- Table: Claims ---

CREATE TABLE core.claims AS
SELECT
	id as claim_id,
    patientid as patient_id,
    providerid as provider_id,
    primarypatientinsuranceid as primary_patient_insurance_id,
    secondarypatientinsuranceid as secondary_patient_insurance_id,
    departmentid as department_id,
    patientdepartmentid as patient_department_id,
    diagnosis1,
    diagnosis2,
    diagnosis3,
    diagnosis4,
    diagnosis5,
 	diagnosis6,
    diagnosis7,
    diagnosis8,
    referringproviderid as referring_provider_id,
    appointmentid as appointment_id,
    NULLIF(currentillnessdate, '')::TIMESTAMPTZ AS current_illness_date_ts,
    NULLIF(servicedate, '')::TIMESTAMPTZ as service_date_ts,
    supervisingproviderid as supervising_provider_id,
    status1,
    status2,
    statusp,
    NULLIF(outstanding1, '')::numeric as outstanding1,
    NULLIF(outstanding2, '')::numeric as outstanding2,
    NULLIF(outstandingp, '')::numeric as outstandingp,
    NULLIF(lastbilleddate1, '')::TIMESTAMPTZ AS last_billing_date1_ts,
    NULLIF(lastbilleddate2, '')::TIMESTAMPTZ AS last_billing_date2_ts,
    NULLIF(lastbilleddatep, '')::TIMESTAMPTZ AS last_billing_datep_ts,
    healthcareclaimtypeid1 as  healthcare_claim_type_id1,
    healthcareclaimtypeid2 as healthcare_claim_type_id2
FROM raw.claims;


--- Table: Claims Transactions ---

CREATE TABLE core.claims_transactions AS
SELECT
	id as claim_transaction_id,
	claimid as claim_id,
	chargeid as charge_id,
	patientid as patient_id,
	type as claim_type,
	NULLIF(amount, '')::numeric as amount,
	method,
	NULLIF(fromdate, '')::TIMESTAMPTZ as from_date_ts,
	NULLIF(todate, '')::TIMESTAMPTZ as to_date_ts,
	placeofservice as place_of_service,
	procedurecode as procedure_code,
	modifier1,
	modifier2,
	diagnosisref1 as diagnosis_ref1,
	diagnosisref2 as diagnosis_ref2,
	diagnosisref3 as diagnosis_ref3,
	diagnosisref4 as diagnosis_ref4,
	NULLIF(units, '')::integer as units,
	departmentid as department_id,
	notes,
	NULLIF(unitamount, '')::numeric as unit_amount,
	transferoutid as transfer_out_id,
	transfertype as transfer_type,
	NULLIF(payments, '')::numeric as payments,
	adjustments,
	NULLIF(transfers, '')::numeric as transfers,
	NULLIF(outstanding, '')::numeric as outstanding,
	appointmentid as appointment_id,
	linenote,
	patientinsuranceid as patient_insurance_id,
	feescheduleid as fee_schedule_id,
	providerid as provider_id,
	supervisingproviderid as supervising_provider_id
FROM raw.claims_transactions;




