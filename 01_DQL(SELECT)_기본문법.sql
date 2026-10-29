/*
 오늘부터 SQL 학습을 시작
 SQL문을 이용해서 저장이 되어있는 데이터를 조회하는 방법!!

 <SELECT>
 데이터를 조회하거나 검색할 때 사용하는 명령어
 
 SELECT
         조회하고자 하는 컬럼
   FROM
         테이블명;          

*/

-- PATIENT 테이블에서 모든 컬럼을 전부 다 조회
SELECT * FROM PATIENT;  -- 성능에 영향을 끼치므로 실무에서는 사용할 수 없음
                        -- 셀렉트와의 사이에 컬럼명을 적어줘야함
                        
SELECT 
         PATIENT_ID
       , PATIENT_NAME
       , DEPT_ID
       , WARD_ID
       , DOCTOR_ID
FROM
         PATIENT;  -- 항상 필요한 컬럼만 명시해서 조회

-- 명령어, 키워드, 테이블명, 컬럼명
SELECT patient_name FROM patient;

--------------------------------------------------------------------------
--실습문제
--1. DEPT 테이블에서 DEPT_ID, DEPT_NAME컬럼을 조회
--2. WARD 테이블에서 WARD_NAME(병동명)컬럼 조회
--3. DOCTOR 테이블에서 DOCTOR_NAME, HIRE_DATE 컬럼을 조회
--4. PATIENT 테이블에서 PATIENT_NAME, GENDER 컬럼을 조회
--5. PATIENT 테이블에서 BIRTH_DATE, PATIENT_NAME 컬럼을 조회

SELECT  
         DEPT_ID
       , DEPT_NAME
  FROM
         DEPT;

SELECT   
         WARD_NAME
  FROM    
         WARD;

SELECT 
         DOCTOR_NAME
       , HIRE_DATE
  FROM 
         DOCTOR;

SELECT 
         PATIENT_NAME
       , GENDER
  FROM 
         PATIENT;

SELECT
         BIRTH_DATE
       , PATIENT_NAME
  FROM 
         PATIENT;
      
--------------------------------------------------------------------------
/*
 * SELECT절에 산술연산을 할 수 있음
 */

-- PATIENT 테이블로부터 환자명, 키(cm)조회
SELECT 
        PATIENT_NAME
      , HEIGHT_CM 
      , HEIGHT_CM / 100
  FROM 
        PATIENT;

-- PATIENT 테이블로부터 환자명, 몸무게
SELECT
        PATIENT_NAME
      , WEIGHT_KG
      , WEIGHT_KG / ((HEIGHT_CM / 100) * (HEIGHT_CM / 100))
  FROM 
        PATIENT;

-- DATE끼리의 연산 -> 입원기간(퇴원일 - 입원일)
SELECT
        PATIENT_NAME
      , ADMISSION_DATE
      , DISCHARGE_DATE
      , DISCHARGE_DATE - ADMISSION_DATE  -- NULL이랑 연산을 하면 NULL이 나온다
  FROM 
        PATIENT;

-- 오늘까지 입원한 일수 (오늘날짜 - 입원일)
SELECT 
        PATIENT_NAME
      , ADMISSION_DATE
      , SYSDATE - ADMISSION_DATE
  FROM 
        PATIENT;

--------------------------------------------------------------------------
-- ResultSet : SELECT문을 통해 조회된 데이터 결과물(행들의 집합)
/*
 * 컬럼명이 너무 복잡할때 -> 별칭을 부여하기!
 * 
 * 컬럼명 별칭, 컬럼명 AS 별칭, 컬럼명 "별칭", 컬럼명 AS "별칭"
 * 
 * <리터럴>
 * 오라클에서 문자열을 다룰 땐 ''을 사용
 * 문자열을 SELECT절에 기술해서 ResultSet에 조회할 수 있음
 */ 
SELECT 
        HEIGHT_CM AS 키
      , 'cm'
  FROM      
        PATIENT;

---------------------------------------------------------------------------

SELECT 
        DISTINCT BLOOD_TYPE
  FROM      
        PATIENT;

