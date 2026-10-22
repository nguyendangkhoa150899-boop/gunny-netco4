-- 22/10/2026: QUA DUNG DO KHO. Chep lai cac bang lat bai do ta tao/chep (lat-bai-game-bang-rong.sql, lat-bai-game-tao-bang.sql)
-- theo quy tac chat (chu server: "quet lai toan bo pho ban coi dung item theo do kho"): nguon la BANG GOC cua game, DUNG do kho
-- (cung pho ban truoc, roi pho ban khac cap Pve_Info gan nhat); khong co thi do kho CAO HON gan nhat; khong lay do kho thap hon.
-- Vd Vong Xoay Thuong/Kho/AH truoc chep bang Vong Xoay De (10081, do tim+ 7,5%) -> nay lay Dai chien rong Thuong/Kho/AH (cung cap 18).
-- Bang goc cua game KHONG doi. Sinh boi scratch quet-dokho.php. Can restart Road. Chay lai an toan (xoa roi chep lai).
USE Db_Tank;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRAN;
-- 90001: Ai ga (Thuong, cap 14) <- bang 5 Gà Thường (Thuong, cap 14, tim+ 19%)
DELETE FROM dbo.Drop_Item WHERE DropId=90001;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90001,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=5;
-- 10100: Bộ lạc nguyên thủy (Thuong, cap 10) <- bang 10106 Kho Báu Người Cá Thường (Thuong, cap 10, tim+ 100%)
DELETE FROM dbo.Drop_Item WHERE DropId=10100;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10100,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10106;
-- 90002: BOSS Rồng (Thuong, cap 30) <- bang 10064 Đấu trường dũng sĩ thường (Thuong, cap 30, tim+ 69%)
DELETE FROM dbo.Drop_Item WHERE DropId=90002;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90002,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
-- 90003: BOSS Tinh Anh Hang (Thuong, cap 30) <- bang 10064 Đấu trường dũng sĩ thường (Thuong, cap 30, tim+ 69%)
DELETE FROM dbo.Drop_Item WHERE DropId=90003;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90003,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
-- 90004: Boss vợ chồng (Thuong, cap 30) <- bang 10064 Đấu trường dũng sĩ thường (Thuong, cap 30, tim+ 69%)
DELETE FROM dbo.Drop_Item WHERE DropId=90004;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90004,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
-- 90005: Christmas (Thuong, cap 30) <- bang 10064 Đấu trường dũng sĩ thường (Thuong, cap 30, tim+ 69%)
DELETE FROM dbo.Drop_Item WHERE DropId=90005;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90005,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
-- 90006: Đảo Hải Tặc (Thuong, cap 10) <- bang 10106 Kho Báu Người Cá Thường (Thuong, cap 10, tim+ 100%)
DELETE FROM dbo.Drop_Item WHERE DropId=90006;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90006,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10106;
-- 90007: Đảo Hiến Tế Anh Hùng (AH, cap 30) <- bang 10072 Đấu trường dũng sĩ anh hùng (AH, cap 30, tim+ 61%)
DELETE FROM dbo.Drop_Item WHERE DropId=90007;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90007,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10072;
-- 90008: Đoạt lại đạo cụ  +2 và đạo cụ 20% (Thuong, cap 1) <- bang 10085 Huyết ma kiến thường (Thuong, cap 8, tim+ 0%)
DELETE FROM dbo.Drop_Item WHERE DropId=90008;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90008,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
-- 90009: Đoạt lại đạo cụ  chiến đấu 30%,40%,50% (Thuong, cap 1) <- bang 10085 Huyết ma kiến thường (Thuong, cap 8, tim+ 0%)
DELETE FROM dbo.Drop_Item WHERE DropId=90009;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90009,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
-- 90010: Đoạt lại máy bay đạo cụ (Thuong, cap 1) <- bang 10085 Huyết ma kiến thường (Thuong, cap 8, tim+ 0%)
DELETE FROM dbo.Drop_Item WHERE DropId=90010;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90010,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
-- 90011: Đoạt lại súng 3 tia và đạo cụ POW (Thuong, cap 1) <- bang 10085 Huyết ma kiến thường (Thuong, cap 8, tim+ 0%)
DELETE FROM dbo.Drop_Item WHERE DropId=90011;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90011,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
-- 10094: Gà Ác mộng (Ac mong, cap 14) <- bang 11 Gà Anh Hùng (AH, cap 14, tim+ 77%)
DELETE FROM dbo.Drop_Item WHERE DropId=10094;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10094,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=11;
-- 90012: Giải cứu gà con ác mộng (Ac mong, cap 9) <- bang 11 Gà Anh Hùng (AH, cap 14, tim+ 77%)
DELETE FROM dbo.Drop_Item WHERE DropId=90012;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90012,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=11;
-- 90013: Hạ các gà xấu xí này để lấy lại đạo cụ 10% (Thuong, cap 1) <- bang 10085 Huyết ma kiến thường (Thuong, cap 8, tim+ 0%)
DELETE FROM dbo.Drop_Item WHERE DropId=90013;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90013,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
-- 90014: Hoang mạc Xatara (Thuong, cap 12) <- bang 5 Gà Thường (Thuong, cap 14, tim+ 19%)
DELETE FROM dbo.Drop_Item WHERE DropId=90014;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90014,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=5;
-- 90015: Huyệt Ma Kiến (Thuong, cap 8) <- bang 10085 Huyết ma kiến thường (Thuong, cap 8, tim+ 0%)
DELETE FROM dbo.Drop_Item WHERE DropId=90015;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90015,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
-- 90016: Huyết ma kiến Ác mộng (Ac mong, cap 8) <- bang 11 Gà Anh Hùng (AH, cap 14, tim+ 77%)
DELETE FROM dbo.Drop_Item WHERE DropId=90016;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90016,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=11;
-- 90017: Kẽ Hở Không Gian Dễ (De, cap 30) <- bang 10061 Đấu trường dũng sĩ dễ (De, cap 30, tim+ 71%)
DELETE FROM dbo.Drop_Item WHERE DropId=90017;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90017,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10061;
-- 90018: KHKG (Thuong, cap 30) <- bang 10064 Đấu trường dũng sĩ thường (Thuong, cap 30, tim+ 69%)
DELETE FROM dbo.Drop_Item WHERE DropId=90018;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90018,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
-- 90019: Lâu đài Dracula (Thuong, cap 15) <- bang 5 Gà Thường (Thuong, cap 14, tim+ 19%)
DELETE FROM dbo.Drop_Item WHERE DropId=90019;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90019,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=5;
-- 10075: Lâu Đài Phép Thuật Dễ (De, cap 10) <- bang 10076 Giải cứu gà con dễ (De, cap 9, tim+ 2%)
DELETE FROM dbo.Drop_Item WHERE DropId=10075;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10075,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10076;
-- 90020: Niên Thú (Thuong, cap 30) <- bang 10064 Đấu trường dũng sĩ thường (Thuong, cap 30, tim+ 69%)
DELETE FROM dbo.Drop_Item WHERE DropId=90020;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90020,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
-- 90021: Rừng ma pháp (Thuong, cap 30) <- bang 10064 Đấu trường dũng sĩ thường (Thuong, cap 30, tim+ 69%)
DELETE FROM dbo.Drop_Item WHERE DropId=90021;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90021,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
-- 90022: Rừng rậm Gamazon (Thuong, cap 8) <- bang 10087 Rừng rậm Gamazon (Thuong, cap 8, tim+ 0%)
DELETE FROM dbo.Drop_Item WHERE DropId=90022;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90022,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10087;
-- 10067: Tàu Hải Tặc (Thuong, cap 10) <- bang 10106 Kho Báu Người Cá Thường (Thuong, cap 10, tim+ 100%)
DELETE FROM dbo.Drop_Item WHERE DropId=10067;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10067,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10106;
-- 90023: Thành Phố Trên Không Anh Hùng (AH, cap 30) <- bang 10072 Đấu trường dũng sĩ anh hùng (AH, cap 30, tim+ 61%)
DELETE FROM dbo.Drop_Item WHERE DropId=90023;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90023,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10072;
-- 90024: Thành Phố Trên Không Dễ (De, cap 30) <- bang 10061 Đấu trường dũng sĩ dễ (De, cap 30, tim+ 71%)
DELETE FROM dbo.Drop_Item WHERE DropId=90024;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90024,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10061;
-- 90025: Thành Phố Trên Không Khó (Kho, cap 30) <- bang 10069 Đấu trường dũng sĩ khó (Kho, cap 30, tim+ 47%)
DELETE FROM dbo.Drop_Item WHERE DropId=90025;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90025,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10069;
-- 90026: Thành Phố Trên Không Thường (Thuong, cap 30) <- bang 10064 Đấu trường dũng sĩ thường (Thuong, cap 30, tim+ 69%)
DELETE FROM dbo.Drop_Item WHERE DropId=90026;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90026,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
-- 90027: Tổ Kiến Lửa (Thuong, cap 10) <- bang 10106 Kho Báu Người Cá Thường (Thuong, cap 10, tim+ 100%)
DELETE FROM dbo.Drop_Item WHERE DropId=90027;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90027,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10106;
-- 90028: Vịnh Cariga (Thuong, cap 18) <- bang 32 Đại chiến rồng thường (Thuong, cap 18, tim+ 38%)
DELETE FROM dbo.Drop_Item WHERE DropId=90028;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90028,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=32;
-- 10186: Vòng Xoáy Thời Gian AH (AH, cap 18) <- bang 43 Đại chiến rồng anh hùng (AH, cap 18, tim+ 77%)
DELETE FROM dbo.Drop_Item WHERE DropId=10186;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10186,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=43;
-- 10187: Vòng Xoáy Thời Gian AH (AH, cap 18) <- bang 43 Đại chiến rồng anh hùng (AH, cap 18, tim+ 77%)
DELETE FROM dbo.Drop_Item WHERE DropId=10187;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10187,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=43;
-- 10183: Vòng Xoáy Thời Gian Khó (Kho, cap 18) <- bang 35 Đại chiến rồng khó (Kho, cap 18, tim+ 71%)
DELETE FROM dbo.Drop_Item WHERE DropId=10183;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10183,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=35;
-- 10184: Vòng Xoáy Thời Gian Khó (Kho, cap 18) <- bang 35 Đại chiến rồng khó (Kho, cap 18, tim+ 71%)
DELETE FROM dbo.Drop_Item WHERE DropId=10184;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10184,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=35;
-- 10180: Vòng Xoáy Thời Gian Thường (Thuong, cap 18) <- bang 32 Đại chiến rồng thường (Thuong, cap 18, tim+ 38%)
DELETE FROM dbo.Drop_Item WHERE DropId=10180;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10180,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=32;
-- 10181: Vòng Xoáy Thời Gian Thường (Thuong, cap 18) <- bang 32 Đại chiến rồng thường (Thuong, cap 18, tim+ 38%)
DELETE FROM dbo.Drop_Item WHERE DropId=10181;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10181,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=32;
-- 90029: Xưởng Hơi Nước Khó (Kho, cap 30) <- bang 10069 Đấu trường dũng sĩ khó (Kho, cap 30, tim+ 47%)
DELETE FROM dbo.Drop_Item WHERE DropId=90029;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90029,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10069;
-- 90030: Xưởng Hơi Nước Thường (Thuong, cap 30) <- bang 10064 Đấu trường dũng sĩ thường (Thuong, cap 30, tim+ 69%)
DELETE FROM dbo.Drop_Item WHERE DropId=90030;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90030,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
-- 10182: ruong ai cuoi Vong Xoay Thuong (Para2 ,2,) <- cung nguon bang lat bai 32 (Dai chien rong Thuong)
DELETE FROM dbo.Drop_Item WHERE DropId=10182;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10182,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=32;
-- 10185: ruong ai cuoi Vong Xoay Kho (Para2 ,2,) <- cung nguon bang lat bai 35 (Dai chien rong Kho)
DELETE FROM dbo.Drop_Item WHERE DropId=10185;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10185,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=35;
-- 10188: ruong ai cuoi Vong Xoay Anh hung (Para2 ,2,) <- cung nguon bang lat bai 43 (Dai chien rong Anh hung)
DELETE FROM dbo.Drop_Item WHERE DropId=10188;
INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 10188,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=43;
COMMIT;
PRINT N'Da chep lai bang lat bai theo do kho.';
GO
