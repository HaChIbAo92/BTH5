--1. Viết SP spTangLuong dùng để tăng lương lên 10% cho tất cả các nhân viên.
CREATE PROC Tang_luong
AS
    UPDATE NHANVIEN SET LUONG = LUONG * 0.1
	select * from NHANVIEN
GO

EXEC Tang_luong

--2. Thêm vào cột NgayNghiHuu (ngày nghỉ hưu) trong bảng NHANVIEN. Viết SP spNghiHuu dùng để cập nhật ngày nghỉ hưu là ngày hiện tại cộng thêm 100 (ngày) cho những nhân viên nam có tuổi từ 60 trở lên và nữ từ 55 trở lên.
ALTER TABLE NHANVIEN ADD NgayNghiHuu DATE;
CREATE PROCEDURE Nghi_Huu
AS
BEGIN
    UPDATE NHANVIEN 
    SET NgayNghiHuu = DATEADD(day, 100, GETDATE())
    WHERE GioiTinh = 'Nam' AND DATEDIFF(year, NgaySinh, GETDATE()) >= 60 OR GioiTinh = 'Nữ' AND DATEDIFF(year, NgaySinh, GETDATE()) >= 55
END

--3. Tạo SP spXemDeAn cho phép xem các đề án có địa điểm đề án được truyền vào khi gọi thủ tục.
CREATE PROCEDURE spXemDeAn
    @DiaDiem VARCHAR(50)
AS
BEGIN
    SELECT * FROM DEAN WHERE DiaDiem = @DiaDiem
END

--4. Tạo SP spCapNhatDeAn cho phép cập nhật lại địa điểm đề án với 2 tham số truyền vào là diadiem_cu, diadiem_moi.
CREATE PROCEDURE spCapNhatDeAn
    @DiaDiemCu VARCHAR(50),
    @DiaDiemMoi VARCHAR(50)
AS
BEGIN
    UPDATE DEAN SET DiaDiem = @DiaDiemMoi WHERE DiaDiem = @DiaDiemCu
END

--5. Viết SP spThemDeAn để thêm dữ liệu vào bảng DEAN với các tham số vào là các trường của bảng DEAN.
Create proc spThemDeAn
    @MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50)
AS
BEGIN
    INSERT INTO DEAN(MADA, TENDEAN, DDIEM_DA)
    VALUES(@MaDeAn, @TenDeAn, @DiaDiem)
END



--6. Cập nhật SP spThemDeAn ở câu trên để thỏa mãn ràng buộc sau: kiểm tra mã đề án có trùng với các mã đề án khác không. Nếu có thì thông báo lỗi “Mã đề án đã tồn tại, đề nghị chọn mã đề án khác”. Sau đó, tiếp tục kiểm tra mã phòng ban. Nếu mã phòng ban không tồn tại trong bảng PHONGBAN thì thông báo lỗi: “Mã phòng không tồn tại”. Thực thi thủ tục với 1 trường hợp đúng và 2 trường hợp sai để kiểm chứng.
CREATE PROC spThemDeAn
	@MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50),
	@MaPhongBan nvarchar(20)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM DEAN WHERE MADA = @MaDeAn)
    BEGIN
        RAISERROR ('Mã đề án đã tồn tại, đề nghị chọn mã đề án khác',16,1)
        RETURN;
    END
    
    IF NOT EXISTS(SELECT 1 FROM PHONGBAN WHERE MAPHG = @MaPhongBan)
BEGIN
        RAISERROR ('Mã phòng không tồn tại',16,1)
        RETURN;
    END
    
    INSERT INTO DEAN(MADA, TenDeAn, DDIEM_DA)
    VALUES(@MaDeAn, @TenDeAn, @DiaDiem)
END

--7. Tạo SP spXoaDeAn cho phép xóa các đề án với tham số truyền vào là Mã đề án. Lưu ý trước khi xóa cần kiểm tra mã đề án có tồn tại trong bảng PHANCONG hay không, nếu có thì viết ra thông báo và không thực hiện việc xóa dữ liệu.
--8. Cập nhật SP spXoaDeAn cho phép xóa các đề án với tham số truyền vào là Mã đề án. Lưu ý trước khi xóa cần kiểm tra mã đề án có tồn tại trong bảng PHANCONG hay không, nếu có thì thực hiện xóa tất cả các dữ liệu trong bảng PHANCONG có liên quan đến mã đề án cần xóa, sau đó tiến hành xóa dữ liệu trong bảng DEAN.
--9. Tạo SP spTongGioLamViec có tham số truyền vào là MaNV, tham số ra là tổng thời gian (tính bằng giờ) làm việc ở tất cả các dự án của nhân viên đó.
--10. Viết SP spTongTien để in ra màn hình tổng tiền phải trả cho nhân viên với tham số truyền vào là mã nhân viên. (Tổng tiền phải trả cho nhân viên = lương + lương đề án; lương đề án = 100000 đ x thời gian). Kết quả của thủ tục là dòng chữ: “Tổng tiền phải trả cho nhân viên ‘333’ là 1200000 đồng.
--11. Viết SP spThemPhanCong để thêm dữ liệu vào bảng PHANCONG thỏa mãn yêu cầu sau: ThoiGian phải là một số dương, MaDA phải tồn tại ở bảng DEAN và MaNV phải tồn tại trong bảng NHANVIEN. Nếu không thỏa mãn phải thông báo lỗi tương ứng và không được phép thêm dữ liệu.
-- Câu 1. Viết SP spTangLuong dùng để tăng lương lên 10% cho tất cả các nhân viên.

