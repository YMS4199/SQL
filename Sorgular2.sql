-- 1960 yilinda doğanlarin listelenmesi

SELECT FirstName , LastName , BirthDate
FROM Employees
WHERE YEAR(BirthDate) = 1960;

-- 1950 ile 1961 yillari arasinda doğanlar

SELECT FirstName , LastName , BirthDate
FROM Employees
WHERE YEAR(BirthDate) >= 1950
      AND 
      YEAR(BirthDate) <= 1961;

-- between => aralık bildirme işlemi

SELECT FirstName , LastName , BirthDate
FROM Employees
WHERE YEAR(birthdate) BETWEEN 1950 AND 1961; -- verilen değerler sorguya dahil edilir.
-- ingiltere'de oturan bayanlarin adi, soyadi, mesleği, ünvani, ülkesi ve doğum tarihini listeleyiniz (Employees)

SELECT FirstName , LastName , TitleOfCourtesy , Title , Country
FROM Employees
WHERE ( TitleOfCourtesy = 'Ms.'
        OR 
        TitleOfCourtesy = 'Mrs.' )
      AND 
      Country = 'UK';

-- Ünvani Mr. olanlar veya yaşi 60'tan büyük olanlarin listelenmesi

SELECT TitleOfCourtesy , FirstName , LastName , YEAR(GETDATE()) - YEAR(BirthDate) AS Age
FROM Employees
WHERE YEAR(GETDATE()) - YEAR(BirthDate) > 60
      OR 
      TitleOfCourtesy = 'Mr.';

-- GETDATE() fonksiyonu güncel tarih bilgisini verir, YEAR() fonksiyonu ile birlikte o tarihe ait olan yil bilgisini öğreniyoruz. Where ifadesi ile  birlikte kendi isimlendirdiğimiz sütunlari kullanamayiz. Örneğin yukarida Yaş olarak isimlendirdiğimiz sütun ismini Where ifadesi ile birlikte kullanamayiz.
-- NULL VERiLERi SORGULAMAK

SELECT Region
FROM Employees;

SELECT TitleOfCourtesy , Title , FirstName , LastName , Region
FROM Employees
WHERE Region IS NULL;  -- bölgesi belirtilmeyen çalışanların listesi

SELECT TitleOfCourtesy , Title , FirstName , LastName , Region
FROM Employees
WHERE Region IS NOT NULL; -- bölgesi belirtilen çalışanların listesi
-- NOT: NULL değerler sorgulanirken = veya <> gibi operatörler kullanilmaz. Bunun yerine IS NULL veya IS NOT NULL ifadeleri kullanilir.
-- Sıralama İşlemleri 

SELECT EmployeeID , FirstName , LastName , Title
FROM Employees
WHERE EmployeeID BETWEEN 2 AND 8
ORDER BY FirstName ASC; -- ascending(artan sırada)

SELECT FirstName , LastName , BirthDate
FROM Employees
ORDER BY BirthDate; -- Eğer ASC ifadesini belirtmezsek de default olarak bu şekilde siralama yapacaktir. Bu sorguda BirthDate sütununa göre artan sirada siralama yaptik.

SELECT FirstName , LastName , BirthDate , HireDate
FROM Employees
ORDER BY HireDate DESC; -- descending azalan sırada sıralama işlemi yapar.
-- ASC ifadesi sayisal sütunlarda küçükten büyüğe, metinsel sütunlarda A'dan Z'ye doğru siralama işlemi yaparken, DESC ifadesi tam tersi şekilde siralama yapar.

SELECT FirstName , LastName , BirthDate , TitleOfCourtesy
FROM Employees
ORDER BY FirstName , LastName DESC;

SELECT FirstName , -- 1. Kolon
LastName , -- 2. Kolon
BirthDate , -- 3. Kolon
HireDate , -- 4. Kolon
Title , -- 5. Kolon
TitleOfCourtesy  -- 6. Kolon
FROM Employees
ORDER BY 4 , 6 DESC;

-- Çalişanlari ünvanlarina göre ve ünvanlari ayniysa yaşlarina göre büyükten küçüğe siralayiniz.

