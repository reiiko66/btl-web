CREATE DATABASE ThuchanhSQL_NguyenHuuBan_2010A02
--THUC HANH 1
--Bai 1.1
--a)Luu database vao o D hoac E
ON(
	Name = ThuchanhSQL_NguyenHuuBan_2010A02,
	FileName = 'D:\TAI LIEU HOC TAP\HE QUAN TRI CSDL (SQL)\BAI THUC HANH\THUC HANH\ThuchanhSQL_PhamXuanTu_17A01.mdf'
  )

USE ThuchanhSQL_NguyenHuuBan_2010A02

CREATE TABLE tblLoaihang
(
  sMaloaihang NVARCHAR(10) NOT NULL,
  sTenloaihang NVARCHAR(10) NOT NULL,
);
ALTER TABLE tblLoaiHang ADD CONSTRAINT PK_sMaloaihang 
PRIMARY KEY(sMaloaihang);

CREATE TABLE tblNhaCungCap
(
  iMaNCC int IDENTITY (1,1) NOT NULL,
  sTenNhaCC NVARCHAR(50) NULL,
  sTengiaodich NVARCHAR(50) NULL,
  sDiachi NVARCHAR(50) NULL,
  sDienthoai NVARCHAR(12) NULL,
  CONSTRAINT PK_tblNhaCungCap PRIMARY KEY (iMaNCC)
);

CREATE TABLE tblMatHang 
( 
  sMahang NVARCHAR(10) NOT NULL,
  sTenhang NVARCHAR(30) NOT NULL,
  iMaNCC int NULL,
  sMaloaihang NVARCHAR(10) NULL,
  fSoluong FLOAT NULL,
  fGiahang FLOAT NULL
); 

ALTER TABLE tblMathang
ADD CONSTRAINT PK_mathang PRIMARY KEY (sMahang),
CONSTRAINT FK_mathang_loaihang FOREIGN KEY (sMaloaihang)
REFERENCES	tblLoaiHang(sMaloaihang),
CONSTRAINT FK_mathang_nhacungcap FOREIGN KEY(iMaNCC)
REFERENCES tblNhaCungCap(iMaNCC)

--b)Tao bang tblKhachHang, tblNhanVien
CREATE TABLE tblKhachHang(
	iMaKH int not null Primary Key,
	sTenKH nvarchar(30),
	sDiachi nvarchar(50),
	sDienthoai nvarchar(12)
)

CREATE TABLE tblNhanVien(
	iMaNV int not null Primary Key,
	sTenNV nvarchar(30),
	sDiachi nvarchar(50),
	sDienthoai nvarchar(12),
	dNgaysinh datetime,
	dNgayvaolam datetime,
	fLuongcoban float,
	fPhucap float
)

--c)Them sCMND khong chua gia tri trung nhau vao tblNhanVien
ALTER TABLE tblNhanVien
ADD sCMND nvarchar(20) unique

select * from tblNhanVien

--d)Rang buoc khoa chinh, ngoai

--e)Ngay lam viec so voi ngay sinh toi thieu du 18 tuoi (tblNhanVien)
ALTER TABLE dbo.tblNhanVien
ADD CONSTRAINT Rangbuoc1 CHECK ((YEAR(getDate())-YEAR(dNgaysinh))>18)

--f)Them cot sDonvitinh vao tblMathang
ALTER TABLE tblMathang
ADD sDonvitinh nvarchar(10)

select * from tblMathang

--g)Tao chi muc cho sTenHang trong tblMatHang
CREATE INDEX iTenhang ON tblMathang(sTenhang)

--Bai 1.2
--a) Tao bang tblDonNhapHang, tblCTNhapHang
CREATE TABLE tblDonnhaphang
(
  iSoHD int NOT NULL,
  iMaNV int NOT NULL,
  dNgaynhaphang DATETIME 
)

CREATE TABLE tblChitietnhaphang 
(
  iSoHD int NOT NULL ,
  sMahang NVARCHAR(10) NOT NULL,
  fGianhap float,
  fSoluongnhap float
)

--b)
	--Khoa chinh
ALTER TABLE tblDonnhaphang
ADD CONSTRAINT PK_donnhaphang PRIMARY KEY (iSoHD)

ALTER TABLE tblChitietNhapHang
ADD CONSTRAINT PK_chitietnhaphang PRIMARY KEY(iSoHD,sMahang)

	--Khoa ngoai
ALTER TABLE tblDonnhaphang
ADD CONSTRAINT FK_manv FOREIGN KEY(iMaNV) REFERENCES tblNhanVien(iMaNV)

	--Bang tblChitietnhaphang sMahang lam khoa ngoai chieu sang tblMathang
ALTER TABLE tblChitietnhaphang
ADD CONSTRAINT FK_mahang FOREIGN KEY(sMahang) REFERENCES tblMathang(sMahang)

	-- Bang tblChitietnhaphang iSoHD lam khoa ngoai tham chieu sang tblDonnhaphang
ALTER TABLE tblChitietnhaphang
ADD CONSTRAINT FK_sohd FOREIGN KEY(iSoHD) REFERENCES tblDonnhaphang(iSoHD)

--c)tblCTNhapHang fGianhap>0, fSoLuongNhap>0
ALTER TABLE tblChitietnhaphang
ADD CONSTRAINT GiaNhap
CHECK ((fGianhap > 0) and (fSoluongnhap > 0))

--Bai 1.3
--a)Them bGioitinh(bit) vao bang tblKhachHang
ALTER TABLE tblKhachHang 
ADD bGioitinh bit

--b)Tao bang btlDondathang
CREATE TABLE tblDondathang(
   iSoHD int NOT NULL PRIMARY KEY,
   iMaNV int,
   iMaKH int,
   dNgaydathang Datetime,
   dNgaygiaohang Datetime,
   sDiachigiaohang NVARCHAR(50),
	CONSTRAINT C_ktngay CHECK ((dNgaygiaohang-dNgaydathang)>=0),
	CONSTRAINT C_thoigian CHECK (dNgaydathang<= GETDATE())
)

--c) Bang tblDondathang iMaKH lam khoa ngoai tham chieu sang tblKhachHang
ALTER TABLE tblDondathang
ADD CONSTRAINT FK_maKH FOREIGN KEY(iMaKH) REFERENCES tblKhachHang(iMaKH)
 
--d) Bang tblDondathang iMaNV lam khoa ngoai tham chieu sang tblNhanVien
ALTER TABLE tblDondathang
ADD CONSTRAINT FK_maNV_dondathang FOREIGN KEY(iMaNV) REFERENCES tblNhanVien(iMaNV)

--Bai 1.4
--a)Tao bang tblChiTietDatHang
CREATE TABLE tblChiTietDatHang(
	iSoHD int NOT NULL,
	sMahang nvarchar(20) NOT NULL,
	fGiaban float,
	fSoluongmua float,
	fMucgiamgia float
)

--b)Trong bang tblChiTietDatHang, sua cau truc sMahang sang nvarchar(10)
ALTER TABLE tblChiTietDatHang
ALTER COLUMN sMahang nvarchar(10) not null

--c)Bang tblChiTietDatHang, dat sMahang khoa ngoai(tblMathang); iSoHD khoa ngoai(tblDondathang)
ALTER TABLE tblChiTietDatHang
ADD CONSTRAINT FK_sMahang_ChiTietDatHang FOREIGN KEY(sMahang) REFERENCES tblMathang(sMahang)

ALTER TABLE tblChiTietDatHang
ADD CONSTRAINT FK_iSoHD_ChiTietDatHang FOREIGN KEY(iSoHD) REFERENCES tblDondathang(iSoHD)

--d)Bang tblChiTietDatHang, dat khoa chinh iSoHD,sMahang
ALTER TABLE tblChiTietDatHang
ADD CONSTRAINT PK_CTDH PRIMARY KEY(iSoHD,sMahang)

--e)Bang tblChiTietDatHang, fGiaban,fSoluongmua,fMucgiamgia > 0
ALTER TABLE tblChiTietDatHang
ADD CONSTRAINT C_chitietdathang CHECK (fGiaban>0 AND fSoluongmua>0 AND fMucgiamgia>=0)

--THUC HANH 2
--Bai 2.1
--a)Them 3 ban ghi cho tblLoaiHang
Insert into tblLoaiHang(sMaloaihang,sTenloaihang)
Values('Mahang1','Tenhang1'),
	  ('Mahang2','Tenhang2'),
	  ('Mahang3','Tenhang3')

