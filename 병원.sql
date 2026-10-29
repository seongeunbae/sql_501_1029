-- ============================================
-- 병원(HOSPITAL) 실습용 데이터베이스
-- Oracle 전용 / 계정 무관 실행 가능
-- ============================================
-- 테이블 구성
--   DEPT      (진료과)      
--   WARD      (병동)       
--   POSITION  (직급)       
--   DOCTOR    (의사)      
--   PATIENT   (환자)       

-- ============================================

-- 기존 테이블 삭제 (의존 순서: PATIENT → DOCTOR → WARD, DEPT, POSITION)
DROP TABLE PATIENT CASCADE CONSTRAINT PURGE;
DROP TABLE DOCTOR CASCADE CONSTRAINT PURGE;
DROP TABLE WARD CASCADE CONSTRAINT PURGE;
DROP TABLE DEPT CASCADE CONSTRAINT PURGE;
DROP TABLE POSITION CASCADE CONSTRAINT PURGE;

-- ============================================
-- 1. DEPT (진료과)
-- ============================================
CREATE TABLE DEPT (
    DEPT_ID    CHAR(2)        NOT NULL,
    DEPT_NAME  VARCHAR2(30)   NOT NULL,
    DEPT_TYPE  VARCHAR2(10)   NOT NULL,
    CONSTRAINT DEPT_PK PRIMARY KEY (DEPT_ID)
);

COMMENT ON TABLE  DEPT           IS '진료과';
COMMENT ON COLUMN DEPT.DEPT_ID   IS '진료과코드';
COMMENT ON COLUMN DEPT.DEPT_NAME IS '진료과명';
COMMENT ON COLUMN DEPT.DEPT_TYPE IS '계열(내과계/외과계/기타)';

INSERT INTO DEPT VALUES ('D1', '내과',         '내과계');
INSERT INTO DEPT VALUES ('D2', '외과',         '외과계');
INSERT INTO DEPT VALUES ('D3', '소아청소년과', '내과계');
INSERT INTO DEPT VALUES ('D4', '정형외과',     '외과계');
INSERT INTO DEPT VALUES ('D5', '신경외과',     '외과계');
INSERT INTO DEPT VALUES ('D6', '산부인과',     '외과계');
INSERT INTO DEPT VALUES ('D7', '응급의학과',   '기타');
INSERT INTO DEPT VALUES ('D8', '피부과',       '내과계');


-- ============================================
-- 2. WARD (병동)
-- ============================================
CREATE TABLE WARD (
    WARD_ID    CHAR(2)        NOT NULL,
    WARD_NAME  VARCHAR2(30)   NOT NULL,
    WARD_TYPE  VARCHAR2(10)   NOT NULL,
    FLOOR_NO   NUMBER         NOT NULL,
    CONSTRAINT WARD_PK PRIMARY KEY (WARD_ID)
);

COMMENT ON TABLE  WARD           IS '병동';
COMMENT ON COLUMN WARD.WARD_ID   IS '병동코드';
COMMENT ON COLUMN WARD.WARD_NAME IS '병동명';
COMMENT ON COLUMN WARD.WARD_TYPE IS '병동구분(일반/중환자/특실)';
COMMENT ON COLUMN WARD.FLOOR_NO  IS '층수';

INSERT INTO WARD VALUES ('W1', '일반병동A', '일반',   3);
INSERT INTO WARD VALUES ('W2', '일반병동B', '일반',   4);
INSERT INTO WARD VALUES ('W3', '중환자실',  '중환자', 2);
INSERT INTO WARD VALUES ('W4', '소아병동',  '일반',   5);
INSERT INTO WARD VALUES ('W5', 'VIP특실',   '특실',   8);


-- ============================================
-- 3. POSITION (직급)
-- ============================================
CREATE TABLE POSITION (
    POSITION_ID    CHAR(2)        NOT NULL,
    POSITION_NAME  VARCHAR2(20)   NOT NULL,
    POSITION_LEVEL NUMBER         NOT NULL,
    CONSTRAINT POSITION_PK PRIMARY KEY (POSITION_ID)
);

