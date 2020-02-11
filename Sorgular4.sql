-- group by ödev
-- Toplam tutari 2500 ile 3500 arasinda olan siparişlerin gruplanması 

SELECT OrderID , SUM(UnitPrice * Quantity) AS 'Toplam'
FROM [Order Details] 
-- where sum(UnitPrice * Quantity) between 2500 and 3500
GROUP BY OrderID
HAVING SUM(UnitPrice * Quantity) BETWEEN 2500 AND 3500
ORDER BY 2;

-- Her bir siparişteki toplam ürün sayisi 200'den az olanlar

SELECT OrderID , SUM(Quantity) AS 'Toplam'
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(Quantity) < 200
ORDER BY 2;

-- Kategorilere göre toplam stok miktarını bulunuz.

SELECT C.CategoryName , SUM(UnitsInStock) AS 'Toplam Stok'
FROM Categories AS C JOIN Products AS P ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName
ORDER BY 2;

-- Her bir çalışan toplam ne kadarlık satış yapmıştır.

SELECT CONCAT(E.FirstName , ' ' , E.LastName) AS Personel , SUM( ( OD.Quantity * OD.UnitPrice ) * 1 - Discount) AS 'Toplam Satış Miktarı'
FROM Employees AS E JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
                    JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY CONCAT(E.FirstName , ' ' , E.LastName);

-- join ödev
-- Bir siparişin hangi çalışan tarafından hangi müşteriye hangi kategorideki üründen hangi fiyattan kaç adet satıldığını listeleyiniz.
-- Çalışanın adı, soyadı, ünvanı, görevi, işe başlama tarihi
-- Müşterinin firma adını, temsilcisini ve telefonunu
-- Ürünün adını, stok miktarını, birim fiyatını
-- Siparişin adetini ve satış fiyatını
-- Kategori adını
-- Orders, Order_Details, Customers,Categories,Products, Employees
-- VIEW
-- Gerçekte var olmayan, SELECT ifadeleri ile tanımlanmış sanal tablolardır. (Kaydedilmiş sorgular)
-- Çeşitli kısıtlamalar dahilinde View'ler üzerinden veri eklenebilir, silinebilir ve güncellenebilir.
-- View'ler tablolar üzerinden tanımlanabildiği gibi (bu tablolara base table denir) başka View'ler üzerinden de tanımlanabilir.

CREATE VIEW SatisRaporlari
AS
     SELECT dbo.Employees.LastName , dbo.Employees.FirstName , dbo.Employees.Title , dbo.Employees.TitleOfCourtesy , dbo.Employees.HireDate , dbo.Customers.CompanyName , dbo.Customers.ContactName , dbo.Customers.Phone , dbo.Products.ProductName , dbo.Products.UnitsInStock , dbo.Products.UnitPrice , dbo.[Order Details].Quantity , dbo.[Order Details].UnitPrice AS SalePrice , dbo.Categories.CategoryName
     FROM dbo.Orders INNER JOIN dbo.[Order Details] ON dbo.Orders.OrderID = dbo.[Order Details].OrderID
                     INNER JOIN dbo.Customers ON dbo.Orders.CustomerID = dbo.Customers.CustomerID
                     INNER JOIN dbo.Products ON dbo.[Order Details].ProductID = dbo.Products.ProductID
                     INNER JOIN dbo.Categories ON dbo.Products.CategoryID = dbo.Categories.CategoryID
                     INNER JOIN dbo.Employees ON dbo.Orders.EmployeeID = dbo.Employees.EmployeeID;

SELECT DISTINCT 
       FirstName , LastName
FROM SatisRaporlari;

/* 
	View'ler genel olarak 2 amaç için kullanılır.

	1) Karmaşık sorguları basitleştirmek için.
	2) Tablo erişimlerini kullanıcı bazında kısıtlayarak bu kullanıcların belirtilen tabloların belirtilen sütunlarına erişmesini sağlamak 
	amacıyla kullanılır. Yani, kullanıcı tablo üzerinde istediği gibi hareket edemeyecektir.
	
*/

CREATE VIEW Kategoriler
AS
     SELECT *
     FROM Categories;

SELECT *
FROM Kategoriler;

ALTER VIEW Kategoriler
AS
     SELECT CategoryID , Description
     FROM Categories;

