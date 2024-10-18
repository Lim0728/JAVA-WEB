-- 1.查询所有员工的姓名、邮箱和工作岗位。
SELECT CONCAT(first_name,' ',last_name) '姓名',email '邮箱',job_title '工作岗位'
FROM employees;
-- 2.查询所有部门的名称和位置。
SELECT dept_name '名称',location '位置'
FROM departments;
-- 3.查询工资超过70000的员工姓名和工资。
SELECT CONCAT(first_name,' ',last_name) '姓名',salary '工资'
FROM employees
WHERE salary > 70000;
-- 4.查询IT部门的所有员工。
SELECT e.*,d.dept_name
FROM employees e
JOIN departments d ON e.dept_id=d.dept_id
WHERE d.dept_name='IT';
-- 5.查询入职日期在2020年之后的员工信息。
SELECT *
FROM employees
WHERE YEAR(hire_date)>2019;
-- 6.计算每个部门的平均工资。
SELECT e.dept_id,d.dept_name,AVG(e.salary) '平均工资'
FROM employees e
JOIN  departments d ON e.dept_id=d.dept_id
GROUP BY e.dept_id;
-- 7.查询工资最高的前3名员工信息。
SELECT *
FROM employees
ORDER BY salary DESC
Limit 3;
-- 8.查询每个部门员工数量。
SELECT e.dept_id,d.dept_name,COUNT(e.emp_id) '数量'
FROM employees e
JOIN  departments d ON e.dept_id=d.dept_id
GROUP BY e.dept_id;
-- 9.查询没有分配部门的员工。
SELECT *
FROM employees
WHERE dept_id is NOT NULL;
-- 10.查询参与项目数量最多的员工。
SELECT e.emp_id,CONCAT(first_name,' ',last_name) '姓名',COUNT(ep.project_id) '数量'
FROM employees e
JOIN employee_projects ep ON e.emp_id=ep.emp_id
GROUP BY ep.emp_id
HAVING COUNT(ep.project_id)=(
						SELECT MAX(project_count)
                        FROM (
                        SELECT COUNT(ep.project_id) project_count 
                        FROM employee_projects ep
                        GROUP BY ep.emp_id
                        )as emp_pro_count
                        );
-- 11.计算所有员工的工资总和。
SELECT sum(salary) '工资总和'
FROM employees;
-- 12.查询姓"Smith"的员工信息。
Select *
FROM employees e
WHERE last_name='Smith';
-- 13.查询即将在半年内到期的项目。
SELECT *
FROM projects
WHERE end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);
-- 14.查询至少参与了两个项目的员工。
SELECT e.emp_id,CONCAT(first_name,' ',last_name) '姓名',COUNT(ep.project_id) '数量'
FROM employees e
JOIN employee_projects ep ON e.emp_id=ep.emp_id
GROUP BY ep.emp_id
HAVING count(ep.emp_id)>=2;
-- 15.查询没有参与任何项目的员工。
SELECT e.emp_id,CONCAT(first_name,' ',last_name) '姓名'
FROM employees e
WHERE e.emp_id NOT IN(
				SELECT ep.emp_id
                FROM employee_projects ep
                );
-- 16.计算每个项目参与的员工数量。
SELECT p.project_id,count(p.project_id) '员工数量'
FROM projects p
JOIN employee_projects ep ON p.project_id=ep.project_id
GROUP BY ep.project_id;
-- 17.查询工资第二高的员工信息。
-- 若不考虑有重复工资的，直接使用LIMIT，这里使用嵌套把第二高工资提取出来，再找员工信息
SELECT e.emp_id,CONCAT(first_name,' ',last_name) '姓名',salary
FROM employees e
WHERE salary = (
		SELECT salary
		FROM employees e
		ORDER BY e.salary DESC
		LIMIT 1,1
        );
-- 18.查询每个部门工资最高的员工。
WITH ranked_employees AS (
	 SELECT e.*, d.dept_name,
	 RANK() OVER(PARTITION BY e.dept_id ORDER BY e.salary DESC) AS salary_rank
	 FROM employees e
	 JOIN departments d ON e.dept_id = d.dept_id
)
SELECT *
FROM ranked_employees
WHERE salary_rank <= 1;
-- 19.计算每个部门的工资总和,并按照工资总和降序排列。
SELECT e.dept_id,sum(salary)
FROM employees e
GROUP BY e.dept_id
ORDER BY sum(salary) DESC;
-- 20.查询员工姓名、部门名称和工资。
SELECT CONCAT(first_name,' ',last_name) '姓名',d.dept_name,salary
FROM employees e
JOIN departments d ON d.dept_id=e.dept_id;
-- 21.查询即将在90天内到期的项目和负责该项目的员工
SELECT p.project_id,p.project_name,e.emp_id,CONCAT(first_name,' ',last_name) '姓名'
FROM employees e,projects p,employee_projects ep
WHERE p.end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 90 DAY) AND
	p.project_id=ep.project_id AND ep.emp_id = e.emp_id;
-- 22.查询员工数量最多的部门
SELECT d.dept_id,count(d.dept_id)
FROM employees e
JOIN departments d ON e.dept_id=d.dept_id
GROUP BY e.dept_id
ORDER BY count(d.dept_id) DESC
LIMIT 1;
-- 23.查询平均工资最高的部门。
SELECT d.dept_id,avg(salary)
FROM employees e
JOIN departments d ON e.dept_id=d.dept_id
GROUP BY e.dept_id
ORDER BY avg(salary) DESC
LIMIT 1;
-- 24.查询姓名包含"son"的员工信息。
SELECT e.emp_id,CONCAT(first_name,' ',last_name) '姓名'
FROM employees e
WHERE CONCAT(first_name,' ',last_name) LIKE '%son%';
-- 25.查询每个部门工资前两名的员工。
WITH ranked_employees AS (
	 SELECT e.*, d.dept_name,
	 RANK() OVER(PARTITION BY e.dept_id ORDER BY e.salary DESC) AS salary_rank
	 FROM employees e
	 JOIN departments d ON e.dept_id = d.dept_id
)
SELECT *
FROM ranked_employees
WHERE salary_rank <= 2;