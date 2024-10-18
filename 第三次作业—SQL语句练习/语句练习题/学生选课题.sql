-- 1. 查询所有学生的信息。
SELECT student_id,name,gender,birth_date,my_class
FROM student;
-- 2. 查询所有课程的信息。
SELECT course_id,course_name,teacher_id,credits
FROM course;
-- 3. 查询所有学生的姓名、学号和班级。
SELECT student_id,name,my_class
FROM student;
-- 4. 查询所有教师的姓名和职称。
SELECT name,title
FROM teacher;
-- 5. 查询不同课程的平均分数。
SELECT c.course_id,avg(score)
FROM course c
JOIN score s ON c.course_id=s.course_id
GROUP BY c.course_id;
-- 6. 查询每个学生的平均分数。
SELECT d.student_id,avg(score)
FROM student d
JOIN score s ON s.student_id=d.student_id
GROUP BY s.student_id;
-- 7. 查询分数大于85分的学生学号和课程号。
SELECT d.student_id,s.course_id
FROM student d
JOIN score s ON d.student_id=s.student_id
WHERE score>85;
-- 8. 查询每门课程的选课人数。
SELECT course_id,COUNT(student_id)
FROM score
GROUP BY course_id;
-- 9. 查询选修了"高等数学"课程的学生姓名和分数。
SELECT d.name,c.course_name,s.score
FROM student d,score s,course c
WHERE course_name='高等数学' AND c.course_id=s.course_id AND s.student_id=d.student_id;
-- 10. 查询没有选修"大学物理"课程的学生姓名。
SELECT student_id,name
FROM student
WHERE student_id NOT IN(
			SELECT student_id
            FROM course c
            JOIN score s ON s.course_id=c.course_id
            WHERE course_name='大学物理'
            );
