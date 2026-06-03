-- =====================================================
-- SECTION 1: Row Counts
-- =====================================================

SELECT 'patients' AS table_name, COUNT(*) FROM core.patients
UNION ALL
SELECT 'encounters', COUNT(*) FROM core.encounters
UNION ALL
SELECT 'conditions', COUNT(*) FROM core.conditions
UNION ALL
SELECT 'medications', COUNT(*) FROM core.medications
UNION ALL
SELECT 'observations', COUNT(*) FROM core.observations
UNION ALL
SELECT 'immunizations', COUNT(*) FROM core.immunizations
UNION ALL
SELECT 'procedures', COUNT(*) FROM core.procedures
UNION ALL
SELECT 'providers', COUNT(*) FROM core.providers
UNION ALL
SELECT 'organizations', COUNT(*) FROM core.organizations
UNION ALL
SELECT 'payers', COUNT(*) FROM core.payers
UNION ALL
SELECT 'payer_transitions', COUNT(*) FROM core.payer_transitions
UNION ALL
SELECT 'claims', COUNT(*) FROM core.claims
UNION ALL
SELECT 'claims_transactions', COUNT(*) FROM core.claims_transactions;


-- =====================================================
-- SECTION 2: Check for Duplicate PK
-- =====================================================

-- Perform this check before adding primary key constraint

SELECT patient_id , COUNT(*)
FROM core.patients
GROUP BY patient_id
HAVING COUNT(*) > 1;

SELECT encounter_id  , COUNT(*)
FROM core.encounters
GROUP BY encounter_id
HAVING COUNT(*) > 1;

SELECT provider_id, COUNT(*)
FROM core.providers
GROUP BY provider_id
HAVING COUNT(*) > 1;

SELECT organization_id, COUNT(*)
FROM core.organizations
GROUP BY organization_id
HAVING COUNT(*) > 1;

SELECT payer_id, COUNT(*)
FROM core.payers 
GROUP BY payer_id
HAVING COUNT(*) > 1;

SELECT claim_id, COUNT(*)
FROM core.claims
GROUP BY claim_id 
HAVING COUNT(*) > 1;

SELECT claim_transaction_id, COUNT(*)
FROM core.claims_transactions
GROUP BY claim_transaction_id  
HAVING COUNT(*) > 1;


-- =====================================================
-- SECTION : Orphan Checks
-- =====================================================

-- Perform this check before adding foreign key constraint

--- Table: Conditions

SELECT COUNT(*) AS orphan_count
FROM core.conditions c 
LEFT JOIN core.patients p
  ON c.patient_id = p.patient_id
WHERE c.patient_id IS NOT NULL 
  AND p.patient_id IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.conditions c 
LEFT JOIN core.encounters e 
  ON c.encounter_id = e.encounter_id 
WHERE c.encounter_id IS NOT NULL
  AND e.encounter_id IS NULL;

--- Table: Encounters

SELECT COUNT(*) AS orphan_count
FROM core.encounters e 
LEFT JOIN core.patients p 
  ON e.patient_id = p.patient_id 
WHERE e.patient_id IS NOT NULL
  AND p.patient_id IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.encounters e 
LEFT JOIN core.providers p  
  ON e.provider_id  = p.provider_id 
WHERE e.provider_id IS NOT NULL
  AND p.provider_id IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.encounters e 
LEFT JOIN core.organizations o   
  ON e.organization_id  = o.organization_id  
WHERE e.organization_id IS NOT NULL
  AND o.organization_id IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.encounters e 
LEFT JOIN core.payers p 
  ON e.payer_id = p.payer_id  
WHERE e.payer_id IS NOT NULL
  AND p.payer_id IS NULL;

--- Table: Medications

SELECT COUNT(*) AS orphan_count
FROM core.medications m 
LEFT JOIN core.patients p   
  ON m.patient_id  = p.patient_id 
WHERE m.patient_id IS NOT NULL
  AND p.patient_id IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.medications m 
LEFT JOIN core.encounters e    
  ON m.encounter_id = e.encounter_id
WHERE m.encounter_id IS NOT NULL
  AND e.encounter_id  IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.medications m 
