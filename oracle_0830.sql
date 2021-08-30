-- 실습문제 남여사원의 수를 조회
select
  sum(case when substr(emp_no,8,1) in ('1','3') then 1 else 0 end)"남",
  sum(case when substr(emp_no,8,1) in ('2','4') then 1 else 0 end)"여"
from
    employee;
    
--==함수 실습문제==
--1.직원명과 이메일, 이메일 길이 출력
select
    emp_name,
    email,
    length(email)"이메일길이"
from
    employee;

--2. 직원의 이름과 이메일 주소중 아이디 부분만 출력
select
    emp_name,
    substr(email,1,instr(email,'@')-1)
from
    employee;

--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력
--      보너스가 null일때 0출력
select
    emp_name,
   '19' || to_char(substr(emp_no,1,2))"년생",
     nvl2(bonus,bonus,'0')
    
from
    employee;

--4. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)
select
  (count(phone)- sum(case when substr(phone,1,3) in ('010') then 1 else 0 end)||'명')"010안쓰는사람들"
from
    employee;
--5. 직원명과 입사년월을 출력하시오
select
    emp_name,
    (extract(year from hire_date) || '년')|| extract(month from hire_date) ||'월' AS"입사년월"
from
    employee;

--6. 직원명과 주민번호를 조회하시오
select
    emp_name,
   rpad(substr(emp_no,1,8),14,'*')
from
    employee;

--7. 직원명, 직급코드, 연봉 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--    연봉은 보너스포인트가 적용된 1년치 급여임
select
    emp_name,
    job_code,
  '\' ||to_char( nvl2(bonus,(salary * 12)+((salary * 12) * bonus),(salary * 12)),'999,999,999')
from
    employee;
    
--8.부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
 --  사번 사원명 부서코드 입사일

select
    emp_id,
    emp_name,
    dept_code,
    hire_date
from
    employee
    
where
    dept_code in ('D5','D9') AND extract(year from hire_date) = '2004';
 
 --9. 직원명, 입사일, 오늘까지의 근무일수 조회 
--	* 주말도 포함 , 소수점 아래는 버림
--	* 퇴사자는 퇴사일-입사일로 계산
select
    emp_name,
    hire_date,
    nvl2(quit_date,quit_date-hire_date,trunc(to_number(sysdate - to_date(hire_date)),-1))AS "근무일수"
from
    employee;
--10. 직원명, 부서코드, 생년월일, 나이(만) 조회
--  단, 생년월일은 주민번호에서 추출해서, 
--  ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--  나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
select
    emp_name, 
    dept_code,
     (decode(substr(emp_no,8,1),'1',1900,'2',1900,2000) + substr(emp_no,1,2) || '년') || (substr(emp_no,3,2) || '월') ||  (substr(emp_no,5,2) || '일')AS "생년월일",
   extract(year from sysdate)- extract(year from to_date(substr(emp_no,1,6)))+1||'세'AS"나이"

from
    employee;
    
--11.  직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
--아래의 년도에 입사한 인원수를 조회하시오. 마지막으로 전체직원수도 구하시오

    
-- 12.부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.
select
    emp_name,
    dept_code,
    case dept_code
        when 'D5' then '총무부'
        when 'D6' then '기획부'
        else '영업부' end
from
    employee
where
    dept_code in('D5','D6','D9')
order by
    dept_code asc;