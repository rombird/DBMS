# cross join (카티션 곱) -> SELECT * FROM usertbl, buytbl;

# self join(테이블 1개로 조인할때 이름을 꼭 따로 정해주기)
# 우대리의 상사 -> 이부장의 상사 ->  김재무의 번호 -> 3333
SELECT manager FROM emptbl WHERE emp = '우대리'; 
SELECT empTel FROM emptbl WHERE emp = '이부장'; 

SELECT empTel FROM emptbl WHERE emp = (SELECT manager FROM emptbl WHERE emp = '우대리');  # 서브쿼리
SELECT * FROM emptbl `EMP`
	INNER JOIN emptbl `MANAGER`
    ON `EMP`.manager = `MANAGER`.emp
WHERE `EMP`.emp = '우대리' ;

# natural join(자연조인) : 두 테이블이 PK, FK가 존재할 때, 이 구문이 INNER JOIN의 ON구문을 자동으로 써주는 것과 같다
SELECT * FROM usertbl
	NATURAL JOIN buytbl;
    
##################
# CREATE VIEW
USE world;

# 아래의 SELECT구문이 실행되는 것과 같은 kyonggi_view 이름의 VIEW를 생성
CREATE VIEW `kyonggi_view` AS
SELECT id, name, population FROM city 
WHERE countryCode = 'kor' AND district = 'kyonggi';

# 이후에 VIEW만 SELECT하면 바로 사용가능하다!
SELECT * FROM kyonggi_view;
SELECT * FROM kyonggi_view WHERE id =2338 ; # where구문도 사용가능

CREATE VIEW `population_sum_view` AS
SELECT district, SUM(population) 인구수합계 FROM city 
WHERE countryCode = 'kor'
GROUP BY district HAVING 1000000 > SUM(population); # district별로 인구수 합계

# 훨씬 간략하게 사용가능
SELECT * FROM population_sum_view
WHERE 1000000 > 인구수합계;

###################
# VIEW에 INSERT로 데이터 추가가 가능한지 확인
USE practice;
CREATE TABLE `test`(
	`no` INT PRIMARY KEY AUTO_INCREMENT,
    `data` CHAR(10)
);

SELECT * FROM test; 

CREATE VIEW `test_view` AS
SELECT `data` FROM `test` WHERE `no` BETWEEN 2 AND 4; 

SELECT * FROM `test_view`;
INSERT INTO `test_view` VALUES ('H');
# VIEW에서 INSERT INTO를 실행하면 기반이 되는 테이블에 INSERT된다. (test_view에서 insert를 하면 test테이블에 insert됨)
# 대신 VIEW생성시 WHERE조건이 있기 때문에 VIEW는 WHERE에 맞는 것만 나온다.

DELETE FROM `test_view` WHERE data ='B' OR `data` = 'H'; # test_view에서는 B삭제 test table에서도 B만 삭제
# DELETE, UPDATE는 VIEW에 존재하는 항목만 가능하다
## 기반 테이블에는 존재한다고 해도 영향을 받지 X 

## WITH CHECK OPTION
# --> VIEW 생성할 때 정했던 조건 이외의 데이터를 삽입하거나 수정 및 삭제를 시도할 시 막음
CREATE OR REPLACE VIEW `test_view` AS
SELECT `data` FROM `test` WHERE `no` BETWEEN 2 AND 4
WITH CHECK OPTION; 

DELETE FROM `test_view` WHERE data ='B' OR `data` = 'H';

INSERT INTO `test_view` VALUES ('B'); # --> INSERT 할수X

###############
# 비재귀적 CTE
WITH my_cte AS # ()안에서 ;빼야함
(
	SELECT * FROM usertbl 
    WHERE addr = '서울'
)
SELECT * FROM my_cte;

###################
# with 구문자체에 (열이름1, 열이름2,..) or select구문에서 원래하던것처럼 이름 설정도 가능
WITH total_sum_cte (아이디, 합계) AS
(
SELECT userId, SUM(price*amount)
FROM buytbl GROUP BY userId 
)
SELECT * FROM total_sum_cte ORDER BY 합계 ; 
# 열의 이름을 정해주지 않았을 시 --> `` 꼭해주기 아니면 진짜 sum을 다시 함 `SUM(price*amount)`

######################
# 지역별 가장 키가 큰 사람들의 키의 평균을 조회
SELECT addr, max(height) FROM usertbl GROUP BY addr;
# 여기서 AVG(MAX(height))를 실행할 수 X 

WITH `height_cte` (지역, 최대키) AS
(
SELECT addr, max(height) FROM usertbl GROUP BY addr
)
SELECT AVG(최대키) FROM height_cte;

####################
# 재귀적 CTE
# RECURSIVE : 재귀
WITH RECURSIVE `r_cte` AS(
	SELECT 1 AS `num`  # 초기 쿼리 : 최초에 한번만 실행되고 끝, 초기쿼리에서  열이름 정할 수 있음
		UNION
	SELECT `num` + 1 FROM `r_cte` # 하위 쿼리 : 최초 구문과 합쳐져서 반복되는 쿼리(반복은 WHERE구문에서)
    WHERE `num` <= 10 # num을 사용하려면 from 구문 꼭 적어주기
) SELECT * FROM `r_cte`;

#############
# 5! = 5*4*3*2*1
WITH RECURSIVE `fact` AS
(
	SELECT 1 숫자, 1 결과
		UNION ALL
    SELECT 숫자+1, 결과*(숫자+1) FROM `fact`
    WHERE 숫자+1 <=  5
) SELECT 결과 FROM `fact` ORDER BY 결과 DESC LIMIT 1;

#######
# 1) 1부터 10까지의 합계를 재귀쿼리로 구하라
# 2) 피보나치 10번째 항의 결과를 재귀쿼리로 구하라 
# 1 1 2 3 5 8 13 21 34

