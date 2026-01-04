SELECT
    job_title_short,
    company_id,
    job_location
FROM
    jan_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    feb_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    mar_jobs

-- find job postings from q1 that have salary > 70k, combine job posting tables then get avg salary > 70k
SELECT 
    Q1_jobs.job_title_short,
    Q1_jobs.job_location,
    Q1_jobs.job_via,
    Q1_jobs.job_posted_date ::date,
    Q1_jobs.salary_year_avg
FROM (
    SELECT *
    FROM jan_jobs
    UNION ALL
    SELECT *
    FROM feb_jobs
    UNION ALL
    SELECT *
    FROM mar_jobs
) AS Q1_jobs

WHERE 
    Q1_jobs.salary_year_avg > 70000 AND 
    Q1_jobs.job_title_short = 'Data Analyst'