SELECT * FROM tblLoaiHang

--b)Voi moi loai hang trong bang tblLoaiHang, them 3 mat hang cho moi loai hang tuong ung vao bang tblMathang
--Mahang1
INSERT INTO tblMathang(sMahang,sTenhang,iMaNCC,sMaloaihang,fSoluong,fGiahang,sDonvitinh)
VALUES('1','Dien Thoai','2','Mahang1',4,3,'VND'),
	  ('2','May Tinh','3','Mahang1',6,2,'Dollar'),
	  ('7','XuanTu','1','Mahang1',16,04,'VND'),
	  ('5','Quat','2','Mahang2',6,2,'VND'), --Mahang2
	  ('4','Ban La','2','Mahang2',3,9,'VND'),
	  ('6','Xe May','3','Mahang2',5,8,'VND'),
	  ('12','Dien Thoai','1','Mahang3',5,2,'VND'),--Mahang3
	  ('16','Cap Sach','2','Mahang3',4,5,'Dollar'),
	  ('18','May Giat','3','Mahang3',3,7,'VND')

select * from tblLoaiHang
select * from tblMathang

--c)Them 3 ban ghi vao tblNhaCungCap
INSERT INTO tblNhaCungCap(sTenNhaCC,sTengiaodich,sDiachi,sDienthoai)
VALUES('Asus','GD1','DaNang','0982860164'),
	  ('HP','GD2','Quang Nam','0934156842'),
	  ('Dell','GD3','Ha Noi','0931054625')

select * from tblNhaCungCap

--d)Xoa mat hang co so luong = 0
Delete from tblMathang
Where fSoluong=0;

--e)Tang phu cap 10% cho NV lam viec > 5 nam
Update tblNhanVien
Set fPhucap=fPhucap + (0.1)*fPhucap
Where ((Year(getdate())-Year(dNgayvaolam))> 5)

Select * from tblNhanVien

--Bai 2.2
--a)Them 3 ban ghi vao tblKhachHang
INSERT INTO tblKhachHang(iMaKH,sTenKH,sDiachi,sDienthoai,bGioitinh)
VALUES(1,'Pham Xuan Tu','Vinh Phuc','0982860164',1),
	  (2,'Nguyen Van Nam','Ha Noi','0925684756',1),
	  (3,'Bui Lan Anh','Ha Nam','0935648952',0)

select * from tblKhachHang

--Them 3 ban ghi vao tblNhanVien
INSERT INTO tblNhanVien(iMaNV,sTenNV,sDiachi,sDienthoai,dNgaysinh,dNgayvaolam,fLuongcoban,fPhucap,sCMND)
VALUES(1,'Nguyen Van Hai','Vinh Yen','0982860164','1990/04/16','2010/05/20',2500,2,'M123456789'),
	  (2,'Hoang Van Minh','Da Nang','0935648512','02/04/1979','01/05/2011',3500,4,'M124545757'),
	  (3,'Pham Hoang Nam','Ninh Binh','0914584152','1970/03/05','2012/01/08',3000,5,'M254685496'),
	  (4,'Pham Hoang','Ninh Binh','0914584152','1970/03/05','2017/01/08',3000,5,'M254685431')

select * from tblNhanVien

--b)Them 3 ban ghi vao tblDondathang
INSERT INTO tblDondathang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
VALUES(1,'1','1','2015/05/20','2015/05/25','Ha Noi'),
	  (2,'2','3','2016/07/10','2016/07/13','Viet Tri'),
	  (3,'3','2','2017/08/05','2017/08/10','Da Nang'),
	  (12,'1','2','2019/05/25','2019/06/06','Vinh Phuc')

select * from tblDondathang

--c)Thuc hien voi moi don dat hang trong tblDondathang cho phep them cac chi tiet don dat hang tuong ung, moi don dat hang co it nhat 2 mat hang
INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
VALUES(1,'4',150,5,20), --Don dat hang 1
	  (1,'5',350,2,50),
	  (2,'12',50,3,10), --Don dat hang 2
	  (2,'16',500,1,25),
	  (3,'6',20,1,5), --Don dat hang 3
	  (3,'18',100,5,20),
	  (12,'LH21',25,5,0), --Don dat hang 12
	  (12,'LH22',150,3,20)
	  
SELECT * FROM [dbo].[tblMathang]

DELETE from tblChiTietDatHang
WHERE sMahang='LH20'

SELECT * FROM tblChiTietDatHang

--d)Muc giam gia la 10% cho all mat hang ban trong thang 7/2016
UPDATE tblChiTietDatHang
SET fMucgiamgia=0.1
FROM tblDondathang,tblChiTietDatHang
WHERE Month(dNgaygiaohang)=7 and Year(dNgaygiaohang)=2016 and tblChiTietDatHang.iSoHD = tblDondathang.iSoHD

--e)Xoa chi tiet don dat hang co ma hoa don = 1
DELETE from tblChiTietDatHang
WHERE iSoHD = 1

--Bai 2.3
--a)Voi khach hang Nam, them moi nguoi 3 don hang (tblDondathang); moi don hang trong 1 thang khac nhau,
--dat it nhat 3 mat hang(tblChiTietDatHang) voi so luong mua khac nhau
Select * from tblKhachHang
Select * from tblDondathang
Select * from tblNhanVien

INSERT INTO tblDondathang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
VALUES(4,'2','1','2018/01/02','2018/01/05','Ha Nam'), --Khach hang Nam MaKH = 1
	  (6,'1','1','2019/02/01','2019/02/02','Phu Tho'),
	  (8,'3','1','2013/09/05','2013/09/08','Nha Trang'),
	  (9,'3','2','2016/12/02','2016/12/05','Hai Phong'), --Khach hang Nam MaKH = 2
	  (10,'2','2','2011/11/01','2011/11/02','Ninh Binh'),
	  (11,'1','2','2014/10/05','2014/10/08','Quang Nam')

--dat it nhat 3 mat hang(tblChiTietDatHang) voi so luong mua khac nhau
Select * from tblChiTietDatHang
Select * from tblDondathang

--b)Them loai hang Thoi trang va Cham soc suc khoe
INSERT INTO tblLoaiHang(sMaloaihang,sTenloaihang)
VALUES('LH20','Thoi Trang'),
	  ('CSSK','CSoc Skhoe')

SELECT *FROM tblLoaiHang

--c)Them 5 mat hang thuoc loai hang Thoi Trang
Insert into tblMathang(sMahang,sTenhang,sMaloaihang,fSoluong,fGiahang,sDonvitinh)
Values('LH21','Dien Thoai','LH20',5,2,'VND'),
	  ('LH22','Cap Sach','LH20',4,5,'Dollar'),
	  ('LH23','May Giat','LH20',3,7,'VND'),
	  ('LH24','Cap Sach','LH20',4,5,'Dollar'),
	  ('LH25','May Giat','LH20',3,7,'VND')

SELECT *FROM tblMathang

--d)Lap don dat hang cho it nhat 2/3 so khach hang Nu voi it nhat 4/5 so mat hang Thoi trang da them
--Khach hang ma 3
INSERT INTO tblDondathang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
VALUES(15,'2','3','2018/01/08','2018/01/15','Ha Noi'),
	  (16,'1','5','2018/05/10','2018/05/15','Hai Phong'),
	  (17,'3','4','2019/01/20','2019/01/25','Nam Dinh'),
	  (18,'2','6','2017/01/01','2018/01/05','Hoa Binh')

SELECT * FROM tblDondathang

SELECT * FROM tblKhachHang

DELETE FROM tblChiTietDatHang
WHERE iSoHD=16

--So hoa don 15, khach hang 3
INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
VALUES(15,'LH21',250,15,10),
	  (15,'LH22',450,33,15),
	  (15,'LH23',155,25,10),
	  (15,'LH24',250,53,15),
	  (15,'18',1000,123,45)

SELECT * from tblKhachHang
SELECT * from tblDondathang
SELECT * from tblChiTietDatHang

