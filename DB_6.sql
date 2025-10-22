# JOIN ***중요!!!!
# SELECT * FROM - INNER JOIN - IN ;

SELECT * FROM pri;
SELECT * FROM fore;
SELECT * FROM fore, pri
WHERE pri_id = id; 
# pri_id = id 를 제외한 나머지 데이터는 의미 X 

############# 옛날방식
SELECT * FROM usertbl U;
SELECT * FROM usertbl U, buytbl B 
WHERE U.userid = B.userid AND U.userid= 'KBS'; 
# 열의 이름이 같으면 : 테이블명.열이름

############## JOIN이용
# SELECT * FROM usertbl U INNER JOIN buytbl B; 	== 	SELECT * FROM usertbl U, buytbl B; 
SELECT * 
FROM usertbl U
	INNER JOIN buytbl B
    ON U.userid = B.userid
WHERE U.userid = 'KBS';	

SELECT U.userid, name, birthyear, prodname
FROM usertbl U
	INNER JOIN buytbl B
    ON U.userid = B.userid
WHERE U.userid = 'KBS';	
# FROM부터 실행되기 때문에 새로 지정한 이름인 U, B만 사용가능 (usertbl, buytbl 이름은 사용 x)

############# usertbl 에는 정보가 있는데 buytbl에 존재하지 않는 userid는 구매하지 않은 사람
## sub query --> 주 테이블에 있는 정보만 최종적으로 SELECT가 가능
SELECT * FROM usertbl WHERE userid NOT IN (SELECT userid FROM buytbl); # 구매하지 않은 사람(BUYTBL에 구매이력이 X)
SELECT * FROM usertbl WHERE userid IN (SELECT userid FROM buytbl); 

# join --> 이미 결합을 한 상태이기 때문에 모든 테이블의 정보를 다 SELECT 할 수 있다
SELECT * FROM usertbl U
	INNER JOIN buytbl B
    ON U.userid = B.userid; # 구매이력이 있는 사람들만 출력
    
SELECT U. * FROM usertbl U
	INNER JOIN buytbl B
    ON U.userid = B.userid; # 구매이력이 있는 사람들만 usertbl에서 출력

SELECT DISTINCT U. * FROM usertbl U
	INNER JOIN buytbl B
    ON U.userid = B.userid; # 중복제거
    
############# JOIN 2번 /stdtbl - stdclubtbl(중간테이블) - clubtbl/ - ppt참고
SELECT S.*, C.* FROM stdtbl S
	INNER JOIN stdclubtbl SC
    ON S.stdname = SC.stdname
    INNER JOIN clubtbl C
    ON SC.clubname = C.clubName;

######### 실습 (서브쿼리랑 조인 둘다 가능한 문제는 둘다 해보기)
# 1 B테이블의 전체 출력 B.*
SELECT B.* FROM usertbl U
	INNER JOIN buytbl B
    ON U.userID = B.userID
WHERE Name = '바비킴';

SELECT * FROM usertbl U, buytbl B WHERE U.userID = B.userID AND name = '바비킴'; # 같은지 확인

# 2 그룹으로 묶어주는 것, SUM 잊지말기!!
SELECT * FROM buytbl;
SELECT userID, price, amount, price*amount FROM buytbl WHERE price*amount >= 200; 

SELECT U.userID, name, addr, prodname, CONCAT(mobile1, mobile2), SUM(price*amount) 합계 FROM buytbl B
	INNER JOIN usertbl U
    ON U.userID = B.userID
GROUP BY B.userID
HAVING 합계 >= 200;
# 설정을 따로 했기 때문에 출력가능 

# 3 prodname 중복제거? ** 다른 열과 같이 출력할 필요 X
SELECT * FROM usertbl;
SELECT * FROM usertbl WHERE birthYear BETWEEN 1970 AND 1979;
SELECT DISTINCT prodName FROM usertbl U
	INNER JOIN buytbl B
    ON U.userID = B.userID
WHERE birthYear BETWEEN 1970 AND 1979; 

# 4
SELECT * FROM clubtbl; # clubname
SELECT * FROM stdclubtbl; # clubname , stdname
SELECT * FROM stdtbl; # stdname (addr 포함)
SELECT * FROM clubtbl WHERE clubName = '봉사'; 

