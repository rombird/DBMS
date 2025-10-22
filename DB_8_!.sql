START TRANSACTION; # transcation안에서 사용하고 있다(만약 실행하지 않고 delete시 원데이터 삭제)
SELECT * FROM usertbl;
INSERT INTO usertbl(userid, name) VALUES('A','A');
DELETE FROM `usertbl` WHERE userid = 'BBK';
COMMIT; # TRANSACTION 끝, 확정 (INSERT, DELETE한 구문 원데이터에 남아있음)
ROLLBACK; # TRANSACTION 끝, (INSERT한 데이터 사라짐)

FLUSH TABLES WITH READ LOCK; # 락 건다(다른 세션에서 사용안됨)
UNLOCK TABLES; # 락 해제

##############
LOCK TABLES usertbl READ; # 읽기 가능
SELECT * FROM usertbl; 
INSERT INTO usertbl(userid, name) VALUES('A','A'); # 쓰기 불가능

LOCK TABLES usertbl WRITE; # 읽고 쓰기 가능
SELECT * FROM usertbl; 
INSERT INTO usertbl(userid, name) VALUES('B','B'); # 쓰기 가능

#############
START TRANSACTION;
# DELETE FROM usertbl;
SELECT * FROM usertbl LOCK IN SHARE MODE; # FOR SHARE
ROLLBACK; 
SELECT * FROM usertbl FOR UPDATE;

START TRANSACTION;
UPDATE usertbl SET name = 'ㅋㅋㅋ' WHERE userid='EJW';
SELECT * FROM usertbl; 
ROLLBACK;