# 1
WITH RECURSIVE `sum_cte` AS
(
	SELECT 1 숫자, 1 합계 
		UNION ALL
	SELECT 숫자 + 1, 합계 + (숫자+1) FROM `sum_cte`
	WHERE 숫자 +1 <= 10	# 숫자 <= 10 이면 11까지 출력되므로 주의!!
)SELECT * FROM `sum_cte` ORDER BY 합계 DESC LIMIT 1;

# 2
WITH RECURSIVE `pibo_cte` AS
(
	SELECT 3 항, 1 전전, 1 전, 2 결과
		UNION ALL
	SELECT 항 + 1 , 전, 결과, 결과 + 전 FROM `pibo_cte`
    WHERE 항 + 1 <= 10
)SELECT * FROM `pibo_cte`;

##############
# 회사의 부하, 상사의 관계를 표현한 테이블에서 해당 직원의 상관관계 출력
SELECT * FROM emptbl WHERE manager IS NULL; # 나사장만 위의 매니저가 없음 (가장 높은 사람)
SELECT * FROM emptbl;

WITH RECURSIVE relation_cte AS
(
	SELECT emp `직원명`, CAST(emp AS CHAR(100)) AS `관계도` FROM emptbl WHERE manager IS NULL
		UNION ALL
	SELECT `직원명`, CONCAT(`관계도`, '->', emp) FROM relation_cte
		INNER JOIN emptbl
        ON emptbl.manager = relation_cte.`직원명`
) SELECT * FROM relation_cte;

#####################
# set @변수명 = 값;
# select @변수명;
SET @num = 5;
SELECT @num +1;

# CAST(표현식 AS 데이터형식)
# CONVERT(표현식, 데이터형식)

# NOW() : 현재날짜와 시간을 조회함, DATETIME 형태의 문자열
SELECT CAST(now() AS DATE);
SELECT CONVERT(now(), DATE);
SELECT CAST(1.12 AS UNSIGNED INT); # 부호가 없는 INT로 변경해라
SELECT CAST(-1.12 AS SIGNED INT); # 부호가 있는(음수가 되는) INT로 변경해라

SELECT '100' + '200'; # 결과는 300, 멋대로 문자를 숫자로 변경
SELECT CONCAT(100, 200); # 결과는 100200, CONCAT은 무조건 문자로 이어진다

# 숫자와 문자를 비교 
SELECT 1 > '2입니닼'; # 결과는 0(FALSE), --> 숫자로 시작하기 때문에 2라는 숫자로 판단한다.
SELECT 1 > '입니닼50'; # 결과는 1, --> 문자로 시작하기 때문에, 문자는 숫자로 따지면 0으로 판단한다.
SELECT 1 > '100입니닼50'; # 결과는 0, --> 100까지만 숫자로 판단하기 때문에 숫자 100으로 된다

# 제어함수 ***** 제대로 알아두기 SQLD에 자주나옴!!  헷갈림 주의!!
# IF의 수식 결과를 보고 둘중에 하나 선택한다
SELECT IF(1!=1, '맞습니다','아닙니다') AS 결과;
SELECT *, IF(birthYear > 1970, '젊은이', '늙은이') FROM usertbl;

# IFNULL
# NULL인 값을 다른 값(기본값을 정하고싶다)으로 대체할 때 자주사용
# NULL이면 뒤에거 선택
SELECT IFNULL(NULL, 'ZZZ');
SELECT IFNULL('ㅎㅎㅎ', 'ㅋㅋㅋ') 결과;

SELECT *, IFNULL(`mobile1`, '-') FROM usertbl; # mobile1=NULL이면 -로 넣어주기

# NULLIF
# 두개가 같으면 NULL, 다르면 앞에거 선택
SELECT NULLIF(100,100);

####################
SELECT 1,2,3,
CASE 100
	WHEN 100 THEN '100이당'
	WHEN 200 THEN '200이네'
    WHEN 300 THEN '300이네'
END 결과; # END : CASE구문 자체가 열이름이 되기때문에 이름을 꼭 바꿔주기

SELECT 1,2,3,
CASE 
	WHEN 1 > 0 THEN '100이당'
	WHEN 2 > 0 THEN '200이네'
    WHEN 300 THEN '300이네'
    ELSE '해당없음'  # 위에서 아무것도 해당되지 않을 때 선택할것
END 결과;

# WHEN순차적으로 봄 첫번째 WHEN 구문에 TRUE면 밑의 WHEN 구문은 보지도 않음

SELECT *,
	CASE mobile1 
    WHEN '010' THEN '최신폰'
    ELSE '낡은폰'
    END 폰상태
FROM usertbl;

##################
# 문자열의 크기/ 길이를 판단
# 1byte = 8bit
# 영어, 숫자. 기본특수문자(!~@#$%^&*) : 1byte
# 한글, 일본어, 중국어 ... : 3byte
SELECT LENGTH('ABC123'); # 할당된 Byte수, 6Byte
SELECT LENGTH('안녕?'); # 7 할당된 byte 수 (3+3+1)
SELECT CHAR_LENGTH('안녕?'); # 3

# CONCAT
SELECT CONCAT(1,2,3,4,5,6,7,8); # 몇개를 쓰던지 이어진다.
SELECT CONCAT_WS('_',1,2,3,4,5,6,7,8); # 맨첫번째 글자는 구분자

SELECT FORMAT(123456.789, 1); # 소수점 첫번째 자리에서 반올림 --> 결과 : 123,456.8
SELECT UPPER('This is TEST'), LOWER('This is TEST'); # 전부 대문자/소문자 변환
SELECT LEFT('This is TEST', 4), RIGHT('This is TEST', 4); 






