-- (2) 구매지표 추출: 매출액, 구매자 수/구매 건수, 인당 매출액(AMV), 건당 구매 금액(ATV) 
-- 1. 매출액 

-- [그림 4-5 쿼리] 
SELECT A.ORDERDATE,
PRICEEACH*QUANTITYORDERED
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER;

-- [그림 4-6 쿼리] 일별 매출액 조회 
SELECT A.ORDERDATE,
SUM(PRICEEACH*QUANTITYORDERED) AS SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP
BY 1
ORDER
BY 1;

-- [그림 4-8 결과] 
SELECT SUBSTR('ABCDE',2,3);

-- [그림 4-9 결과] 월별 매출액 조회 
SELECT SUBSTR(A.ORDERDATE,1,7) MM,
SUM(PRICEEACH*QUANTITYORDERED) AS SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP
BY 1
ORDER
BY 1;

-- [그림 4-10 결과] 연도별 매출액 조회 
SELECT SUBSTR(A.ORDERDATE,1,4) MM,
SUM(PRICEEACH*QUANTITYORDERED) AS SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP
BY 1
ORDER
BY 1;

-- 2. 구매자 수, 구매 건수  

-- [그림 4-11 결과] 
SELECT ORDERDATE,
CUSTOMERNUMBER,
ORDERNUMBER
FROM CLASSICMODELS.ORDERS
;

-- [그림 4-12 결과] 
SELECT COUNT(ORDERNUMBER) N_ORDERS,
COUNT(DISTINCT ORDERNUMBER) N_ORDERS_DISTINCT
FROM CLASSICMODELS.ORDERS
;

-- [그림 4-13 결과] 구매자 수, 구매 건수 
SELECT ORDERDATE,
COUNT(DISTINCT CUSTOMERNUMBER) N_PURCHASER,
COUNT(ORDERNUMBER) N_ORDERS
FROM CLASSICMODELS.ORDERS
GROUP
BY 1
ORDER
BY 1;

-- 3. 인당 매출액(연도별)  

-- [그림 4-14 결과] 연도별 매출액과 구매자 수 
SELECT SUBSTR(A.ORDERDATE,1,4) YY,
COUNT(DISTINCT A.CUSTOMERNUMBER) N_PURCHASER,
SUM(PRICEEACH*QUANTITYORDERED) AS SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP
BY 1
ORDER
BY 1;

-- [그림 4-15 결과] 연도별 인당 매출액 
SELECT SUBSTR(A.ORDERDATE,1,4) YY,
COUNT(DISTINCT A.CUSTOMERNUMBER) N_PURCHASER,
SUM(PRICEEACH*QUANTITYORDERED) AS SALES,
SUM(PRICEEACH*QUANTITYORDERED)/ COUNT(DISTINCT A.CUSTOMERNUMBER) AMV
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP
BY 1
ORDER
BY 1;

-- 4. 건당 구매 금액(ATV, Average Transaction Value)(연도별)  
-- 1건의 거래는 평균적으로 얼마의 매출을 발생시키는가? 이를 ATV(Average Transaction Value)라고 한다. 

-- [그림 4-16 결과] 
SELECT SUBSTR(A.ORDERDATE,1,4) YY,
COUNT(DISTINCT A.ORDERNUMBER) N_PURCHASER,
SUM(PRICEEACH*QUANTITYORDERED) AS SALES,
SUM(PRICEEACH*QUANTITYORDERED)/ COUNT(DISTINCT A.ORDERNUMBER) ATV
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP
BY 1
ORDER
BY 1;

-- (3) 그룹별 구매지표 구하기: 국가별/도시별 매출액, 북미 vs 비북미 매출액, 매출 Top 5 국가 및 매출, 국가별 Top Product 및 매출 
-- 1. 국가별/도시별 매출액 

-- [그림 4-18 결과] 3개의 테이블을 조합 
SELECT *
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
;

-- [그림 4-19 결과] 필요한 칼럼만 호출 
SELECT COUNTRY,CITY,PRICEEACH*QUANTITYORDERED
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
;

-- [그림 4-20 결과] 
SELECT C.COUNTRY,
C.CITY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1,2
;

-- [그림 4-21 결과] 최종 결과 
SELECT C.COUNTRY,
C.CITY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1,2
ORDER
BY 1,2
;

