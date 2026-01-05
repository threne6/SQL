/*
Question: What are the top skills based on salary?
- Look at the avg salary associated with each skill for BA positions
- Focuses on roles with specificed salaries, regardless of location
- Reveals how different skills impact salary levels for BA's
and helps identify the most financialy rewarding skills
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short LIKE '%Business Analyst%' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25

/*

Top-paying “Business Analyst” roles are actually technical hybrid roles
- High salaries are driven by engineering + analytics, not traditional BA work.
- Skills like Chef, Hadoop, Airflow, Ruby, C, Node.js point to roles closer to analytics engineer or platform analyst
- These professionals build and maintain data systems, not just analyze outputs
- Job titles say “BA,” but responsibilities often include production code and infrastructure

Machine learning and the Python ecosystem command a clear pay premium
- ML-capable analysts consistently earn ~$120k+.
- Strong demand for PyTorch, TensorFlow, scikit-learn, Julia
- Core Python stack (NumPy, Pandas, Matplotlib, Seaborn) appears repeatedly
- Companies value analysts who can translate business problems into models, not just dashboards

Owning the data pipeline pays more than owning the dashboard
- Infrastructure and data-engineering skills outperform pure BI tools.
- Higher pay for Airflow, Snowflake, NoSQL, Cassandra, Elasticsearch
- Visualization tools (e.g., Looker) pay well but sit below pipeline-level skills- Compensation rises when analysts control data ingestion → transformation → analysis
*/
