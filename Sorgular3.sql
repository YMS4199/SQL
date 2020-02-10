-- JOIN IŞLEMLERI
-- 1) Inner Join: Bir tablodaki her bir kaydın diğer tabloda bir karşılığı olan kayıtlar listelenir. Inner Join ifadesini yazarken Inner cümlesini yazmazsak da (sadece Join yazarsak) bu yine Inner Join olarak işleme alınır.

SELECT *
FROM Categories;

SELECT *
FROM Products;

SELECT ProductName , CategoryName
FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
ORDER BY CategoryName;

-- Products tablosundan ProductID, ProductName, CategoryID,
-- Categories tablosundan CategoryName, Description

SELECT ProductID , ProductName , Products.CategoryID , CategoryName , Description
FROM Categories JOIN Products ON Categories.CategoryID = Products.CategoryID;

-- NOT: Eğer seçtiğimiz sütunlar her iki tabloda da bulunuyorsa, o sütunu hangi tablodan seçtiğimizi açıkça belirtmemiz gerekir. (Products.CategoryID gibi)
-- Hangi sipariş, hangi çalışan tarafından, hangi müşteriye yapılmış
-- Orders
-- Employees
-- Customers

SELECT O.OrderID AS 'Sipariş No' , E.FirstName + ' ' + E.LastName AS Personel , C.CompanyName AS [Şirket Adı] , C.ContactName AS 'Yetkili Kişi'
FROM Employees AS E JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
                    JOIN Customers AS C ON C.CustomerID = O.CustomerID;

-- Suppliers tablosundan CompanyName, ContactName
-- Products tablosundan ProductName, UnitPrice
-- Categories tablosundan CategoryName
-- CompanyName sütununa göre artan sırada sıralayınız.

SELECT S.CompanyName , S.ContactName , P.ProductName , P.UnitPrice , C.CategoryName
FROM Suppliers AS S JOIN Products AS P ON S.SupplierID = P.SupplierID
                    JOIN Categories AS C ON C.CategoryID = P.CategoryID
ORDER BY S.CompanyName;

UPDATE Products
       SET CategoryID = NULL
WHERE ProductID > 77;

-- 2.) OUTER JOIN  
-- 2.1) LEFT OUTER JOIN : Sorguda katılan tablolardan soldakinin tüm kayıtları getirilirken, sağdaki tablodaki sadece ilişkili olan kayıtlar getirilir.
-- Aşağıdaki işlem için Products tablosuna CategoryID bilgisi yazılmayan bir ürün ekledik

SELECT *
FROM Categories AS C JOIN Products AS P ON C.CategoryID = P.CategoryID;  -- 77  elde ederiz. inner join sadece ilişkisel dataları teslim eder.

SELECT *
FROM Categories AS C LEFT OUTER JOIN Products AS P ON C.CategoryID = P.CategoryID;

-- 2.2) RIGHT OUTER JOIN: Sorguda katılan tablolardan sağdakinin tüm kayıtları getirilirken, soldaki tablodaki sadece ilişkili olan kayıtlar getirilir.

SELECT C.CategoryName , P.ProductName
FROM Categories AS C RIGHT OUTER JOIN Products AS P ON C.CategoryID = P.CategoryID;

-- 3.) FULL JOIN: Her iki tablodaki tüm kayıtlar getirilir. Left ve Right Outer Join'in birleşimidir.

SELECT C.CategoryName , P.ProductName , C.CategoryID
FROM Categories AS C FULL JOIN Products AS P ON C.CategoryID = P.CategoryID;

-- 4.) CROSS JOIN: Bir tablodaki bir kaydın diğer tablodaki tüm kayıtlarla eşleştirilmesini sağlar.

SELECT CategoryName , ProductName
FROM Categories CROSS JOIN Products;

-- Aggregate Fonksiyonlar (Toplam Fonksiyonlari, Gruplamali Fonksiyonlar)
-- COUNT(Sütun adi | *): Bir tablodaki kayit sayisini öğrenmek için kullanilir.
-- Bir tablodaki toplam kayit sayisini öğrenebiliriz.

SELECT COUNT(EmployeeID)
FROM Employees; -- Toplam 9 Kayıt

SELECT COUNT(Region)
FROM Employees;  -- Toplam 5 Kayıt  