LEFT JOIN core.payers p 
  ON m.payer_id = p.payer_id  
WHERE m.payer_id IS NOT NULL
  AND p.payer_id IS NULL;

--- Table: Payer_Transitions

SELECT COUNT(*) AS orphan_count
FROM core.payer_transitions pt 
LEFT JOIN core.patients p 
  ON pt.patient_id = p.patient_id 
WHERE pt.patient_id IS NOT NULL
  AND p.patient_id IS NULL;


--- Table: Provider

SELECT COUNT(*) AS orphan_count
FROM core.providers p 
LEFT JOIN core.organizations o  
  ON p.organization_id  = o.organization_id 
WHERE p.organization_id IS NOT NULL
  AND o.organization_id IS NULL;


--- Table: Claims

SELECT COUNT(*) AS orphan_count
FROM core.claims c 
LEFT JOIN core.patients p   
  ON c.patient_id = p.patient_id 
WHERE c.patient_id IS NOT NULL
  AND p.patient_id IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.claims c 
LEFT JOIN core.providers p    
  ON c.provider_id  = p.provider_id 
WHERE c.provider_id IS NOT NULL
  AND p.provider_id IS NULL;


--- Table: Claims_Transactions

SELECT COUNT(*) AS orphan_count
FROM core.claims_transactions ct 
LEFT JOIN core.claims c   
  ON ct.claim_id  = c.claim_id 
WHERE ct.claim_id IS NOT NULL
  AND c.claim_id IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.claims_transactions ct 
LEFT JOIN core.patients p   
  ON ct.patient_id = p.patient_id 
WHERE ct.patient_id IS NOT NULL
  AND p.patient_id IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.claims_transactions ct 
LEFT JOIN core.providers p    
  ON ct.provider_id  = p.provider_id 
WHERE ct.provider_id IS NOT NULL
  AND p.provider_id IS NULL;


--- Table: Observations

SELECT COUNT(*) AS orphan_count
FROM core.observations o 
LEFT JOIN core.patients p    
  ON o.patient_id  = p.patient_id 
WHERE o.patient_id IS NOT NULL
  AND p.patient_id IS NULL;

SELECT COUNT(*) AS orphan_count
FROM core.observations o 
LEFT JOIN core.encounters e 
  ON o.encounter_id   = e.encounter_id 
WHERE o.encounter_id IS NOT NULL
  AND e.encounter_id IS NULL;                   



-- =====================================================
-- SECTION : Check for Duplicate Business Grain
-- =====================================================

-- Table: Conditions

SELECT
    patient_id,
    encounter_id,
    condition_code,
    start_date,
    COUNT(*) AS duplicate_count
FROM core.conditions
GROUP BY patient_id, encounter_id, condition_code, start_date
HAVING COUNT(*) > 1;


-- Table: Medications
-- ** Below check failed, found 24 duplicate records **

SELECT
    patient_id,
    encounter_id,
    medication_code,
    start_ts,
    stop_ts,
    COUNT(*) AS duplicate_count
FROM core.medications
GROUP BY patient_id, encounter_id, medication_code, start_ts, stop_ts
HAVING COUNT(*) > 1;

-- Table: Observations
-- ** Below check failed, found 249 duplicate records **

SELECT
    patient_id,
    encounter_id,
    observation_code,
    observation_value,
    date_ts,
    COUNT(*) AS duplicate_count
FROM core.observations
GROUP BY patient_id, encounter_id, observation_code, observation_value, date_ts
HAVING COUNT(*) > 1;


-- =====================================================
-- SECTION : Date Sanity Check
-- =====================================================

SELECT COUNT(*) AS bad_condition_dates
FROM core.conditions
WHERE stop_date  < start_date;

SELECT COUNT(*) AS bad_encounter_dates
FROM core.encounters
WHERE stop_date  < start_date;

SELECT COUNT(*) AS bad_patient_birth_dates
FROM core.patients
WHERE death_date  < birth_date;

SELECT COUNT(*) AS bad_payer_transitions_dates
FROM core.payer_transitions
WHERE end_ts  < start_ts;

