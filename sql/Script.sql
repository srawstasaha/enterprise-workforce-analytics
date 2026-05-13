WITH ranked_employees AS (
    SELECT
        e.department,
        e.employee_name,
        SUM(t.hours_logged) AS total_hours,
        ROW_NUMBER() OVER (
            PARTITION BY e.department
            ORDER BY SUM(t.hours_logged) DESC
        ) AS rank
    FROM employees e
    JOIN timesheets t
    ON e.employee_id = t.employee_id
    GROUP BY e.department, e.employee_name
)

SELECT *
FROM ranked_employees
WHERE rank = 1;