--e)Giam gia 5% moi mat hang da dat va chua giao thuoc loai hang Thoi trang
UPDATE tblChiTietDatHang
SET fMucgiamgia=fMucgiamgia + 0.05
FROM tblMathang,tblChiTietDatHang,tblDondathang
WHERE sMaloaihang = 'LH20' and (dNgaydathang < getdate()) and ((dNgaygiaohang > getdate()) OR (dNgaygiaohang = NULL))
and tblMathang.sMahang = tblChiTietDatHang.sMahang and tblDondathang.iSoHD = tblChiTietDatHang.iSoHD

SELECT * from tblMathang
Select * from tblChiTietDatHang
Select * from tblDondathang

--f)Xoa loai hang Cham soc suc khoe
DELETE FROM tblLoaiHang
WHERE sMaloaihang = 'CSSK'

--Bai 2.4
--a)Them 3 ban ghi vao bang tblKhachHang va 3 ban ghi vao tblNhanVien
--Them 3 ban ghi vao tblKhachHang
INSERT INTO tblKhachHang(iMaKH,sTenKH,sDiachi,sDienthoai,bGioitinh)
VALUES(4,'Nguyen Vinh','Dong Nai','0936258489',1),
	  (5,'Bui Linh','Quang Tri','0935456874',0),
	  (6,'Bui Hoang Oanh','Tuyen Quang','0984596154',0),
	  (7,'Pham Hanh','Thai Binh','0935201265',0)

--Them 3 ban ghi vao tblNhanVien
INSERT INTO tblNhanVien(iMaNV,sTenNV,sDiachi,sDienthoai,dNgaysinh,dNgayvaolam,fLuongcoban,fPhucap,sCMND)
VALUES(5,'Nguyen Tuan','Hai Phong','0935481587','1999/04/10','2019/05/10',2000,3,'M123434568'),
	  (6,'Nguyen Hai Nam','Ninh Thuan','0984654210','2000/01/01','2019/05/05',3000,4,'M014545757'),
	  (7,'Hoang Nam','Binh Duong','0964515252','1998/05/03','2019/01/05',3000,6,'M254325615')

SELECT * FROM tblKhachHang
SELECT * FROM tblNhanVien

--b)Them 3 ban ghi vao bang tblDonnhaphang, ngay nhap thuoc nam 2016 va 2017
INSERT INTO tblDonnhaphang(iSoHD,iMaNV,dNgaynhaphang)
VALUES(1,2,'2017/01/05'),
	  (3,5,'2016/04/07'),
	  (4,6,'2017/05/25')

SELECT * FROM tblDonnhaphang

--c)Voi moi don nhap hang trong tblDonnhaphang them cac chi tiet nhap hang tuong ung, moi don nhap hang co it nhat 2 mat hang dc them
INSERT INTO tblChitietnhaphang(iSoHD,sMahang,fGianhap,fSoluongnhap)
VALUES(1,5,100,5), --Hoa don 1
	  (1,4,350,10),
	  (3,6,500,1), --Hoa don 3
	  (3,16,500,20),
	  (4,12,500,1), --Hoa don 4
	  (4,18,500,20)

SELECT * FROM tblDonnhaphang
SELECT * FROM tblChitietnhaphang

--d)Xoa chi tiet nhap hang co so hoa don bang 3
DELETE from tblChitietnhaphang 
WHERE iSoHD = 3

--Bai 3.1
--a)Cho biet nhung mat hang nao co so luong duoi 100
Insert into tblMathang(sMahang,sTenhang,sMaloaihang,fSoluong,fGiahang,sDonvitinh)
Values('20','PXT','LH20',120,5,'VND');

Select *
From tblMathang
Where fSoluong < 100

Select * from tblMathang

--b)Tao View so mat hang cua tung loai hang
GO
CREATE VIEW vvSoMatHang_TungLoaiHang(sMaloaihang,TongSoHang)
AS
	Select sMaloaihang,count(sMahang)
	From tblMathang
	Group by sMaloaihang

Select * from vvSoMatHang_TungLoaiHang
Select * from [dbo].[tblMathang]
Select * from [dbo].[tblLoaiHang]

--c)So tien phai tra cua tung don dat hang
Select iSoHD,sum((fGiaban*fSoluongmua)-fMucgiamgia) AS [Tong tien]
From tblChiTietDatHang
Group by iSoHD

Select * from [dbo].[tblDondathang]
Select * from [dbo].[tblChiTietDatHang]

--d)Tong so tien hang thu dc trong moi thang nam 2016 theo dNgaydathang
Select Month(dNgaydathang) AS [Thang],sum((fGiaban*fSoluongmua)-fMucgiamgia) AS [Tong tien]
From tblChiTietDatHang,tblDondathang
Where tblChiTietDatHang.iSoHD=tblDondathang.iSoHD and Year(dNgaydathang) = '2016'
Group by Month(dNgaydathang)

Select * from [dbo].[tblDondathang]
Select * from [dbo].[tblChiTietDatHang]

--e)Nhung mat hang dc mua 1 lan trong nam 2016
Select tblMathang.sMahang,sTenHang,fSoluongmua
From tblMathang,tblChiTietDatHang,tblDondathang
Where tblChiTietDatHang.iSoHD=tblDondathang.iSoHD and tblChiTietDatHang.sMahang=tblMathang.sMahang
		and Year(dNgaydathang) = '2016' and fSoluongmua=1

Select * from [dbo].[tblDondathang]
Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblMathang]

--Bai 3.2
--a)Tao View tinh tong tien hang, tong so mat hang cua tung don nhap hang
Go
Create View vvTongTienHang_TongMatHang(iSoHD,TongTienHang, TongSoMatHang)
AS
	Select iSoHD,sum(fGianhap*fSoluongnhap),count(sMahang)
	From tblChitietnhaphang
	Group by iSoHD

Select * from [dbo].[vvTongTienHang_TongMatHang]
Select * from [dbo].[tblDonnhaphang]
Select * from [dbo].[tblChitietnhaphang]
Select * from [dbo].[tblMathang]

--b)Ds ten cac mat hang khong dc nhap ve trong thang 5/2017
SELECT sMahang,sTenhang
FROM tblMathang
WHERE sMahang NOT IN (SELECT sMahang
					  FROM tblChitietnhaphang,tblDonnhaphang
					  WHERE tblChitietnhaphang.iSoHD=tblDonnhaphang.iSoHD and Year(dNgaynhaphang)='2017' and Month(dNgaynhaphang)=5)

Select * from [dbo].[tblDonnhaphang]
Select * from [dbo].[tblChitietnhaphang]
Select * from [dbo].[tblMathang]

--c)Chi biet sTenNhaCC da cung cap nhung mat hang thuoc loai hang 'Mahang1'
Select tblNhaCungCap.iMaNCC,sTenNhaCC,tblLoaiHang.sMaloaihang,sTenhang
From tblNhaCungCap,tblLoaiHang,tblMathang
Where tblNhaCungCap.iMaNCC=tblMathang.iMaNCC and tblMathang.sMaloaihang=tblLoaiHang.sMaloaihang and tblLoaiHang.sMaloaihang='Mahang1'

Select * from [dbo].[tblNhaCungCap]
Select * from [dbo].[tblLoaiHang]
Select * from [dbo].[tblMathang]

--d)Tao View cho biet so luong da ban cua tung loai hang nam 2016
go
Create View vvSoluongban_Tungloaihang(sMaloaihang,sTenloaihang,SoLuongBan)
AS
	Select tblLoaiHang.sMaloaihang,sTenloaihang,sum(fSoluongmua)
	From tblLoaiHang,tblChiTietDatHang,tblDondathang,tblMathang
	Where Year(dNgaydathang)='2016' and tblChiTietDatHang.iSoHD=tblDondathang.iSoHD and tblMathang.sMaloaihang=tblLoaiHang.sMaloaihang
		and tblChiTietDatHang.sMahang=tblMathang.sMahang
	Group by tblLoaiHang.sMaloaihang,sTenloaihang

Select * from [dbo].[vvSoluongban_Tungloaihang]
Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblDondathang]
Select * from [dbo].[tblLoaiHang]
Select * from [dbo].[tblMathang]

--e)Cho biet tong so tien hang da ban duoc cua tung nhan vien nam 2016
Select tblNhanVien.iMaNV,sTenNV,sum((fGiaban*fSoluongmua)-fMucgiamgia) AS [TongTienHang]
From tblNhanVien, tblChiTietDatHang,tblDondathang
Where Year(dNgaydathang)='2016' and tblNhanVien.iMaNV=tblDondathang.iMaNV and tblChiTietDatHang.iSoHD=tblDondathang.iSoHD
Group by tblNhanVien.iMaNV,sTenNV

