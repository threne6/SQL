# Introduction
Focusing on business analyst roles, this project explores top paying jobs, in demand skills, and where high demand meets high salary in data analytics.

SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background
This project was made from a desire to pintpoint top-paid and in-demand skills, streamlining others work to find optimal jobs. 

### The questions I wanted to answer through my SQL queries were:

1. What are the top paying business analyst roles?
2. What skills are required for these high-paying jobs?
3. What skills are more in-demand for business analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into this project, I used several key tools:

- **SQL**: The backbone of the analysis, helping me to query the database and discover key insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data I had.
- **VS Code**: The platfom used for database management and actually excecuting the SQL queries.
- **Git & Github**: Version control and sharing my SQL scripts and analysis.

# The Analysis
Each query for this project aimed at investiagting specific aspects of the buisness analyst job market. Here's how I approached each question:

### 1. Top Paying Business Analyst Roles: 
To identify which business analyst roles are the highest paying, I filtered BA positions by average yearly salary. This highlights the high paying opportunities in this field.

``` SQL
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
```
#### Top compensation is driven by economics, applied science, and decision-critical roles
- The highest salaries cluster around roles that directly influence platform economics and market dynamics, not traditional reporting

- Principal Economist / Scientist (Roblox) at ~$387k is a massive outlier, signaling strong demand for economic modeling, experimentation, and marketplace design

- Similar premium roles include Applied Science (Uber) and Economy Designer, blending economics, data science, and strategy

These roles sit close to core product and monetization decisions, justifying outsized pay

#### “Business Intelligence” roles pay most when they look like engineering or science
- BI titles reach $175k–$220k when they involve data engineering, modeling, and system ownership

- Lead / Senior BI Engineer roles (Noom, Block, Amazon) consistently pay well above typical BI analyst levels

- “Engineer” and “Lead” designations matter more than “Analyst” in compensation outcomes

- Indicates a market shift from dashboard creation → building scalable analytics infrastructure

### 2. Skills Required for Top-Paying BA Roles: 
To understand what skills are needed to land the highest-paying BA jobs, I first pulled the top 10 highest-paying business analyst postings (with non-null salaries). Then, I joined those jobs to the skills tables to list every skill associated with each top-paying role. This reveals the common technical and analytical skill requirements that show up most often in elite BA postings, helping highlight what candidates should prioritize learning.

``` SQL
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
```
SQL leads by a wide margin (6 postings), making it the most critical skill for high-paying BA positions.

Python follows closely (6 postings), highlighting the growing importance of analytical programming.

Tableau appears frequently (3 postings), emphasizing strong demand for data visualization and storytelling.

Excel remains a core requirement(2 postings), even in senior and higher-paid roles.

Cloud & data platforms such as Snowflake, BigQuery, and AWS appear consistently, signaling a shift toward modern data stacks.

Big data tools like Spark and Hadoop show up in more technical, higher-paying roles.

Less common but notable skills such as R, Go, and Airflow tend to appear in roles with deeper technical or engineering overlap.

### 3. Most In-Demand Skills for Business Analysts:
To identify which skills are most in demand for business analysts, I analyzed all BA job postings and counted how often each skill appeared across roles. By grouping postings by skill and ranking them by frequency, this query highlights the top skills employers most commonly request, providing insight into the baseline and must-have competencies for business analysts in the job market.

``` SQL
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
```
#### SQL and Excel are non-negotiable baseline skills

- SQL (17,372 postings) and Excel (17,134 postings) appear in nearly every business analyst role, signaling they are table-stakes, not differentiators

- Employers expect BAs to query, clean, and manipulate data independently

- Lacking either skill significantly limits job eligibility

#### BI and dashboarding tools dominate the middle layer of demand

- Tableau (9,324) and Power BI (9,251) show strong, but clearly secondary, demand

- Indicates many BA roles emphasize data visualization and stakeholder reporting