-- 11. 查询C001比C002课程成绩高的学生信息及课程分数。
SELECT  s.student_id,s.name,s.gender,s.birth_date,s.my_class,sc1.score AS 'C001成绩',sc2.score AS 'C002成绩'
FROM score sc1  
JOIN score sc2 ON sc1.student_id = sc2.student_id  
JOIN student s ON s.student_id = sc1.student_id  
WHERE sc1.course_id = 'C001' AND sc2.course_id = 'C002' AND sc1.score > sc2.score;
-- 12. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
SELECT course.course_id,course_name,
    COUNT(CASE WHEN score BETWEEN 85 AND 100 THEN 1 END) AS '[100-85]',
    COUNT(CASE WHEN score BETWEEN 70 AND 84 THEN 1 END) AS '[85-70]',
    COUNT(CASE WHEN score BETWEEN 60 AND 69 THEN 1 END) AS '[70-60]',
    COUNT(CASE WHEN score < 60 THEN 1 END) AS '[60-0]',
    COUNT(*) AS total_students,
    ROUND(COUNT(CASE WHEN score BETWEEN 85 AND 100 THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_100_85,
    ROUND(COUNT(CASE WHEN score BETWEEN 70 AND 84 THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_85_70,
    ROUND(COUNT(CASE WHEN score BETWEEN 60 AND 69 THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_70_60,
    ROUND(COUNT(CASE WHEN score < 60 THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_60_0
FROM score
JOIN course ON score.course_id=course.course_id
GROUP BY course.course_id;
-- 13. 查询选择C002课程但没选择C004课程的成绩情况(不存在时显示为 null )。
SELECT DISTINCT student_id,course_id,score
FROM score
WHERE student_id in
				(SELECT student_id 
                FROM score 
                WHERE course_id='C002' AND  student_id NOT IN 
				(SELECT student_id 
                FROM score 
                WHERE course_id='C004' )
				);
-- 14. 查询平均分数最高的学生姓名和平均分数。
SELECT name,avg(score)
FROM student d
JOIN score s ON s.student_id=d.student_id
GROUP BY s.student_id
ORDER BY avg(score) DESC
LIMIT 1;
-- 15. 查询总分最高的前三名学生的姓名和总分。
SELECT name,sum(score)
FROM student d
JOIN score s ON s.student_id=d.student_id
GROUP BY s.student_id
ORDER BY sum(score) DESC
LIMIT 3;
-- 16. 查询每个班级的学生人数和平均年龄.
SELECT my_class,COUNT(student_id) AS '学生人数',AVG(YEAR(CURRENT_DATE() )-YEAR(birth_date)) AS '平均年龄'
FROM student
GROUP BY my_class;
-- 17. 查询男生和女生的人数。
SELECT gender, COUNT(student_id) '人数'
FROM student 
GROUP BY gender;
-- 18. 查询年龄最大的学生姓名。
SELECT name
FROM student
ORDER BY birth_date
LIMIT 1;
-- 19. 查询年龄最小的教师姓名。
SELECT name
FROM teacher
ORDER BY birth_date DESC
LIMIT 1;
-- 20. 查询学过「张教授」授课的同学的信息。
SELECT d.student_id,d.name,d.gender,d.birth_date,d.my_class
FROM student d,score s
WHERE d.student_id=s.student_id AND course_id IN(
		SELECT c.course_id
        FROM course c,teacher t,score s
        WHERE t.name='张教授' AND t.teacher_id=c.teacher_id AND c.course_id =s.course_id
        );
-- 21. 查询至少有一门课与学号为"2021001"的同学所学相同的同学的信息 。
SELECT DISTINCT d.student_id,d.name,d.gender,d.birth_date,d.my_class
FROM student d JOIN score s ON d.student_id=s.student_id
WHERE s.course_id IN
			(SELECT course_id 
            FROM score 
            WHERE student_id='2021001'
            );
-- 22. 查询每门课程的平均分数，并按平均分数降序排列。
SELECT sc.course_id,avg(score) '平均分数'
FROM score sc
GROUP BY sc.course_id
ORDER BY avg(score) DESC;
-- 23. 查询学号为"2021001"的学生所有课程的分数。
SELECT student_id,course_id,score
FROM score
WHERE student_id='2021001';
-- 24. 查询所有学生的姓名、选修的课程名称和分数。
SELECT s.name,c.course_name,sc.score
FROM student s,course c,score sc
WHERE s.student_id=sc.student_id AND sc.course_id=c.course_id;
-- 25. 查询每个教师所教授课程的平均分数。
SELECT t.teacher_id,avg(score)
FROM teacher t,score sc,course c
WHERE t.teacher_id=c.teacher_id AND c.course_id=sc.course_id
GROUP BY t.teacher_id;
-- 26. 查询分数在80到90之间的学生姓名和课程名称。
SELECT s.name,c.course_name,sc.score
FROM student s,course c,score sc
WHERE score BETWEEN 80 AND 90 AND sc.course_id=c.course_id AND sc.student_id=s.student_id;
-- 27. 查询每个班级的平均分数。
SELECT my_class,avg(score)
FROM student s
JOIN score sc ON s.student_id=sc.student_id
GROUP BY my_class;
-- 28. 查询没学过"王讲师"老师讲授的任一门课程的学生姓名。
SELECT s.name
FROM student s
WHERE s.student_id NOT IN (
		SELECT student_id
		FROM score s
		WHERE course_id IN(
				SELECT c.course_id
				FROM course c,teacher t,score s
				WHERE t.name='王讲师' AND t.teacher_id=c.teacher_id AND c.course_id =s.course_id
			)
		);
-- 29. 查询两门及其以上小于85分的同学的学号，姓名及其平均成绩 。
SELECT s.student_id,s.name,AVG(sc.score) '平均成绩',SUM(CASE WHEN sc.score <85 THEN 1 ELSE 0 END) AS count_85
FROM student s 
JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id
HAVING count_85>=2;
-- 30. 查询所有学生的总分并按降序排列。
SELECT student_id,sum(score)
FROM score
GROUP BY student_id
ORDER BY sum(score) DESC;
-- 31. 查询平均分数超过85分的课程名称。
SELECT course_name
FROM course
WHERE course_id IN(
		SELECT course_id
        FROM score
        GROUP BY course_id
        HAVING avg(score)>85
        );
-- 32. 查询每个学生的平均成绩排名。
SELECT RANK() OVER (ORDER BY AVG(score) DESC) AS '排名',student_id,AVG(score) AS 平均成绩
FROM score
GROUP BY student_id;
-- 33. 查询每门课程分数最高的学生姓名和分数。
WITH ranked_student AS (
	 SELECT sc.*,s.name,
	 RANK() OVER(PARTITION BY sc.course_id ORDER BY sc.score DESC) AS score_rank
	 FROM score sc
	 JOIN student s ON s.student_id=sc.student_id
)
SELECT name,course_id,score
FROM ranked_student
WHERE score_rank <= 1;
-- 34. 查询选修了"高等数学"和"大学物理"的学生姓名。
SELECT name
FROM course c,student s,score sc
WHERE c.course_name IN('高等数学','大学物理') AND c.course_id=sc.course_id AND s.student_id=sc.student_id
GROUP BY s.student_id
HAVING COUNT(DISTINCT c.course_id)=2;
-- 35. 查询平均成绩大于等于90分的同学的学生编号和学生姓名和平均成绩
SELECT s.student_id,name,avg(score)
FROM student s
JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id
HAVING avg(score)>=90;
-- 36. 查询分数最高和最低的学生姓名及其分数。
WITH ranked_score AS(  
 SELECT s.name,sc.score,  
        RANK() OVER (ORDER BY sc.score DESC) AS score_desc,  
        RANK() OVER (ORDER BY sc.score ASC) AS score_asc  
 FROM student s 
 JOIN score sc ON s.student_id = sc.student_id  
)  
SELECT name,score  
FROM ranked_score 
WHERE score_desc = 1 OR score_asc = 1;
-- 37. 查询每个班级的最高分和最低分。
SELECT s.my_class, MAX(sc.score) AS '最高分', MIN(sc.score) AS '最低分'  
FROM student s 
JOIN score sc ON s.student_id = sc.student_id  
GROUP BY s.my_class;
-- 38. 查询每门课程的优秀率（优秀为90分）。
SELECT course_id,
 ( SUM(CASE WHEN score >=90 THEN 1 ELSE 0 END) / COUNT(score) ) * 100 AS '优秀率'
FROM score
GROUP BY course_id;
-- 39. 查询平均分数超过班级平均分数的学生。
WITH class_avgscore AS(
 SELECT s.my_class,AVG(sc.score) AS 班级平均分
 FROM student s 
 JOIN score sc ON s.student_id=sc.student_id
 GROUP BY s.my_class
)
SELECT s.*,AVG(sc.score) AS 学生平均分,c_a.班级平均分
 FROM student s 
 JOIN score sc ON s.student_id=sc.student_id
 JOIN class_avgscore c_a ON s.my_class=c_a.my_class
 GROUP BY s.student_id
 HAVING 学生平均分> c_a.班级平均分;
-- 40. 查询每个学生的分数及其与课程平均分的差值。
WITH class_avg1 AS(
	SELECT course_id,avg(score) 课程平均成绩
    FROM score
    GROUP BY course_id
)
SELECT sc.student_id,sc.course_id,ABS(sc.score - c_a.课程平均成绩) '差值'
FROM score sc
JOIN class_avg1 c_a ON sc.course_id=c_a.course_id;