-- DROP VIEW Kategoriler;

SELECT *
FROM Kategoriler;

DELETE FROM Kategoriler
WHERE CategoryID > 8;

-- View üzerinden veri ekleyebilmemiz için, base table'ın Null geçilemeyen sütunları View'ın tanımında yer almalıdır. Aksi halde bu şekilde bir 
--INSERT işlemi geçerli olmayacaktır.

INSERT INTO Kategoriler ( Description
                        ) 
VALUES ( 'Açıklama'
       );

CREATE VIEW Musteriler
AS
     SELECT EmployeeID , FirstName , LastName , Title , City
     FROM Employees;

ALTER VIEW Musteriler
WITH ENCRYPTION
AS
     SELECT EmployeeID , FirstName , LastName , Title , City
     FROM Employees
     WHERE City = 'London'
WITH CHECK OPTION;

SELECT *
FROM Musteriler;

INSERT INTO Musteriler
VALUES ( 'Murat' , 'Vuranok' , 'Kaldırım Mühendisi' , 'London'
       );





-- STORED PROCEDURE (Saklı Yordamlar)
-- TSQL komutları ile hazırladığımız işlemler bütününün çalıştırılma anında derlenmesi ile size bir sonuç üreten sql server bileşenidir.
-- Çalışma anı planlama sağlar ve tekrar tekrar kullanılabilir
-- Querylerinize otomatik parametrelendirme getirir
-- Uygulamalar arasında ortak kullanılabilir yapıdadır
-- Güvenli data modifikasyonu sağlar
-- Network bandwidth inden tasarruf sağlar(daha az network bandwith kaynak kullanımı)
-- Job olarak tanımlanabilir ve schedule edilebilir
-- Database objelerine güvenli erişim sağlar.


CREATE PROCEDURE sp_Kategoriler
AS
    BEGIN
        SELECT *
        FROM Categories;
    END;


EXECUTE sp_Kategoriler;

CREATE PROC sp_UrunlerByKategori
AS
    BEGIN
        SELECT *
        FROM Products
        WHERE CategoryID = 3;
    END;

EXEC sp_UrunlerByKategori;


ALTER PROC sp_UrunlerByKategori 
@Id int
AS
BEGIN

SELECT * FROM Products WHERE CategoryID=@Id;
END;


EXEC sp_UrunlerByKategori 8;
-- Adının ilk harfine göre personelleri listeleyen sp yazınız.


CREATE PROC sp_1 
@harf nvarchar
AS
BEGIN
SELECT * FROM Employees WHERE FirstName LIKE @harf+'%';
END;

CREATE PROC sp_2 
@harf nvarchar
AS
BEGIN
SELECT * FROM Employees WHERE LEFT(FirstName , 1)=@harf;
END;

exec sp_1 'A'
exec sp_2 'A'

											 
											 
CREATE PROC sp_MusteriEkle 					 
  @CustomerID   NCHAR(5), 					 
  @CompanyName  NVARCHAR(40), 				 
  @ContactName  NVARCHAR(30) = 'Boş Alan', 				 
  @ContactTitle NVARCHAR(30) = 'Boş Alan', 				 
  @Address      NVARCHAR(60) = 'Boş Alan', 				 
  @City         NVARCHAR(15) = 'Boş Alan', 				 
  @Region       NVARCHAR(15) = 'Boş Alan', 				 
  @PostalCode   NVARCHAR(10) = 'Boş Alan', 				 
  @Country      NVARCHAR(15) = 'Boş Alan', 				 
  @Phone        NVARCHAR(24) = 'Boş Alan', 				 
  @Fax          NVARCHAR(24) = 'Boş Alan'				 
AS											 
BEGIN										 
INSERT INTO Customers						 
VALUES
(
  @CustomerID, @CompanyName, @ContactName, @ContactTitle, @Address, @City, @Region, @PostalCode, @Country, @Phone, @Fax);
END;


exec sp_MusteriEkle 'DNMG','Deneme Şirket'

select * from Customers




-- Tüm açıklamalar mevcut

-- Tablo Adı = " Country ", Parametreler = Id, CountryName,Code
-- Tablo Adı = " City",     Parametreler = Id, CityName, CountryId,Code
-- Tablo Adı = " District", Parametreler = Id, DistrictName, CountryId, CityId,Code
-- Tablo Adı = " Town",     Parametreler = Id, TownName, CountryId, CityId, DistrictId,code