- Suggests BAs are often responsible for turning raw data into executive-ready insights

#### Python is in demand—but still a differentiator, not a requirement

- Python (8,097) trails BI tools in demand, implying it is not mandatory for all BA roles

- Python is more common in advanced, technical, or analytics-heavy BA positions

- Acts as a career accelerator rather than a baseline skill

### 4. Skills Associated with Higher Salaries:
To determine which skills are linked to higher-paying business analyst roles, I joined BA job postings with their required skills and calculated the average salary for each skill. By filtering for roles with reported salaries and ranking skills by average pay, this query highlights the skills that command the strongest salary premiums, helping identify which technical and analytical capabilities are most financially rewarding.

``` SQL
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
```
#### Top-paying “Business Analyst” roles are actually technical hybrid roles
- High salaries are driven by engineering + analytics, not traditional BA work

- Skills like Chef, Hadoop, Airflow, Ruby, C, Node.js point to roles closer to analytics engineer or platform analyst

- These professionals build and maintain data systems, not just analyze outputs

- Job titles say “BA,” but responsibilities often include production code and infrastructure

#### Machine learning and the Python ecosystem command a clear pay premium
- ML-capable analysts consistently earn ~$120k+

- Strong demand for PyTorch, TensorFlow, scikit-learn, Julia

- Core Python stack (NumPy, Pandas, Matplotlib, Seaborn) appears repeatedly

- Companies value analysts who can translate business problems into models, not just dashboards

#### Owning the data pipeline pays more than owning the dashboard
- Infrastructure and data-engineering skills outperform pure BI tools

- Higher pay for Airflow, Snowflake, NoSQL, Cassandra, Elasticsearch

- Visualization tools (e.g., Looker) pay well but sit below pipeline-level skills- Compensation rises when analysts control data ingestion → transformation → analysis
*/

### 5. Most Optimal Skills to Learn:
To find the most optimal skills for business analysts to learn, I combined two perspectives: skill demand and skill pay premium. First, I calculated how frequently each skill appears in BA job postings (demand). Then, I computed the average salary associated with each skill for postings with reported salaries. By joining these two results on skill_id and ranking the output by highest demand and then highest average salary, this query identifies skills that offer the best blend of market relevance and earning potential.

```SQL
WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short LIKE '%Business Analyst%'
    GROUP BY
       skills_dim.skill_id
), average_salary AS(
    SELECT 
        skills_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short LIKE '%Business Analyst%' AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25
```
#### Core BA skills drive demand, but not the highest pay
- SQL and Excel dominate demand by a wide margin, confirming they are foundational skills for business analysts.

- SQL (17,372 postings) and Excel (17,134) appear in nearly every BA role

- However, their average salaries (~$95k and ~$87k) sit below more technical skills

- This suggests they are required to enter the field, but not strong salary differentiators

#### Visualization and business tools offer balanced but capped returns

- BI and business-facing tools show solid demand with moderate pay.

- Tableau and Power BI combine strong demand (~9k postings) with near-$100k salaries

- Tools like PowerPoint, Jira, Outlook are common but correlate with lower compensation

- Indicates that insight delivery alone is less valued than technical data ownership

# What I learned:
Throughout this project, I have learned many new functions in my SQL toolkit:

- Complex Queries: I learned multiple advanced SQL functions, including manipulating and merging tables.
- Data Aggregation: I became familliar with the GROUP BY function, turning aggregate functions like COUNT () and AVG() into helpful tools for data summarizing.
- Analytial Skills: Leveled up my real world problem solving skills, turning questions into actionable and insightful SQL queries.

# Closing Thoughts:

This project applied the SQL skills I learned (both basic and advanced) and provided insights into the business analyst market. The findings from the analysis serve as a guide to prioritizing certain skills in job search efforts. By focusing on high-demand, high-paying skills, Business Analysts can position themselves better in the job market. This exploration shows the importance of continous learning and adaptation to emerging trends in the field.