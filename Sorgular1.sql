
-- northwind indirebileceğiniz link
-- http://blog.regencysoftware.com/post/2014/11/16/download-sql-server-northwind-database-bak-file

USE Northwind;  -- Kullanmak istediğimiz database'i komut ile seçebilirsiniz.
-- Tek satırlık yorum satırı
/*
Çoklu
Yorum
Satırı
*/

-- Bilgilendirme ekranı için Ctrl+r (açıp kapatır)
-- sorguyu çalıştırmak için (execute) F5, alt+x veya menüde yer alan execute butonu
-- Tabloları sorgulamak
-- select <sütun adları, *> from <tablo adı>
-- * yıldız anahtar kelimesi, kullanılmaması gereken nesnelerden biridir :) performans için.
-- NOT: Sorgularımızı yazarken küçük-büyük harfe dikkat etmemize gerek yok. (Eğer başlangıçta Server kurulurken bu ayar seçilmiş ise)
--DML-> Data Manipulation Language

SELECT *
FROM Employees;

-- Tüm kolonları eklemek için, select ile from arasına tablo içerisinde yer alan columns klasörünü sürükleyip bırakabilirsiniz.

SELECT [EmployeeID] , [LastName] , [FirstName] , [Title] , [TitleOfCourtesy] , [BirthDate] , [HireDate] , [Address] , [City] , [Region] , [PostalCode] , [Country] , [HomePhone] , [Extension] , [Photo] , [Notes] , [ReportsTo] , [PhotoPath]
FROM Employees;

SELECT FirstName , LastName
FROM Employees;

-- Employees tablosundan, çalışanlara ait ad, soyad, görev ve doğum tarihi bilgilerini listeleyelim

SELECT FirstName , LastName , Title , BirthDate
FROM Employees;

-- Tablo sütunlarının isimlendirilmesi.
-- 1. Yol

SELECT FirstName AS Ad , LastName AS Soyad , Title AS Görev
FROM Employees;

-- 2. Yol

SELECT FirstName AS Adi , LastName AS Soyadi , Title AS Görev , BirthDate AS 'Doğum Tarihi'
FROM Employees;

-- 3. Yol

SELECT [Adi] = [FirstName] , 'Soyadi' = LastName , Görev = Title , 'Doğum Tarihi' AS BirthDate , [İşe Giriş Tarihi] = HireDate
FROM Employees;

-- Tekil Kayıtların Listelenmesi

SELECT DISTINCT 
       City
FROM Employees;

SELECT DISTINCT 
       FirstName , City
FROM Employees;

-- Metinleri birleştirmek 

SELECT TitleOfCourtesy + ' ' + FirstName + ' ' + LastName AS Personel
FROM Employees;

SELECT CONCAT(TitleOfCourtesy , ' ' , FirstName , ' ' , LastName) AS Employees
FROM Employees;

-- + operatörü ile metinleri birleştirebiliriz. ' ' ile araya boşluk  ekliyoruz. Eğer as ısim demeseydik, tablomuzda sorguda yazdığımız gibi bütün bir sütun olmadığı için sütun başlığı olarak NoColumnName ifadesi yazacaktı.
-- Veritabanı İşlemleri 
-- Create  => tablo üzerine veri ekleme işlemi
-- Read    => select * from tabloAdi
-- Update  => tabloda yer alan kay(ıtların)dın güncellenme işlemi
-- Delete  => tabloda yer alan kay(ıtların)dın silinme işlemi
-- 1) INSERT: Bir veritabanındaki tablolardan birine yeni kayıt eklemek için kullanacağımız komuttur.

/*
     insert into <tabloAdi> (sütun adları,) values(sütun değerleri,)
*/

SELECT *
FROM Categories;
-- NOT : eğer bir alan primary key ise ve o alan identity özelliğine sahipse id değeri otomatik olarak sql tarafından veriliyor anlamına gelir. ID değeri göndermeyin :)

INSERT INTO Categories ( CategoryName , Description
                       ) 
VALUES ( 'Tatlı' , 'Fıstklı Sarma'
       );

-- Alt tarafta yer alan sorgu çalışmayacaktır. Ekleme işlemi yaparken mutlaka boş geçilemez alanlara veri eklemek zorundasınız

