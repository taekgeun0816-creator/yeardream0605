/* =====================================================================
   5장 서브쿼리 — 실습 문제 모음 (답지 포함)
   - 강의자료 순서 준수:
       01 단일 행 서브쿼리   (WHERE 절 + 비교 연산자 =, >, <, ...)
       02 다중 행 서브쿼리   (IN / NOT IN, 그리고 ANY/ALL의 SQLite 대체)
       03 위치에 따른 분류   (스칼라(SELECT절) / FROM절 파생테이블 / EXISTS·상관)
   - 사용 DB: SQLite Tutorial 샘플 데이터베이스 (chinook)
     주요 테이블: artists, albums, tracks, genres,
                  invoices, invoice_items, customers, employees
   - 관계 요약:
       artists.ArtistId      <-> albums.ArtistId
       albums.AlbumId        <-> tracks.AlbumId
       genres.GenreId        <-> tracks.GenreId
       invoices.CustomerId   <-> customers.CustomerId
       invoice_items.TrackId <-> tracks.TrackId
       customers.SupportRepId<-> employees.EmployeeId
   - SQLite는 ANY / ALL 연산자를 지원하지 않음 → MIN / MAX 로 대체
   ===================================================================== */


/* ===============  01. 단일 행 서브쿼리 (WHERE, 비교 연산자)  =========== */



-- 문제 1.
-- 'Balls to the Wall' 트랙보다 재생시간(Milliseconds)이 긴 트랙의
-- 이름과 재생시간을 조회하세요. (단일 행, > 연산자)
-- 메인쿼리 : 이름과 재싱시간 조회
-- 서브쿼리 : 'balls to the wall'의 재생시간 조회

-- 메인쿼리
SELECT Name, Milliseconds
From tracks
WHERE Milliseconds >= (
    SELECT Milliseconds FROM tracks WHERE Name = 'Balls to the wall'
)
;

--서브쿼리
-- 문제 2.
-- 전체 트랙의 평균 재생시간보다 긴 트랙의 이름과 재생시간을 조회하세요.
-- 힌트: 서브쿼리에서 AVG를 쓰면 한 값만 반환 = 단일 행.

--메인쿼리
--이름과 재생시간 조회
SELECT * From tracks;


SELECT Name, Milliseconds
from tracks
WHERE Milliseconds > (
    SELECT AVG(Milliseconds) from tracks
    );

--서브쿼리
--평균재생시간 



-- 문제 3.
-- 단가(UnitPrice)가 가장 비싼 트랙과 '같은' 단가를 가진 트랙의
-- 이름과 단가를 조회하세요. (= 연산자, MAX)

-- 메인쿼리
-- 이름과 단과를 조회하세요

SELECT Name, UnitPrice
from tracks
WHERE UnitPrice = (
    SELECT max(UnitPrice) from tracks
    );


-- 서브쿼리
SELECT max(UnitPrice) from tracks;

-- 문제 4.
-- 앨범 'Let There Be Rock'에 수록된 트랙의 이름을 조회하세요.
-- 힌트: 앨범 1개의 AlbumId는 단일 행 → = 연산자 사용.

-- mainquary
--트랙의 이름을 조회

SELECT Name
from tracks
where AlbumId  = (SELECT AlbumId from albums where Title = 'Let There Be Rock'
);





-- subquary
--'Let There Be Rock' 찾기
SELECT AlbumId from albums where Title = 'Let There Be Rock';
select * from albums;


-- 문제 5.
-- 인보이스 총액(Total)이 전체 평균 총액보다 '작은'(<) 인보이스의
-- InvoiceId와 Total을 조회하세요.

-- mainquary
-- invoiceid와 total 조회

--subquary
--total의 평균 

/* ===================  02. 다중 행 서브쿼리 (IN / NOT IN)  ============== */

-- 문제 6.
-- 'AC/DC'가 발매한 앨범에 속한 모든 트랙의 이름을 조회하세요.
-- 힌트: 아티스트→여러 앨범(다중 행)이므로 IN. (서브쿼리 중첩)

