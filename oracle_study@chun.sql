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


--1. 의학계열 학과 학생의 학생명, 학과명 조회
select 
    s.student_name,
    d.department_name
    
from 
    tb_student s join tb_department d
        on s.department_no = d.department_no
where
    s.department_no in ('053','054','055');

--2. 2006학번의 학생명, 담당교수명 조회
select
    s.student_name,
    p.professor_name
from
    tb_student s join  tb_professor p
        on s.coach_professor_no = p.professor_no
where
    extract(year from entrance_date) = '2006';

--3.자연과학계열의  수업명, 학과명 조회
select
    c.class_name,
    d.department_name
from
    tb_class c join tb_department d
        on c.department_no = d.department_no
where
    d.category = '자연과학';
    
--4. 담당학생이 한명도 없는 교수 조회

-- inner join 579 --> 담당교수가 없는 학생 제외
-- left join 588 : 579 + 9 --> 담당교수가 없는 학생 포함
-- right join 580 : 579 + 1(담당학생이 없는 교수) --> 담당학생이 없는 교수 포함

select
    p.professor_name
from
    tb_student s right join tb_professor p
        on s.coach_professor_no = p.professor_no
where
    s.COACH_PROFESSOR_NO IS NULL;
    
--08-31 @실습문제
--1. 휴학중인 학번, 학생명, 학과명조회
select 
    S.student_no,
    S.student_name,
    d.department_name
from
    tb_student S join tb_department D
        on S.department_no = D.department_no
where
    absence_yn = 'Y';
    
--(oracle 전용문법)
select 
    S.student_no,
    S.student_name,
    d.department_name
from
    tb_student S ,tb_department D
where
    S.department_no = D.department_no
    and
    absence_yn ='Y';
    
--2. 수업번호, 수업명, 교수번호, 교수명 조회
select * from tb_professor;

select
    C.class_no,
    C.class_name,
    P.professor_no,
    P.professor_name
from
    tb_class_professor cp
         join tb_class C
            on cp.class_no = c.class_no
        join tb_professor P
            on cp.professor_no = p.professor_no;

--(oracle 전용문법)
select
    C.class_no,
    C.class_name,
    P.professor_no,
    P.professor_name
from
     tb_class_professor cp , tb_class c,tb_professor p
where
    cp.class_no = c.class_no
    and
    cp.professor_no = p.professor_no;
    
    

--3. 송박선 학생의 모든 학기 과목별 점수를 조회
--      학기,학번,학생명,수업명,점수
select
    G.term_no,
    s.student_no,
    s.student_name,
    C.class_name,
    G.point
from
    tb_grade G
        join tb_student S
            on G.student_no = s.student_no
        join tb_class C
            on g.class_no = C.class_no
where
    s.student_name = '송박선';


--(oracle 전용문법)
select
     G.term_no,
    s.student_no,
    s.student_name,
    C.class_name,
    G.point
from
    tb_grade g,tb_student s, tb_class c
where
    G.student_no = s.student_no
    and
    g.class_no = C.class_no
    and
     s.student_name = '송박선';



--4. 학생별 전체 평점(소숫점이하 버림) 조회
-- 학번, 학생명, 평점
select * from tb_student;

select
    G.student_no,
    S.student_name,
    trunc(avg(G.point))
from
    tb_grade G
        join tb_student S
            on G.student_no = S.student_no 
group by
    G.student_no,S.student_name;
    
    
--(oracle 전용문법)
select
    G.student_no,
    S.student_name,
    trunc(avg(G.point))

from
    tb_grade g,tb_student s
where
     G.student_no = S.student_no 
group by
    G.student_no,S.student_name;
    

--5. 교수번호, 교수명, 담당학생명수 조회
-- 단, 5명 이상의 학생이 담당하는 교수만 출력
select * from tb_student; --588개
select * from tb_professor; -- 114개

-- left join 588개 join + 9 (담당교수가 없는 학생포함)
-- join 579 개   담당교수가 없는 학생 제외
-- right join 580개 join + 1 (담당학생이 없는 교수 포함)

select
    p.professor_no,
    p.professor_name,
    count(*) cnt
from
   tb_student s  left join  tb_professor p
        on p.professor_no = s.coach_professor_no
where s.coach_professor_no is not null

group by
  p.professor_no,p.professor_name
having
    count(*) >= 5
order by cnt desc;



--(oracle 전용문법)
select
    p.professor_no,
    p.professor_name,
    count(*) cnt
from
    tb_student s, tb_professor p
where
    p.professor_no = s.coach_professor_no(+)
    and
    s.coach_professor_no is not null
group by
  p.professor_no,p.professor_name
having
    count(*) >= 5
order by cnt desc;




--0907 워크북 실습문제