SELECT TitleOfCourtesy , FirstName , LastName , YEAR(GETDATE()) - YEAR(BirthDate) AS Age
FROM Employees
ORDER BY TitleOfCourtesy , Age DESC; -- Order By ifadesi ile sütunlara vermiş olduğumuz takma isimleri kullanabiliriz. Örneğin Age sütunundaki gibi.
-- BETWEEN - AND KULLANIMI
-- Aralik bildirmek için kullanacağimiz bir yapi sunar.
-- 1952 ile 1960 arasinda doğanlarin listelenmesi
-- 1. Yol

SELECT FirstName , LastName , YEAR(BirthDate) AS BirthMonth
FROM Employees
WHERE YEAR(BirthDate) >= 1952
      AND 
      YEAR(BirthDate) <= 1960
ORDER BY 3;

-- 2. Yol

SELECT FirstName , LastName , YEAR(BirthDate) AS BirthMonth
FROM Employees
WHERE YEAR(BirthDate) BETWEEN 1952 AND 1960
ORDER BY 3;

-- Alfabetik olarak Janet ile Robert arasinda olanlarin listelenmesi

SELECT FirstName , LastName
FROM Employees
WHERE FirstName BETWEEN 'Janet' AND 'Robert'
ORDER BY FirstName;

-- IN KULLANIMI
-- Ünvani Mr. veya Dr. olanlarin listelenmesi
-- 1. Yol

SELECT TitleOfCourtesy , FirstName , LastName
FROM Employees
WHERE TitleOfCourtesy = 'Mr.'
      OR 
      TitleOfCourtesy = 'Dr.'
ORDER BY TitleOfCourtesy;
-- 2. Yol

SELECT TitleOfCourtesy , FirstName , LastName
FROM Employees
WHERE TitleOfCourtesy IN ( 'Mr.' , 'Dr.'
                         )
ORDER BY TitleOfCourtesy;

-- 1950, 1955 ve 1960 yillarinda doğanlarin listelenmesi

SELECT FirstName , LastName , BirthDate
FROM Employees
WHERE YEAR(BirthDate) IN ( 1950 , 1955 , 1960
                         );

-- TOP Kullanimi

SELECT TOP 3 FirstName , LastName , Title
FROM Employees; -- ilk 3 kayit getirilir.

SELECT TOP 5 EmployeeID , FirstName , LastName , BirthDate
FROM Employees
ORDER BY FirstName; -- TOP ifadesi bir sorguda en son çalişan kisimdir. Yani öncelikle sorgumuz çaliştirilir ve oluşacak olan sonuç kümesinin (result set) ilk 5 kaydi alinir.
-- Çalişanlari yaşlarina göre azalan sirada siraladiktan sonra, oluşacak sonuç kümesinin %25'lik kismini listeleyelim.

SELECT TOP 25 PERCENT FirstName , LastName , YEAR(GETDATE()) - YEAR(BirthDate) AS Age
FROM Employees
ORDER BY Age;

-- LIKE KULLANIMI
-- Adı Michael olan personellerin listelenmesi
-- 1. Yol

SELECT FirstName , LastName
FROM Employees
WHERE FirstName = 'Michael';

-- 2. Yol

SELECT FirstName , LastName
FROM Employees
WHERE FirstName LIKE 'Michael';

-- Adının ilk harfi A ile başlayanlar

SELECT FirstName , LastName
FROM Employees
WHERE FirstName LIKE 'A%'
ORDER BY LastName;

-- Soyadının son harfi N olanların listelenmesi

SELECT FirstName , LastName
FROM Employees
WHERE LastName LIKE '%N'
ORDER BY LastName;

-- Adının ilk harfi A veya L olanlar
-- 1. Yol

SELECT FirstName , LastName
FROM Employees
WHERE FirstName LIKE 'A%'
      OR 
      FirstName LIKE 'L%'
ORDER BY LastName;

-- 2. Yol

SELECT FirstName , LastName
FROM Employees
WHERE FirstName LIKE '[AL]%'
ORDER BY LastName;

-- Adının içerisinde R veya T harfi bulunanlar