CREATE PROC spTangLuong
	AS
	UPDATE NHANVIEN set LUONG = LUONG * 0.1
	go
	EXEC spTangLuong

-- Câu 2.Thêm vào cột NgayNghiHuu (ngày nghỉ hưu) trong bảng NHANVIEN. Viết SP spNghiHuu dùng để 
-- cập nhật ngày nghỉ hưu là ngày hiện tại cộng thêm 100 (ngày) cho những nhân viên nam có tuổi từ 60 trở lên và nữ từ 55 trở lên.
-- Tạo cột NgayNghiHuu
Alter table NHANVIEN
ADD NgayNghiHuu date 
go
CREATE PROC spNghiHuu
as
UPDATE NHANVIEN set NgayNghiHuu = (select GETDATE()+100)
go

-- Câu 3. Tạo SP spXemDeAn cho phép xem các đề án có địa điểm đề án được truyền vào khi gọi thủ tục.
Create proc spXemDeAn 
	@diadiem nvarchar(20)
as
select * from DEAN where DDIEM_DA = @diadiem
go

-- Câu 4.Tạo SP spCapNhatDeAn cho phép cập nhật lại địa điểm đề án với 2 tham số truyền vào là diadiem_cu, diadiem_moi.
Create proc spCapNhatDeAn 
	@diadiemcu nvarchar(50) ,
	@diadiemmoi nvarchar(50)
as
UPDATE DEAN
    SET DDIEM_DA = @DiaDiemMoi
    WHERE DDIEM_DA = @DiaDiemCu
go

--Câu 5. Viết SP spThemDeAn để thêm dữ liệu vào bảng DEAN với các tham số vào là các trường của bảng DEAN.

Create proc spThemDeAn
    @MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50)
AS
BEGIN
    INSERT INTO DEAN(MADA, TENDEAN, DDIEM_DA)
    VALUES(@MaDeAn, @TenDeAn, @DiaDiem)
END

--Câu 6. Cập nhật SP spThemDeAn ở câu trên để thỏa mãn ràng buộc sau: kiểm tra mã đề án có
--trùng với các mã đề án khác không. Nếu có thì thông báo lỗi “Mã đề án đã tồn tại, đề nghị chọn
--mã đề án khác”. Sau đó, tiếp tục kiểm tra mã phòng ban. Nếu mã phòng ban không tồn tại
--trong bảng PHONGBAN thì thông báo lỗi: “Mã phòng không tồn tại”. Thực thi thủ tục với 1
--trường hợp đúng và 2 trường hợp sai để kiểm chứng.
CREATE PROC spThemDeAn
	@MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50),
	@MaPhongBan nvarchar(20)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM DEAN WHERE MADA = @MaDeAn)
    BEGIN
        RAISERROR ('Mã đề án đã tồn tại, đề nghị chọn mã đề án khác',16,1)
        RETURN;
    END
    
    IF NOT EXISTS(SELECT 1 FROM PHONGBAN WHERE MAPHG = @MaPhongBan)
BEGIN
        RAISERROR ('Mã phòng không tồn tại',16,1)
        RETURN;
    END
    
    INSERT INTO DEAN(MADA, TenDeAn, DDIEM_DA)
    VALUES(@MaDeAn, @TenDeAn, @DiaDiem)
END


CREATE PROCEDURE spThemPhanCong
@MaNV INT,
@MaDA INT,
@ThoiGian INT
AS
BEGIN
IF @ThoiGian <= 0
BEGIN
PRINT 'Thời gian phải là một số dương.'
RETURN
END
IF NOT EXISTS (SELECT * FROM DEAN WHERE MaDeAn = @MaDA)
BEGIN
    PRINT 'Mã đề án không tồn tại trong bảng DEAN.'
    RETURN
END

IF NOT EXISTS (SELECT * FROM NHANVIEN WHERE MaNV = @MaNV)
BEGIN