-- 메인쿼리: 트랙의 이름조히
SELECT NAME FROM Tracks
WHERE AlbumId IN (SELECT AlbumId FROM albums WHERE ArtistID = (SELECT ArtistID FROM artists WHERE Name = 'AC/DC'));



-- 서브쿼리:acdc가 발매한 앨범ID
---- 서브쿼리의 메인쿼리 : Album ID FROM Albums
SELECT AlbumId FROM albums;

---- 서브쿼리의 서브쿼리 : AC/DC의 ArtistID조회
SELECT ArtistID from artists where name = 'AC/DC'


-- 서브쿼리 합치기

SELECT AlbumId FROM albums
WHERE ArtistID = (
    SELECT ArtistID from artists where name = 'AC/DC'
);

-- 문제 7.
-- 담당 직원(SupportRepId)이 캐나다(Country = 'Canada')에 근무하는
-- 고객의 이름(FirstName, LastName)을 조회하세요. (IN)
-- 테이블명 (customers, employees)

SELECT * FROM employees;

--메인쿼리
--고객이름을 조회 하세요
SELECT FirstName, LastName from customers
WHERE SupportRepId in (
    SELECT EmployeeId  FROM employees WHERE Country = 'Canada'
    );

--서브쿼리
----담당직원을 찾으세요
SELECT EmployeeId  FROM employees WHERE Country = 'Canada'




-- 문제 8.
-- 한 번이라도 구매된 적이 있는(invoice_items에 등장한) 트랙의 이름을
-- 조회하세요. (IN)
-- 테이블: tracks, invoice_items

--메인쿼리
--트랙의 이름을 조회하세요
SELECT NAME FROM tracks
WHERE trackid in (SELECT TrackId From invoice_items);

--서브쿼리
--한번이라도 구매된적있는 = invoice_items의 trackid 조회
SELECT TrackId From invoice_items

SELECT * FROM invoice_items;

-- 문제 9.
-- 한 번도 구매되지 않은 트랙의 이름을 조회하세요. (NOT IN)
-- 주의: 서브쿼리 결과에 NULL이 섞이면 NOT IN은 아무 것도 반환하지 않을 수
--       있음 → 문제 19의 NOT EXISTS 방식이 더 안전.

SELECT NAME FROM tracks
WHERE trackid NOT IN (SELECT TrackId From invoice_items);


-- 문제 10.
-- 'Rock' 장르의 트랙이 한 곡이라도 포함된 앨범의 제목을 조회하세요. (IN)
--테이블명: albums, tracks, genres

--메인트랙
--앨범의 제목을 조회
SELECT Title FROM Albums
WHERE AlbumID IN (SELECT AlbumId FROM tracks WHERE GenreId = (SELECT GenreId FROM genres WHERE NAME = 'Rock'));


--서브트랙
--트랙찾기
SELECT AlbumId FROM tracks
WHERE GenreId = (SELECT GenreId FROM genres WHERE NAME = 'Rock')

--서브서브트랙
--장르아이디 찾기
SELECT GenreId FROM genres WHERE NAME = 'Rock'

SELECT * FROM genres;


/* ----  [SQLite 보강] 강의자료의 ANY / ALL → SQLite에서는 MIN / MAX  ---- */

-- 문제 11.  (강의자료의 ALL 개념)
-- 'Rock' 장르의 '모든' 트랙보다 재생시간이 긴 트랙의 이름을 조회하세요.
-- SQLite 미지원: WHERE Milliseconds > ALL (SELECT Milliseconds ...)
-- 대체: ALL → MAX (모든 값보다 크다 = 최댓값보다 크다)

--메인쿼리 트랙이름 조회, 재생시간 Name, Milliseconds
SELECT Name, Milliseconds FROM tracks
WHERE Milliseconds > (SELECT MAX(Milliseconds) FROM tracks
WHERE GenreId = (SELECT GenreID from genres WHERE Name = 'Rock')
);
-- 서브쿼리 
--  rock 장르와 관련된 것은 Genres테이블, GenreID