SELECT FirstName , LastName
FROM Employees
WHERE FirstName LIKE '%[RT]%'
ORDER BY LastName;

-- Adının ilk harfi alfabetik olarak J ile R aralığında olanlar

SELECT FirstName , LastName
FROM Employees
WHERE FirstName LIKE '[J-R]%'
ORDER BY FirstName;

-- Adı şu şekilde olanlar: tAmEr, yAsEmin, tAnEr (A ile E arasında tek bir karakter olanlar)

SELECT FirstName , LastName
FROM Employees
WHERE FirstName LIKE '%A_E%'
ORDER BY FirstName;

--Adının içerisinde A ile E arasında iki tane karakter olanlar

SELECT FirstName , LastName
FROM Employees
WHERE FirstName LIKE '%A__E%'
ORDER BY FirstName;

-- Adının ilk iki harfi LA, LN, AA veya AN olanlar

SELECT FirstName , LastName
FROM Employees
WHERE FirstName LIKE '[LA][AN]%'
ORDER BY FirstName;

SELECT 5 + 6;

SELECT GETDATE();

SELECT 'Bilge Adam Beşiktaş';

PRINT 'Bilge Adam';

-- String Fonksiyonlar

SELECT ASCII('A') AS 'Ascii Değeri (sayısal)';

SELECT CHAR(65) AS 'Metinsel Değeri';

SELECT CHARINDEX('@' , 'murat.vuranok@bilgeadam.com') AS IndexNo; -- Arama işlemine soldan sağa doğru yapar :)

SELECT LEFT('Bilge Adam' , 5) AS 'Soldan sağa karakter al';

SELECT RIGHT('Bilge Adam' , 4) AS 'Sağdan sola karakter al';

SELECT 
-- nabüyün  
LEN('bilge adam') AS 'Toplam Uzunluk Teslim Eder';

SELECT LOWER('BİLGe ADAM') AS 'LOWER' , UPPER('bilge Adam') AS 'UPPER';

SELECT LEN('           bilge adam');

SELECT LTRIM('           bilge adam') AS 'Soldaki boşlukları siler';

SELECT LEN(LTRIM('           bilge adam'));

SELECT LEN('bilge adam           ');

SELECT RTRIM('bilge adam           ') AS 'Sağdaki boşlukları siler';

SELECT LEN(RTRIM('bilge adam           '));

SELECT REPLACE('bilge adam' , 'adam' , 'hatun');

SELECT REPLACE('b i l g e a d a m' , ' ' , '-');

-- tüm metni küçük harf alınız ve metin içerisinde yer alan türkçe karakterleri temizleyiniz(ş,s)(ç,c) vs..

SELECT REPLACE(REPLACE(REPLACE(LOWER(ProductName) , 'ô' , 'o') , '''' , '-') , 'ş' , 's')
FROM Products
ORDER BY 1;

PRINT 'bilge adam''da';

SELECT REVERSE('bilge adam');

SELECT REPLICATE('Seni Çok Seviyorum KızınAdıGelecek' , 1000);

SELECT 'bilge' + SPACE(50) + 'adam';

-- 1. Ödev  bir mail adresinden istenilen datalar
-- murat.vuranok@bilgeadam.com
-- 1) isim
-- 2) soyisim
-- 3) domain
-- 4) mail
-- 2. Ödev bir telefon numarasını formatlayınız.
-- 5324567890    => +90 (532) 456 78 90
-- 05324567890   => +90 (532) 456 78 90

SELECT SUBSTRING('bilge adam' , 1 , 5); -- alt metinler oluştur. 
-- 1. parametre işlem yapılacak olan değer
-- 2. parametre başlanılacak olan index değeri
-- 3. parametre teslim alınacak olan eleman sayısı

DECLARE @mail NVARCHAR(150)= 'murat.vuranok@bilgeadam.com' , @isim NVARCHAR(50) , @soyisim NVARCHAR(50);

PRINT @mail;

SET @mail = @mail + ' beşiktaş';   -- set anahtar kelimesi tek bir değişken ataması yapar

PRINT @mail;

SELECT @mail = '' , @isim = '' , @soyisim = '';