# 모든 열에 값을 설정해서 한 줄 넣기 : INSERT INTO 테이블명 VALUES (값1, 값2 ...) 
INSERT INTO student VALUES (1, '홍길동', 10, '2024-10-11 13:00:07');
INSERT INTO student VALUES (2, '김나나'); # 모든 열의 값을 적어야 한다
SELECT * FROM student;

# 원하는 열에 값을 설정해서 한줄 넣기
# INSERT INTO 테이블명 (속성명1, 속성명2 ,,,) VALUES (값1, 값2,,,)
INSERT INTO student (id, name) VALUES (2, '김나나');
INSERT INTO student (id, regist_date, name) VALUES (10, NOW(), '김박사'); # ID는 PK이기 때문에 중복 X, 속성명 순서 바꿔도 상관 X
SELECT NOW(); # 현재 시간과 날짜 

# 같은 속성에 여러 값 넣기
INSERT INTO student (id, name) VALUES 
(11, '김박사'), (12, '이박사'), (13, '박박사');

# SELECT UPDATE INSERT DELETE
SELECT * FROM student;
TRUNCATE student;

# AUTO INCREMENT (AI) : AI로 PK를 자동 증가되게 되어있는 경우
INSERT INTO student (name) VALUES ('김나나');
INSERT INTO student VALUES (NULL, '홍길동', DEFAULT, '2024-10-11 13:00:07'); # ID부분에 NULL설정하면 자동증가돼서 들어감

# 마지막에 INSERT된 AUTO INCREMENT값을 조회
SELECT LAST_INSERT_ID();

# TABLE에서 시작하는 AI번호의 값을 변경
# AUTO_INCREMENT 는 자동으로 현제 테이블의 데이터에서 맨 뒤에 있는 값의 다음 값으로 들어간다
ALTER TABLE student AUTO_INCREMENT = 100; 
INSERT INTO student (name) VALUES ('김나나');
ALTER TABLE student AUTO_INCREMENT = 10; 
INSERT INTO student (name) VALUES ('A'); # 자동으로 맨 뒤에 들어감

ALTER TABLE student AUTO_INCREMENT = 1; 
SELECT * FROM student;

############
SET @@AUTO_INCREMENT_INCREMENT = 1;  # 
CREATE TABLE AI(
	n INT PRIMARY KEY AUTO_INCREMENT
);
# 3씩 증가하도록 해도, 1부터 시작하고 3씩 증가
INSERT INTO AI VALUES (); # 기본으로 1들어감 -> 한번 더 실행하면 4 (SET @@ ~ : 3으로 설정했기 때문에)
SELECT * FROM ai;
SELECT LAST_INSERT_ID();

# HOME -> WORKBENCH 다시 들어오면 세션이 나눠짐(독립적으로 작동)

# 
SELECT * FROM student;
INSERT INTO student (name) VALUES ('ABC');
INSERT INTO student (name) VALUES ('ABC '); # result grid 에서 데이터에 더블클릭하면 띄어쓰기가 되어있는걸 확인
SELECT * FROM student WHERE name = 'ABC' AND id = 103;
SELECT name = 'ABC' FROM student WHERE id = 103; # 1(true)
SELECT name = 'ABC' FROM student WHERE id = 105;
# VARCHAR는 가변문자열이라서 뒤에있는 ' '공백문자까지 비교대상이다
# NAME을 CHAR로 바꾼뒤에는 'ABC '로 찾으면 0(FALSE)
# CHAR는 원래 남는 문자수를 ' '공백으로 채운다. 따라서 뒤에 있는 공백은 의미가 없다
# -> INSERT할때 'ABC '이렇게 넣어도 'ABC'로 넣은거다
TRUNCATE student;
INSERT INTO student (id, name) VALUES (1, '김테스트');
INSERT INTO student (id, name) VALUES 
(2, '김테스트2'), (1, '김테스트1'), (3, '김테스트3'); # 그냥하면 ID 중복된 1이 있어서 실행X
INSERT IGNORE INTO student (id, name) VALUES 
(2, '김테스트2'), (1, '김테스트1'), (3, '김테스트3'); # IGNORE하면 2,3입력됨
SELECT * FROM student;

# PK가 중복이 되어서 INSERT를 못한다면 대신 UPDATE를 시켜라
INSERT INTO student (id, name) VALUES 
(4, '김테스트2'), (1, '김테스트1')
ON DUPLICATE KEY UPDATE name = '중복이름!';

