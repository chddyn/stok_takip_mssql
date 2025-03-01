USE [stok_takip]
GO
/****** Object:  StoredProcedure [dbo].[SP_MaterialAccepting]    Script Date: 1.08.2019 17:54:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[SP_MaterialAccepting]
(
@UserID int,
@LocationID int,
@OperationTypeID int,
@ProductTypeID int,
@ProductID int,
@ProductNo int,
@ProductQuantity int
)
AS
BEGIN
Declare @auth int;
Declare @No int;
DECLARE @NAME NVARCHAR(50);
DECLARE @UNITPRICE INT;
DECLARE @LIFETIME INT;
SELECT @No = Product.Ürün_No from Product WHERE Product.PID = @ProductID

SELECT @auth = Users.TPID from Users,Users_Type WHERE Users.TPID = Users_Type.TPID AND Users.UID = @UserID
IF(@ProductNo = @No)
BEGIN
if(@auth=4)
begin
select 
	Ad as 'kullanıcıadı',
	adet as 'ürün adeti' ,
	@ProductNo as 'ürün no',
	Product.Ürün_Adı as 'Urun_Adi',
	Lokasyon_Adı as 'lokasyon adı' 
from Operation,Locations,Users,Product
WHERE Operation.Lokasyon_ID = Locations.LID 
AND Operation.Kullanıcı_ID = Users.UID
AND Operation.Ürün_ID = Product.PID
AND Operation.OTID = 4
--AND Operation.Tarih = GETDATE()
end
if(@auth=3)
begin
select * from Operation
end
IF(@auth = 1)
BEGIN
INSERT INTO Operation([Lokasyon_ID],[Kullanıcı_ID],[Ürün_ID],[Ürüntipi_ID],[Tarih],[Ürün_Miktarı],[OTID],[ürün_no]) 
VALUES(@LocationID,@UserID,@ProductID,@ProductTypeID,GETDATE(),@ProductQuantity,@OperationTypeID,@ProductNo)
SELECT @NAME = Product.Ürün_Adı FROM Product WHERE Product.Ürün_No = @No;
SELECT @UNITPRICE = Product.Birim_Fİyat FROM Product WHERE Product.Ürün_No = @No;
SELECT @LIFETIME = Product.Yaşam_Ömrü FROM Product WHERE Product.Ürün_No = @No;
INSERT INTO dbo.Product VALUES (@NAME,@UNITPRICE,@LIFETIME,@ProductQuantity,@No);

	UPDATE Product SET Ürün_Miktarı += @ProductQuantity WHERE Product.PID = @ProductID
	SELECT 'OPERASYON EKLENDİ' AS 'BAŞARILI';


END 
END





ELSE 
BEGIN
SELECT 'URUN NOSU BULUNMAMAKTADIR' AS 'HATA';
END

END