SELECT MAX(Milliseconds) FROM tracks
WHERE GenreId = (SELECT GenreID from genres WHERE Name = 'Rock')




-- 문제 12.  (강의자료의 ANY 개념)
-- 'Jazz' 장르 트랙 중 '하나라도'보다 재생시간이 긴 트랙의 이름을 조회하세요.
-- SQLite 미지원: WHERE Milliseconds > ANY (...)
-- 대체: ANY → MIN (하나라도보다 크다 = 최솟값보다 크다)

-- 메인쿼리
-- 트랙이름조회
SELECT Name, Milliseconds FROM tracks


--서브쿼리
재즈 장르중
SELECT 

재즈장르중에서 하나라도 


/* ============  03. 위치에 따른 분류 — 스칼라 서브쿼리 (SELECT 절)  ===== */

-- 문제 13.
-- 각 앨범의 제목과, 그 앨범에 속한 트랙 수를 스칼라 서브쿼리로 함께
-- 조회하세요. (상관 서브쿼리: 바깥의 a.AlbumId 참조)
SELECT
    a.Title
    , (SELECT COUNT(*) FROM tracks t WHERE t.AlbumID = a.AlbumID) AS track_cnt --앨범의 속한 트랙수
FROM albums a;

-- 문제 14.
-- 각 고객의 이름과, 그 고객의 총 결제 금액(SUM(Total))을 스칼라 서브쿼리로
-- 조회하세요.

SELECT NAME, ()

-- 서브쿼리 총 결제금액
SELECT c. FirstName, c. LastName, (SELECT SUM(i.Total) FROM invoices i WHERE i.CustomerId = c.CustomerId) AS total_spent
FROM customers C 
;
-- 문제 15.
-- 각 트랙의 이름과, 그 트랙이 속한 앨범 제목을 스칼라 서브쿼리로 조회하세요.
-- (강의자료 포인트: 스칼라 서브쿼리는 JOIN과 같은 결과)

-- 메인
SELECT t.name, (SELECT al.title FROM albums al where al.AlbumId = t.AlbumID) AS album_title 

FROM tracks t ;


-- 문제 15-1.  (참고) 위 문제 15를 JOIN으로 바꾼 동일 결과


/* -------------  [보강] FROM 절 서브쿼리 (파생 테이블, 별칭 필수)  ------- */

-- 문제 16.
-- 앨범별 트랙 수를 먼저 구한 뒤, 그 트랙 수의 '전체 평균'을 구하세요.
-- 힌트: FROM 절 서브쿼리에는 반드시 별칭(AS ...)을 붙입니다.

-- 문제 17.
-- 국가별 매출 합계를 구한 파생 테이블에서, 매출이 높은 상위 5개 국가를
-- 조회하세요.

-- SELECT * FROM () GROUP BY / ORDER BY
-- 메인쿼리 : 매출이 높은 국가
-- invoices

SELECT BillingCountry FROM (select BillingCountry, sum(Total) From invoices GROUP BY BillingCountry ORDER by 2 DESC LIMIT 5);


--select BillingCountry, sum(Total) From invoices GROUP BY BillingCountry ORDER by 2 DESC LIMIT 5;


/* ----------------  [보강] EXISTS / 상관 서브쿼리  -------------------- */

-- 문제 18.
-- 트랙이 한 곡이라도 존재하는 앨범의 제목을 EXISTS로 조회하세요.

-- 문제 19.
-- 한 번도 구매된 적이 없는 트랙의 이름을 NOT EXISTS로 조회하세요.
-- (문제 9의 NOT IN보다 NULL 안전한 방식)

-- 문제 20.  (종합)
-- 각 직원에 대해 그 직원이 담당하는 고객 수를 스칼라 서브쿼리로 구하되,
-- 담당 고객이 한 명 이상인 직원만 조회하세요.
-- (스칼라 서브쿼리 + WHERE 절 다중 행 서브쿼리 동시 사용)


