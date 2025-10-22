#1
SELECT * FROM city;
SELECT countrycode, MAX(Population), MIN(Population) FROM city WHERE CountryCode = 'kor';
#2 언어 중복제거 해주기
SELECT * FROM countrylanguage;
SELECT COUNT(DISTINCT Language) FROM countrylanguage;
#3 그룹으로 묶을 변수 잘 설정하기!
SELECT countrycode, count(*) FROM city GROUP BY countrycode ORDER BY COUNT(*) DESC;
SELECT  name, countrycode, COUNT(District) FROM city GROUP BY Name ORDER BY CountryCode DESC;
#4 distrcit 그룹으로 묶기!!
SELECT * FROM city WHERE countrycode = 'kor' GROUP BY District HAVING count(district) >= 5;
SELECT district, count(*) FROM city WHERE countrycode = 'kor' GROUP BY District HAVING count(*) >= 5;
#5 
SELECT * FROM usertbl;
SELECT addr, AVG(height) FROM usertbl GROUP BY addr ORDER BY AVG(Height) LIMIT 3 ;
#6
SELECT * FROM usertbl WHERE mobile1 IS NOT NULL AND mobile2 IS NOT NULL;
#7
SELECT userID, sum(PRICE * amount) FROM buytbl GROUP BY userID WITH ROLLUP; # 구매액 합계 = price * amount
#8
SELECT prodName, SUM(price*amount) FROM buytbl GROUP BY prodName WITH ROLLUP;

#######
DESC usertbl; 
DESCRIBE usertbl;
# database는 생성후에 다시 만들 수 없고(중복), 이름 변경 불가능
# IF NOT EXISTS : mydb가 존재하지 않으면 database를 만들어라, 생략가능
CREATE DATABASE IF NOT EXISTS  mydb;
DROP DATABASE mydb; #database 삭제


###############DAY4#################
####### MYDB에 TABLE 넣어보기
# person(개체), name(속성)
# 생성되어있는 테이블을 제거(속성을 하나 추가하고 싶다면 제거 후 다시 생성)
DROP TABLE person;
CREATE TABLE IF NOT EXISTS person(
name VARCHAR(10) PRIMARY KEY,
age TINYINT,
birth DATE,
height DOUBLE,
grade ENUM('GOLD', 'SLIVER', 'BRONZE')
); 
SELECT * FROM person;
# ENUM : ENUM으로 지정된 값만 넣을 수 있음
# PRIMARY KEY는 무조건 지정해야 다른 속성들의 값을 지정할 수 있음, PRIMARY KEY기준으로 오름차순으로 정렬
# 값을 넣었다고 지우면 '' -> 빈 문자열(결국 문자로 인식 NULL X)
# NULL로 바꾸고 싶으면 마우스 오른쪽버튼 SET FIELD TO NULL로 바꿔줌

#######
# `` (작은따옴표 X) : 명령어가 아닌 이름을 나타낼 때 사용, TABLE 이름, DB 이름, COULMN(속성)이름으로 사용
# 일반값은 `쓰면 오류 
CREATE TABLE `computer`(
	`serial` CHAR(10),	# PRIMARY KEY라서 NULL 안됨
    `price` INT NOT NULL UNIQUE,	# NOT NULL : NULL이 될 수 없음, 값을 무조건 입력해야함	# UNIQUE : 중복이 있으면 안됨(price의 데이터는 모두 달라야함), NULL가능
    `release` DATE DEFAULT '2020-10-11',	# DATE를 넣지 않으면 기본값 설정
    PRIMARY KEY(`serial`)
);
SELECT * FROM computer;

####### computer 테이블과 관계를 가지는 order 테이블
# computer 1 : order N (1:N의 관계)
# 하나의 컴퓨터로 여러 주문 할 수 있다.
CREATE TABLE `order`(
	`no` INT PRIMARY KEY,	# 순번
    `computer_serial` CHAR(10),	# computer 테이블의 serial과 연관될 때 연관되는 속성은 자료형을 똑같이 설정
    `order_date` DATE,	# 주문날짜
    FOREIGN KEY (`computer_serial`) REFERENCES `computer` (`serial`)
    # FOREIGN KEY (내 테이블에 있는 속성) REFERENCES 남의 테이블(남의 속성)
    # computer_serial에는 computer테이블의 serial 속성에 있는 값만 넣을 수 있게됨 
    # FK로 설정가능한 상대방 속성은 상대방 속성이 PK이거나 UNIQUE인 속성만 가능함
);
SELECT * FROM `order`;

