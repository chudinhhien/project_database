select * from trangbi natural join thietbi;
select * from thietbi;

insert into trangbi(maphong,matb,sotb) values ('PT03','TB02',2);
update trangbi set sotb = sotb + 15 where maphong = 'PT03' and matb='TB02';
-- TRIGGER FUCTION INSERT 
        create or replace function insert_trang_bi()
        returns trigger 
        as $$
        declare 
            v_so_tb int = 0;
        begin
            select soTBKHo into v_so_tb from thietBi where maTB = new.maTB;
            if (new.soTB > v_so_tb) then
                raise notice 'Số lượng thiết bị không được vượt quá %', v_so_tb;
                return NULL;
            else
            	update thietBi
            	set soTBKHO = soTBKHO - new.soTB
            	where maTB = new.maTB;
				return new;
			end if;
        end;
        $$
		language plpgsql;
--TRIGGER INSERT 
        create trigger tg_insert_trang_bi
        before insert  or update on trangBi
		for each row
        execute procedure insert_trang_bi();
		
		
-- update trangBi FUNCTION
        create or replace function update_trang_bi() 
        returns trigger
        as $$
        declare 
                v_so_tb int = 0;
        begin
            select soTBKHo into v_so_tb from thietBi where maTB = new.maTB;
            if	(new.sotb - old.sotb) > v_so_tb then
				RAISE NOTICE 'Số lượng thiết bị không được vượt quá %',v_so_tb;
				return old;
			else
				update thietbi set sotbkho = sotbkho - new.sotb+old.sotb where maTB = new.maTB;
				return new;
            end if;
        end;
        $$
		language plpgsql;
--TRIGGER UPDATE
        create or replace trigger tg_update_trang_bi
        before update on trangbi    
        for each row
		when (new.maTB is distinct from old.maTB or new.soTB is distinct from old.soTB)
        execute procedure update_trang_bi();
--TRIGGER TÍNH TIỀN ĐIỆN
--FUNCTION TRIGGER 
CREATE OR REPLACE TRIGGER tg_tinh_tien_dien
BEFORE INSERT ON 

--FUNCTION TRIGGER CẬP NHẬT LẠI TRẠNG THÁI PHÒNG TRỌ
CREATE OR REPLACE FUNCTION update_tt_pt() RETURNS TRIGGER AS
$$
BEGIN
	IF NEW.ngaytra is null THEN
		UPDATE phongtro SET tinhtrang = false WHERE maphong = new.maphong;
	ELSE
		UPDATE phongtro SET tinhtrang = true WHERE maphong = new.maphong;
	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--TRIGGER CẬP NHẬT LẠI TRẠNG THÁI PHÒNG TRỌ
CREATE OR REPLACE TRIGGER tg_update_tt_pt
BEFORE INSERT OR UPDATE ON thuephong
FOR EACH ROW
EXECUTE PROCEDURE update_tt_pt();
INSERT INTO khachhang(makh,tenkh,namsinh,cmnd,diachi,nghenghiep,sdt) values ('KH03','Chu Đình Hiển','2003-03-18','036203006112','Nam Định','Sinh viên','0398877675');
UPDATE thuephong SET ngaytra = '2024-01-01' where maDK = 'DK03';
select * from khachhang;
INSERT INTO thuephong(maDK,maKH,maPhong,ngayThue,ngayTra) values ('DK03','KH03','P03','2023-07-10',NULL);
select * from trangbi;
select * from thietbi;
INSERT INTO trangbi(maphong,matb,sotb) values ('P01','TB01',3);
UPDATE trangbi SET sotb = sotb + 1 where maphong = 'P01' and matb = 'TB01';











create or replace  function update_trang_bi() 
        returns trigger
        as $$
        declare 
                v_so_tb int = 0;
        begin
            select soTBKHo into v_so_tb from thietBi where maTB = new.maTB;
            if (new.maTB = old.maTB) then 
                if (new.soTB > v_so_tb + old.soTB) then
                    raise notice 'Số lượng thiết bị không được vượt quá %', v_so_tb + old.soTB;
                    return NULL;
                else
                	update thietBi
                	set soTBKHO = soTBKHO + old.soTB - new.soTB
                	where maTB = new.maTB;
                	return NEW;
				end if;
            else 
                if (new.soTB > v_so_tb) then
                    raise notice 'So thiet bi khong duoc vuot qua %', v_so_tb;
                    return NULL;
                else
                -- sửa só luonwg mã TB cũ
                	update thietBi
                	set soTBKHO = soTBKHO + old.soTB
                	where maTB = old.maTB;
                -- cập nhât số luog ma TB cũ
                	update thietBi
                	set soTBKHO = soTBKHO - new.soTB
                	where maTB = new.maTB;
                	return new;
				end if;
            end if;
            
        end;
        $$
		language plpgsql;
		




CREATE OR REPLACE TRIGGER tg_update_sl
BEFORE UPDATE ON trangbi
FOR EACH ROW
EXECUTE PROCEDURE update_sl();


CREATE OR REPLACE FUNCTION update_sl() RETURNS TRIGGER AS
$$
DECLARE 
	v integer;
BEGIN
	select sotbkho into v from thietbi where matb = old.matb;
	IF (new.sotb - old.sotb) > v THEN
		RAISE NOTICE 'Số lượng thiết bị trong kho không đủ!';
		RETURN OLD;
	ELSE
		UPDATE thietbi SET sotbkho = sotbkho - (new.sotb-old.sotb) WHERE matb = new.matb;
		RETURN NEW;
	END IF;
END;
$$
LANGUAGE plpgsql;

---CHU DINH HIEN
---ITE6-01

		
		
		
		
		
		
		
		
