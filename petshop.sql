--
--=========================QUẢN LÝ SHOP BÁN SẢN PHẨM & DỊCH VỤ DÀNH CHO THÚ CƯNG=========================
--------------------------
use master
go
Create database QLShopSpDvThuCung
go
use QLShopSpDvThuCung
go
-------------------------

----Table----
Create table TaiKhoan(
	TaiKhoanId int identity(1,1) primary key not null,
	Email varchar(50) unique not null, --Đăng nhập bằng email.
	MatKhau nvarchar(255) not null, --Mật khẩu đã được mã hóa.
	Quyen tinyint not null, --Gồm có: 1.Quản lí, 2.Nhân viên, 3.Khách Hàng.
	-- Khi tạo tài khoản sẽ phải chọn 'Nhân viên', hoặc 'Khách hàng'.
	-- Tài khoản 'Quản lý' gồm 1 tài khoản có sẵn.
	-- Muốn đổi quản lý thì vào trang quản lý chọn "Nhượng quyền 'Quản Lý' sang 'Nhân viên' mới"
	MaThongBao varchar(60), -- đổi mật khẩu (token)
	NgayTao date default getdate(), --<<Mặc định: ngày hôm nay>>
	TrangThai bit, --Gồm có: 0.Hoạt động 1.Ngừng hoạt động --ktra xem tài khoản die chưa.
	--Thông tin--
	HoTen nvarchar(100) not null,
	SoDienThoai nvarchar(10) unique,
	GioiTinh bit, 
	NgaySinh date,
	Hinh nvarchar(255),
	NgayHetHan datetime default null,
	Provider varchar(15) DEFAULT NULL
); 
go
--Tạo index tìm kiếm số điện thoại--
Create index idxSoDienThoai ON TaiKhoan(SoDienThoai); 
--VD--
--SELECT * FROM TaiKhoan WHERE SoDienThoai like '0423424536' --Tìm kiếm số điện thoại 0423424536

go
Create table KhuyenMai(
	KhuyenMaiId int identity(1,1) primary key not null,
	TenKhuyenMai nvarchar(100) not null, -- Gồm có: 1.Tên khuyến mãi, 2.Không có.
	PhanTram int, -- Phần trăm số khuyến mãi
	NgayBatDau date,
	NgayKetThuc date,
	Hinh nvarchar(255)
	-- Khuyến mãi = (Đơn giá * số lượng) * số phần trăm
	-- Thành tiền = Số tiền sản phẩm - khuyến mãi
	-- VD Chưa khuyến mãi: Thành tiền: (50.000 * 3) = 150.000 (VNĐ)
	-- VD Đã khuyến mãi 10%: Thành tiền: (50.000 * 3) * 10% = 15.000 (VNĐ)
	-- Thành Tiền: 150.000 - 15.000 = 135.000 (VND)
); 
go
create table ApDungKhuyenMai(
	ApDungKhuyenMaiId int identity(1,1) not null primary key,
	TaiKhoanId int not null,
	KhuyenMaiId int not null,        
	foreign key (TaiKhoanId) references TaiKhoan(TaiKhoanId),
	foreign key (KhuyenMaiId) references KhuyenMai(KhuyenMaiId)
);
go
create table SanPham(
	SanPhamId int identity(1,1) not null primary key,
	TenSanPham nvarchar(100) not null,
	GiaBan float not null,
	GiaNhap float not null,
	KhoiLuong float, 
	DonVi tinyint, --Gồm có: 1.gam, 2.kg, 3.ml, 4.cm...
	LoaiSanPham tinyint not null, --Gồm có: 1.thức ăn, 2.phụ kiện, 3.vật dụng, 4.thuốc...
	LoaiThuCung tinyint, --Gồm có: 1.tất cả, 2.Meo meo, 3.Cún
	SoLuongKho int, 
	MoTa nvarchar(1000) not null,
	Hinh nvarchar(255),
	HinhHover nvarchar(255),
	XuatXu nvarchar(255),
	BaoBi nvarchar(255),
	ThanhPhan nvarchar(1000)
);
go
create table ThuCung(
	ThuCungId int identity(1,1) not null primary key,
	TaiKhoanId int not null,
	TenThuCung nvarchar(100) not null, 
	LoaiThuCung tinyint, --Gồm có: 1.Gâu gâu, 2.Meo meo
	GioiTinh bit not null,
	ThangTuoi int, 
	CanNang float,
	GhiChu nvarchar(255), --<<vd: tiêm chủng,....>>
	foreign key (taiKhoanId) references TaiKhoan(taiKhoanId),
);
go
create table DichVu(
	DichVuId int identity(1,1) not null primary key,
	TenDichVu nvarchar(255) not null,
	GiaDichVu float not null,
	MoTa nvarchar(255),
	Hinh nvarchar(255)
);
go
create table DatDichVu(
	DatDichVuId int identity(1,1) not null primary key,
	TaiKhoanId int not null,
	ThuCungId int not null,
	DichVuId int not null,
	NgayDat date default getdate(),
	NgayThucHien date,
	TrangThai bit default 0, -- 0. chưa nhận, 1. đã nhận
	foreign key (TaiKhoanId) references TaiKhoan(TaiKhoanId),
	foreign key (ThuCungId) references ThuCung(ThuCungId),
	foreign key (DichVuId) references DichVu(DichVuId)
);
go
create table DanhGia(
	DanhGiaId int identity(1,1) not null primary key,
	SanPhamId int not null,
	TaiKhoanId int not null,
	Diem int not null,
	NoiDung nvarchar(255),
	NgayDanhGia date default getdate(),
	hinh nvarchar(255),
	foreign key (SanPhamId) references SanPham(SanPhamId),
	foreign key (TaiKhoanId) references TaiKhoan(TaiKhoanId)
);
go
create table HoaDon(
	HoaDonId int identity(1,1) not null primary key,
	TaiKhoanId int not null,
	KhuyenMaiId int,
	PhuongThucThanhToan tinyint not null, --Gồm có: 1.Tiền mặt, 2.VN Pay.,....
	TrangThai bit default 0, --Chưa thanh toán và thanh toán (mặc định là 0 = chưa thanh toán)
	ChoXacNhan tinyint default 1, --Gồm có: 1.Chờ xác nhận, 2.Đã xác nhận, 3.Đang giao, 4.Đã đến, 5.Đã nhận, 6.Đã hủy (5 là thao tác của khách hàng, 6 là thao tác của shop hoặc khách hàng)
	NgayTao date default getdate(), --<<Mặc định: ngày hôm nay>>
	TongTien float not null,
	DiaChi nvarchar(255),
	foreign key (TaiKhoanId) references TaiKhoan(TaiKhoanId),
	foreign key (KhuyenMaiId) references KhuyenMai(KhuyenMaiId)
);
go
create table ChiTietHoaDon(
	Id int identity(1,1) not null primary key,
	SanPhamId int not null,
	HoaDonId int not null,
	SoLuong int not null,
	DonGia float not null, --Đơn giá
	foreign key (SanPhamId) references SanPham(SanPhamId),
	foreign key (HoaDonId) references HoaDon(HoaDonId)
);
go