SELECT COUNT(*) AS bad_procedures_dates
FROM core."procedures"
WHERE stop_ts  < start_ts;

-- Below table had 5 bad dates
SELECT COUNT(*) AS bad_medication_dates
FROM core.medications
WHERE stop_ts < start_ts;


--- Below table had about 70K bad dates
SELECT COUNT(*) AS bad_claim_dates
FROM core.claims_transactions 
WHERE to_date_ts < from_date_ts;


-- =====================================================
-- SECTION : NULL rates Check
-- =====================================================

-- Following queries will check if any of the key columns have too many NULL's


-- Table: Conditions
SELECT 'conditions.nulls' AS check_type,
       COUNT(*) AS total,
       COUNT(patient_id) AS non_null_patient_id,
       COUNT(encounter_id) AS non_null_encounter_id,
       COUNT(condition_code) AS non_null_condition_code,
       COUNT(start_date) AS non_null_start_date
FROM core.conditions;


-- Table: Medications
SELECT 'medications.nulls' AS check_type,
       COUNT(*) AS total,
       COUNT(patient_id) AS non_null_patient_id,
       COUNT(encounter_id) AS non_null_encounter_id,
       COUNT(medication_code) AS non_null_medication_code,
       COUNT(start_ts) AS non_null_start_date
FROM core.medications;

-- Table: Observations
SELECT 'observations.nulls' AS check_type,
       COUNT(*) AS total,
       COUNT(patient_id) AS non_null_patient_id,
       COUNT(encounter_id) AS non_null_encounter_id,
       COUNT(observation_code) AS non_null_observation_code,
       COUNT(date_ts) AS non_null_start_date
FROM core.observations;


-- Table: Encounters
SELECT 'encounters.nulls' AS check_type,
       COUNT(*) AS total,
       COUNT(patient_id) AS non_null_patient_id,
       COUNT(encounter_id) AS non_null_encounter_id,
       COUNT(encounter_code) AS non_null_encounter_code,
       COUNT(start_date) AS non_null_start_date
FROM core.encounters;


-- Table: Claims Transactions
SELECT 'claims_transactions.nulls' AS check_type,
       COUNT(*) AS total,
       COUNT(patient_id) AS non_null_patient_id,
       COUNT(claim_id) AS non_null_claim_id,
       COUNT(procedure_code) AS non_null_procedure_code,
       COUNT(from_date_ts) AS non_null_start_date
FROM core.claims_transactions;


-- =====================================================
-- SECTION : Plausability Check
-- =====================================================

-- Patients born after today
SELECT COUNT(*) AS impossible_birth_date
FROM core.patients
WHERE birth_date > CURRENT_DATE;

-- Impossible or null condition code
SELECT COUNT(*) AS condition_code_missing_or_placeholder
FROM core.conditions
WHERE condition_code IS NULL
   OR TRIM(condition_code) = ''
   OR condition_code = '-999'
   OR condition_code = 'UNKNOWN';

-- Negative or zero cost?
SELECT COUNT(*) AS negative_base_cost
FROM core.medications
WHERE base_cost < 0;

SELECT COUNT(*) AS zero_base_cost
FROM core.medications
WHERE base_cost = 0;

-- Missing or invalid values
SELECT COUNT(*) AS missing_observation_value
FROM core.observations
WHERE observation_value IS NULL
   OR TRIM(observation_value) = '';

SELECT COUNT(*) AS invalid_observation_value_type
FROM core.observations
WHERE observation_value_type IS NULL
   OR TRIM(observation_value_type) = '';

-- Negative or zero total cost
SELECT COUNT(*) AS negative_total_cost
FROM core.claims_transactions
WHERE amount < 0;

-- Claims with zero total cost
SELECT COUNT(*) AS zero_total_cost
FROM core.claims_transactions
WHERE amount = 0;


-- =====================================================
-- SECTION : Temporal Coverage
-- =====================================================

SELECT
    MIN(start_date) AS min_date,
    MAX(start_date) AS max_date
FROM core.conditions;

SELECT
    MIN(start_ts) AS min_date,
    MAX(start_ts) AS max_date
