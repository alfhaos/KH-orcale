--실습문제
--1.employee테이블에서 1990년대에 입사한 사원의 사번, 사원명, 입사년도를 인라인뷰를 사용해서 출력.
select
    e.*
from(
    select
        emp_id,
        emp_name,
        extract(year from hire_date)
    from
        employee
    where
        extract(year from hire_date) >= 1990
        and
        extract(year from hire_date) < 2000
    )e;
    
--2.employee테이블에서 사원중 30대, 40대인 여자사원의 사번, 부서명, 성별, 나이를 출력하라.
select
    a.*
from(
    select
        emp_id,
        d.dept_title,
        decode(substr(emp_no,8,1),'1','남','3','남','여'),
        extract(year from sysdate) -  (decode(substr(emp_no,8,1),'1',1900,'2',1900,2000) + substr(emp_no,1,2)) +1 "한국나이"
    from
        employee e join department d
        on e.dept_code = d.dept_id
    where
         extract(year from sysdate) -  (decode(substr(emp_no,8,1),'1',1900,'2',1900,2000) + substr(emp_no,1,2)) +1 >= 30
         and
         extract(year from sysdate) -  (decode(substr(emp_no,8,1),'1',1900,'2',1900,2000) + substr(emp_no,1,2)) +1 < 50
         and
         decode(substr(emp_no,8,1),'1','남','3','남','여') in ('여'))a;