Select * from [dbo].[tblNhanVien]
Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblDondathang]

--Bai 3.3
--a)DS khach hang Nu chua dat hang lan nao
Select *
From tblKhachHang
Where bGioitinh=0 and iMaKH NOT IN (Select tblKhachHang.iMaKH
									From tblKhachHang,tblDondathang
									Where bGioitinh=0 and tblKhachHang.iMaKH=tblDondathang.iMaKH)

Select * from [dbo].[tblDondathang]
Select * from [dbo].[tblKhachHang]

--b)So luong dat hang cua toan bo cac mat hang 'Thoi Trang' ke ca mat hang chua dc dat lan nao
Select tblMathang.sMahang,sTenhang,tblLoaiHang.sMaloaihang,sTenloaihang,sum(fSoluongmua) AS [SoLuongDatHang]
From tblLoaiHang,tblChiTietDatHang,tblDondathang,tblMathang
Where tblLoaiHang.sMaloaihang='LH20' and tblLoaiHang.sMaloaihang=tblMathang.sMaloaihang and tblDondathang.iSoHD=tblChiTietDatHang.iSoHD
		and tblMathang.sMahang=tblChiTietDatHang.sMahang
Group by tblMathang.sMahang,sTenhang,tblLoaiHang.sMaloaihang,sTenloaihang

Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblDondathang]

Select * from [dbo].[tblMathang]

--c)DS khach hang Nam va tong tien dat hang cua moi nguoi
Select tblKhachHang.iMaKH,sTenKH,bGioitinh,sum((fGiaban*fSoluongmua)-fMucgiamgia) AS [TongTienDatHang]
From tblKhachHang,tblChiTietDatHang,tblDondathang
Where bGioitinh=1 and tblKhachHang.iMaKH = tblDondathang.iMaKH and tblDondathang.iSoHD = tblChiTietDatHang.iSoHD
Group by tblKhachHang.iMaKH,sTenKH,bGioitinh

Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblDondathang]
Select * from [dbo].[tblKhachHang]

--d)Tao View thong ke so luong khach hang theo gioi tinh
go
Create View vvKH_TheoGioiTinh(bGioitinh,SoLuong)
As
	Select bGioitinh,count(iMaKH)
	From tblKhachHang
	Group by bGioitinh

Select * from [dbo].[vvKH_TheoGioiTinh]
Select * from [dbo].[tblKhachHang]

--e)Tao View DS 3 khach hang mua hang nhieu nhat
go
Create View vvDSKH_MuaNhieuNhat(iMaKH,sTenKH,SoLanMua)
AS
	Select TOP 3 tblDondathang.iMaKH,sTenKH,count(tblDondathang.iMaKH) AS [SoLanMua]
	From tblKhachHang,tblDondathang
	Where tblKhachHang.iMaKH=tblDondathang.iMaKH
	Group by tblDondathang.iMaKH,sTenKH
	Order by SoLanMua DESC
	
Select * from [dbo].[vvDSKH_MuaNhieuNhat]
Select * from [dbo].[tblKhachHang]
Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblDondathang]

--f)Tao View DS mat hang va gia ban trung binh cua tung mat hang
go
Create View vvDSMathang_GiabanTB(sMahang,sTenhang,GiaBanTrungBinh)
AS
	Select tblMathang.sMahang,sTenhang,avg(fGiaban)
	From tblMathang,tblChiTietDatHang,tblDondathang
	Where tblMathang.sMahang=tblChiTietDatHang.sMahang and tblChiTietDatHang.iSoHD=tblDondathang.iSoHD
	Group by tblMathang.sMahang,sTenhang

Select * from [dbo].[vvDSMathang_GiabanTB]
Select * from [dbo].[tblDondathang]
Select * from [dbo].[tblMathang]
Select * from [dbo].[tblChiTietDatHang]

--g)Cap nhat gia ban (tblMathang.fGiahang) theo qui tac: Gia ban 1 mat hang = Gia mua lon nhat trong vong 30 ngay cua mat hang do + 10%
go
Create View vvCapNhatGiaHang(sMahang,sTenhang,MaxGiaBan)

AS
	Select tblChiTietDatHang.sMahang,sTenhang, MAX(fGiaban)
	From tblMathang,tblDondathang,tblChiTietDatHang
	Where tblMathang.sMahang=tblChiTietDatHang.sMahang and tblChiTietDatHang.iSoHD=tblDondathang.iSoHD
	Group by tblChiTietDatHang.sMahang,sTenhang

Update tblMathang
Set fGiahang = vvCapNhatGiaHang.MaxGiaBan + vvCapNhatGiaHang.MaxGiaBan*(0.1)
From vvCapNhatGiaHang,tblMathang,tblChiTietDatHang
Where tblMathang.sMahang = vvCapNhatGiaHang.sMahang and tblMathang.sMahang=tblChiTietDatHang.sMahang and fGiaban = MaxGiaBan and tblMathang.sMahang = '18' 

Select * from [dbo].[vvCapNhatGiaHang]
Select * from [dbo].[tblMathang]
Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblDondathang]

--Bai 4.1
--a)Tao thu tuc cho biet cac mat hang khong ban dc trong nam la tham so truyen vao
go
CREATE PROC prMatHang_Nam(@dNgaygiaohang datetime)
AS
BEGIN
	SELECT sMahang,sTenHang
	FROM tblMathang
	WHERE sMahang NOT IN(SELECT tblChiTietDatHang.sMahang
						FROM tblMathang,tblDondathang,tblChiTietDatHang
						WHERE tblMathang.sMahang=tblChiTietDatHang.sMahang and tblChiTietDatHang.iSoHD=tblDondathang.iSoHD
							and Year(dNgaygiaohang)=Year(@dNgaygiaohang))
END

EXEC prMatHang_Nam '2016'

Select * from [dbo].[tblMathang]
Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblDondathang]

--b)Viet thu tuc tham so truyen vao la so luong hang va nam, thuc hien tang luong gap len gap ruoi cho NV nao ban dc so luong
--hang > so luong hang truyen vao trong nam nao do
INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
VALUES(16,'6',123,4567,89)

--Tao View so luong hang ban duoc cua tung nhan vien
go
CREATE VIEW vwSLHangbanduoc_TungNV(Nam,sMaNV,SLHangBanDuoc)
AS
	SELECT Year(dNgaygiaohang),tblNhanVien.iMaNV,sum(fSoluongmua)
	FROM tblChiTietDatHang,tblNhanVien,tblDondathang
	WHERE tblChiTietDatHang.iSoHD = tblDondathang.iSoHD and tblNhanVien.iMaNV = tblDondathang.iMaNV
	GROUP BY Year(dNgaygiaohang),tblNhanVien.iMaNV

Select * from [dbo].[vwSLHangbanduoc_TungNV]

--Tao proc
go
CREATE PROC prTangluong_TheoSLHang(@SLHang int, @Nam datetime)
AS
BEGIN
	UPDATE tblNhanVien
	SET fLuongcoban = fLuongcoban + fLuongcoban*(0.5)
	FROM tblNhanVien,vwSLHangbanduoc_TungNV,tblChiTietDatHang,tblDondathang
	WHERE vwSLHangbanduoc_TungNV.SLHangBanDuoc > @SLHang and Year(@Nam) = vwSLHangbanduoc_TungNV.Nam
			and tblChiTietDatHang.iSoHD = tblDondathang.iSoHD and tblNhanVien.iMaNV = tblDondathang.iMaNV
			and vwSLHangbanduoc_TungNV.sMaNV = tblDondathang.iMaNV
END

EXEC prTangluong_TheoSLHang '250','2018'

Select * from [dbo].[vwSLHangbanduoc_TungNV]
Select * from [dbo].[tblNhanVien]
Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblDondathang]

--c)Tao thu tuc thong ke tong so luong hang ban duoc cua 1 mat hang co ma hang la tham so truyen vao
CREATE PROC prTongsoluonghang(@MaH nvarchar(10))
AS
BEGIN
	SELECT tblMathang.sMahang,sTenhang,sum(fSoluongmua) AS [SoLuongHangDaBan]
	FROM tblMathang,tblChiTietDatHang
	WHERE tblMathang.sMahang = tblChiTietDatHang.sMahang and @MaH = tblMathang.sMahang
	GROUP BY tblMathang.sMahang,sTenhang
