SELECT *
FROM (-- SUBQUERY STARTS HERE
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS jan_jobs;

WITH jan_jobs AS (--CTE STARTS HERE
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1
    )

SELECT *
FROM jan_jobs

SELECT name AS company_name
FROM company_dim
WHERE company_id IN (

SELECT 
        company_id
FROM job_postings_fact
WHERE 
        job_no_degree_mention = true
)

-- FINDING COMPANIES WITH THE MOST JOB OPENINGS, FIRST FINAL TOTAL # OF JOB POSTINGS PER COMPANY ID, THEN RETURN WITH COMPANY NAME)

WITH company_count AS (
    SELECT  
        company_id,
        COUNT(*) AS total_jobs

    FROM job_postings_fact
    GROUP BY
        company_id
)
SELECT 
    name,
    company_count.total_jobs

FROM company_dim
LEFT JOIN company_count ON company_count.company_id = company_dim.company_id

 ORDER BY
    total_jobs DESC

-- TOP 5 skills most frequently mentioned

SELECT *
FROM (
    SELECT  
        skill_id,
        COUNT(*) AS total_skills
    FROM skills_job_dim
    GROUP BY 
        skill_id
) AS skills


LEFT JOIN skills_dim ON skills_dim.skill_id = skills.skill_id

-- FIND COUNT OF # OF REMOTE JOB POSTINGS PER SKILL

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = True AND 
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT 
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;