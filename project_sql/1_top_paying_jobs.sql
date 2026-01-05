/*
Question: What are the top paying business analyst roles?
- Identify the top 10 highest paying business analyst roles.
- Focuses on the job postings with specified salaries (remove nulls).
- Highlight the top paying oppourtunities for business analysts, offering insights into which are the most optimal roles
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short LIKE '%Business Analyst%' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;