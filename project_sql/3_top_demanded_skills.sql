/*
Question: What are the most demanded skills for buisness analysts?
- Identify the top 5 demanded skills for a BA.
- Focus on all job postings.
- Retrieves the top 5 skills with the highest demand in the job market, 
providing insights into the most valuable skills for job seekers.
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short LIKE '%Business Analyst%'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5