---------THÊM DỮ LIỆU------------
--Quản lý--(1)
go
insert into TaiKhoan values('anvqpc@gmail.com','123',1,'','2024-10-28',0,N'Võ Quốc An','0328059731',0,'2003-11-25','','','');
--Nhân viên--(5)
insert into TaiKhoan values('khangndpc07672@fpt.edu.vn','1234',2,'','2024-01-02',0,N'Nguyễn Duy Khang','0961609748',0,'2004-01-02','','','');
insert into TaiKhoan values('khoatdpc07634@fpt.edu.vn','1234',2,'','2024-12-06',0,N'Trần Đăng Khoa','0767995570',0,'2004-12-06','','','');
insert into TaiKhoan values('haodnpc07644@fpt.edu.vn','1234',2,'','2024-01-01',0,N'Đặng Nhựt Hào','0983836824',0,'2004-01-01','','','');
insert into TaiKhoan values('phultpc07732@fpt.edu.vn','1234',2,'','2024-10-28',0,N'Lâm Thành Phú','0962267402',0,'2004-10-28','','','');
insert into TaiKhoan values('huyenntmpc07545@fpt.edu.vn','1234',2,'','2024-12-13',0,N'Nguyễn Thị Mỹ Huyền','0704952624',1,'2004-12-13','','','');
go
--Khách Hàng--(14)
go
insert into TaiKhoan values('huongnt@gmail.com','12345',3,'','2024-10-30',0,N'Nguyễn Thị Hương','0723124531',1,'2004-01-01','','','');
insert into TaiKhoan values('trangntm@gmail.com','12345',3,'','2024-10-23',1,N'Nguyễn Thị Mỹ Trang','0137352475',1,'2004-01-01','','','');
insert into TaiKhoan values('thanhpt@gmail.com','12345',3,'','2024-10-21',0,N'Phạm Thiên Thanh','0972451942',1,'2004-01-01','','','');
insert into TaiKhoan values('trungvv@gmail.com','12345',3,'','2024-10-10',0,N'Võ Văn Trung','0972648135',0,'2004-01-01','','','');
insert into TaiKhoan values('baocvt@gmail.com','12345',3,'','2024-12-07',0,N'Chu Văn Tiểu Bảo','0763482954',0,'2004-01-01','','','');
insert into TaiKhoan values('nhatpm@gmail.com','12345',3,'','2024-12-22',0,N'Phạm Minh Nhật','0732543686',0,'2004-01-01','','','');
insert into TaiKhoan values('mynh@gmail.com','12345',3,'','2024-09-11',0,N'Nguyễn Hồng My','0786246591',1,'2004-01-01','','','');
insert into TaiKhoan values('kietlt@gmail.com','12345',3,'','2024-03-05',1,N'Lê Tuấn Kiệt','0773558324',0,'2004-01-01','','','');
insert into TaiKhoan values('ngochm@gmail.com','12345',3,'','2024-03-03',1,N'Hồ Mỹ Ngọc','0973957255',1,'2004-01-01','','','');
insert into TaiKhoan values('sangdq@gmail.com','12345',3,'','2024-11-11',0,N'Đinh Quốc Sang','0111223344',0,'2004-01-01','','','');
insert into TaiKhoan values('mycn@gmail.com','12345',3,'','2024-07-11',0,N'Chu Ngọc Mỹ','0222334455',1,'2004-01-01','','','');
insert into TaiKhoan values('bangncb@gmail.com','12345',3,'','2024-12-20',0,N'Nguyễn Châu Băng Băng','0333445566',1,'2004-01-01','','','');
insert into TaiKhoan values('baonvq@gmail.com','12345',3,'','2024-12-01',0,N'Nguyễn Văn Quốc Bảo','0455667788',0,'2004-01-01','','','');
insert into TaiKhoan values('ngocnt@gmail.com','12345',3,'','2024-10-07',0,N'Nguyễn Thị Ngọc','0444556677',1,'2004-01-01','','','');
go
--Khuyến Mãi--(8)
insert into KhuyenMai values(N'Tháng 10 cùng pet',5,'2024-10-01','2024-10-10','');
insert into KhuyenMai values(N'Quốc tế giáo viên giảm giá cực hot',25,'2024-11-20','2024-11-30','');
insert into KhuyenMai values(N'Ngày lễ tri ân',5,'2024-11-20','2024-11-30','');
insert into KhuyenMai values(N'Giáng sinh cùng pet yêu',10,'2024-12-24','2024-12-30','');
insert into KhuyenMai values(N'Áo ấm cho pet',10,'2024-12-24','2024-12-30','');
insert into KhuyenMai values(N'Tết đến rồi pet thay áo mới',30,'2024-01-01','2024-01-10','');
insert into KhuyenMai values(N'Nhăm nhăm tuổi mới cùng thức ăn ngon',10,'2024-01-01','2024-01-10','');
insert into KhuyenMai values(N'Tết nguyên đáng mừng tuổi bé yêu',5,'2024-01-29','2024-02-10','');
go
--Sản Phẩm--(12)
INSERT INTO SanPham (TenSanPham, GiaBan, GiaNhap, KhoiLuong, DonVi, LoaiSanPham, LoaiThuCung, SoLuongKho, MoTa, Hinh, HinhHover, XuatXu, BaoBi, ThanhPhan) 
VALUES 
(N'Túi thức ăn Royal', 230000, 200000, 500, 1, 1, 2, 10, N'Không', 'royal.jpg', 'royal1.jpg', N'Việt Nam', N'Nhựa', N'Protein: các dòng sản phẩm Royal Canin đều có thành phần protein có chất lượng cao nhằm đảm bảo mèo có thể hấp thụ tối đa các chất dinh dưỡng.'),
(N'Túi thức ăn Pedigree', 180000, 170000, 500, 1, 1, 3, 30, N'Không', 'product-1.jpg', 'product-1_0.jpg', N'Thái Lan', N'Nhựa', N'Hương vị thơm ngon khiến cún cưng không ngừng quẫy đuôi phấn khích Thức ăn vặt Pedigree chứa nhiều chất dinh dưỡng, đạm lại ít béo, tốt cho sức khỏe cún Thanh thức ăn được xử lý độ dai mềm hoàn hảo, bảo vệ hàm răng của cún khỏi tổn thương. '),
(N'Chuồng vệ sinh cho mèo', 120000, 110000, 0, 0, 2, 2, 10, N'Không', 'CVS.jpg', 'CVS_1.jpg', N'Việt Nam', N'Nhựa cao cấp', N'Giúp giữ vệ sinh môi trường, tránh tình trạng cát bị bới tung toé khi mèo đi vệ sinh. Tập cho mèo có một thói quen văn minh. Có 2 cửa: cửa trên và cửa trước thuận tiện cho bé Bên trong có sợi than hoạt tính giúp khử mùi triệt để Thiết kế xinh xắn, kiểu dáng hiện đại, màu sắc điệu đà Có tặng kèm xẻng vệ sinh'),
(N'Thuốc trị nấm', 30000, 25000, 30, 3, 4, 1, 10, N'Không', 'tTriNam1.jpg', 'tTriNam.jpg', N'Việt Nam', N'Nhựa', N'Không'),
(N'Thức ăn hạt cho chó Zoi Dog', 30000, 28000, 1, 2, 1, 3, 10, N'Không', 'product-6.jpg', 'product-6_0.jpg', N'Việt Nam', N'Nhựa', N'Không'),
(N'Pate lon cho chó lớn smart heart', 31000, 25000, 400, 1, 1, 3, 10, N'Không', 'paTeLonCho.jpg', 'paTeLonCho1.jpg', N'Việt Nam', N'Nhựa', N'Không'),
(N'Thức ăn cho chó Pedigree túi lớn', 210000, 200000, 400, 1, 3, 8, 10, N'Không', 'Pedigree.jpg', 'Pedigree_1.jpg', N'Việt Nam', N'Nhựa', N'Cung cấp đầy đủ dinh dưỡng: Thức ăn hạt Pedigree được chế biến từ các nguyên liệu chất lượng cao và đảm bảo đầy đủ dinh dưỡng cho chó. Tăng cường sức khỏe tim mạch: Thức ăn hạt Pedigree chứa các thành phần bảo vệ tim mạch và giúp giảm nguy cơ các bệnh liên quan đến tim mạch.'),
(N'Vòng cổ cho Mèo', 44000, 40000, 400, 1, 1, 2, 20, N'Không', 'VongCo.jpg', 'VongCo_1.jpg', N'Việt Nam', N'Vải và nhựa tổng hợp', N'hiều màu sắc và họa tiết bắt mắt Kích cỡ đa dạng.'),
(N'Chuồng vệ sinh cho mèo', 60000, 55000, 0, 0, 2, 2, 17, N'Không', 'CanCau.jpg', 'CanCau_1.jpg', N'Việt Nam', N'Nhựa cao cấp', N'Làm từ chất liệu an toàn giúp thú cưng hăng say chơi Tạo sự vận động khỏe mạnh và nhanh nhẹn Kiểu dáng và màu sắc đẹp.'),
(N'Cát vệ sinh Nhật cho mèo hương táo túi 3,8kg', 80000, 78000, 0, 0, 2, 2, 14, N'Không', 'CatVS.jpg', 'CatVS_1.jpg', N'Việt Nam', N'', N'Thấm hút nhanh và vón cục nhanh chóng Không gây bụi trong không khí Chống nấm mốc.'),
(N'Pate PateWhishas gói 80gr', 31000,29000, 80, 1, 1, 2, 10, N'Không', 'PateWhishas.jpg', 'PateWhishas_1.jpg', N'Việt Nam', N'Nhựa', N'Pate dạng ướt chuyên dành cho các bé Mèo trên 12 tháng tuổi. Cung cấp đầy đủ dưỡng chất giúp bé mèo phát triển tốt nhất.'),
(N'Gel dinh dưỡng chó mèo Nutri Plus', 100000, 90000, 200, 1, 1, 1, 10, N'Không', 'GelDinhDuong.jpg', 'GelDinhDuong_-1.jpg', N'Việt Nam', N'Nhựa tổng hợp', N'Nutri Plus Gel Virbac  kem dinh dưỡng cho chó mèo là chất giàu dinh dưỡng dạng kem ăn ngon miệng bổ sung năng lượng cho chó mèo và cung cấp tất cả những sinh tố và khoáng chất cần thiết cho sự phát triển, vận động, hồi phục sức khỏe, đẹp lông da cho chó con đang phát triển, chó mẹ đang mang thai, chó đực giống, phục hồi sức khỏe cho chó bệnh, biếng ăn….'),
(N'Xương gặm sạch răng thơm miệng cho chó Orgo 90g', 20000, 15000, 1, 2, 1, 3, 22, N'Không', 'XuongGam.jpg', 'XuongGam_1.jpg', N'Việt Nam', N'Nhựa', N'Với thiết kế độc đáo giống chiếc bàn chải đánh răng phù hợp với thói quen nhai của những chú chó đáng yêu của bạn có thể xoa bóp và tăng hiệu quả sạch răng dễ dàng. Loại bỏ 99% những mảng cao răng cứng đầu.'),
(N'Tháp banh 4 tầng cho mèo', 65000, 60000, 0, 0, 2, 2, 6, N'Không', 'ThapBanh.jpg', 'ThapBanh_1.jpg', N'Việt Nam', N'Nhựa cao cấp', N'Đồ Chơi Tháp Banh 4 Tầng Cho Mèo - Kích thước: Đường kính 16-25cm, Cao 16cm - Được làm từ chất liệu nhựa cao cấp, an toàn và đặc biệt không bị bay màu theo thời gian. Thiết kế độc đáo hình tháp vững chắc sẽ tránh được việc tháp bị đổ khi có những thành phần Boss “quá khích” tham gia.'),
(N'Đồ chơi bóng 7 màu chó mèo', 200000, 180000, 0, 0, 2, 2, 18, N'Không', 'Bong7Mau.jpg', 'Bong7Mau_1.jpg', N'Việt Nam', N'Nhựa cao cấp', N'Bóng 7 màu sắc cho chó mèo làm bằng cao su cực kỳ mềm mại, không gây độc hại, rất thích hợp để sử dụng trong những trường hợp chủ vắng nhà và khiến chúng không cắn phá đồ đạc'),
(N'Đồ chơi quả tạ cho chó', 180000, 150000, 1, 2, 1, 3, 14, N'Không', 'QuaTa.jpg', 'QuaTa_1.jpg', N'Việt Nam', N'cao su lành tính', N' Đồ Chơi Cao Su Bóng Quả Tạ Lục Lạc Cho Chó Mèo được làm từ cao su dẻo không độc hại, an toàn cho thú cưng khi cắn và vui chơi. Được thiết kế với kiểu dáng và màu sắc tươi tắn, bền đẹp.'),
(N'Đồ chơi Dây thừng cottton thắt cút cho chó', 280000, 250000, 1, 2, 1, 3, 12, N'Không', 'DayThung.jpg', 'DayThung_1.jpg', N'Việt Nam', N'Cotton', N'rong số những món đồ cần thiết đó không thể thiếu các sản phẩm đồ chơi cho thú cưng đa dạng mẫu mã như  phổ biến trong số đó là đồ chơi gặm bằng dây thừng cotton thắt cút chống mài mòn cho chó. '),
(N'Thú cao su âm thanh cho chó', 174000, 170000, 1, 2, 1, 3, 3, N'Không', 'ThuCaoSu.jpg', 'ThuCaoSu_1.jpg', N'Việt Nam', N'Cotton', N'rong số những món đồ cần thiết đó không thể thiếu các sản phẩm đồ chơi cho thú cưng đa dạng mẫu mã '),
(N'Xúc xích cho chó mèo', 169000, 154000, 1, 2, 1, 3, 1, N'Không', 'XucXich.jpg', 'XucXich_1.jpg', N'Việt Nam', N'Cotton', N' Xúc xích cung cấp một số chất dinh dưỡng quan trọng có lợi cho cơ thể của chó mèo như vitamin, khoáng chất, chất đạm, chất béo tốt,.. Mua xúc xích cho chó mèo không chất bảo quản, không chất phụ gia'),
--20--
(N'Thức Ăn Cho Chó  APRO IQ Formula', 45000, 40000, 1, 2, 1, 3, 1, N'Không', 'AProIQ.jpg', 'AProIQ_1.jpg', N'Việt Nam', N'Cotton', N'Nguyên liệu: ngô, gạo hoặc sắn, lúa mì, thịt các loại, cá, bột đậu tương, ngô, đậu tương, mỡ gà hoặc dầu thực vật, gan, bia ủ men khô, muối iốt, vitamin và khoáng chất, chất chống oxy hóa và màu thực phẩm.'),
(N'Bát nước tự động', 45000, 43000, 1, 2, 1, 1, 1, N'Không', 'BatNuocTuDong.jpg', 'BatNuocTuDong_1.jpg', N'Việt Nam', N'Cotton', N'Bát uống nước tự động cho chó mèo Bergan Auto-Wata đáp ứng nhu cầu tưới nước bên ngoài vật nuôi của bạn và giữ bát đầy. Kết nối nó với một vòi vườn tiêu chuẩn và để cho nó đi. Phao bên trong ngăn nước chảy khi tô đầy và tự động lấp đầy khi thấp, không bao giờ lãng phí nước. Làm bằng nhựa bền, giữ nó trên sàn nhà hoặc gắn vào tường.'),
(N'Thức ăn cho chó Bull pháp - DR. Glint - Túi 2kg', 189000, 180000, 1, 2, 1, 3, 1, N'Không', 'TABullPhap.jpg', 'TABullPhap_1.jpg', N'Việt Nam', N'Cotton', N'Công thức muối thấp (hàm lượng muối ko quá 0.45%) không gây kích ứng da,  Công nghệ sinh học phân tử nhỏ - Pyrolysis Technology được sử dụng trong sản xuất cùng thành phần cân bằng giúp giảm mùi hôi miệng, giảm mùi hôi cơ thể'),
(N'Thức ăn hạt cho mèo mọi lứa tuổi MININO YUM', 169000, 163000, 1, 2, 1, 2, 3, N'Không', 'Minino_1.jpg', 'Minino.jpg', N'Việt Nam', N'Cotton', N' Thức ăn cho mèo Yum Minino là sản phẩm thuộc tập đoàn Neovia. Neovia là một trong những tập đoàn hàng đầu của Pháp có hơn 60 năm kinh nghiệm trong sản xuất thức ăn cho thú cưng, gia súc và thủy sản. Yum Minino được sản xuất với công nghệ tiêu chuẩn quốc tế. Thức ăn hạt Yum Minino là bao bì mới của Blisk cũ. Tuy nhiên công thức được giữ nguyên để đảm bảo chất dinh dưỡng, màu của hạt thức ăn là màu nguyên chất của nguyên liệu, không nhuộm phẩm màu, đảm bảo an toàn. '),
(N'Thức ăn hạt cho chó trưởng thành Zoi Dog gói 1kg', 31000, 29000, 1, 2, 1, 3, 22, N'Không', 'ZoiDog.jpg', 'ZoiDog_1.jpg', N'Việt Nam', N'Cotton', N'Ngô, cám lúa mì, bột gia cầm, sắn, bột hạt cọ, mỡ gia cầm, khoáng chất (canxi carbonate, monocalcium phosphate, natri clorua, kali clorua, sắt II sulfate, đồng sulfate, ôxít mangan, cobalt sulfate, ôxít kẽm, kali iodua, selen), vitamin (vitamin a, d, e, k, thiamine (b1), riboflavin (b2), niacin (b3), axít panthothenic (b5), pyridoxine (b6), cobalamin (b12), biotin, axít folic, colin), chất chống oxy hóa, màu thực phẩm.'),
(N'Thức ăn cho mèo MRVET toàn diện ', 135000, 130000, 1, 2, 1, 2, 7, N'Không', 'MeoVet.jpg', 'MeoVet_1.jpg', N'Việt Nam', N'Cotton', N'Hạt cho mèo MR.VET T1 là sản phẩm phù hợp cho mọi lứa tuổi mèo, từ mèo con, mèo trưởng thành đến mèo mang thai. Đây là dòng hạt Premium Holistic có giá thành hợp lý trên thị trường, được làm từ nguyên liệu tự nhiên cao cấp, ít hoặc không có chất phụ gia và chất bảo quản nhân tạo, đảm bảo an toàn cho mèo. - Sản phẩm còn được tăng cường với các loại thảo mộc như hạt cỏ linh lăng, hạt vỏ mã đề, hạt lanh và chất chống oxy hóa, giúp tăng cường sức khỏe toàn diện cho mèo. '),
(N'【Pet Snacks】Súp Thưởng Cho Mèo Dinh Dưỡng ', 5000, 3000, 1, 2, 1, 2, 220, N'Không', 'PetSnack.jpg', 'PetSnack_1.jpg', N'Việt Nam', N'Cotton', N' Dải Mèo Được Làm Bằng Nguyên Liệu Tươi, Vật Nuôi Kết Cấu Mousse Dễ Hấp Thu, Taurine Đặc Biệt Bổ Dưỡng Và Tốt Cho Sức Khỏe, Giàu Hương Vị, Có Thêm Bí Đỏ, Thêm Cỏ Mèo Và Các Chất dinh Dưỡng Cao, Bạn Có Thể Tự tin cho ăn.Nên Cho Mèo Ăn Trên 3 Tháng Tuổi, Chỉ Một Dải Mèo Mỗi Ngày.'),
(N'Thanh cỏ mèo mix thịt gà GZM ', 39000, 30000, 1, 2, 1, 2, 22, N'Không', 'CoMeo.jpg', 'CoMeo_1.jpg', N'Việt Nam', N'Cotton', N'Thanh cỏ mix ức gà GZM được chiết xuất từ cỏ mèo, ức gà tươi, giúp tiêu búi lông và hạn chế tối đa các bệnh đường ruột cho mèo, bổ sung protein cho chế độ ăn của mèo.'),
(N'CAT’S ON 5KG THỨC ĂN CHO MÈO', 45000, 35000, 1, 2, 1, 2, 8, N'Không', 'CatOn.jpg', 'CatOn_1.jpg', N'Việt Nam', N'Cotton', N'Chỉ tiêu chất lượng: Độ ẩm (max) ≤ 10,0 %; protein (min) ≥ 33,0 %; béo thô (min) ≥ 15,0 %; xơ thô (max) ≤ 4,0 %; khoáng tổng số (max) ≤ 10,0 %; canxi (min) > 1,0 %; phốt pho(min) > 0,5 % Công dụng: - Tốt cho lông da, tăng cường thị lực. - Tăng cường miễn dịch và khả năng tiêu hóa. - Mùi vị thơm ngon kích thích sự thèm ăn.'),
(N'Hạt Me-O ', 45000, 34000, 1, 2, 1, 2, 6, N'Không', 'MeoO.jpg', 'MeoO_1.jpg', N'Việt Nam', N'Cotton', N'Hạt cho mèo Me-o dạng hạt, có hương vị thơm ngon giúp kích thích vị giác tạo nên sự thích thú với bữa ăn của thú cưng nhà bạn. Có 3 hương vị cho mèo cưng: Cá biển, Cá ngừ, Cá thu. Hạt Me-o thơm ngon, đảm bảo mèo nào cũng thích luôn nha. Mèo nhà mình 3 đời ăn hạt Me-o luôn.'),
--30--
(N'Cỏ Mèo Gắn Tường Quả Mật', 15000, 13000, 1, 2, 1, 2, 18, N'Không', 'CoMeoQuaMat_1.jpg', 'CoMeoQuaMat.jpg', N'Việt Nam', N'Cotton', N'Cỏ mèo dạng viên tròn xoay 360 độ .có thể dính lên tường hoặc bàn ghế rất chắc chắn ạ . Cỏ bạc hà giúp các mèo cưng THƯ GIÃN, GIẢI TỎA căng thẳng, nhanh chóng hồi phục sức khỏe. - Ngoài ra cỏ bạc hà còn giúp mèo NÔN RA những BÚI LÔNG trong ruột.'),
(N'Gói 500G khô gà viên sấy lạnh ', 15000, 10000, 1, 2, 1, 1, 9, N'Không', 'KhoGa.jpg', 'KhoGa_1.jpg', N'Việt Nam', N'Cotton', N'Ức gà cung cấp rất nhiều protein giúp tăng cường sự phát triển ở thú cưng. Ức gà chứa rất nhiều Vitamin và khoáng chất giúp tăng cường hệ miễn dịch. Giữ nguyên hương vị, không chất bảo quản và chất phụ gia khác. Quy trình thực hiện: Ức gà tươi được đưa vào máy ở nhiệt độ -36 độ C. Sau đó, khử nước và khử trùng bằng công nghệ hút chân không. '),
(N'Sữa tắm cho chó mèo DORRIKEY', 15000, 14000, 1, 2, 1, 1, 22, N'Không', 'SuaTam.jpg', 'SuaTam_1.jpg', N'Việt Nam', N'Cotton', N'Bốn chức năng đảm Bảo Giàu AFFG cytokine có thể kích hoạt sâu tế bào tóc đánh thức lớp biểu bì phát triển dây thần kinh và sửa chữa tóc Bị hư hỏng giàu yếu tố làm đẹp sinh Học Tăng cường điều hòa dinh dưỡng của tóc, làm cho tóc cảm thấy mịn màng, mềm mại và tươi sáng công nghệ khai Thác Sinh Học nắm Bắt Sâu sắc và phát hành các yếu tố giữ ẩm sinh học để đạt được độ ẩm Có chứa peptide.'),
(N'Sữa tắm cho chó mèo SOS', 15000,9000, 1, 2, 1, 1, 24, N'Không', 'SOS.jpg', 'SOS_1.jpg', N'Việt Nam', N'Cotton', N'Sữa tắm SOS màu đen: Sữa tắm chuyên dùng điều trị viêm da cho Chó, Mèo. Có tác dụng trong việc điều trị viêm da, nấm, các loại kí sinh truyền nhiễm ngoài da như ve, bọ chét gây ra các bệnh về da ở Chó, Mèo, Sữa tắm SOS màu xanh nõn chuối: Sữa tắm làm mềm mượt lông cho Chó, Mèo. Có tác dụng giữ ẩm, giữ nước làm mềm mượt và giàu dưỡng chất'),
(N'NEEKA dành cho mèo ', 15000, 8000, 1, 2, 1, 2, 18, N'Không', 'NEKA.jpg', 'NEKA_1.jpg', N'Việt Nam', N'Cotton', N'LƯU Ý: Phân loại ngẫu nhiên shop sẽ mix dựa trên những vị có sẵn, nếu còn đủ 8 vị shop sẽ mix đều cho khách ạ. Phân Loại Chọn Vi khách vui lòng sau khi lên đơn nhắn vị cần chọn(còn sẵn hàng) giúp shop nha. Sau khi lên đơn 8 tiếng chưa chọn vị shop buộc gửi theo phân loại mix ngẫu nhiên vì chính sách của sàn ạ, mong khách thông cảm giúp shop ạ!'),
(N'SỮA TẮM HELLO BOSS ', 15000, 10000, 1, 2, 1, 3, 18, N'Không', 'HELLOBOSS.jpg', 'HELLOBOSS_1.jpg', N'Việt Nam', N'Cotton', N'Sữa tắm chuyên dụng cho chó Hello Boss - làm sạch, khử mùi, bông lông, mượt lông, làm dày lông')

