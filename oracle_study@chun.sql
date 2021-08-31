--===================================
-- 관리자계정
--===================================


alter session set "_oracle_script" = true;

create user chun
identified by chun
default tablespace users;

alter user chun quota unlimited on users;

grant connect, resource to chun;
--===================================
-- chun 계정
--===================================
select * from tb_department;
select * from tb_student;   --tb_student.department_no --> tb_department.department_no
                                         -- tb_student.coach_professor_no --> tb_professor.professor_no
                                         
select * from tb_professor;
select * from tb_class;
select * from tb_class_professor;
select * from tb_grade;


--실습문제 : chun 계정
--1. 학과테이블에서 계열별 정원의 평균을 조회(정원 내림차순 정렬)
select
    category,
    trunc(avg(capacity))정원평균
from
    tb_department
group by
    CATEGORY
order by
    2 desc;

--2. 휴학생을 제외하고, 학과별로 학생수를 조회(학과별 인원수 내림차순)
select
    department_no,
    count(*)
from
    tb_student
where 
    absence_yn != 'Y'
group by
    department_no
order by
    2 desc;
    
--3. 과목별 지정된 교수가 2명이상이 과목번호와 교수인원수를 조회
select
    class_no,
    count(*)
from
    tb_class_professor
group by
    class_no
having 
    count(*) >= 2;

--4. 학과별로 과목을 구분했을때, 과목구분이 "전공선택"에 한하여 과목수가 10개 이상인
--      행의 학과번호, 과목구분, 과목수를 조회(전공 선택 만 조회)
select
    department_no,
    class_type,
    count(*)
from
    tb_class
where
    class_type = '전공선택'
group by
    department_no,class_type
having
    count(*) >= 10
order by
    3;

--chun Basic SELECT
--1. 춘 기술대의 학과 이름과 계열을 표시하시오, 단 , 출력 헤더는 "학과 명", "계열",으로 표시
select
    department_name"학과 명",
    category"계열"
from    
    tb_department;

--2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
select
    department_name ||'의 정원은' || capacity|| '명 입니다.' AS "학과별 정원"
from    
    tb_department;
    
--3. "국어국문학과"에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다.
--      누구인가?
select
    student_name
from
     tb_student
where
    department_no = '001' and absence_yn = 'Y' and substr(student_ssn,8,1) != '1' ;

--4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 그 대상자들의
-- 학번이 다음과 같을 때 대상자들을 찾는 적절한 sql구문을 작성
select
  student_name
from 
    tb_student
where
    student_no = 'A513079'
    or student_no = 'A513119'
    or student_no = 'A513091'
    or student_no = 'A513110'
    or student_no = 'A513090' ;

--5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력
select
    department_name,
    category
from 
    tb_department
where
    capacity >= 20 and capacity <= 30;

--6. 춘기술대학교는총장을제외하고모든교수들이소속학과를가지고있다.
-- 그럼춘기술대학교총장의이름을알아낼수있는SQL 문장을작성하시오
select
    * 
from 
    tb_professor
where
    department_no is null;
--7. 혹시 전산상의착오로학과가지정되어있지않은학생이있는지확인하고자핚다. 어떠핚SQL 문장을사용하면될것인지작성하시오.
select 
    *
from 
    tb_student
where
    department_no is null;
    
-- 8. 선수과목 여부 확인 선수과목이 존재하는 과목들은 어떤 과목인지 조회
select
    class_no
from
    tb_class
where
    preattending_class_no is not null;
    
--9. 춘 대학에는 어떤 계열들이 있는지 조회
select
    category
from
    tb_department
group by
    category;

--10. 02학번 전주 거주자들의 모임 만들려고 한다. 휴학한 사람들은 제외한 재학중인
-- 학생들의 학번,이름 , 주민번호를 출력하는 구문 작성

select
    student_no,
    student_name,
    student_ssn
from
    tb_student
where
  extract(year from entrance_date) = 2002 and  substr(student_address,1,3) ='전주시' and absence_yn = 'N';