--1.영어영문학과(학과코드002) 학생들의학번과이름, 입학년도를입학년도가빠른순으로표시하는SQL 문장을작성하시오.
--  (단, 헤더는"학번", "이름", "입학년도" 가표시되도록핚다.

select * from tb_department;
select * from tb_student; 

select
   student_no,
   student_name,
   extract(year from entrance_date)
from
    tb_student
where
    department_no = '002'

order by
    department_no desc;
    

--2.춘 기술대학교의 교수 중 이름이 세글자가 아닌 교수가 한 명 있다고 한다. 
--  그교수의 이름 과 주민번호를 화면에 출력하는 SQL 문장을 작성 해보자.
--  (*이때올바르게작성핚SQL 문장의결과값이예상과다르게나올수있다. 원인이무엇일지생각해볼것)

select 
    professor_name,
    professor_ssn
from 
    tb_professor
where
    professor_name not like '___';
    
--3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 sql 문장 작성
-- 나이가 적은 사람에서 많은 사람 순서로 화면에 출력 되도록 만들어라
--(단, 교수 중 2000년 이후 출생자는 없으며 출력 헤더는 "교수이름","나이"로 한다, 나이는"만"으로 계산)
select
    professor_name"교수이름",
     extract(year from sysdate) -  (decode(substr(professor_ssn,8,1),'1',1900,'2',1900) + substr(professor_ssn,1,2)) +1 "나이"
from
    tb_professor
where
    substr(professor_ssn,8,1) in ('1','3')
order by
    extract(year from sysdate) -  (decode(substr(professor_ssn,8,1),'1',1900,'2',1900) + substr(professor_ssn,1,2)) +1 asc;

--4. 교수들의 이름 중 성을 제외한 이름만 출력하는 sql 문장을 작성하시오, 출력 헤더는
--     "이름"이 찍히도록 한다. (성이 2자인 경우는 교수는 없다고 가정)
select
    substr(professor_name,2,2)"이름"
from
    tb_professor
where
    professor_name not like '__';


--5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 19살에 입학하면 재수를 하지 않은 것으로 간주
select * from tb_student;
select 
    student_no,
    student_name
from 
    tb_student
where
    (extract(year from entrance_date) - (decode(substr(student_ssn,8,1),'1',1900,'2',1900,2000) + substr(student_ssn,1,2))) > 19;   



--6.2020년 크리스마스 요일
select
    to_char(to_date('20201225','YYYYMMDD'),'day')
from  
    dual;
    
--7.TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD')은 각각 몇년 몇월 몇일을 의미 할까?
-- 또TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD')은 각각 몇년 몇월 몇일을 의미 할까?
select
    TO_DATE('99/10/11','YY/MM/DD'),
    TO_DATE('49/10/11','YY/MM/DD'),
    TO_DATE('99/10/11','RR/MM/DD'),
    TO_DATE('49/10/11','RR/MM/DD')
from
    dual;

-- 8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다.
--  2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오
select * from tb_student;

select
    student_no,
    student_name
from
    tb_student
where
    substr(student_no,1,1) not in ('A');
    
    
--9. 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성,
--      단 , 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지 표시
select * from tb_student;

select
    round(avg(g.point),1)"평점"
from
    tb_student s join tb_grade g
    on s.student_no = g.student_no
where
    s.student_no = 'A517178';
    
    
--10. 학과별 학생수를 구하여 "학과번호","학생수"의 형태로 해더를 만들어
--      결과값이 출력되도록 하시오
select
    department_no,
    count(student_no)
from
    tb_student 
group by
    department_no
order by
    department_no asc;
    
--11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 확인
select * from tb_student;

select
    count(*)
from
    tb_student
where
    coach_professor_no is null;
    
--12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL문을 작성하시오,
--      단 , 이때 헤더는 "년도","년도 별 평점" 찍히게 하고 점수는 반올림하여 소수점 이하 한자리까지
select * from tb_student;

select
    substr(term_no,1,4)"년도",
    round(avg(point),1)"년도 별 평점"
from
    tb_grade
where
    student_no = 'A112113'
group by
   substr(term_no,1,4);
   
--13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오
select
    department_no,
    count(*)
from
    tb_student
where
    absence_yn = 'Y'
group by
    department_no
order by
    department_no asc;

--14. 춘 대학교에 다니는 동명이인 학생들의 이름을 찾고자 한다.
--      어떤 SQL문장을 사용하면 가능하겠는가?
select
    student_name,
    count(student_name)
from
    tb_student
group by
    student_name
having
     count(student_name) >= 2;
     
--15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과
--      년도 별 누적 평점, 총 평점을 구하는 SQL문 작성
--      (평점은 소수점 1자리까지만 반올림)
select * from tb_grade;


select
    substr(term_no,1,4)"년도",
    substr(term_no,5,2)"학기",
    round(point,1)
from
    tb_grade
where
    student_no = 'A112113'
union
select
     substr(term_no,1,4)"년도",
     null,
    round(avg(point),1)"평점"
from
    tb_grade
where
    student_no = 'A112113'
group by
    substr(term_no,1,4)
union
    select
     null,
     null,
    round(avg(point),1)"평점"
from
    tb_grade
where
    student_no = 'A112113';