go
--Dịch vụ--(5)
insert into DichVu values(N'Dịch vụ tắm massage cho thú cưng',580000,N'Không','dichvuvesinh.png');
insert into DichVu values(N'Dịch vụ cắt tỉa, tạo kiểu lông cho thú cưng',580000,N'Không','dichVuCatTia.png');
insert into DichVu values(N'Dịch vụ vệ sinh toàn diện cho cún cưng',750000,N'Không','dichvuChamSocThucung.png');
insert into DichVu values(N'Dịch vụ nhuộm lông, tạo kiểu cho thú cưng',1800000,N'Không','dichvuCTNhuom.png');
insert into DichVu values(N'Dịch vụ khách sạn thú cưng',180000,N'Không','dichvuChamSocThucung.png');
go
--Đánh giá--(1)
insert into DanhGia values(1,7,5,N'Sản phẩm xịn quá','2024-10-08',''); --5 = 5 sao
go
--Hóa đơn--(2)
insert into HoaDon values(7,Null,1,0,1,'2024-10-08',230000, N'Cần Thơ');
insert into HoaDon values(8,1,1,1,1,'2024-10-02',437000, N'TP HCM');
go
--Chi tiết hóa đơn--(2)
insert into ChiTietHoaDon values(1,1,1,230000);
insert into ChiTietHoaDon values(1,2,2,460000);



