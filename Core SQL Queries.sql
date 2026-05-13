Employee Utilization Analysis
SELECT
    e.department,
    COUNT(DISTINCT e.employee_id) AS employees,
    ROUND(AVG(a.allocation_percentage),2) AS avg_utilization
FROM employees e
JOIN allocations a
ON e.employee_id = a.employee_id
GROUP BY e.department
ORDER BY avg_utilization DESC;

Overtime Hotspots
SELECT
    e.department,
    SUM(t.overtime_hours) AS total_overtime
FROM employees e
JOIN timesheets t
ON e.employee_id = t.employee_id
GROUP BY e.department
HAVING SUM(t.overtime_hours) > 100
ORDER BY total_overtime DESC;

Allocated Resources
SELECT
    p.project_name,
    COUNT(DISTINCT a.employee_id) AS allocated_resources,
    ROUND(AVG(a.allocation_percentage),2) AS avg_allocation
FROM projects p
JOIN allocations a
ON p.project_id = a.project_id
GROUP BY p.project_name
ORDER BY allocated_resources DESC
LIMIT 10;

Monthly Workforce
SELECT
    DATE_TRUNC('month', work_date) AS month,
    SUM(hours_logged) AS total_hours,
    LAG(SUM(hours_logged))
        OVER (ORDER BY DATE_TRUNC('month', work_date)) AS prev_month_hours,
    ROUND(
        100.0 *
        (SUM(hours_logged) -
        LAG(SUM(hours_logged))
        OVER (ORDER BY DATE_TRUNC('month', work_date)))
        /
        LAG(SUM(hours_logged))
        OVER (ORDER BY DATE_TRUNC('month', work_date)),
    2) AS growth_pct
FROM timesheets
GROUP BY DATE_TRUNC('month', work_date)
ORDER BY month;

Top Performers by Department
WITH ranked_employees AS (
    SELECT
        e.department,
        e.employee_name,
        SUM(t.hours_logged) AS total_hours,
        ROW_NUMBER() OVER (
            PARTITION BY e.department
            ORDER BY SUM(t.hours_logged) DESC
        ) AS employee_rank
    FROM employees e
    JOIN timesheets t
    ON e.employee_id = t.employee_id
    GROUP BY e.department, e.employee_name
)

SELECT *
FROM ranked_employees
WHERE employee_rank = 1;