COMMENT ON TABLE  POSITION                IS '직급';
COMMENT ON COLUMN POSITION.POSITION_ID    IS '직급코드';
COMMENT ON COLUMN POSITION.POSITION_NAME  IS '직급명';
COMMENT ON COLUMN POSITION.POSITION_LEVEL IS '직급순위(1이 가장 높음)';

INSERT INTO POSITION VALUES ('J1', '과장',   1);
INSERT INTO POSITION VALUES ('J2', '전문의', 2);
INSERT INTO POSITION VALUES ('J3', '전공의', 3);
INSERT INTO POSITION VALUES ('J4', '인턴',   4);


-- ============================================
-- 4. DOCTOR (의사)
-- ============================================
CREATE TABLE DOCTOR (
    DOCTOR_ID   CHAR(4)        NOT NULL,
    DOCTOR_NAME VARCHAR2(30)   NOT NULL,
    DEPT_ID     CHAR(2),
    POSITION_ID CHAR(2)        NOT NULL,
    HIRE_DATE   DATE           NOT NULL,
    CONSTRAINT DOCTOR_PK PRIMARY KEY (DOCTOR_ID),
    CONSTRAINT DOCTOR_DEPT_FK     FOREIGN KEY (DEPT_ID)     REFERENCES DEPT (DEPT_ID),
    CONSTRAINT DOCTOR_POSITION_FK FOREIGN KEY (POSITION_ID) REFERENCES POSITION (POSITION_ID)
);

COMMENT ON TABLE  DOCTOR             IS '의사';
COMMENT ON COLUMN DOCTOR.DOCTOR_ID   IS '의사코드';
COMMENT ON COLUMN DOCTOR.DOCTOR_NAME IS '의사명';
COMMENT ON COLUMN DOCTOR.DEPT_ID     IS '소속진료과코드(NULL=미배정)';
COMMENT ON COLUMN DOCTOR.POSITION_ID IS '직급코드';
COMMENT ON COLUMN DOCTOR.HIRE_DATE   IS '입사일';


INSERT INTO DOCTOR VALUES ('DR01', '장기려', 'D2', 'J1', TO_DATE('2003-03-02', 'YYYY-MM-DD'));  -- 외과 과장
INSERT INTO DOCTOR VALUES ('DR02', '슈바이처', 'D2', 'J2', TO_DATE('2010-03-01', 'YYYY-MM-DD'));
INSERT INTO DOCTOR VALUES ('DR03', '프로이트', 'D5', 'J1', TO_DATE('2006-09-01', 'YYYY-MM-DD'));  -- 신경외과 과장
INSERT INTO DOCTOR VALUES ('DR04', '지석영', 'D3', 'J1', TO_DATE('2008-03-03', 'YYYY-MM-DD'));  -- 소아청소년과 과장
INSERT INTO DOCTOR VALUES ('DR05', '제너', 'D3', 'J3', TO_DATE('2019-03-04', 'YYYY-MM-DD'));
INSERT INTO DOCTOR VALUES ('DR06', '박에스더', 'D6', 'J1', TO_DATE('2009-05-11', 'YYYY-MM-DD'));  -- 산부인과 과장
INSERT INTO DOCTOR VALUES ('DR07', '나이팅게일', 'D7', 'J1', TO_DATE('2011-07-18', 'YYYY-MM-DD'));  -- 응급의학과 과장
INSERT INTO DOCTOR VALUES ('DR08', '이태석', 'D7', 'J3', TO_DATE('2016-03-02', 'YYYY-MM-DD'));
INSERT INTO DOCTOR VALUES ('DR09', '허준', 'D1', 'J1', TO_DATE('2007-01-15', 'YYYY-MM-DD'));  -- 내과 과장
INSERT INTO DOCTOR VALUES ('DR10', '플레밍', 'D2', 'J2', TO_DATE('2012-03-05', 'YYYY-MM-DD'));
INSERT INTO DOCTOR VALUES ('DR11', '히포크라테스', 'D4', 'J1', TO_DATE('2015-09-07', 'YYYY-MM-DD'));  -- 정형외과 과장
INSERT INTO DOCTOR VALUES ('DR12', '파스퇴르', NULL, 'J4', TO_DATE('2026-03-02', 'YYYY-MM-DD'));  -- 인턴(진료과 미배정, 담당 환자 없음)