END

EXEC prTongsoluonghang '18'

--d)Tao thu tuc co tham so truyen vao la nam, tinh tong so tien hang thu duoc trong nam do
CREATE PROC prTongsotienhang_Nam(@Nam datetime)
AS
BEGIN
	SELECT sum(fGiaban*fSoluongmua-fMucgiamgia) AS [TongSoTienHang]
	FROM tblChiTietDatHang,tblDondathang
	WHERE tblChiTietDatHang.iSoHD=tblDondathang.iSoHD and Year(dNgaygiaohang)=Year(@Nam)
END

EXEC prTongsotienhang_Nam '2016'

--e)Viet trigger cho tblChiTietDatHang de sao cho khi them 1 ban ghi hoac khi sua tblChiTietDatHang.fGiaban
--chi chap nhan gia ban ra phai >= gia goc tblMathang.fGiahang
CREATE TRIGGER trGiabanra_HonGiagoc
ON tblChiTietDatHang
FOR INSERT, UPDATE
AS
BEGIN
	Declare @fGiaban float, @fGiagoc float, @sMahang nvarchar(10)
	Select @sMahang = sMahang, @fGiaban = fGiaban from INSERTED
	Select @fGiagoc=fGiahang from tblMathang where sMahang=@sMahang
	IF(@fGiaban >= @fGiagoc)
		PRINT N'Cap nhat thanh cong'
	ELSE
		BEGIN 
			PRINT N'Gia ban phai lon hon gia goc'
			ROLLBACK TRAN
		END
END

INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
VALUES(17,'5',1,4567,89)

SELECT * FROM [dbo].[tblChiTietDatHang]
SELECT * FROM [dbo].[tblMathang]

--f)Tao Trigger de luong hang ban ra khong vuot qua luong hang hien co
CREATE TRIGGER trLuonghangbanra_nhohonluonghanghienco
ON tblChiTietDatHang
FOR INSERT,UPDATE
AS
BEGIN
	Declare @fSoluongban float, @fSoluongco float, @sMahang nvarchar(10)
	Select @sMahang = sMahang, @fSoluongban = fSoluongmua FROM INSERTED
	Select @fSoluongco = fSoluong FROM tblMathang WHERE @sMahang = sMahang
	IF(@fSoluongban <= @fSoluongco)
		PRINT N'Cap nhat thanh cong'
	ELSE
		BEGIN
			PRINT N'So luong hang ban ra phai nho hon so hang hien co'
			ROLLBACK TRAN
		END
END

INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
VALUES(17,'5',3,7,8)

DELETE tblChiTietDatHang
WHERE iSoHD= 17 and sMahang = 5

Select * from [dbo].[tblChiTietDatHang]
Select * from [dbo].[tblMathang]
Select * from [dbo].[tblDondathang]

--Bai 4.2
--a)Tao thu tuc them 1 ban ghi moi cho tblDondathang kiem tra dNgaydathang < getdate, dNgaygiaohang >= dNgaydathang
CREATE PROC prThemDLDondathang(@iSoHD int, @iMaNV int, @iMaKH int, @dNgaydathang datetime, @dNgaygiaohang datetime,@sDiachigiaohang nvarchar(50))
AS
BEGIN
	IF EXISTS (Select * from tblDondathang Where @iSohd = iSoHD)
		PRINT N'So HD da ton tai'
	ELSE
		IF NOT EXISTS (Select * from tblDondathang Where @iMaNV = iMaNV)
			PRINT N'Ma NV khong ton tai'
		ELSE
			IF NOT EXISTS (Select * from tblDondathang Where @iMaKH = iMaKH)
				PRINT N'Ma KH khong ton tai'
			ELSE
				/*IF EXISTS (Select * from tblDondathang Where @dNgaydathang > getdate() and @dNgaygiaohang < dNgaydathang)
					PRINT N'Ngay dat hang phai nho hon ngay hien tai va ngay giao hang phai lon hon ngay dat hang'
				ELSE*/
					BEGIN
						INSERT INTO tblDondathang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
						VALUES(@iSoHD,@iMaNV,@iMaKH,@dNgaydathang,@dNgaygiaohang,@sDiachigiaohang)
					END
END

prThemDLDondathang '51','1','10','2019/06/11','2019/06/13','Ca Mau'

Select * from [dbo].[tblDondathang]

--b)Them cot TongTienHang (float) vao tblKhachHang, tao trigger sao cho gia tri TongTienHang tu dong tang len moi
--khi khach hang den tham gia mua hang tai cua hang
ALTER TABLE tblKhachHang
ADD TongTienHang float

UPDATE tblKhachHang
SET TongTienHang = 0

INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
VALUES('16','7','6','15','1')

DELETE FROM tblChiTietDatHang WHERE iSoHD = 16 and sMahang = 7

SELECT * FROM [dbo].[tblKhachHang]
SELECT * FROM [dbo].[tblChiTietDatHang]
SELECT * FROM [dbo].[tblDondathang]
SELECT * FROM [dbo].[tblMathang]

CREATE TRIGGER trTudongtang_Tongtienhang
ON tblChiTietDatHang
AFTER INSERT
AS
BEGIN
	Declare @MaKH int, @TongTien float
	Select @MaKH = (SELECT tblDondathang.iMaKH
					FROM tblDondathang INNER JOIN INSERTED ON tblDondathang.iSoHD = INSERTED.iSoHD)
	Select @TongTien = (SELECT sum(fGiaban*fSoluongmua-fMucgiamgia) AS TTT
						FROM INSERTED INNER JOIN tblDondathang ON INSERTED.iSoHD = tblDondathang.iSoHD)
	IF EXISTS (SELECT sTenKH FROM tblKhachHang WHERE @MaKH = iMaKH)
		BEGIN	
			UPDATE tblKhachHang
			SET TongTienHang = TongTienHang + @TongTien
			WHERE @MaKH = iMaKH
		END
	ELSE
		BEGIN
			PRINT N'Khach hang chua dat hang'
			ROLLBACK TRAN
		END
END

--c)Tao thu tuc cho biet danh sach ten cac mat hang da duoc nhap hang tu 1 nha cung cap theo 1 nam nao do (tham so truyen vao la ten NCC va nam)
CREATE PROC prTenmathang_NCC_Nam(@dNgaynhaphang datetime, @sTenNhaCC nvarchar(50))
AS
BEGIN
	SELECT tblMathang.sMahang,sTenhang
	FROM tblMathang,tblChitietnhaphang,tblDonnhaphang,tblNhaCungCap
	WHERE tblMathang.sMahang = tblChitietnhaphang.sMahang and tblChitietnhaphang.iSoHD = tblDonnhaphang.iSoHD
		and tblMathang.iMaNCC = tblNhaCungCap.iMaNCC and Year(dNgaynhaphang) = Year(@dNgaynhaphang) and sTenNhaCC = @sTenNhaCC
END

EXEC prTenmathang_NCC_Nam '2017', 'HP'

SELECT * FROM [dbo].[tblMathang]
SELECT * FROM [dbo].[tblChitietnhaphang]
SELECT * FROM [dbo].[tblDonnhaphang]
SELECT * FROM [dbo].[tblNhaCungCap]

--d)Tao thu tuc cho biet ten cac nha cung cap va ngay nhap hang da duoc nhap hang cua 1 mat hang nao di theo ten mat hang,(tham so truyen vao la ten mat hang)
CREATE PROC prTenNCC_Ngaynhap_Tenmathang(@sTenhang nvarchar(30))
AS
BEGIN
	SELECT sTenNhaCC,dNgaynhaphang
	FROM tblDonnhaphang,tblMathang,tblNhaCungCap,tblChitietnhaphang
	WHERE tblDonnhaphang.iSoHD = tblChitietnhaphang.iSoHD and tblChitietnhaphang.sMahang = tblMathang.sMahang
	and tblNhaCungCap.iMaNCC = tblMathang.iMaNCC and sTenhang = @sTenhang
END

EXEC prTenNCC_Ngaynhap_Tenmathang 'Ban La'

--e)Them cot TongSoMatHang (float) vao tblDondathang, tao trigger sao cho gia tri cua TongSoMatHang tu dong tang len moi khi
--bo sung them 1 mat hang khach dat mua trong don dat hang tuong ung
ALTER TABLE tblDondathang
ADD TongSoMatHang float

