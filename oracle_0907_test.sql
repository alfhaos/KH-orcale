-- 테이블생성 실습
--1.
create table EX_MEMBER(
    MEMBER_CODE number,         --회원전용코드
    MEMBER_ID varchar2(20) ,      -- 회원 아이디
    MEMBER_PWD char(20) not null,        --회원비밀번호
    MEMBER_NAME varchar2(30),       -- 회원 이름
    MEMBER_ADDR varchar2(100) not null,      --회원거주지
    MEMBER_GENDER char(3),      --성별
    PHONE char(11)  not null,      --회원 연락처
    
    constraint pk_exm_code primary key(MEMBER_CODE),
    constraint uq_exm_ID unique(MEMBER_ID),
    constraints ck_exm_gender check(MEMBER_GENDER in('남','여'))


);

--2.
create table EX_MEMBER_NICKNAME(

    MEMBER_CODE number,
    MEMBER_NICKNAME varchar2(100),
    
    constraint uq_emn_code unique(MEMBER_NICKNAME),
    constraint fk_emn_code foreign key(MEMBER_CODE) references EX_MEMBER(MEMBER_CODE),
    constraint pk_emn_nick primary key(MEMBER_CODE)
    
);

DESC  EX_MEMBER_NICKNAME;




