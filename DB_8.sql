# 문자열 내에 문자열 삽입
SELECT INSERT('abcdef', 0, 0, '!@#');
SELECT INSERT('abcdef', 1, 2, '!@#'); # 'abcdef'의 1번째위치에서 2개를 지우고 '!@#'를 넣어라

# 1234와 합해서 10개 문자가 될때까지 #을 왼쪽(LPAD), 오른쪽(RPAD)에 추가한다.
SELECT LPAD('1234', 10, '#');
SELECT RPAD('1234', 10, '#');

SELECT TRIM('            !     ABCD     !         ');
SELECT RTRIM('            !     ABCD     !         ');
SELECT LTRIM('            !     ABCD     !         ');
# 다른 문자를 만날때까지 양쪽에 있는 ! 문자를 지워라
SELECT TRIM(BOTH '!' FROM '!!!!!!     ABCD     !!!!!');

# 1번째 위치부터 4개 문자만 잘라서 가져오세요
SELECT SUBSTRING('This is MySQL', 1, 4);

# MySQL 문자열을 찾아서 Python으로 바꿔라
SELECT REPLACE('This is MySQL', 'MySQL', 'Python');

###################
# NOW() : 현재 날짜와 시간을 알려주는 DATETIME 형식의 데이터
# SYSDATE() : 현재 시스템(윈도우 OS)의 시간을 알려주는 DATETIME 형식의 데이터
# CURRENT_TIMESTAMP() : 1970년 1월 1일 기준으로 현재까지 지난 초를 알려주는 TIMESTAMP 형식의 데이터
SELECT CURDATE(), CURTIME(), NOW(), SYSDATE(), CURRENT_TIMESTAMP, 
		UNIX_TIMESTAMP(), from_unixtime(1739841591);
SELECT NOW();
SELECT YEAR(NOW()), SECOND(NOW()), CAST(NOW() AS DATE);

# DATE는 년/월/일 사이에 아무 문자나 맞춰 적으면 알아서 잘해준다
SELECT DATE('2025-01-11 11:11:11');
SELECT DATE('2025/01/11 11:11:11'); 
# TIME은 : 으로 해야한다
SELECT TIME('11:11:11');

SELECT DATE_FORMAT(NOW(), '오늘은 %Y년%m월%d일 오전 %I시%i분%s초');
SELECT STR_TO_DATE('2024-01-05 13:22:40', '%Y-%m-%d'); # '-'로 데이터를 입력했으니 잘 읽어라
SELECT STR_TO_DATE('2024!01~05 13:22:40', '%Y!%m~%d %H:%i:%S');

# <, >연산자로 판단 -, +로 연산 불가능
SELECT DATE('2025-02-17') < DATE('2025-01-17');

USE world;
SELECT
	GROUP_CONCAT(`name`) # 한 칸에 이름을 다 묶어줌
FROM city
WHERE countryCode='kor';

SELECT
	GROUP_CONCAT(`name` SEPARATOR '-')
FROM city
WHERE countryCode='kor';

########
SELECT NOW(), SYSDATE();
SELECT SYSDATE(), SLEEP(2), SYSDATE();

######
# 4
USE practice;
SELECT * FROM usertbl;

SELECT userid,
	CASE addr
		WHEN '서울' THEN 'A'
		WHEN '경기' THEN 'B'
		WHEN '경남' THEN 'C'
		WHEN '전남' THEN 'D'
		WHEN '경북' THEN 'E'
    END 지역구분
FROM usertbl;

# 3
SELECT * FROM buytbl;
SELECT * FROM buytbl GROUP BY groupName;
SELECT CONCAT(groupName, ': ', price, '개') AS '종류:개수' FROM buytbl 
WHERE groupName IS NOT NULL
GROUP BY groupName; 

# 2 *** 일, 시간을 한번에 빼는 방법??
SELECT current_timestamp(); 
SELECT SUBDATE(current_timestamp(), 4);
SELECT SUBTIME(current_timestamp(),'1:0:0');
SELECT DATE_FORMAT(SUBDATE(current_timestamp(), 4), '오늘은 %Y년 %m월 %d일 %I시 %i분 %s초');

# 
SELECT ADDTIME(NOW(), '1:0:0'), ADDTIME(CURRENT_TIMESTAMP, 4);
SELECT ADDTIME(ADDTIME(CURRENT_TIMESTAMP, 4), '1:0:0') AS 결과;

# 1
SELECT REPLACE('21-12-40', '-', ':');
SELECT DATE('2020-05-14'), TIME(REPLACE('21-12-40', '-', ':'));