UPDATE tblDondathang
SET TongSoMatHang = 0

CREATE TRIGGER trGiatritongsomathang
ON tblChiTietDatHang
FOR INSERT
AS
BEGIN
	Declare @Tongsomathang float ,@iSoHD int
	Select @iSoHD = iSoHD from INSERTED
	Select @Tongsomathang = (Select fSoluongmua from INSERTED)

	UPDATE tblDondathang
	SET TongSoMatHang = TongSoMatHang + @Tongsomathang
	WHERE iSoHD = @iSoHD
END

INSERT INTO tblChiTietDatHang
VALUES('1','16','5','3','1')

DELETE FROM tblChiTietDatHang
WHERE iSoHD = 1 AND sMahang = 16

SELECT * FROM [dbo].[tblChiTietDatHang]
SELECT * FROM [dbo].[tblDondathang]
SELECT * FROM [dbo].[tblMathang]

--Bai 4.3
--a)Tao thu tuc them du lieu cho tblMathang theo tham so truyen vao
CREATE PROC prThemDLMathang(@sMaHang nvarchar(10),@sTenhang nvarchar(30),@iMaCC int, @sMaloaihang nvarchar(10),
							@fSoluong float, @fGiahang float,@sDonvitinh nvarchar(10))
AS
BEGIN
	IF EXISTS(SELECT * FROM tblMathang WHERE sMahang = @sMaHang)
		PRINT N'Ma hang da ton tai'
	ELSE
		IF NOT EXISTS(SELECT * FROM tblMathang WHERE @iMaCC = iMaNCC)
			PRINT N'Ma nha cung cap khong ton tai'
		ELSE
			IF NOT EXISTS(SELECT * FROM tblMathang WHERE @sMaloaihang = sMaloaihang)
				PRINT N'Ma loai hang khong ton tai'
			ELSE
				BEGIN
					INSERT INTO tblMathang(sMahang,sTenhang,iMaNCC,sMaloaihang,fSoluong,fGiahang,sDonvitinh)
					VALUES(@sMaHang,@sTenhang,@iMaCC,@sMaloaihang,@fSoluong,@fGiahang,@sDonvitinh)
				END
END

prThemDLMathang '1','DLMoiThem','3','Mahang3','22','03','1971'

SELECT * FROM tblMathang

--b)Tao thu tuc tham so truyen vao la Gia tri, muc giam gia, thuc hien giam gia cho cac mat hang duoc dat trong thang hien tai,
	--co (fGiaban*fSoluongmua) > = Gia tri va dang co fMucgiamgia = 0
CREATE PROC prGiamgia(@Giatri float, @fMucgiamgia float)
AS
BEGIN
	UPDATE tblChiTietDatHang
	SET fMucgiamgia = @fMucgiamgia
	FROM tblChiTietDatHang,tblDondathang
	WHERE (fGiaban*fSoluongmua) > = @Giatri and fMucgiamgia = 0 and Month(dNgaygiaohang) = Month(getdate())
			and tblChiTietDatHang.iSoHD = tblDondathang.iSoHD
END

EXEC prGiamgia '200','1999'

/*UPDATE tblChiTietDatHang
SET fMucgiamgia = 0
WHERE sMahang = 'LH22' --sMahang = 18 AND fGiaban = 100*/

SELECT * FROM tblChiTietDatHang

SELECT * FROM tblDondathang

--c)
CREATE PROC prXauhang(@chuoi nvarchar(256),@sMahang nvarchar(10)=null, @iSoHD int , @fGiaban float =null, @fSoluongmua int = null,
@fMucgiamgia float=0,@iMaNV int, @iMaKH int, @dNgaygiaohang nvarchar(20), @dNgaydathang nvarchar(20), @sDiachigiaohang nvarchar(20))
AS
BEGIN
	WHILE LEN(@chuoi) <> 0
	BEGIN
		SET @sMahang = SUBSTRING(@chuoi , 1 , CHARINDEX(',', @chuoi)-1)
		SET @chuoi = SUBSTRING(@chuoi ,CHARINDEX(',', @chuoi)+1, LEN(@chuoi))
		IF CHARINDEX(',', @chuoi) = 0
			BEGIN
				SET @fSoluongmua = SUBSTRING(@chuoi , 1 , LEN(@chuoi))
				SET @chuoi = ''
				SET @fGiaban = (SELECT fGiahang FROM tblMathang WHERE sMahang = @sMahang)
			END
		ELSE
			BEGIN
				SET @fSoluongmua = SUBSTRING(@chuoi , 1 , CHARINDEX(',', @chuoi)-1)
				SET @chuoi = SUBSTRING(@chuoi ,CHARINDEX(',', @chuoi)+1, LEN(@chuoi))
				SET @fGiaban = (SELECT fGiahang FROM tblMathang WHERE sMahang = @sMahang)
			END
				INSERT INTO tblDondathang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
				VALUES(@iSoHD,@iMaNV,@iMaKH,@dNgaydathang,@dNgaygiaohang,@sDiachigiaohang)
				INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
				VALUES(@iSoHD,@sMahang,@fGiaban,@fSoluongmua,@fMucgiamgia)
				SET @iSoHD = @iSoHD +1
	END
END
	
EXEC prXauhang @chuoi = '1,3,100,21,12,4', @iSoHD =20,@iMaNV=1, @iMaKH =2, @dNgaydathang =N'2017-10-11',
@dNgaygiaohang =N'2017-10-13', @sDiachigiaohang= N'Hà Nội'
	
SELECT * FROM [dbo].[tblChiTietDatHang]
SELECT * FROM [dbo].[tblDondathang]
SELECT * FROM [dbo].[tblMathang]

--d)Khi xoa 1 NV khoi tblNhanVien thi cac don dat hang va don nhap hang cua nhan vien do se duoc chuyen deu cho cac nhan vien khac
--co so don dat hang va so don nhap hang cao nhat nhung it hon nhan vien bi xoa
CREATE TRIGGER tg_DropNhanVien
ON tblNhanVien
AFTER INSERT
AS
BEGIN
	DECLARE @MaNVXoa int, @MaNVNhap int, @MaNVXuat int, @SoHDNVXNhap int, @SoHDNVXXuat int, @SoHDNVKNhap int, @SoHDNVKXuat int
	SELECT @MaNVXoa = (SELECT iMaNV FROM INSERTED)
	
	SELECT @SoHDNVXNhap = (SELECT count(iSoHD) FROM tblDondathang WHERE tblDondathang.iMaNV = @MaNVXoa)

	SELECT @SoHDNVXXuat = (SELECT count(iSoHD) FROM tblDonnhaphang WHERE tblDonnhaphang.iMaNV = @MaNVXoa)
	
	SELECT @SoHDNVKNhap = (SELECT TOP 1 count(iSoHD) FROM tblDondathang HAVING count(iSoHD) < @SoHDNVXNhap ORDER BY count(iSoHD) DESC)

	SELECT @SoHDNVKXuat = (SELECT TOP 1 count(iSoHD)  FROM tblDonnhaphang HAVING count(iSoHD) < @SoHDNVXXuat ORDER BY count(iSoHD) DESC)
	
	SELECT @MaNVNhap = (SELECT iMaNV from tblDondathang WHERE tblDondathang.iSoHD = @SoHDNVKNhap )
	SELECT @MaNVXuat = (SELECT iMaNV from tblDonnhaphang WHERE tblDonnhaphang.iSoHD = @SoHDNVKXuat )
	
	UPDATE tblDondathang SET iMaNV = @MaNVNhap where iMaNV = @MaNVXoa
	UPDATE tblDonnhaphang SET iMaNV = @MaNVXuat where iMaNV = @MaNVXoa
END

SELECT * FROM [dbo].[tblNhanVien]
SELECT * FROM [dbo].[tblDondathang]
SELECT * FROM [dbo].[tblDonnhaphang]

INSERT INTO tblDonnhaphang
VALUES('1','2','2018/04/16')

DELETE FROM tblDonnhaphang
WHERE iMaNV = '2'

--Bai 5.1
--a) Tao tai khoan dang nhap SQL Server co ten 'Capnhat'
CREATE LOGIN Capnhat
WITH PASSWORD = '123456'

