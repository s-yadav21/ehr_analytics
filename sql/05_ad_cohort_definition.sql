-- AD Cohort Definition
-- Inclusion: patients with at least one Atopic Dermatitis diagnosis
-- Exclusion: none for this descriptive analysis

CREATE OR REPLACE VIEW analytics.ad_cohort AS
SELECT DISTINCT
    p.patient_id,
    p.birth_date,
    p.gender,
    p.race,
    MIN(c.start_date) AS index_date,        -- first AD diagnosis date
    EXTRACT(YEAR FROM AGE(MIN(c.start_date), p.birth_date)) AS age_at_index
FROM core.patients p
JOIN core.conditions c ON p.patient_id = c.patient_id
WHERE c.condition_description = 'Atopic dermatitis'
GROUP BY p.patient_id, p.birth_date, p.gender, p.race;