-- ============================================
-- 5. PATIENT (환자)
-- ============================================
CREATE TABLE PATIENT (
    PATIENT_ID     CHAR(3)        NOT NULL,
    PATIENT_NAME   VARCHAR2(20)   NOT NULL,
    DEPT_ID        CHAR(2)        NOT NULL,
    WARD_ID        CHAR(2)        NOT NULL,
    DOCTOR_ID      CHAR(4),
    GENDER         CHAR(1)        NOT NULL,
    BLOOD_TYPE     VARCHAR2(2)    NOT NULL,
    HEIGHT_CM      NUMBER         NOT NULL,
    WEIGHT_KG      NUMBER         NOT NULL,
    BIRTH_DATE     DATE           NOT NULL,
    ADMISSION_DATE DATE           NOT NULL,
    DISCHARGE_DATE DATE,
    DIAGNOSIS      VARCHAR2(50)   NOT NULL,
    CONSTRAINT PATIENT_PK PRIMARY KEY (PATIENT_ID),
    CONSTRAINT PATIENT_DEPT_FK   FOREIGN KEY (DEPT_ID)   REFERENCES DEPT (DEPT_ID),
    CONSTRAINT PATIENT_WARD_FK   FOREIGN KEY (WARD_ID)   REFERENCES WARD (WARD_ID),
    CONSTRAINT PATIENT_DOCTOR_FK FOREIGN KEY (DOCTOR_ID) REFERENCES DOCTOR (DOCTOR_ID),
    CONSTRAINT PATIENT_GENDER_CK CHECK (GENDER IN ('M', 'F')),
    CONSTRAINT PATIENT_BLOOD_CK  CHECK (BLOOD_TYPE IN ('A', 'B', 'O', 'AB'))
);

COMMENT ON TABLE  PATIENT                IS '환자';
COMMENT ON COLUMN PATIENT.PATIENT_ID     IS '환자코드';
COMMENT ON COLUMN PATIENT.PATIENT_NAME   IS '환자명';
COMMENT ON COLUMN PATIENT.DEPT_ID        IS '진료과코드';
COMMENT ON COLUMN PATIENT.WARD_ID        IS '병동코드';
COMMENT ON COLUMN PATIENT.DOCTOR_ID      IS '담당의코드(NULL=미배정)';
COMMENT ON COLUMN PATIENT.GENDER         IS '성별(M/F)';
COMMENT ON COLUMN PATIENT.BLOOD_TYPE     IS '혈액형(A/B/O/AB)';
COMMENT ON COLUMN PATIENT.HEIGHT_CM      IS '키(cm)';
COMMENT ON COLUMN PATIENT.WEIGHT_KG      IS '몸무게(kg)';
COMMENT ON COLUMN PATIENT.BIRTH_DATE     IS '생년월일';
COMMENT ON COLUMN PATIENT.ADMISSION_DATE IS '입원일';
COMMENT ON COLUMN PATIENT.DISCHARGE_DATE IS '퇴원일(NULL=입원 중)';
COMMENT ON COLUMN PATIENT.DIAGNOSIS      IS '진단명';