--b) Tao user trong DB tuong ung voi login 'Capnhat' va thuc hien cap quyen Insert, Update, Delete
CREATE USER db_User
FOR LOGIN Capnhat

GRANT INSERT, UPDATE, DELETE
TO db_User

--c) Kiem tra ket qua phan quyen bang viec thuc hien lenh select, insert tren bang bat ki
INSERT INTO tblLoaiHang
VALUES('TL',N'Tủ lạnh')
INSERT INTO tblNhaCungCap
VALUES(N'Điện máy xanh',N'Bán lẻ',N'Hà Nội','0982860164');

SELECT * FROM [dbo].[tblLoaiHang]
SELECT * FROM [dbo].[tblNhaCungCap]

--Bai 5.2
--a) Tao user dang nhap SQL Server co ten 'BanHang' va thuc hien cap quyen Insert tren bang tblDondathang va tblChiTietDatHang
CREATE LOGIN BanHang WITH PASSWORD = '234567'

CREATE USER BanHang
FOR LOGIN BanHang

ALTER LOGIN BanHang
WITH DEFAULT_DATABASE = ThuchanhSQL_PhamXuanTu_17A01

GRANT INSERT
ON tblDondathang 
TO BanHang

GRANT INSERT
ON tblChiTietDatHang
TO BanHang

INSERT INTO tblDondathang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
VALUES('164','3','5','2019/04/16','2019/04/20',N'Vĩnh Phúc')

INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
VALUES('164','7','164','15','164')
 
SELECT * FROM [dbo].[tblDondathang]
SELECT * FROM [dbo].[tblChiTietDatHang]
SELECT * FROM tblMathang

--b)Tao user va cap quyen thuc thi thu tuc
CREATE LOGIN xuantu164 WITH PASSWORD = '123456789'

CREATE USER User2
FOR LOGIN xuantu164

GRANT EXECUTE ON prThemDLDondathang TO User2
--prThemDLDondathang '51','1','10','2019/06/11','2019/06/13','Ca Mau'
GRANT EXECUTE ON prTenmathang_NCC_Nam TO User2
GRANT EXECUTE ON prTenNCC_Ngaynhap_Tenmathang TO User2

SELECT * FROM tblDondathang

--c)
GRANT SELECT
ON tblMathang
TO User2

--Bai 5.3
--a) Tao 1 tai khoan SQL Server login voi ten truy cap 'U1' va mat khau la 'a1b2c3'
CREATE LOGIN U1
WITH PASSWORD = 'a1b2c3'

--b) Tao 1 user tuong ung voi login U1
CREATE USER User_U1
FOR LOGIN U1

--c)Cho phep U1 duoc toan quyen tren bang tblKhachHang
GRANT ALL
ON tblKhachHang
TO User_U1

--d)Tao ROLE
CREATE ROLE BPNhapHang

--Duoc xem, them du lieu cua tblNhaCungCap, tblDonnhaphang, tblChitietnhaphang
GRANT INSERT, SELECT ON tblNhaCungCap TO BPNhapHang
GRANT INSERT, SELECT ON tblDonnhaphang TO BPNhapHang
GRANT INSERT, SELECT ON tblChitietnhaphang TO BPNhapHang

--Duoc xem du lieu tblNhanVien,tblMathang
GRANT SELECT ON tblNhanVien TO BPNhapHang
GRANT SELECT ON tblMathang TO BPNhapHang

--Cam them sua xoa tren tblKhachHang
DENY INSERT, DELETE, UPDATE
ON tblKhachHang
TO BPNhapHang

--e)Dua U1 vao lam thanh vien cua role BLNhapHang
EXEC sp_addrolemember 'BPNhapHang','User_U1'

INSERT INTO tblDonnhaphang
VALUES(10,3,'2017-07-05')

SELECT * FROM [dbo].[tblDonnhaphang]
SELECT * FROM [dbo].[tblChitietnhaphang]

INSERT INTO tblChitietnhaphang
VALUES(10,'7',600,10),
      (10,'2',650,15)

SELECT * FROM [dbo].[tblMathang]
SELECT * FROM [dbo].[tblChitietnhaphang]

DELETE FROM tblKhachHang
WHERE iMaKH  = 8

DENY INSERT, DELETE, UPDATE
ON tblKhachHang
TO BPNhapHang

INSERT INTO tblKhachHang
VALUES(8,N'Nguyễn',N'Nam Định','0982860164',0,0)

SELECT * FROM tblKhachHang

--Bai 6.1
--a)Phan tan ngang tblKhachHang, 'Ha Noi' o may 1, khac 'Ha Noi' o may 2
--Dùng công cụ

SELECT * FROM [dbo].[tblKhachHang]
SELECT * FROM [dbo].[tblDondathang]

--b)Viet lenh lay danh sach khach hang khong o Ha Noi da mua hang
SELECT KH.iMaKH,sTenKH,iSoHD
FROM tblDondathang,LINKMAY2.[ThuchanhSQL_PhamXuanTu_17A01].[dbo].[tblKhachHang] KH
WHERE KH.iMaKH = tblDondathang.iMaKH
GROUP BY KH.iMaKH,sTenKH,iSoHD

SELECT * FROM [dbo].[tblKhachHang]

--Xem tblKhachHang may 1
SELECT *
FROM LINKMAY1.[ThuchanhSQL_PhamXuanTu_17A01].[dbo].[tblKhachHang]

--Xem tblKhachHang may 2
SELECT *
FROM LINKMAY2.[ThuchanhSQL_PhamXuanTu_17A01].[dbo].[tblKhachHang]

--c)Viet thu tuc them du lieu khach hang vao dua vao may phu hop
/*CREATE PROC prThemKH(@iMaKH int,@sTenKH nvarchar(30),@sDiachi nvarchar(50),@sDienthoai nvarchar(12),@bGioitinh bit)
AS
BEGIN
	IF EXISTS (SELECT * FROM LINKMay1.ThuchanhSQL_PhamXuanTu_17A01.dbo.tblKhachHang KH WHERE KH.iMaKH = @iMaKH)
		BEGIN
			PRINT N'Mã khách hàng đã tồn tại ở máy 1'
		END
	ELSE 
		IF EXISTS (SELECT * FROM LINKMay2.ThuchanhSQL_PhamXuanTu_17A01.dbo.tblKhachHang KH WHERE KH.iMaKH = @iMaKH)
			BEGIN
				PRINT N'Mã khách hàng đã tồn tại ở máy 2'
			END
		ELSE
			IF (@sDiachi = 'Ha Noi')
				BEGIN
					INSERT INTO tblKhachHang(iMaKH,sTenKH,sDiachi,sDienthoai,bGioitinh)
					VALUES(@iMaKH,@sTenKH,@sDiachi,@sDienthoai,@bGioitinh)
					PRINT N'Đã thêm khách hàng vào máy 1'
				END
			ELSE
				BEGIN
					INSERT INTO LINK.ThuchanhSQL_PhamXuanTu_17A01.DBO.tblKhachHang(iMaKH,sTenKH,sDiachi,sDienthoai,bGioitinh)
					VALUES(@iMaKH,@sTenKH,@sDiachi,@sDienthoai,@bGioitinh)
					PRINT N'Đã thêm khách hàng vào máy 2'
				END
END

EXEC prThemKH '1','NEW4','Khac Ha Noi','0990','0'*/

exec sp_linkedservers

--------------------------------------Câu 6.1 a,c Vân

CREATE PROC prThemKH2(@iMaKH int,@sTenKH nvarchar(30),@sDiachi nvarchar(50),@sDienthoai nvarchar(12),@bGioitinh bit)
AS
BEGIN
	IF EXISTS (SELECT * FROM tblKhachHang WHERE dbo.tblKhachHang.iMaKH = @iMaKH)
		BEGIN
			PRINT N'Mã khách hàng đã tồn tại 1'
		END
	ELSE 
		IF EXISTS (SELECT * FROM MAY1.ThuchanhSQL_PhamXuanTu_17A01.dbo.tblKhachHang KH WHERE KH.iMaKH = @iMaKH)
			BEGIN
				PRINT N'Mã khách hàng đã tồn tại 2' 
			END
		ELSE
			IF (@sDiachi = 'Ha Noi')
				BEGIN
					INSERT INTO tblKhachHang(iMaKH,sTenKH,sDiachi,sDienthoai,bGioitinh)
					VALUES(@iMaKH,@sTenKH,@sDiachi,@sDienthoai,@bGioitinh)
					PRINT N'Ðã thêm khách hàng vào máy 1'
				END
			ELSE
				BEGIN
					INSERT INTO MAY1.ThuchanhSQL_PhamXuanTu_17A01.DBO.tblKhachHang(iMaKH,sTenKH,sDiachi,sDienthoai,bGioitinh)
					VALUES(@iMaKH,@sTenKH,@sDiachi,@sDienthoai,@bGioitinh)
					PRINT N'Ðã thêm khách hàng vào máy 2'
				END