-- 2. 북미 vs 비북미 매출액 비교 
-- [그림 4-22 결과]
SELECT CASE WHEN COUNTRY IN ('USA','Canada') THEN 'North America'
ELSE 'Others' END COUNTRY_GRP
FROM CLASSICMODELS.CUSTOMERS; 

-- [그림 4-23 결과]
SELECT C.COUNTRY,
C.CITY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1,2
ORDER
BY 3 DESC
;

-- [그림 4-24 결과]
SELECT CASE WHEN COUNTRY IN ('USA','Canada') THEN 'North America'
ELSE 'Others' END COUNTRY_GRP,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1
ORDER
BY 2 DESC
;

-- [그림 4-25 결과]
CREATE TABLE CLASSICMODELS.STAT AS
SELECT C.COUNTRY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1
ORDER
BY 2 DESC
;

-- [그림 4-26 결과]
SELECT *
FROM CLASSICMODELS.STAT;

-- [그림 4-27 결과]
SELECT COUNTRY,
SALES,
DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM CLASSICMODELS.STAT;

-- [그림 4-28 결과]
SELECT *
FROM CLASSICMODELS.STAT_RNK;

-- [그림 4-29 결과]
SELECT *
FROM CLASSICMODELS. STAT_RNK
WHERE RNK BETWEEN 1 AND 5;

-- [그림 4-31 결과]
SELECT *
FROM
(SELECT COUNTRY,
SALES,
DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM
(SELECT C.COUNTRY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1) A) A
WHERE RNK <= 5
;

-- [109 페이지 과정1]
SELECT *
FROM
(SELECT COUNTRY,
SALES,
DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM
(SELECT C.COUNTRY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1) A) A
WHERE RNK <= 5
;

-- [110 페이지 과정2]
SELECT *
FROM
(SELECT COUNTRY,
SALES,
DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM
(SELECT C.COUNTRY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1) A) A
WHERE RNK <= 5
;

-- [그림 4-32 결과]
SELECT A.CUSTOMERNUMBER,
A.ORDERDATE,
B.CUSTOMERNUMBER,
B.ORDERDATE
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERS B
ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER AND SUBSTR(A.ORDERDATE,1,4)
= SUBSTR(B.ORDERDATE,1,4) -1;

-- [그림 4-33 결과]
SELECT C.COUNTRY,
SUBSTR(A.ORDERDATE,1,4) YY,
COUNT(DISTINCT A.CUSTOMERNUMBER) BU_1,
COUNT(DISTINCT B.CUSTOMERNUMBER) BU_2,
COUNT(DISTINCT B.CUSTOMERNUMBER)/COUNT(DISTINCT A.CUSTOMERNUMBER)
RETENTION_RATE
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERS B
ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER AND SUBSTR(A.ORDERDATE,1,4)
= SUBSTR(B.ORDERDATE,1,4)-1
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1,2
;

-- [그림 4-35 결과]
CREATE TABLE CLASSICMODELS.PRODUCT_SALES AS
SELECT D.PRODUCTNAME,
SUM(QUANTITYORDERED*PRICEEACH) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.CUSTOMERS B
ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER
LEFT
JOIN CLASSICMODELS.ORDERDETAILS C
ON A.ORDERNUMBER = C.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.PRODUCTS D
ON C.PRODUCTCODE = D.PRODUCTCODE
WHERE B.COUNTRY = 'USA'
GROUP
BY 1
;

SELECT *
FROM
(SELECT *,
ROW_NUMBER() OVER(ORDER BY SALES DESC) RNK
FROM CLASSICMODELS.PRODUCT_SALES) A
WHERE RNK <=5
ORDER
BY RNK
;

-- (6) Churn Rate(%): 활동 고객 중 얼마나 많은 고객이 비활동 고객으로 전환되었는지 
-- 탑을 쌓아나간다고 생각하자! 

-- [그림 4-37 결과] 마지막 구매일
SELECT MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS;
-- ORDERS 테이블에 2005년 5월 31일까지의 주문 내역이 있다는 것을 확인할 수 있다. 