-- 외과 (D2) : 장기려(DR01) / 슈바이처(DR02) / 플레밍(DR10)
INSERT INTO PATIENT VALUES ('P01', '김민준', 'D2', 'W1', 'DR02', 'M', 'A',  175, 72, TO_DATE('1985-04-12','YYYY-MM-DD'), TO_DATE('2026-09-01','YYYY-MM-DD'), TO_DATE('2026-09-10','YYYY-MM-DD'), '급성 충수염');
INSERT INTO PATIENT VALUES ('P02', '이서연', 'D2', 'W2', 'DR02', 'F', 'O',  162, 55, TO_DATE('1992-11-03','YYYY-MM-DD'), TO_DATE('2026-10-15','YYYY-MM-DD'), NULL,                               '담낭염');
INSERT INTO PATIENT VALUES ('P03', '박도윤', 'D2', 'W3', 'DR01', 'M', 'B',  180, 85, TO_DATE('1968-07-21','YYYY-MM-DD'), TO_DATE('2026-10-20','YYYY-MM-DD'), NULL,                               '간암');
INSERT INTO PATIENT VALUES ('P04', '최지우', 'D2', 'W1', 'DR10', 'F', 'AB', 158, 50, TO_DATE('2001-02-14','YYYY-MM-DD'), TO_DATE('2026-08-05','YYYY-MM-DD'), TO_DATE('2026-08-09','YYYY-MM-DD'), '급성 충수염');
INSERT INTO PATIENT VALUES ('P05', '정하준', 'D2', 'W5', 'DR01', 'M', 'A',  172, 78, TO_DATE('1955-09-30','YYYY-MM-DD'), TO_DATE('2026-10-01','YYYY-MM-DD'), NULL,                               '위암');
INSERT INTO PATIENT VALUES ('P06', '강서윤', 'D2', 'W2', 'DR10', 'F', 'A',  165, 60, TO_DATE('1979-12-25','YYYY-MM-DD'), TO_DATE('2026-07-12','YYYY-MM-DD'), TO_DATE('2026-07-20','YYYY-MM-DD'), '서혜부 탈장');
INSERT INTO PATIENT VALUES ('P07', '조예준', 'D2', 'W1', NULL,   'M', 'O',  177, 70, TO_DATE('1998-06-08','YYYY-MM-DD'), TO_DATE('2026-10-25','YYYY-MM-DD'), NULL,                               '담석증');   -- 담당의 미배정

-- 내과 (D1) : 허준(DR09)
INSERT INTO PATIENT VALUES ('P08', '윤지호', 'D1', 'W1', 'DR09', 'M', 'B',  170, 80, TO_DATE('1960-03-17','YYYY-MM-DD'), TO_DATE('2026-10-05','YYYY-MM-DD'), NULL,                               '당뇨병');
INSERT INTO PATIENT VALUES ('P09', '임채원', 'D1', 'W2', 'DR09', 'F', 'A',  160, 52, TO_DATE('1988-08-29','YYYY-MM-DD'), TO_DATE('2026-09-18','YYYY-MM-DD'), TO_DATE('2026-09-25','YYYY-MM-DD'), '폐렴');
INSERT INTO PATIENT VALUES ('P10', '한지안', 'D1', 'W3', 'DR09', 'F', 'O',  155, 48, TO_DATE('1942-01-09','YYYY-MM-DD'), TO_DATE('2026-10-18','YYYY-MM-DD'), NULL,                               '심부전');
INSERT INTO PATIENT VALUES ('P11', '오시우', 'D1', 'W1', 'DR09', 'M', 'AB', 178, 90, TO_DATE('1975-05-05','YYYY-MM-DD'), TO_DATE('2026-06-10','YYYY-MM-DD'), TO_DATE('2026-06-17','YYYY-MM-DD'), '고혈압');
INSERT INTO PATIENT VALUES ('P12', '서하은', 'D1', 'W5', 'DR09', 'F', 'B',  163, 58, TO_DATE('1950-10-10','YYYY-MM-DD'), TO_DATE('2026-10-22','YYYY-MM-DD'), NULL,                               '간경변');
INSERT INTO PATIENT VALUES ('P13', '신준서', 'D1', 'W2', 'DR09', 'M', 'A',  168, 74, TO_DATE('1995-04-01','YYYY-MM-DD'), TO_DATE('2026-08-20','YYYY-MM-DD'), TO_DATE('2026-08-27','YYYY-MM-DD'), '위염');

