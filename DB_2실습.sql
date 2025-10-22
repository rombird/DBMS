SELECT * FROM usertbl;
SELECT * FROM buytbl;

#실습
SELECT * FROM buytbl WHERE amount >= 5;
SELECT * FROM buytbl WHERE groupName = '서적' OR groupName = '전자';
# == SELECT * FROM buytbl WHERE groupName IN ('서적', '전자');
SELECT userID, prodName FROM buytbl WHERE groupName <=> NULL;
# == SELECT userID, prodName FROM buytbl WHERE groupName IS NULL;
SELECT * FROM buytbl WHERE amount BETWEEN 3 AND 10 ORDER BY price;
SELECT * FROM usertbl WHERE userID LIKE 'K%';
SELECT DISTINCT userID FROM buytbl ORDER BY userID DESC;
SELECT name, birthyear, addr FROM usertbl WHERE birthYear >= 1970;