FROM core.medications;

SELECT
    MIN(start_date) AS min_date,
    MAX(start_date) AS max_date
FROM core.encounters;

SELECT
    MIN(from_date_ts) AS min_date,
    MAX(from_date_ts) AS max_date
FROM core.claims_transactions;


-- =====================================================
-- SECTION : Completeness and Linkage
-- =====================================================

-- How many encounters have at least one condition
SELECT
    'encounters_with_condition' AS check_type,
    COUNT(*) AS total_encounters,
    COUNT(*) FILTER (WHERE has_condition) AS encounters_with_condition,
    ROUND(100.0 * COUNT(*) FILTER (WHERE has_condition) / COUNT(*), 2) AS pct_with_condition
FROM (
    SELECT
        e.encounter_id,
        BOOL_OR(c.condition_sk IS NOT NULL) AS has_condition
    FROM core.encounters e
    LEFT JOIN core.conditions c
      ON e.encounter_id = c.encounter_id
    GROUP BY e.encounter_id
) x;


-- How many encounters have at least one medication
SELECT
    'encounters_with_medication' AS check_type,
    COUNT(*) AS total_encounters,
    COUNT(*) FILTER (WHERE has_medication) AS encounters_with_medication,
    ROUND(100.0 * COUNT(*) FILTER (WHERE has_medication) / COUNT(*), 2) AS pct_with_medication
FROM (
    SELECT
        e.encounter_id,
        BOOL_OR(m.medication_sk IS NOT NULL) AS has_medication
    FROM core.encounters e
    LEFT JOIN core.medications m
      ON e.encounter_id = m.encounter_id
    GROUP BY e.encounter_id
) x;


-- How many encounters have at least one observation
SELECT
    'encounters_with_observation' AS check_type,
    COUNT(*) AS total_encounters,
    COUNT(*) FILTER (WHERE has_observation) AS encounters_with_observation,
    ROUND(100.0 * COUNT(*) FILTER (WHERE has_observation) / COUNT(*), 2) AS pct_with_observation
FROM (
    SELECT
        e.encounter_id,
        BOOL_OR(o.observation_sk IS NOT NULL) AS has_observation
    FROM core.encounters e
    LEFT JOIN core.observations o
      ON e.encounter_id = o.encounter_id
    GROUP BY e.encounter_id
) x;


-- How many patients have at least one encounter
SELECT
    'patients_with_encounter' AS check_type,
    COUNT(*) AS total_patients,
    COUNT(*) FILTER (WHERE has_encounter) AS patients_with_encounter,
    ROUND(100.0 * COUNT(*) FILTER (WHERE has_encounter) / COUNT(*), 2) AS pct_with_encounter
FROM (
    SELECT
        p.patient_id,
        BOOL_OR(e.encounter_id IS NOT NULL) AS has_encounter
    FROM core.patients p
    LEFT JOIN core.encounters e
      ON p.patient_id = e.patient_id
    GROUP BY p.patient_id
) x;


-- How many claims_transactions have a procedure code
SELECT
    'claims_transactions_with_code' AS check_type,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (WHERE procedure_code IS NOT NULL) AS transactions_with_code,
    ROUND(100.0 * COUNT(*) FILTER (WHERE procedure_code IS NOT NULL) / COUNT(*), 2) AS pct_with_code
FROM core.claims_transactions;


-- Unique condition codes
SELECT
    COUNT(*) AS total_conditions,
    COUNT(DISTINCT condition_code) AS unique_condition_codes
FROM core.conditions;

-- Unique medication codes
SELECT
    COUNT(*) AS total_medications,
    COUNT(DISTINCT medication_code) AS unique_medication_codes
FROM core.medications;

-- How many patients have all key demographics?
SELECT
    COUNT(*) AS total_patients,
    COUNT(*) FILTER (WHERE race IS NOT NULL) AS has_race,
    COUNT(*) FILTER (WHERE ethnicity IS NOT NULL) AS has_ethnicity,
    COUNT(*) FILTER (WHERE gender IS NOT NULL) AS has_gender
FROM core.patients;