-- 소아청소년과 (D3) : 지석영(DR04) / 제너(DR05)  → 소아병동(W4)
INSERT INTO PATIENT VALUES ('P14', '권유진', 'D3', 'W4', 'DR04', 'F', 'A',  110, 19, TO_DATE('2019-06-15','YYYY-MM-DD'), TO_DATE('2026-10-12','YYYY-MM-DD'), NULL,                               '폐렴');
INSERT INTO PATIENT VALUES ('P15', '황시온', 'D3', 'W4', 'DR05', 'M', 'O',   95, 15, TO_DATE('2021-09-02','YYYY-MM-DD'), TO_DATE('2026-10-24','YYYY-MM-DD'), NULL,                               '급성 장염');
INSERT INTO PATIENT VALUES ('P16', '송지민', 'D3', 'W4', 'DR05', 'F', 'B',  140, 35, TO_DATE('2014-03-20','YYYY-MM-DD'), TO_DATE('2026-09-03','YYYY-MM-DD'), TO_DATE('2026-09-07','YYYY-MM-DD'), '급성 장염');
INSERT INTO PATIENT VALUES ('P17', '류하율', 'D3', 'W4', 'DR04', 'M', 'AB', 125, 25, TO_DATE('2017-12-11','YYYY-MM-DD'), TO_DATE('2026-07-30','YYYY-MM-DD'), TO_DATE('2026-08-03','YYYY-MM-DD'), '천식');
INSERT INTO PATIENT VALUES ('P18', '전서준', 'D3', 'W4', 'DR04', 'M', 'A',  160, 52, TO_DATE('2010-05-18','YYYY-MM-DD'), TO_DATE('2026-10-19','YYYY-MM-DD'), NULL,                               '급성 충수염');
INSERT INTO PATIENT VALUES ('P19', '문아린', 'D3', 'W4', 'DR05', 'F', 'O',   85, 12, TO_DATE('2023-02-28','YYYY-MM-DD'), TO_DATE('2026-09-28','YYYY-MM-DD'), TO_DATE('2026-10-02','YYYY-MM-DD'), '기관지염');

-- 신경외과 (D5) : 프로이트(DR03)
INSERT INTO PATIENT VALUES ('P20', '배준혁', 'D5', 'W3', 'DR03', 'M', 'B',  176, 77, TO_DATE('1963-08-08','YYYY-MM-DD'), TO_DATE('2026-10-16','YYYY-MM-DD'), NULL,                               '뇌출혈');
INSERT INTO PATIENT VALUES ('P21', '양수아', 'D5', 'W2', 'DR03', 'F', 'A',  161, 54, TO_DATE('1981-01-23','YYYY-MM-DD'), TO_DATE('2026-09-10','YYYY-MM-DD'), TO_DATE('2026-09-20','YYYY-MM-DD'), '추간판 탈출증');
INSERT INTO PATIENT VALUES ('P22', '백현우', 'D5', 'W5', 'DR03', 'M', 'O',  182, 88, TO_DATE('1972-11-11','YYYY-MM-DD'), TO_DATE('2026-10-08','YYYY-MM-DD'), NULL,                               '뇌종양');
INSERT INTO PATIENT VALUES ('P23', '노은서', 'D5', 'W2', 'DR03', 'F', 'AB', 157, 49, TO_DATE('1999-07-07','YYYY-MM-DD'), TO_DATE('2026-08-14','YYYY-MM-DD'), TO_DATE('2026-08-18','YYYY-MM-DD'), '편두통');