INSERT INTO Categories ( Description
                       ) 
VALUES ( 'Tepsi Baklava'
       );

SELECT *
FROM Shippers;

INSERT INTO Shippers ( CompanyName , Phone
                     ) 
VALUES ( 'Mng Express' , '(503) 555-9831'
       );

INSERT INTO Shippers
VALUES ( 'Aras Express' , '(503) 555-9831'
       );

-- BilgeAdam şirketini Müşteriler(Customers) tablosuna ekleyiniz :)

INSERT INTO Customers ( CompanyName , CustomerID
                      ) 
VALUES ( 'Bilge Adam' , 'BLGDM'
       );

SELECT *
FROM Customers;
-- Customers tablosundaki CustomerID sütununun tipi nchar(5)'tir. Yani, bu sütun Identity olarak belirtilemez, dolayısıyla bu tabloya bir  kayıt girerken CustomerID sütununa da kendimiz veri girmeliyiz.
-- 2) Update: Bir tablodaki kayıtları güncellemek için kullanılır. Dikkat edilmesi gereken hangi kaydı güncelleyeceğimizi açıktan belirtmek
--AKSI HALDE TÜM KAYITLAR GÜNCELLENEBILIR.

/*
    update <tablo adı> set <sütun adı> = <sütun değeri>,
	                       <sütun adı> = <sütun değeri>
*/

-- Employees tablosunda yer alan kayıtları Calisanlar adında bir tablo oluştur ve verileri oraya kopyala

SELECT *
INTO Calisanlar
FROM Employees;

SELECT *
FROM Calisanlar;

UPDATE Calisanlar
       SET LastName = 'Vuranok';

-- DROP TABLE Calisanlar;  => Calisanlar tablosunu siler

UPDATE Calisanlar
       SET FirstName = 'Murat'
WHERE EmployeeID = 1;

-- Personel Id değeri 1 olan personelin adını Değiştirme

UPDATE Calisanlar
       SET LastName = 'Şahin'
WHERE TitleOfCourtesy = 'Ms.';

-- Products tablosunu Urunler adında yeni bir tabloya taşıyınız ve ürünlere birim fiyatı üzerinden %5 lik zam yapınız :)
--drop Table Urunler

SELECT ProductID , ProductName , UnitPrice AS OldPrice , UnitPrice AS NewPrice
INTO Urunler
FROM Products;

SELECT *
FROM Urunler;

UPDATE Urunler
       SET NewPrice = NewPrice + ( NewPrice * 0.05 );

-- 3) Delete: Bir tablodan kayıt silmek için kullanacağımız komuttur. Aynı Update işlemi gibi dikkat edilmesi gerekir, çünkü birden fazla kayıt 
--yanlışlıkla silinebilir.

/*
	Delete From <tablo_adi>	
*/

DELETE FROM Calisanlar;  -- tablo içerisinde yer alan kayıtları siler

DROP TABLE Calisanlar;   -- db üzerinden tabloyu siler

SELECT *
INTO Calisanlar
FROM Employees;

SELECT *
FROM Calisanlar;

DELETE FROM Calisanlar
WHERE EmployeeID = 1;

DELETE FROM Calisanlar
WHERE TitleOfCourtesy = 'Mrs.'
      OR 
      TitleOfCourtesy = 'Ms.';

DELETE FROM Calisanlar
WHERE TitleOfCourtesy IN ( 'Mrs.' , 'Ms.'
                         );

-- SORGULARI FiLTRELEMEK
-- Yazdiğimiz sorgulari belirli koşullara göre filtreleyebilmek için WHERE cümleciğini kullaniriz. 
-- Ünvani Mr. olanlarin listelenmesi

SELECT TitleOfCourtesy , FirstName , LastName
FROM Employees
WHERE TitleOfCourtesy = 'Mr.';

-- EmployeeID değeri 5'ten büyük olanlarin listelenmesi

SELECT EmployeeID , FirstName , LastName
FROM Employees
WHERE EmployeeID >= 5;

-- 1960 yilinda doğanlarin listelenmesi

select FirstName, LastName, BirthDate  from Employees
where YEAR(BirthDate) = 1960