## 실습
# 1
SELECT * FROM buytbl;
UPDATE buytbl SET prodName = 'MySQL' WHERE prodName = '책';
# 2
SELECT * FROM usertbl;
SELECT *, CONCAT(mobile1, mobile2) mobile FROM usertbl; # 문자열 이어짐
# 3
INSERT IGNORE INTO usertbl (userID, Name, addr) VALUES
('KSW', '김성우', '대구'), ('KSW', '김소원', '부산'), ('HGD', '홍길동', '제주') ;
# 4 *** 다시보기
SELECT * FROM buytbl;
DESC buytbl;
INSERT INTO buytbl VALUES (11, 'KSW', '이어폰', '전자', DEFAULT, DEFAULT) 
DUPLICATE KEY UPDATE amount = amount + 1;

# 5
SELECT * FROM usertbl;
SELECT * FROM usertbl WHERE addr = '서울' AND height > 180;
DELETE FROM usertbl WHERE addr = '서울' AND height > 180 LIMIT 2;
# 6
SELECT * FROM buytbl WHERE amount <= 2;
DELETE FROM buytbl WHERE amount <= 2;

########sub query
SELECT * FROM usertbl WHERE height > (SELECT height FROM usertbl WHERE name = '바비킴');
SELECT * FROM usertbl;

# ANY : 결과로 조회된 것 중 아무거나 

SELECT height FROM usertbl WHERE addr = '경기';
# 경기의 166보다 큰 사람도 나오고 172보다 큰 사람도 나옴
SELECT * FROM usertbl 
WHERE height > ANY (SELECT height FROM usertbl WHERE addr = '경기');

# 최소값보다 크다라는 말과 같다
SELECT * FROM usertbl 
WHERE height > (SELECT MIN(height) FROM usertbl WHERE addr = '경기');

# ALL : 결과 모두와 비교해서 맞아야 한다
SELECT * FROM usertbl 
WHERE height > ALL (SELECT height FROM usertbl WHERE addr = '경기');

# 최대값보다 크다라는 말과 같다
SELECT * FROM usertbl 
WHERE height > (SELECT MAX(height) FROM usertbl WHERE addr = '경기');

#
SELECT * FROM usertbl WHERE height > 170 AND addr IN ('서울', '경기') ;

# 
CREATE TABLE user_copy (SELECT userid, height FROM usertbl);
SELECT * FROM user_copy;
DESC user_copy; # field와 type만 가져오고 default값은 가져오지 X
INSERT INTO user_copy (SELECT prodName, price FROM buytbl);  # insert할 열을 선택할 수 x

# 
SELECT * FROM usertbl, buytbl, world.city;
SELECT *, (SELECT MAX(price) FROM buytbl) FROM usertbl; # usertbl 의 개수만큼 열을 출력
SELECT * FROM usertbl, (SELECT price, prodName FROM buytbl) 새로운테이블; # usertbl 한 개당 buytbl 인식
SELECT price, prodName FROM buytbl 새로운테이블;

## 실습
SELECT * FROM usertbl;
SELECT * FROM buytbl;

# 1
SELECT AVG(birthyear) FROM usertbl;
SELECT * FROM usertbl WHERE birthYear < (SELECT AVG(birthyear) FROM usertbl);

# 2 *** 똑같은 PRICE 값이라도 PRICE값이 여러개이기 때문에 한 개의 값을 설정해주기위해 MAX를 설정
SELECT price FROM buytbl WHERE groupName = '의류';
SELECT * FROM buytbl WHERE price > (SELECT MAX(price) FROM buytbl WHERE groupName = '의류');

# 3
SELECT * FROM buytbl;
CREATE TABLE newBuyTbl (SELECT prodname, price, amount FROM buytbl);
SELECT * FROM newBuyTbl;

# 4 *** 
SELECT * FROM buytbl;
SELECT userID, groupname FROM buytbl WHERE groupname = '전자';
SELECT * FROM usertbl;
# WHERE (SELECT userID, groupname FROM buytbl WHERE groupname = '전자');

# 5 
SELECT * FROM countrylanguage;
SELECT * FROM countrylanguage GROUP BY countrycode ;
SELECT countrycode, count(language) FROM countrylanguage GROUP BY countrycode;
SELECT countrycode, count(language) FROM countrylanguage GROUP BY countrycode HAVING count(Language);
SELECT * FROM country;

#6 나라의 code, name 그리고 그 나라의 도시개수 조회