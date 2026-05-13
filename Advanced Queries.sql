Attrition Rate Analysis
SELECT
    department,
    COUNT(a.employee_id) AS attritions
FROM employees e
JOIN attrition a
ON e.employee_id = a.employee_id
GROUP BY department
ORDER BY attritions DESC;

Bench Strength Analysis
SELECT
    employee_name,
    employment_status
FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id
    FROM allocations
);

Staffing Gap Analysis
SELECT
    project_name,
    required_headcount,
    allocated_headcount,
    required_headcount - allocated_headcount AS staffing_gap
FROM projects
ORDER BY staffing_gap DESC;