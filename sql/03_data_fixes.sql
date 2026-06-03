-- ==========================================================
-- SECTION : Fix for tables that failed business grain check
-- ==========================================================

-- Table: Observations table had 249 duplicate records
-- There was no difference in the rows suggesting data-source issue, 

alter table core.observations
rename to observations_original;

CREATE TABLE core.observations AS
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY patient_id, encounter_id, observation_code, observation_value, date_ts
               ORDER BY observation_sk
           ) AS rn
    FROM core.observations_original
)
SELECT *
FROM ranked
WHERE rn = 1;

-- Table: Medications table had 24 duplicate records with only difference in base cost and total_cost columns.
-- Since this difference was in pricing layer not in clinical layer, therefore I removed those records and create a new table

alter table core.medications
rename to medications_original;

CREATE TABLE core.medications AS
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY patient_id, encounter_id, medication_code, start_ts, stop_ts, dispenses
               ORDER BY total_cost DESC, base_cost DESC, medication_sk
           ) AS rn
    FROM core.medications_original
)
SELECT *
FROM ranked
WHERE rn = 1;


-- =======================================================
-- SECTION : Fix for tables that failed date sanity check
-- =======================================================

--- Medications and Claims transaction tables date anomalies were flagged and reviewed. Obvious reveresed intervals were corrected where appropriate.

---- Fix: medications_dedup -------

UPDATE core.medications 
SET
    start_ts = stop_ts,
    stop_ts   = start_ts
WHERE stop_ts < start_ts;

--- Fix : claims_transactions ---

alter table core.claims_transactions
rename to claims_transactions_original;

UPDATE core.claims_transactions_original 
SET
    from_date_ts = to_date_ts,
    to_date_ts   = from_date_ts
WHERE to_date_ts < from_date_ts
and to_date_ts <> '1969-12-31 18:00:00.000 -0600';

CREATE TABLE core.claims_transactions AS
SELECT *
FROM core.claims_transactions_original
where to_date_ts != '1969-12-31 18:00:00.000 -0600'
  AND to_date_ts >= from_date_ts;
