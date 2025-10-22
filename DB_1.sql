SELECT NULL = NULL;  
SELECT 1+1;
SELECT '하이!';
SELECT 1 AND 1; ## true = 1 (true, false 출력 X)
SELECT * FROM world.city;

# 나는 world 데이터베이스를 기본으로 사용하겠습니다. 선언
USE world; 
SELECT * FROM city;
# 한줄 주석
-- 한줄 주석(-- 후에 띄어쓰기필수)
/*
여러줄
주석
*/
## *말고 내가 원하는 속성만 조회할 때
SELECT Population FROM city;
SELECT name, population FROM city; # 원하는 열(속성)들만
select population, id from city; # 원하는 순서로 
## 조회시 속성 이름을 다른 이름으로 변경하고 싶을 때
SELECT name AS '도시명' FROM city; # as구문
SELECT id '아이디', name AS 도시명 FROM city;
SELECT id '도시 아이디!' FROM city; # 특수문자나 띄어쓰기는 무조건 ''로 묶기
#### WHERE - SELECT 시 조건을 달아야 할 경우
SELECT * FROM city WHERE countrycode = 'kor';
SELECT id, name, district FROM city WHERE countrycode = 'kor';
SELECT * FROM city WHERE countrycode = 'kor' AND population >= 1000000;
SELECT * FROM city WHERE countrycode = 'kor' OR countrycode = 'afg'; ##countrycode = 'kor' or 'afg' --> X
SELECT * FROM city LIMIT 1; # 최상위 1개만 조회
SELECT * FROM city LIMIT 2, 3; # 위에서 2번째 데이터이후부터 3개만 조회해라 
SELECT * FROM city LIMIT 5 OFFSET 3; # 위에서 3번째 데이터 이후부터 5개만 조회해라

## DISTINCT - 중복을 제거
SELECT * FROM city; # 4079개 도시
SELECT distinct countrycode FROM city; # coutrycode 중복제거 -> 232개 조회 (232개국가)
SELECT distinct countrycode, name FROM city; # countrycode, name의 중복 전체 조회

## ORDER BY - 정렬하기
# ASC(ascending), DESC(descending)
SELECT * FROM city ORDER BY population; # 오름차순 정렬
SELECT * FROM city ORDER BY population desc; # 내림차순 정렬