SELECT DISTINCT addr FROM clubtbl C
	INNER JOIN stdclubtbl SC
	ON C.clubName = SC.clubName
    INNER JOIN stdtbl S
	ON SC.stdName = S.stdName
WHERE C.clubName = '봉사';

# stdclubtbl  에 누가 어떤 동아리에 들어있는지 확인이 가능하므로 join 1번만 해도 가능
SELECT DISTINCT addr FROM stdclubtbl SC
    INNER JOIN stdtbl S
	ON SC.stdName = S.stdName
WHERE SC.clubName = '봉사';

# 5 서브쿼리만 가능 inner join구문은 모든 열을 다 매핑해서 연결하기 때문에 가입되어있지 않은 동아리를 찾을 수 없다.
# 동아리를 하나도 가입하지 않은 학생의 정보조회
SELECT * FROM stdtbl WHERE stdname NOT IN  (SELECT stdname FROM stdclubtbl); 
# 회원이 한명도 가입되어 있지 않은 동아리의 정보조회
SELECT * FROM clubtbl WHERE clubname NOT IN  (SELECT clubname FROM stdclubtbl);

##############
# 외부결합(outer join)
SELECT * FROM usertbl
	LEFT OUTER JOIN buytbl # on구문 없으면 실행 불가능
    ON usertbl.userid = buytbl.userid; 
# left outer join 을 사용했기 때문에 usertbl에 있는 모든 데이터들이 출력 --> 구매이력이 없는 사람도 출력
# right outer join 을 사용하면 buytbl의 모든 데이터들만 출력 --> 구매이력이 없는 사람은 출력되지 X
# SELECT * FROM -1- LEFT OUTER JOIN -2- (LEFT기준 왼쪽에 있는 '-1-' 데이터가 모두 출력) 

SELECT * FROM usertbl
	LEFT OUTER JOIN buytbl # on구문 없으면 실행 불가능
    ON usertbl.userid = buytbl.userid
WHERE num IS NULL; # buytbl에서 num은 pk라서 null이 될 수 없는데 null이면 데이터가 없다는 소리

#########################
SELECT * FROM stdtbl S
	LEFT OUTER JOIN stdclubtbl SC
	ON S.stdName = SC.stdName
    LEFT OUTER JOIN clubtbl C
    ON C.clubName = SC.clubName;

SELECT * FROM stdtbl S
	LEFT OUTER JOIN stdclubtbl SC
	ON S.stdName = SC.stdName
    RIGHT OUTER JOIN clubtbl C # CLUB 데이터가 전부 다 나옴
    ON C.clubName = SC.clubName;
    
# INNER JOIN을 사용할꺼면 초반에만 사용 중반에 쓰면 다른 JOIN을 쓴것이 의미가 X

SELECT * FROM stdtbl S
	RIGHT OUTER JOIN stdclubtbl SC
	ON S.stdName = SC.stdName
    RIGHT OUTER JOIN clubtbl C
    ON C.clubName = SC.clubName;

SELECT S.*, SC.joinDate, c.* FROM stdtbl S
	LEFT OUTER JOIN stdclubtbl SC
	ON S.stdName = SC.stdName
    LEFT OUTER JOIN clubtbl C
    ON C.clubName = SC.clubName
UNION ALL    
SELECT S.*, SC.joinDate, c.* FROM stdtbl S
	RIGHT OUTER JOIN stdclubtbl SC
	ON S.stdName = SC.stdName
    RIGHT OUTER JOIN clubtbl C
    ON C.clubName = SC.clubName;

###########
# UNION : 테이블의 결과를 병합(합집합)
SELECT 1, 2, 3
	UNION
SELECT 'A', 'B', 1
	UNION
SELECT 1, 2, 3;
# 조회하는 열의 개수 동일(데이터 타입은 상관 X)\
# 중복되는 건 합쳐짐

SELECT 1, 2, 3
	UNION
SELECT 'A', 'B', 1
	UNION ALL
SELECT 1, 2, 3;
# UNION ALL : 중복제거하지 않고 다 합쳐짐
# UNION ALL을 앞에 넣어도 마지막에 UNION을 넣으면 중복제거됨


