SELECT COUNT(*)
FROM Employees; -- Toplam 9 Kayıt
-- Region sütunundaki kayit sayisi (Region sütunu null geçilebileceği için bir tablodaki kayit sayisini bu sütundan yola çikarak öğrenmek yanliş sonuçlar oluşturabilir. Çünkü aggregate fonksiyonlari NULL değer içeren kayitlari dikkate almaz. Bu nedenle kayit sayisini öğrenebilmek için ya * karakterini ya da NULL değer geçilemeyen sütunlardan birinin adini kullanmamiz gerekir.

SELECT COUNT(DISTINCT City)
FROM Employees;

-- SUM(Sütun adi): Bir sütundaki değerlerin toplamini verir.

SELECT SUM(EmployeeID)
FROM Employees;-- EmployeeID sütunundaki verilerin toplami
-- Çalişanlarin yaşlarinin toplamini bulunuz.

SELECT SUM(YEAR(GETDATE()) - YEAR(BirthDate))
FROM Employees;

SELECT SUM(DATEDIFF(year , BirthDate , GETDATE()))
FROM Employees;

-- Select SUM(FirstName) From Employees -- SUM fonksiyonunu sayisal sütunlarla kullanabilirsiniz.
-- AVG(Sütun adi): Bir sütundaki değerlerin ortalamasini verir.

SELECT AVG(employeeID)
FROM Employees;

-- Çalişanlarin yaşlarinin ortalamasi

SELECT AVG(YEAR(GETDATE()) - YEAR(BirthDate))
FROM Employees;


SELECT AVG(LastName)
FROM Employees; -- AVG fonksiyonu sayisal sütunlarla kullanilir.

-- MAX(Sütun adi): Bir sütundaki en büyük değeri verir.


select max(EmployeeID) from Employees
select  MAX(FirstName)  from Employees

-- MIN(Sütun adi): Bir sütundaki en küçük değeri verir.

select min(EmployeeID) from Employees
select  min(FirstName)  from Employees
select FirstName from Employees order by 1

-- CASE - WHEN - THEN Kullanimi

select FirstName as Adi , LastName  as Soyadi, Country as Ülke from Employees



SELECT FirstName , LastName ,
                  ( CASE(Country)
                       WHEN 'UK'
                       THEN 'İngiltere Birleşik Krallığı'
                       WHEN 'USA'
                       THEN 'Amerika Birleşik Devletleri'
                     --WHEN 'TR'
                     --THEN 'Türkiye'
                     --ELSE 'Belirtilmedi'
                       ELSE Country
                   END ) AS Country
FROM Employees;

-- Personelin ID değeri 5'ten büyükse büyüktür, 5'ten küçükse küçütür. aksi durumda eşittir.



SELECT FirstName , LastName , EmployeeID ,
                              CASE
                                  WHEN EmployeeID > 5
                                  THEN 'EmployeeID Değeri 5''ten büyütür'
                                  WHEN EmployeeID < 5
                                  THEN 'EmployeeID Değeri 5''ten küçüktür'
                                  ELSE 'EmployeeID Değeri 5''e eşittir'
                              END AS Durum
FROM Employees;


 -- GROUP BY Kullanımı
-- Çalışanların ülkelerine göre gruplanması


select Country,COUNT(*) as Adet from Employees
group by Country

-- Çalışanların yapmış olduğu sipariş adeti   -- Orders 

select EmployeeID, COUNT(*) 'Toplam Sipariş Adet' from Orders
group by EmployeeID
order by 2
-- Ürün bedeli 35$'dan az olan ürünlerin kategorilerine göre gruplanması

select C.CategoryName, COUNT(*) as 'Toplam Ürün Sayısı' from Categories C join Products P on C.CategoryID = P.CategoryID
where P.UnitPrice <= 35
group by C.CategoryName
order by 2

-- Baş harfi A-K aralığında olan ve stok miktarı 5 ile 50 arasında olan ürünleri kategorilerine göre gruplayınız.


select C.CategoryName, COUNT(*) as 'Adet' from Products P  join Categories C on P.CategoryID = C.CategoryID
where ProductName like '[A-K]%'
and
UnitsInStock between 5 and 50
group by C.CategoryName
 

   
-- Her bir siparişteki toplam ürün sayısını bulunuz.  [Order_Details]
select OrderID , SUM(Quantity) As 'Sipariş Adet' from [Order Details]
group by OrderID
order by 2

-- group by ödev
-- Toplam tutari 2500 ile 3500 arasinda olan siparişlerin gruplanması 

-- Her bir siparişteki toplam ürün sayisi 200'den az olanlar

-- Kategorilere göre toplam stok miktarını bulunuz.

-- Her bir çalışan toplam ne kadarlık satış yapmıştır.




-- join ödev

-- Bir siparişin hangi çalışan tarafından hangi müşteriye hangi kategorideki üründen hangi fiyattan kaç adet satıldığını listeleyiniz.
-- Çalışanın adı, soyadı, ünvanı, görevi, işe başlama tarihi
-- Müşterinin firma adını, temsilcisini ve telefonunu
-- Ürünün adını, stok miktarını, birim fiyatını
-- Siparişin adetini ve satış fiyatını
-- Kategori adını

-- Orders, Order_Details, Customers,Categories,Products, Employees