SELECT 
        PATIENT_NAME
      , BLOOD_TYPE
  FROM    
        PATIENT;

-- DISTINCT 조회시 중복제거 SELECT할 땐 한개만 사용 가능

---------------------------------------------------------------------------
/*
 * < WHERE 절 >
 * 조건을 제시해서 조건에 만족하는 행만 조회
 * 
 * < 비교연산자 >
 * 동등비교 : =, !=
 * 대소비교 : <, >, <=, >=
 */

-- PATIENT 테이블에서 환자들의 이름, 몸무게 조회 --> 몸무게가 80kg이상인 사람들만 조회
SELECT 
        PATIENT_NAME
      , WEIGHT_KG
  FROM      
        PATIENT
 WHERE
        WEIGHT_KG >= 80;

-- PATIENT 테이블에서 환자들의 이름, 성별 조회
SELECT 
        PATIENT_NAME
      , GENDER
  FROM    
        PATIENT
 WHERE 
        GENDER != 'F';  --GENDER <> 'M';

-- 순서 1. FROM -> 2. WHERE -> 3. SELECT
--------------------------------------------------------------------------
/*
 * < 논리 연산자 >
 * AND / OR
 */
-- 병동코드 W3(중환자실)이면서 키가 170cm 이상인 환자들 이름, 병동코드, 키 조회

SELECT 
        PATIENT_NAME
      , WARD_ID
      , HEIGHT_CM
  FROM      
        PATIENT
 WHERE 
        WARD_ID = 'W3'
   AND  -- OR
        HEIGHT_CM >=170;

-- 키가 160이상 170이하인 환자들의 이름 키를 조회하시오

SELECT 
        PATIENT_NAME
      , HEIGHT_CM
  FROM  
        PATIENT 
 WHERE  
        HEIGHT_CM <= 170
   AND     
         HEIGHT_CM >= 160 ;

-------------------------------------------------------------------------

SELECT 
        PATIENT_NAME
      , HEIGHT_CM
  FROM     
        PATIENT
 WHERE
        HEIGHT_CM BETWEEN 160 AND 170;  -- 보기가 간단 => 권장사항 
-- HEIGHT_CM NOT BETWEEN 160 AND 170;
-- 몇 이상 몇 이하인 범위에 대한 조건을 제시할 때 < BETWEEN AND >       
--------------------------------------------------------------------------
-- 1990(1990 ~ 1999년)에 태어난 환자들의 이름, 생년월일 조회 

SELECT 
        PATIENT_NAME
      , BIRTH_DATE
  FROM 
        PATIENT
 WHERE 
        BIRTH_DATE BETWEEN TO_DATE('1990-01-01', 'YYYY-MM-DD')
                       AND TO_DATE('1999-12-31', 'YYYY-MM-DD');

---------------------------------------------------------------------------
/*
 * < LIKE '특정패턴' >
 * 컬럼의 값이 지정한 특정 패턴에 만족할 경우 조회
 * 
 * '%' : 0글자 이상
 * LIKE '김%' => '김'으로 시작하는 모든 글자
 * LIKE '%김' => '김'으로 끝나는 모든 글자
 * LIKE '%김%' => '김'이 포함되는 모든 글자
 */        
-- 환자들의 이름, 진단명 조회 --> 골절 환자 찾기

SELECT 
        PATIENT_NAME
      , DIAGNOSIS
  FROM 
        PATIENT
 WHERE
        DIAGNOSIS LIKE '%골절';

SELECT 
        PATIENT_NAME
      , DIAGNOSIS
  FROM 
        PATIENT
 WHERE 
        DIAGNOSIS LIKE '%급성%';
        
-- 이름이 2글자인 의사들만 조회

SELECT
        DOCTOR_NAME
  FROM 
        DOCTOR
 WHERE 
        DOCTOR_NAME LIKE '__';

-------------------------------------------------------------------------
/*
 * < IS NULL > 
 */
-- 현재 입원 중인 환자들 조회

