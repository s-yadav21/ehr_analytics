CREATE OR REPLACE VIEW analytics.ad_medications_classified AS
SELECT 
    m.patient_id,
    m.encounter_id,
    m.medication_description AS original_drug_name,
    m.reason_description,
    m.start_ts,
    m.stop_ts,
    CASE 
        WHEN lower(m.medication_description) LIKE '%cetirizine%'       THEN 'Cetirizine'
        WHEN lower(m.medication_description) LIKE '%fexofenadine%'     THEN 'Fexofenadine'
        WHEN lower(m.medication_description) LIKE '%loratadine%'       THEN 'Loratadine'
        WHEN lower(m.medication_description) LIKE '%diphenhydramine%'  THEN 'Diphenhydramine'
        WHEN lower(m.medication_description) LIKE '%chlorpheniramine%' THEN 'Chlorpheniramine'
        WHEN lower(m.medication_description) LIKE '%hydrocortisone%'   THEN 'Hydrocortisone (Topical)'
        WHEN lower(m.medication_description) LIKE '%prednisone%'       THEN 'Prednisone'
        WHEN lower(m.medication_description) LIKE '%cyclosporine%'     THEN 'Cyclosporine'
        WHEN lower(m.medication_description) LIKE '%methotrexate%'     THEN 'Methotrexate'
    END AS drug_short_name,
    CASE 
        WHEN lower(m.medication_description) LIKE '%cetirizine%'       THEN 'Antihistamine'
        WHEN lower(m.medication_description) LIKE '%fexofenadine%'     THEN 'Antihistamine'
        WHEN lower(m.medication_description) LIKE '%loratadine%'       THEN 'Antihistamine'
        WHEN lower(m.medication_description) LIKE '%diphenhydramine%'  THEN 'Antihistamine'
        WHEN lower(m.medication_description) LIKE '%chlorpheniramine%' THEN 'Antihistamine'
        WHEN lower(m.medication_description) LIKE '%hydrocortisone%'   THEN 'Topical Steroid'
        WHEN lower(m.medication_description) LIKE '%prednisone%'       THEN 'Oral Steroid'
        WHEN lower(m.medication_description) LIKE '%cyclosporine%'     THEN 'Systemic Immunosuppressant'
        WHEN lower(m.medication_description) LIKE '%methotrexate%'     THEN 'Systemic Immunosuppressant'
    END AS drug_class,
    CASE 
        WHEN lower(m.medication_description) LIKE '%cetirizine%'       THEN 1
        WHEN lower(m.medication_description) LIKE '%fexofenadine%'     THEN 1
        WHEN lower(m.medication_description) LIKE '%loratadine%'       THEN 1
        WHEN lower(m.medication_description) LIKE '%diphenhydramine%'  THEN 1
        WHEN lower(m.medication_description) LIKE '%chlorpheniramine%' THEN 1
        WHEN lower(m.medication_description) LIKE '%hydrocortisone%'   THEN 2
        WHEN lower(m.medication_description) LIKE '%prednisone%'       THEN 3
        WHEN lower(m.medication_description) LIKE '%cyclosporine%'     THEN 4
        WHEN lower(m.medication_description) LIKE '%methotrexate%'     THEN 4
    END AS treatment_step
FROM core.medications m
WHERE m.patient_id IN (
    SELECT DISTINCT patient_id FROM analytics.ad_cohort
)
AND (
    lower(m.medication_description) LIKE '%hydrocortisone%'
    OR lower(m.medication_description) LIKE '%cyclosporine%'
    OR lower(m.medication_description) LIKE '%prednisone%'
    OR lower(m.medication_description) LIKE '%cetirizine%'
    OR lower(m.medication_description) LIKE '%fexofenadine%'
    OR lower(m.medication_description) LIKE '%loratadine%'
    OR lower(m.medication_description) LIKE '%diphenhydramine%'
    OR lower(m.medication_description) LIKE '%chlorpheniramine%'
    OR lower(m.medication_description) LIKE '%methotrexate%'
);
