/*
Question: What skills are required for the top paying business analyst roles?
- Use the top 10 highest paying roles from Query 1.
- Add the specifics skills required for thee roles.
This will provide a detailed look at which high paying jobs demand certain skills, helping job seekers understand which 
skills to develop that align with top salaries.
*/


WITH top_paying_jobs AS (

    SELECT
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short LIKE '%Business Analyst%' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

/*

SQL leads by a wide margin (6 postings), making it the most critical skill for high-paying BA positions.

Python follows closely (6 postings), highlighting the growing importance of analytical programming.

Tableau appears frequently (3 postings), emphasizing strong demand for data visualization and storytelling.

Excel remains a core requirement(2 postings), even in senior and higher-paid roles.

Cloud & data platforms such as Snowflake, BigQuery, and AWS appear consistently, signaling a shift toward modern data stacks.

Big data tools like Spark and Hadoop show up in more technical, higher-paying roles.

Less common but notable skills such as R, Go, and Airflow tend to appear in roles with deeper technical or engineering overlap.

*/