SELECT 
        PATIENT_NAME
      , DISCHARGE_DATE 
  FROM       
        PATIENT
 WHERE 
       -- DISCHARGE_DATE = NULL;  -> NULL은 동등비교로 비교 불가능
        DISCHARGE_DATE IS NULL;

SELECT 
        PATIENT_NAME
      , DISCHARGE_DATE
  FROM 
        PATIENT
 WHERE 
        DISCHARGE_DATE IS NOT NULL;

------------------------------------------------------------------------        

SELECT 
        PATIENT_NAME || '의 담당의 코드는 ' || DOCTOR_ID || '입니다' 별칭
  FROM 
        PATIENT;

-- 연결연산자 || 여러 개의 값들을 하나의 컬럼값처럼 연결하는 연산자

------------------------------------------------------------------------
-- 혈액형이 A형이거나 B형이거나 O형인 환자들의 이름, 혈액형

SELECT 
        PATIENT_NAME
      , BLOOD_TYPE  
  FROM      
        PATIENT
 WHERE 
        BLOOD_TYPE != 'AB';

SELECT 
        PATIENT_NAME
      , BLOOD_TYPE
  FROM 
        PATIENT
 WHERE 
        BLOOD_TYPE NOT IN ('A', 'B', 'O');
--      BLOOD_TYPE IN ('A', 'B', 'O');
-- 비교대상 컬럼값이 제시한 목록중에 일치하는것이 존재하는지

-----------------------------------------------------------------------
-- WARD_ID가 W3이면서 성별은 M이거나 몸무게는 85이상
SELECT 
        PATIENT_NAME
      , WARD_ID
      , GENDER
      , WEIGHT_KG
  FROM 
        PATIENT
 WHERE
        WARD_ID = 'W3'
   AND     
        (GENDER = 'M'  -- AND가 무용지물
    OR 
        WEIGHT_KG >= 85);
-- 연산자 우선순위를 고려하지 않은 예씨
/*
 * < 연산자 우선순위 >
 * 
 * 1. ( )
 * 2. 산술연산자
 * 3. 연결연산자
 * 4. 비교연산자
 * 5. ISNULL, LIKE, IN, BETWEEN AND
 * 6. NOT
 * 7. AND
 * 8. OR
 * 
 * -> 헷갈리면 무조건 괄호를 치는 것이 정답
 * -> AND가 OR보다 먼저 묶인다!!는 것은 꼭 기억
 */
-------------------------------------------------------------------------

SELECT * FROM PATIENT;  -- 정렬이 안된 상태
--SELECT - FROM - WHERE - ORDER BY가 한세트

SELECT 
        PATIENT_NAME
      , HEIGHT_CM
  FROM 
        PATIENT
 ORDER 
    BY 
        HEIGHT_CM; -- 오름차순        
     -- HEIGHT_CM DESC; 내림차순
        
-- 최근 입원한 순으로 정렬
        
SELECT
        PATIENT_NAME
      , ADMISSION_DATE
  FROM 
        PATIENT
 ORDER 
    BY 
        ADMISSION_DATE DESC;

SELECT 
        PATIENT_NAME
      , DISCHARGE_DATE
  FROM 
        PATIENT
 ORDER 
    BY 
        DISCHARGE_DATE DESC NULLS LAST;  -- NULL값을 제일 밑으로 보냄
-- ORACLE에서는 NULL을 가장 큰 값으로 취급하기 때문에 NULLS FIRST / LAST를 사용해야함
        
SELECT 
        PATIENT_NAME
      , HEIGHT_CM / 100 키
  FROM 
        PATIENT
 WHERE 
        HEIGHT_CM / 100 >= 1.5
 ORDER 
    BY 
        2 DESC;  -- SELECT보다 순서가 뒤, 컬럼의 순서만으로도 정렬가능하지만 비추!
      
--------------------------------------------------------------------------
-- 환자명, 병동코드(WARD_ID)를 조회
        
SELECT 
        PATIENT_NAME
      , WARD_ID
  FROM 
        PATIENT
 ORDER 
    BY 
        WARD_ID
      , PATIENT_NAME;















        
        