/*
  NOT : Yeni bir veri tabanı kod ile oluşturulacak :)

  1) Yukarıdaki tablolar Code ile oluşturulacak ve kod ile ılişkilendirilecektir.
  2) Bir adet StoreProcedure yazılacak ve bu procedure içerisine parametre olarak, Ülke Adı, şehir Adı, ılçe Adı ve Mahalle Adı alacak.
  3) Ülkeler tablosunda parametrede gönderilen ülke var mı yok mu kontrol edilecek. 
    3.1) Eğer Ülke Yok ise Eklenecek. Var ise kullanıcıya mesaj ile bildirilecek
  4) şehirler tablosunda parametrede gönderilen Ülke Kontol edilecek ve Bu ülkeye ait Bölyle bir şejir olup olmadığı kontrol edilecek. 
    4.1) Eğer şehir yok ise eklenecek. Var ise O ülkenin Id paramtresi yakalanacak ve o Id paramteresine göre şehirler tablosuna kayıt eklenecek.
  5) ılçeler tablosunda parametrede gönderilen Ülke o ülkeye bağlı şehir ve o şehire bağlı ılçe varmı yok mu kontrol edilecek.
    5.1) Eğer Ülke Yok ise, Ülke eklenecek. Sonra eklenen ülkenin Id parametresine göre ıl eklenecek. Sonrasında ise, ülke Id ve ıl Id parametreleri yakalanıp ilçe eklenecek.
    5.2) Eğer Ülke var şehir yok ise, parametrede gönderilen ülke Id yakalanıp şehir eklenecek ve Ulke Id ile şehir Id parametrelerini kullanarak ılçeyi Eklenecek.
  6) Mahalle tablosunda parametrede gönderilen Ülke, o ülkeye bağlı şehir, o şehire bağlı ilçe varmı yok mu kontrol edilecek.
    6.1) Eğer Ülke yok ise; Önce Ülke eklenecek ve o ülkenin Id parametresine göre ıl, Ülke ve ıl Id parametrelerine göre ilçe, Ulke ıl ve ılçe Id parametrelerine göre de Mahalle eklenecek.
    6.2) Eğer ülke var ise ve şehir yok  ise O ülke Id parametresine göre şehir,, Ülke ve şehir Id parametresine göre ılçe, Ülke  şehir ilçe Id parametrelerine göre Mahalle eklenecek.
    6.3) Eğer ülke ıl var ama ilçe yok ise, Ülke şehir Id parametreleri yakalanacak ve ılçe eklenecek. Sonrasında Ülke şehir ve ılçe Id parametreleri yakalnarak Mahalle Eklenecek
    6.4) Eğer ülke il ilçe var ama mahalle yok ise, Ülke ıl ılçe Id parametreleri kullanılarak Mahalle eklenecektir.

	NOT : ıl ve şehir Aynı Anlama Gelir :) artı (+) her blok içerisinde mesaj verilecek
*/






-- Kullanıcı Tanımlı Fonksiyonlar (User Defined Function - UDF)
-- Fonksiyonlar değer döndüren yapısal birimlerdir. Parametre alabilirler. Aynı SP'ler gibi önceden derlenmiþlerdir ve bu nedenle daha hızlı çalıþan yapılardır.
-- Fonksiyonlar geriye tek bir değer veya bir tablo döndürebilirler.
-- SP'lerden en büyük farkları sorgu içerisinde kullanılabilmeleridir.
-- View'lerden en büyük farkı parametre alan yapıları sağlayabilmeleridir.
-- Değer döndüren fonksiyonlara Scalar Function, Tablo döndüren fonksiyonlara da Table Value Function denir.

/*
	SKALER Fonksiyonlar
	* Geriye tek bir değer döndürürler. Genellikle matematiksel iþlemlerde kullanılırlar.
	* RETURNS <tip> ile geriye hangi tipte değer döndürüleceği bildirilmelidir.
	* RETURN ifadesi ile geriye fonksiyonun döndüreceği değer belirtilir.
	* Fonksiyonu oluþturan kod bloğu BEGIN - END arasında yazılır ve kullanılırken tablonun þeması da belirtilir.
	
*/

-- Klasik Sorgu