-- 정형외과 (D4) : 히포크라테스(DR11)
INSERT INTO PATIENT VALUES ('P24', '하도현', 'D4', 'W1', 'DR11', 'M', 'A',  174, 71, TO_DATE('2003-03-03','YYYY-MM-DD'), TO_DATE('2026-10-21','YYYY-MM-DD'), NULL,                               '대퇴골 골절');
INSERT INTO PATIENT VALUES ('P25', '심지유', 'D4', 'W2', 'DR11', 'F', 'O',  159, 53, TO_DATE('1958-12-01','YYYY-MM-DD'), TO_DATE('2026-10-11','YYYY-MM-DD'), NULL,                               '고관절 골절');
INSERT INTO PATIENT VALUES ('P26', '곽민재', 'D4', 'W1', 'DR11', 'M', 'B',  171, 69, TO_DATE('1990-09-19','YYYY-MM-DD'), TO_DATE('2026-09-14','YYYY-MM-DD'), TO_DATE('2026-09-21','YYYY-MM-DD'), '전방십자인대 파열');
INSERT INTO PATIENT VALUES ('P27', '남유나', 'D4', 'W2', 'DR11', 'F', 'A',  164, 57, TO_DATE('1986-06-26','YYYY-MM-DD'), TO_DATE('2026-07-02','YYYY-MM-DD'), TO_DATE('2026-07-06','YYYY-MM-DD'), '손목 골절');

-- 산부인과 (D6) : 박에스더(DR06)
INSERT INTO PATIENT VALUES ('P28', '안소율', 'D6', 'W2', 'DR06', 'F', 'A',  163, 65, TO_DATE('1993-04-04','YYYY-MM-DD'), TO_DATE('2026-10-23','YYYY-MM-DD'), NULL,                               '자연분만');
INSERT INTO PATIENT VALUES ('P29', '장서현', 'D6', 'W5', 'DR06', 'F', 'O',  167, 68, TO_DATE('1989-10-30','YYYY-MM-DD'), TO_DATE('2026-10-17','YYYY-MM-DD'), TO_DATE('2026-10-21','YYYY-MM-DD'), '제왕절개');
INSERT INTO PATIENT VALUES ('P30', '주하린', 'D6', 'W2', 'DR06', 'F', 'B',  160, 54, TO_DATE('1976-02-02','YYYY-MM-DD'), TO_DATE('2026-08-25','YYYY-MM-DD'), TO_DATE('2026-08-29','YYYY-MM-DD'), '자궁근종');

-- 응급의학과 (D7) : 나이팅게일(DR07) / 이태석(DR08)
INSERT INTO PATIENT VALUES ('P31', '홍지훈', 'D7', 'W3', 'DR07', 'M', 'AB', 179, 82, TO_DATE('1983-05-15','YYYY-MM-DD'), TO_DATE('2026-10-26','YYYY-MM-DD'), NULL,                               '교통사고 다발성 외상');
INSERT INTO PATIENT VALUES ('P32', '탁예린', 'D7', 'W1', 'DR08', 'F', 'A',  156, 47, TO_DATE('2005-08-21','YYYY-MM-DD'), TO_DATE('2026-10-25','YYYY-MM-DD'), NULL,                               '급성 알레르기');
INSERT INTO PATIENT VALUES ('P33', '변시윤', 'D7', 'W1', 'DR08', 'M', 'O',  173, 75, TO_DATE('1947-07-19','YYYY-MM-DD'), TO_DATE('2026-10-24','YYYY-MM-DD'), TO_DATE('2026-10-26','YYYY-MM-DD'), '열사병');
INSERT INTO PATIENT VALUES ('P34', '공서아', 'D7', 'W3', 'DR07', 'F', 'B',  162, 56, TO_DATE('1970-03-09','YYYY-MM-DD'), TO_DATE('2026-10-13','YYYY-MM-DD'), NULL,                               '급성 심근경색');

-- 피부과 (D8) : 소속 의사 없음 → 담당의 미배정
INSERT INTO PATIENT VALUES ('P35', '도윤서', 'D8', 'W1', NULL,   'F', 'A',  166, 58, TO_DATE('2000-01-01','YYYY-MM-DD'), TO_DATE('2026-10-19','YYYY-MM-DD'), TO_DATE('2026-10-22','YYYY-MM-DD'), '대상포진');
INSERT INTO PATIENT VALUES ('P36', '염태양', 'D8', 'W1', NULL,   'M', 'O',  170, 66, TO_DATE('1965-11-28','YYYY-MM-DD'), TO_DATE('2026-10-26','YYYY-MM-DD'), NULL,                               '봉와직염');

COMMIT;
