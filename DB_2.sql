# 순서 : SELECT -> FROM -> WHERE -> GROUP BY -> ORDER BY -> LIMIT

USE sakila; # 내가 사용할 데이터베이스를 선택하겠다
## -> 마우스로 sakila 더블 클릭한것과 동일
SELECT * FROM film;
# SELECT * FROM film ORDER BY rental_duration, rental_rate;

###ORDER BY에서 여러 열 기준으로 정렬하기
SELECT title, rental_duration, rental_rate FROM film
ORDER BY rental_duration DESC, rental_rate ASC;

### BETWEEN
# BETWEEN은 100과 130을 포함 / NOT BETWEEN은 100과 130을 사이의 값들을 포함 xxx
SELECT * FROM film WHERE length NOT BETWEEN 100 AND 130;
SELECT * FROM film WHERE length >= 100 AND length <= 130; # 100 < length < 130 으로 사용 XXX 

## IN : OR보다 더 간편하게 사용가능(추천)
SELECT * FROM film WHERE rating = 'PG' OR rating = 'G';
SELECT * FROM film WHERE rating IN ('PG', 'G');

## NULL은 비교가 안됨, <=>연산자로 NULL비교 가능
# NULL이랑 = 비교하면 결과는 무조건 FALSE(0)으로 판단 
SELECT * FROM world.country WHERE IndepYear <=> NULL; 	# USE WORLD로 불러들이거나 WORLD. COUNTRY로 사용
SELECT * FROM country WHERE IndepYear IS NULL;
SELECT * FROM country WHERE IndepYear IS NOT NULL;

## LIKE
SELECT * FROM country WHERE name LIKE 'A%'; # A% : A로 시작하는 어떤 문자(%는 아무거나라는 뜻), A뒤에 아무거나
SELECT * FROM country WHERE name LIKE '%A'; # 아무거나 뒤에 A, A로 끝나는 아무문자
SELECT * FROM country WHERE name LIKE '%KO%'; # 아무거나 시작하고 아무거나로 끝나는데 중간에 KO만 들어있는 문자
SELECT * FROM country WHERE name LIKE '%K%O%';
#_ : 문자의 개수
# 국가명이 5글자로 되어있는 국가를 조회
SELECT * FROM country WHERE name LIKE '_____';
# 글자수가 5글자인데 4번째 글자가 N인 국가명을 조회
SELECT * FROM country WHERE name LIKE '___n_'; # China, Ghana 출력 
# C로 시작하고 마지막에 n_으로 끝나는 국가명
SELECT * FROM country WHERE name LIKE 'C%n_';

############################# 실습
CREATE DATABASE practice;
############################# 
SELECT SUM(population) FROM city;
SELECT MIN(population) FROM city; 
SELECT AVG(population) FROM city; 
SELECT name, LifeExpectancy + 1 계산결과 FROM country; # 연산가능, 열이름 변경도 가능
SELECT name, LifeExpectancy, 'zzzzzzzzzzzz' FROM country; # 내가 만든 열도 붙일 수 있음
SELECT name, LifeExpectancy, LifeExpectancy * 10 FROM country; # 내가 만든 열도 붙일 수 있음
SELECT Population, LifeExpectancy, Population + LifeExpectancy FROM country; 

SELECT MAX(Population), MIN(Population), AVG(Population) FROM city;
SELECT SUM(Population) / COUNT(population) AS '평균' FROM city; # avg 연산자체도 가능 (굳이 avg 사용하지 X)
SELECT COUNT(DISTINCT countrycode) FROM city; # 중복제거한 그 결과의 COUNT를 확인할수 있음ALTER
# SELECT name, MAX(population) FROM city; # --> 실행X : 행의 개수를 맞춰줘야함 

## GROUP BY 작성시, GROUP BY에 작성된 열만 SELECT 가능(집계함수 등 하나의 데이터 제외)
SELECT * FROM city;
SELECT countrycode FROM city GROUP BY CountryCode;
SELECT countrycode, SUM(Population) FROM city GROUP BY CountryCode; # 실행 : countrycode = AFG그룹으로 묶은 뒤 집계함수 사용가능
SELECT name, countrycode, SUM(Population) FROM city GROUP BY CountryCode; # 실행 :  AFG에 4개의 데이터 포함되기때문에 NAME은 볼수 X

## HAVING : GROUP BY의 결과에 조건을 추가하고 싶다면, HAVING 사용
# 왜냐하면 WHERE구문은 GROUP BY 전에 실행되기 때문 
SELECT countrycode, sum(population) AS '합계' 
FROM city 
WHERE CountryCode = 'KOR' # WHERE에서는 합계열을 사용 X
GROUP BY CountryCode 
HAVING 합계 < 10000  # 새로운 열 이름으로 작성해도 OK
ORDER BY 합계; # 세미클론이 끝나야 하나의 실행문 완성 , 띄어쓰기 가능

SELECT COUNT(*) FROM city;
SELECT COUNT(countrycode) FROM city GROUP BY countrycode; # group by에 있는 열의 이름으로 count에 지정
# 여러 열을 사용해서 그룹으로 묶기
SELECT Continent, Region FROM country GROUP BY continent, region ORDER BY continent, region;

## ROLL UPDATE
SELECT CountryCode, COUNT(countrycode) FROM city GROUP BY countrycode WITH ROLLUP ; # 하단에 총합계 보여줌
SELECT Continent, Region, SUM(GNP) FROM country GROUP BY continent, region WITH ROLLUP; # 그룹된 continent에 따른 합도 보여주고 모든 총합도 보여줌

### ONLY FULL GROUP BY
SELECT countrycode, name FROM city GROUP BY CountryCode;