########
CREATE TABLE 주인(
	`DATA` INT PRIMARY KEY
);
CREATE TABLE 부하(
	`DATA` INT PRIMARY KEY,
    `주인데이터` INT DEFAULT 1,
    FOREIGN KEY(`주인데이터`) REFERENCES 주인(`DATA`) # ON UPDATE NO ACTION ON DELETE CASCADE
);
SELECT * FROM 주인; 
SELECT * FROM 부하;
# 부하 TABLE에서 ON DELETE CASCADE -> 주인의 `DATA`를 삭제하면 부하의 `주인데이터`도 삭제됨

#######
CREATE TABLE TEST(
	A INT,
    B INT,
    C INT,
    PRIMARY KEY(A, B),	# A, B를 합쳐서 PK로 설정
    CONSTRAINT CHECK(C > 1000)	# CONSTRAINT : 제약조건(C의 값은 1000 초과한 값만 넣을 수 있다고 하는 제약조건 설정)
);
SELECT * FROM TEST;

####실습
CREATE TABLE `고객`(
	고객아이디 CHAR(10) PRIMARY KEY,
    고객이름 CHAR(10) NOT NULL,
    나이 TINYINT,
    등급 VARCHAR(10) NOT NULL,
    직업 VARCHAR(20),
    적립금 INT DEFAULT 0
);

CREATE TABLE 제품(
	제품번호 VARCHAR(7) PRIMARY KEY,
    제품명 VARCHAR(10),
    재고량 INT,
    단가 INT,
    제조업체 VARCHAR(200),
    CONSTRAINT CHECK(재고량 >= 0 AND 재고량 <= 10000)
);

CREATE TABLE 주문(
	주문번호 INT PRIMARY KEY,
    주문고객 CHAR(10),
    주문제품 VARCHAR(7),
    수량 INT,
    배송지 VARCHAR(255),
    주문일자 DATE,
    FOREIGN KEY(주문고객) REFERENCES 고객(고객아이디),
	FOREIGN KEY(주문제품) REFERENCES 제품(제품번호)
); 

# UNSIGNED 부호가 없는 : age unsigned tinyint(-128 ~ 127 -> 0 ~ 256까지 인식)
##
DESC animal;
ALTER TABLE animal ADD age INT NOT NULL DEFAULT 1;
ALTER TABLE animal DROP age;
# 이름 타입 다 변경가능(COLUMN 자체를 변경, 제약조건 초기화)
ALTER TABLE animal CHANGE COLUMN age height TINYINT;	
# 이름만 변경
ALTER TABLE animal RENAME COLUMN height TO age;		
# 속성의 타입(+ 제약조건)을 변경하고 싶을 때
ALTER TABLE animal MODIFY COLUMN age INT NOT NULL DEFAULT 10; 	
# PK를 제거하고 싶을 때
ALTER TABLE animal DROP PRIMARY KEY;
# PK를 추가
ALTER TABLE animal ADD PRIMARY KEY(name);

##### 제약조건확인
USE information_schema;
SHOW TABLES;
SELECT * FROM information_schema.table_constraints;

####
SELECT * FROM 부하;
# safe update mode : DELETE, UPDATE에서 변경되는 데이터가 PRIMARY KEY가 조건에 없으면 거부됨
UPDATE 부하 SET `주인데이터` = 2 WHERE `data` = 40;

###다시보기
SELECT * FROM animal;
UPDATE animal SET age = 10;
UPDATE animal SET age = 20, addr = '대구' WHERE name = 'a'OR name = 'b';
SET sql_safe_updates = FALSE; # 해제

########
DELETE FROM animal WHERE age = 1 AND name = 'b';
SELECT * FROM animal;
TRUNCATE animal; # DELETE FROM animal 과 결과가 같음


# copy to clipboard -> create statement
CREATE TABLE `animal` (
  `name` varchar(55) NOT NULL,
  `addr` varchar(45) DEFAULT NULL,
  `age` int NOT NULL DEFAULT '10',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