INSERT INTO ThuCung (TaiKhoanId, TenThuCung, LoaiThuCung, GioiTinh, ThangTuoi, CanNang, GhiChu)
VALUES 
(7, 'Max', 1, 1, 12, 5.5, N'Tiêm chủng đầy đủ'),
(8, 'Luna', 2, 0, 6, 4.2, N'Đã triệt sản'),
(9, 'Rocky', 1, 1, 24, 15.0, N'Cần giảm cân'),
(10, 'Bella', 2, 0, 36, 3.5, N'Sức khỏe tốt'),
(11, 'Milo', 1, 1, 18, 8.3, N'Vui vẻ, năng động'),
(12, 'Charlie', 1, 1, 30, 12.0, N'Cần tiêm chủng'),
(13, 'Nala', 2, 0, 24, 5.0, N'Khỏe mạnh'),
(14, 'Buddy', 1, 1, 15, 9.0, N'Tăng cân ổn định'),
(15, 'Whiskers', 2, 0, 18, 4.5, N'Đã triệt sản'),
(16, 'Daisy', 1, 0, 8, 4.0, N'Năng động, vui vẻ'),
(17, 'Simba', 1, 1, 48, 18.0, N'Cần giảm cân');
INSERT INTO DatDichVu (TaiKhoanId, ThuCungId, DichVuId, NgayDat, NgayThucHien, TrangThai)
VALUES 
(7, 1, 1, '2024-11-15', '2024-11-18', 0),
(8, 2, 2, '2024-11-16', '2024-11-19', 0),
(9, 3, 1, '2024-11-17', '2024-11-20', 0),
(10, 4, 3, '2024-11-18', '2024-11-21', 0),
(11, 5, 2, '2024-11-19', '2024-11-22', 0),
(12, 6, 1, '2024-11-20', '2024-11-23', 1),
(13, 7, 3, '2024-11-21', '2024-11-24', 0),
(14, 8, 2, '2024-11-22', '2024-11-25', 1),
(15, 9, 1, '2024-11-23', '2024-11-26', 0),
(16, 10, 3, '2024-11-24', '2024-11-27', 0),
(17, 11, 2, '2024-11-25', '2024-11-28', 1);
go
--Xem thông tin
select * from TaiKhoan 
select * from KhuyenMai 
select * from SanPham 
select * from DichVu 
select * from DanhGia 
select * from HoaDon 
select * from ChiTietHoaDon 
select * from DatDichVu
select * from ThuCung