END

EXEC prThemKH2 '164','NEW4','Khac Ha Noi','0990','0'

DELETE FROM tblKhachHang
WHERE iMaKH = '164'

SELECT * FROM tblKhachHang
--union
SELECT * FROM MAY1.ThuchanhSQL_PhamXuanTu_17A01.dbo.tblKhachHang

--------------------------------------Câu 6.1 a,c Vân

--Bai 6.2
--a)Phan tan ngang tblNhanVien, luong < 4 tr o may 1, con lai o may 2
--Dùng công cụ
SELECT * FROM [dbo].[tblNhanVien]

--b)Viet thu tuc them du lieu nhan vien vao dua vao may phu hop
/*CREATE PROC prThemNV(@iMaNV int,@sTenNV nvarchar(30),@sDiachi nvarchar(50),@sDienthoai nvarchar(12),@dNgaysinh datetime,
@dNgayvaolam datetime,@fLuongcoban float,@fPhucap float,@sCMND nvarchar(20))
AS
BEGIN
	IF EXISTS (SELECT * FROM LINKMay1.ThuchanhSQL_PhamXuanTu_17A01.dbo.tblNhanVien NV WHERE NV.iMaNV = @iMaNV)
		BEGIN
			PRINT N'Mã nhân viên đã tồn tại ở máy 1'
		END
	ELSE 
		IF EXISTS (SELECT * FROM LINKMay2.ThuchanhSQL_PhamXuanTu_17A01.dbo.tblNhanVien NV WHERE NV.iMaNV = @iMaNV)
			BEGIN
				PRINT N'Mã nhân viên đã tồn tại ở máy 2'
			END
		ELSE
			IF (@fLuongcoban < 3500)
				BEGIN
					INSERT INTO LINKMay1.ThuchanhSQL_PhamXuanTu_17A01.DBO.tblNhanVien(iMaNV,sTenNV,sDiachi,sDienthoai,dNgaysinh,dNgayvaolam,fLuongcoban,
					fPhucap,sCMND)
					VALUES(@iMaNV,@sTenNV,@sDiachi,@sDienthoai,@dNgaysinh,@dNgayvaolam,@fLuongcoban,@fPhucap,@sCMND)
					PRINT N'Đã thêm nhân viên vào máy 1'
				END
			ELSE
				BEGIN
					INSERT INTO LINKMay2.ThuchanhSQL_PhamXuanTu_17A01.DBO.tblNhanVien(iMaNV,sTenNV,sDiachi,sDienthoai,
					dNgaysinh,dNgayvaolam,fLuongcoban,fPhucap,sCMND)
					VALUES(@iMaNV,@sTenNV,@sDiachi,@sDienthoai,@dNgaysinh,@dNgayvaolam,@fLuongcoban,@fPhucap,@sCMND)
					PRINT N'Đã thêm nhân viên vào máy 2'
				END
END

EXEC prThemNV '9','NEW','2','3','1999/04/16','2019/01/01','3555','7','8'*/

--------------------------------------Câu 6.2 a,b Vân
CREATE PROC prThemNV2(@iMaNV int,@sTenNV nvarchar(30),@sDiachi nvarchar(50),@sDienthoai nvarchar(12),@dNgaysinh datetime,
@dNgayvaolam datetime,@fLuongcoban float,@fPhucap float,@sCMND nvarchar(20))
AS
BEGIN
	IF EXISTS (SELECT * FROM tblNhanVien WHERE dbo.tblNhanVien.iMaNV = @iMaNV)
		BEGIN
			PRINT N'Mã nhân viên đã tồn tại'
		END
	ELSE 
		IF EXISTS (SELECT * FROM MAY1.ThuchanhSQL_PhamXuanTu_17A01.dbo.tblNhanVien NV WHERE NV.iMaNV = @iMaNV)
			BEGIN
				PRINT N'Mã nhân viên đã tồn tại'
			END
		ELSE
			IF (@fLuongcoban < 4000)
				BEGIN
					INSERT INTO tblNhanVien(iMaNV,sTenNV,sDiachi,sDienthoai,dNgaysinh,dNgayvaolam,fLuongcoban,
					fPhucap,sCMND)
					VALUES(@iMaNV,@sTenNV,@sDiachi,@sDienthoai,@dNgaysinh,@dNgayvaolam,@fLuongcoban,@fPhucap,@sCMND)
					PRINT N'Ðã thêm nhân viên vào máy 1'
				END
			ELSE
				BEGIN
					INSERT INTO MAY1.ThuchanhSQL_PhamXuanTu_17A01.DBO.tblNhanVien(iMaNV,sTenNV,sDiachi,sDienthoai,dNgaysinh,dNgayvaolam,fLuongcoban,
					fPhucap,sCMND)
					VALUES(@iMaNV,@sTenNV,@sDiachi,@sDienthoai,@dNgaysinh,@dNgayvaolam,@fLuongcoban,@fPhucap,@sCMND)
					PRINT N'Ðã thêm nhân viên vào máy 2'
				END
END

EXEC prThemNV2 '11','NEW','Ha Noi','3','1999/04/16','2019/01/01','1000','7','11'

SELECT * FROM tblNhanVien
--union
SELECT * FROM MAY1.ThuchanhSQL_PhamXuanTu_17A01.dbo.tblNhanVien
--------------------------------------Câu 6.2 a,b Vân

--c)Tao view cho xem danh sach ten nhan vien da lam o cua hang tren 2 nam
SELECT * FROM [dbo].[tblNhanVien]

--Xem tblNhanVien may 1
SELECT *
FROM LINKMAY1.[ThuchanhSQL_PhamXuanTu_17A01].[dbo].[tblNhanVien]

CREATE VIEW vwDSNV_LamHon2Nam
AS
	SELECT *
	FROM LINK.[ThuchanhSQL_PhamXuanTu_17A01].[dbo].[tblNhanVien]
	WHERE (YEAR(GETDATE()) - YEAR(dNgayvaolam)) >= 2

SELECT * FROM [dbo].[vwDSNV_LamHon2Nam]

--Xem tblNhanVien may 2
SELECT *
FROM LINKMAY2.[ThuchanhSQL_PhamXuanTu_17A01].[dbo].[tblNhanVien]

--Bai 6.3
CREATE PROC prThemDDH(@iSoHD int, @iMaNV int, @iMaKH int, @dNgaydathang datetime, @dNgaygiaohang datetime, @sDiachigiaohang nvarchar(50))
AS
BEGIN
	IF EXISTS (SELECT * FROM tblDondathang WHERE dbo.tblDondathang.iSoHD = @iSoHD)
		BEGIN
			PRINT N'Số hóa đơn đã tồn tại'
		END
	ELSE 
		IF EXISTS (SELECT * FROM LINK.ThuchanhSQL_PhamXuanTu_17A01.dbo.tblDondathang DDH WHERE DDH.iSoHD = @iSoHD)
			BEGIN
				PRINT N'Số hóa đơn đã tồn tại'
			END
		ELSE
			BEGIN
				INSERT INTO tblDondathang(iMaKH,sTenKH,sDiachi,sDienthoai,bGioitinh)
				VALUES(@iMaKH,@sTenKH,@sDiachi,@sDienthoai,@bGioitinh)
				PRINT N'Ðã thêm hóa đơn vào máy 1'
			END
		BEGIN
			INSERT INTO LINK.ThuchanhSQL_PhamXuanTu_17A01.DBO.tblDondathang(iMaKH,sTenKH,sDiachi,sDienthoai,bGioitinh)
			VALUES(@iMaKH,@sTenKH,@sDiachi,@sDienthoai,@bGioitinh)
			PRINT N'Ðã thêm hóa đơn vào máy 2'
		END
END

EXEC prThemKH2 '3','NEW4','Khac Ha Noi','0990','0'
