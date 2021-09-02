--@0901 조인 실습문제

--1. 2020년 12월 25일이 무슨 요일인지 조회하시오
select
     to_char(to_date('20201225'), 'day')
from
    dual;
    
--2. 주민번호가 70년대 생이면서 성별이 여자이고, 
--    성이 전씨인 직원들의 사원명,주민번호,부서명,직급명 조회

select
    emp_name,
    emp_no,
    d.dept_title,
    j.job_name
    
from
    employee e join department d
        on dept_code = dept_id
        join job j
        on e.job_code = j.job_code
where
    (substr(emp_no,1,2) between 70 and 79)
    and
    (emp_name like '전%')
    and
    (substr(emp_no,8,1) in ('2','4'));
    
--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명 조회
select
    rownum,
    id,
    name,
    age,
    title,
    jname
from(
    select
        rownum,
        e.emp_id id,
        e.emp_name name,
        e.emp_no,
        extract(year from sysdate) -  (decode(substr(emp_no,8,1),'1',1900,'2',1900,2000) + substr(emp_no,1,2)) +1 age,
        d.dept_title title,
        j.job_name jname
    from
        employee e join department d
            on e.dept_code = d.dept_id
        join job j
            on e.job_code = j.job_code
            
    order by
        extract(year from sysdate) -  (decode(substr(emp_no,8,1),'1',1900,'2',1900,2000) + substr(emp_no,1,2)) +1 )
where 
    rownum = 1;

--4. 이름에'형'자가 들어가는 직원들의 사번, 사원명,부서명 조회

select
    emp_id,
    emp_name,
    d.dept_title
from
    employee e join department d
        on e.dept_code = d.dept_id
where
    emp_name like '%형%';
    
--5. 해외영업팀에 근무하는 사원명, 직급명,부서코드, 부서명을 조회하시오


select
    e.emp_name,
    j.job_name,
    e.dept_code,
    d.dept_title
from
    employee e join department d
        on e.dept_code = d.dept_id
        join job j
        on e.job_code = j.job_code
where
    substr(d.dept_title,1,4) like '해외영업%';
    
--6. 보너스 포인트를 받는 직원들의 사원명, 보너스포인트,부서명,근무지역명을 조회 
select * from department;
select * from employee;
select * from location;
select * from job;
select
    emp_name,
    bonus,
    d.dept_title,
    l.local_name
from
    employee e join department d
        on e.dept_code = d.dept_id
        join location l
        on d.location_id = l.local_code
where
    bonus is not null;
    
--7. 부서코드가 D2인 직원들의 사원명,직급명,부서명,근무지역명 조회

select
    emp_name,
    j.job_name,
    d.dept_title,
    l.local_name
 
from
    employee e join department d
        on e.dept_code = d.dept_id
        join location l
        on d.location_id = l.local_code
        join job j
        on e.job_code = j.job_code
where
    e.dept_code = 'D2';
    
--8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--  (사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
select * from employee;
select * from department;
select * from job;
select * from location;
select * from nation;
select * from sal_grade;

select
    e.emp_name,
    j.job_name
from
        employee e join job j
        on e.job_code = j.job_code
        join sal_grade s
        on e.sal_level = s.sal_level
where
    e.salary > s.max_sal;

--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
-- 사원명, 부서명, 지역명, 국가명을 조회하시오.
select
    e.emp_name,
    d.dept_title,
    l.local_name,
    n.national_name
from
    employee e join department d
        on e.dept_code = d.dept_id
        join location l
        on d.location_id = l.local_code
        join nation n
        on l.national_code = n.national_code
where
    l.national_code in ('KO','JP');
    
--10.같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
--     self join 사용
select distinct
    e1.emp_name,
    e1.dept_code,
    e2.emp_name
from
    employee e1 join employee e2
    on  e1.dept_code = e2.dept_code;

-- 11.보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 
-- 직원들의 사원명, 직급명, 급여를 조회하시오.
select
    e.emp_name,
    j.job_name,
    e.salary
from
    employee e join job j
        on e.job_code = j.job_code
where
    e.bonus is null and j.job_name in ('차장','사원');
    
--12.재직중인 직원과 퇴사한 직원의 수를 조회하시오.
select * from employee;
select
    sum(decode(quit_yn,'N',1)) AS "재직중",
    sum(decode(quit_yn,'Y',1)) AS "퇴사"
from
    employee