-- [그림 4-38 결과] 고객별 마지막 구매일 
SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP
BY 1
;
-- 나만 코드가 4-37과 동일하게 쓰여있는지는 모르겠지만, 수정했어요.
-- 103번 고객은 2004년 11월 25일 이후로 구매하지 않았고, 112번 고객은 2004년 11월 29일에 마지막 구입 날짜네요.

-- [그림 4-39 결과] 2005년 6월 1일(END POINT) 기준으로 며칠 소요되었는지 계산 
SELECT CUSTOMERNUMBER,
MX_ORDER,
'2005-06-01',
DATEDIFF('2005-06-01', MX_ORDER) DIFF  #DATEDIFF(date1, date2): date1 - date2의 결과가 출력 
FROM
(SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP
BY 1) BASE
;
-- DIFF 값이 클수록 오랫동안 쇼핑몰을 이용하지 않은 고객. 4번째 줄에 있는 119번 고객은 DIFF 변수의 값이 1로 꽤 최근에 쇼핑몰을 이용한 고객임을 확인할 수 있다. 

-- [그림 4-40 결과] Churn을 DIFF가 90일 이상인 경우라고 가정, CHURN_TYPE 변수 만들어 churn 여부를 확인하기 
SELECT *,
CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE
FROM
(SELECT CUSTOMERNUMBER,
MX_ORDER,
'2005-06-01' END_POINT,
DATEDIFF('2005-06-01',MX_ORDER) DIFF
FROM
(SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP
BY 1) BASE) BASE
;
-- 103번은 CHURN이고 119번은 NON-CHURN.. 

-- [그림 4-41 결과] CHURN RATE(%) 구하기 
SELECT CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE,
COUNT(DISTINCT CUSTOMERNUMBER) N_CUS  # DISTINCT 잊지 말기!! 
FROM
(SELECT CUSTOMERNUMBER,
MX_ORDER,
'2005-06-01' END_POINT,
DATEDIFF('2005-06-01',MX_ORDER) DIFF
FROM
(SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP
BY 1) BASE) BASE
GROUP
BY 1
;
-- CHURN_TYPE별 고객 수를 세어보니, CHURN인 경우는 69이고 NON-CHURN인 경우는 29로, Chrun Rate은 약 70%이다. 

-- 2) Churn 고객이 가장 많이 구매한 Productilne
-- Churn 고객이 어떤 사람들인지를 알아야 그들의 특성을 반영한 고객관리정책을 펼치고 고객 유출을 줄일 수 있을 것. 

-- [121 페이지, Churn table 생성] 고객별 Churn table 
CREATE TABLE CLASSICMODELS.CHURN_LIST AS
SELECT CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE,
CUSTOMERNUMBER
FROM
(SELECT CUSTOMERNUMBER,
MX_ORDER,
'2005-06-01' END_POINT,
DATEDIFF('2005-06-01',MX_ORDER) DIFF
FROM
(SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP
BY 1) BASE) BASE
;

-- [그림 4-43 결과] productline별 구매자 수 
SELECT C.PRODUCTLINE,
COUNT(DISTINCT B.CUSTOMERNUMBER) BU
FROM CLASSICMODELS.ORDERDETAILS A
LEFT
JOIN CLASSICMODELS.ORDERS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.PRODUCTS C
ON A.PRODUCTCODE = C.PRODUCTCODE
GROUP
BY 1
;
-- Classic Cars 생산라인를 이용한 고객은 94명, Motorcycles 생산라인을 이용한 고객은 55명, ..이다. 

-- [그림 4-44 결과] Churn Type, Product Line별 구매자 수 
-- 위 4-43 코드에 CHURN_LIST 테이블을 결합해 Churn Type으로 데이터를 한 번 더 GROUP BY 해주면 된다. 
SELECT D.CHURN_TYPE,
C.PRODUCTLINE,
COUNT(DISTINCT B.CUSTOMERNUMBER) BU
FROM CLASSICMODELS.ORDERDETAILS A
LEFT
JOIN CLASSICMODELS.ORDERS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.PRODUCTS C
ON A.PRODUCTCODE = C.PRODUCTCODE
LEFT
JOIN CLASSICMODELS.CHURN_LIST D
ON B.CUSTOMERNUMBER = D.CUSTOMERNUMBER
GROUP
BY 1,2
ORDER
BY 1,3 DESC
;