SELECT ProductName AS [Ürün Adı] , CategoryName AS [Kategori] , UnitPrice AS [Birim Fiyat] , UnitPrice * 1.18 AS [KDV Dahil]
FROM Products INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID;



create function KDVHesapla(@fiyat money)

returns money  -- function geriye money veri tipi teslim eder.
begin
declare @sonuc  money
set  @sonuc = @fiyat * 1.18
return  @sonuc -- işlem sonucunu geriye teslim eder. NOT : return anahtar kelimesinden sonra yazılan hiç bir kod bloğu çalışmaz.
end

SELECT ProductName AS [Ürün Adı] , CategoryName AS [Kategori] , UnitPrice AS [Birim Fiyat] , dbo.KDVHesapla(UnitPrice) AS [KDV Dahil]
FROM Products INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID;


 


CREATE DATABASE UserDB;
GO

USE UserDB;
 GO

CREATE TABLE Users ( 
             Id          INT PRIMARY KEY IDENTITY(1 , 1) , 
             FirstName   NVARCHAR(50) NOT NULL , 
             LastName    NVARCHAR(50) NOT NULL , 
             Mail        NVARCHAR(150) NULL , 
             Phone       NVARCHAR(24) NULL , 
             CreatedDate DATETIME DEFAULT(GETDATE())
                   );
GO

INSERT INTO Users ( FirstName , LastName , Mail , Phone
                  ) 
VALUES ( 'murat' , 'vuranok' , 'murat.vuranok@bilgeadam.com' , '05323520987'
       ) , ( 'murat' , 'vuranok' , 'murat.vuranok@bilgeadam.com' , '05323520987'
           ) , ( 'murat' , 'vuranok' , 'murat.vuranok@bilgeadam.com' , '05323520987'
               ) , ( 'murat' , 'vuranok' , 'murat.vuranok@bilgeadam.com' , '05323520987'
                   ) , ( 'murat' , 'vuranok' , 'murat.vuranok@bilgeadam.com' , '05323520987'
                       ) , ( 'murat' , 'vuranok' , 'murat.vuranok@bilgeadam.com' , '05323520987'
                           ) , ( 'murat' , 'vuranok' , 'murat.vuranok@bilgeadam.com' , '05323520987'
                               );

SELECT *
FROM Users;




CREATE FUNCTION Phone ( 
                @phone NVARCHAR(24)
                      ) 
RETURNS NVARCHAR(24)
     BEGIN
         DECLARE @newPhone NVARCHAR(24);
         SET @phone = REPLACE(REPLACE(REPLACE(REPLACE(@phone , '+' , '') , '(' , '') , ')' , '') , ' ' , '');
         IF ( LEFT(@phone , 1) <> '0' )   -- Eğer gelen data 0 ile başlamıyor ise, 0 değerini ekledik. 
             BEGIN
                 SET @phone = '0' + @phone;
         END;
         IF ( LEN(@phone) = 11 )  -- Telefonun uzunluğu 11'e eşit ise
             BEGIN
                 SET @newPhone = '+9' + LEFT(@phone , 1) + ' (' + SUBSTRING(@phone , 2 , 3) + ') ' + SUBSTRING(@phone , 5 , 3) + ' ' + SUBSTRING(@phone , 8 , 2) + ' ' + RIGHT(@phone , 2);
         END;
             ELSE  -- 11'den büyük veya küçükse
             BEGIN
                 SET @newPhone = 'Geçersiz Numara';
         END;
         RETURN @newPhone;
     END;





SELECT FirstName , LastName , Mail , dbo.Phone ( Phone
                                               ) AS Phone , Phone
FROM Users;
 


CREATE TABLE Countries ( 
             Id          INT PRIMARY KEY IDENTITY(1 , 1) , 
             CountryName NVARCHAR(50) , 
             PhoneCode   NVARCHAR(10)
                       );
GO

CREATE TABLE Cities ( 
             Id        INT PRIMARY KEY IDENTITY(1 , 1) , 
             CityName  NVARCHAR(50) , 
             PhoneCode NVARCHAR(10) , 
             PlateCode NVARCHAR(10) , 
             CountryId INT FOREIGN KEY REFERENCES Countries(Id)  -- Countries tablosuna bire çok iliki kuruyoruz.
                    );


-- services.msc