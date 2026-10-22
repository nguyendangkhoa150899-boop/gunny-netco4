-- 22/10/2026: tao bang lat bai trong game cho moi ai chua co (30 bang, 93 ai), de lat bai KHONG ra la trang va web lat the
-- dung DUNG bang cua game cho moi pho ban (MiniGameController::dropIdCua). Sinh boi scratch lap-bang.php (luu y trong README muc 20).
-- Nguon (chu server chon "bang pho ban gan cap"): (a) bang ai cuoi cua chinh nhom, (b) cung pho ban do kho gan nhat,
-- (c) pho ban khac cung do kho, cap (Pve_Info.LevelLimits) gan nhat, (d) bat ky cap gan nhat. Pho ban moi khong co trong Pve_Info
-- (Thanh Pho Tren Khong, Xuong Hoi Nuoc, Dao Hien Te, Ke Ho Khong Gian, Rung ma phap, boss su kien) tinh cap 30; ai huong dan cap 1.
-- DropID moi 90001-90030 (cu lon nhat 80111). Moi bang = 1 dong Drop_Condiction (Para1 liet ke cac ai thieu, Para2 ,1,) + chep Drop_Item.
-- Drop_Item / Drop_Condiction nap luc Road khoi dong: PHAI RESTART ROAD. Chay lai an toan (bo qua DropID da co).
-- Hoan tac: DELETE FROM Db_Tank.dbo.Drop_Item WHERE DropId BETWEEN 90001 AND 90030; DELETE FROM Db_Tank.dbo.Drop_Condiction WHERE DropID BETWEEN 90001 AND 90030;
USE Db_Tank;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRAN;
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90001) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90001)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90001,5,N',4003,',N',1,',N'Ai ga (lat bai, chep tu bang 10043)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90001,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10043;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90002) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90002)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90002,5,N',1243,',N',1,',N'BOSS Rồng (lat bai, chep tu bang 10064)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90002,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90003) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90003)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90003,5,N',5020101,5020102,5020103,5020104,5020105,5020201,5020202,5020203,5020204,5020205,5020301,5020302,5020303,5020304,5020305,5020401,5020402,5020403,5020404,5020405,5020501,5020502,5020503,5020504,5020505,5020601,5020602,5020603,5020604,5020605,',N',1,',N'BOSS Tinh Anh Hang (lat bai, chep tu bang 10064)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90003,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90004) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90004)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90004,5,N',15002,',N',1,',N'Boss vợ chồng (lat bai, chep tu bang 10064)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90004,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90005) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90005)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90005,5,N',3101101,3101102,3101103,',N',1,',N'Christmas (lat bai, chep tu bang 10064)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90005,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90006) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90006)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90006,5,N',70001,',N',1,',N'Đảo Hải Tặc (lat bai, chep tu bang 10100)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90006,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10100;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90007) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90007)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90007,5,N',20301,20302,20303,20305,',N',1,',N'Đảo Hiến Tế Anh Hùng (lat bai, chep tu bang 10072)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90007,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10072;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90008) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90008)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90008,5,N',1088,',N',1,',N'Đoạt lại đạo cụ  +2 và đạo cụ 20% (lat bai, chep tu bang 10085)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90008,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90009) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90009)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90009,5,N',1089,',N',1,',N'Đoạt lại đạo cụ  chiến đấu 30%,40%,50% (lat bai, chep tu bang 10085)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90009,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90010) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90010)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90010,5,N',1087,',N',1,',N'Đoạt lại máy bay đạo cụ (lat bai, chep tu bang 10085)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90010,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90011) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90011)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90011,5,N',1086,',N',1,',N'Đoạt lại súng 3 tia và đạo cụ POW (lat bai, chep tu bang 10085)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90011,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90012) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90012)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90012,5,N',91002,91003,91004,91005,',N',1,',N'Giải cứu gà con ác mộng (lat bai, chep tu bang 47)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90012,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=47;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90013) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90013)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90013,5,N',1085,',N',1,',N'Hạ các gà xấu xí này để lấy lại đạo cụ 10% (lat bai, chep tu bang 10085)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90013,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90014) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90014)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90014,5,N',900,901,',N',1,',N'Hoang mạc Xatara (lat bai, chep tu bang 10043)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90014,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10043;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90015) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90015)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90015,5,N',3001,4001,',N',1,',N'Huyệt Ma Kiến (lat bai, chep tu bang 10085)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90015,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90016) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90016)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90016,5,N',91000,91001,',N',1,',N'Huyết ma kiến Ác mộng (lat bai, chep tu bang 10085)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90016,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10085;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90017) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90017)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90017,5,N',16101,16102,',N',1,',N'Kẽ Hở Không Gian Dễ (lat bai, chep tu bang 10061)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90017,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10061;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90018) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90018)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90018,5,N',490000,490001,',N',1,',N'KHKG (lat bai, chep tu bang 10064)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90018,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90019) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90019)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90019,5,N',700,701,',N',1,',N'Lâu đài Dracula (lat bai, chep tu bang 10043)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90019,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10043;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90020) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90020)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90020,5,N',1347,',N',1,',N'Niên Thú (lat bai, chep tu bang 10064)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90020,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90021) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90021)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90021,5,N',71135,',N',1,',N'Rừng ma pháp (lat bai, chep tu bang 10064)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90021,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90022) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90022)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90022,5,N',800,',N',1,',N'Rừng rậm Gamazon (lat bai, chep tu bang 10087)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90022,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10087;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90023) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90023)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90023,5,N',340001,340002,340003,',N',1,',N'Thành Phố Trên Không Anh Hùng (lat bai, chep tu bang 10072)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90023,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10072;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90024) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90024)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90024,5,N',310001,310002,310003,310004,',N',1,',N'Thành Phố Trên Không Dễ (lat bai, chep tu bang 10061)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90024,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10061;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90025) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90025)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90025,5,N',330001,330002,330003,330004,',N',1,',N'Thành Phố Trên Không Khó (lat bai, chep tu bang 10069)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90025,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10069;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90026) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90026)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90026,5,N',320001,320002,320003,320004,',N',1,',N'Thành Phố Trên Không Thường (lat bai, chep tu bang 10064)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90026,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90027) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90027)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90027,5,N',420001,420002,420003,',N',1,',N'Tổ Kiến Lửa (lat bai, chep tu bang 10100)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90027,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10100;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90028) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90028)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90028,5,N',600,601,',N',1,',N'Vịnh Cariga (lat bai, chep tu bang 32)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90028,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=32;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90029) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90029)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90029,5,N',520004,520005,520006,520007,',N',1,',N'Xưởng Hơi Nước Khó (lat bai, chep tu bang 10069)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90029,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10069;
END
IF NOT EXISTS (SELECT 1 FROM dbo.Drop_Condiction WHERE DropID=90030) AND NOT EXISTS (SELECT 1 FROM dbo.Drop_Item WHERE DropId=90030)
BEGIN
  INSERT INTO dbo.Drop_Condiction(DropID,CondictionType,Para1,Para2,Detail) VALUES(90030,5,N',510004,510005,510006,510007,',N',1,',N'Xưởng Hơi Nước Thường (lat bai, chep tu bang 10064)');
  INSERT INTO dbo.Drop_Item(DropId,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs) SELECT 90030,ItemId,ValueDate,IsBind,Random,BeginData,EndData,IsTips,IsLogs FROM dbo.Drop_Item WHERE DropId=10064;
END
COMMIT;
DECLARE @b int = (SELECT COUNT(*) FROM dbo.Drop_Condiction WHERE DropID BETWEEN 90001 AND 90030);
DECLARE @i int = (SELECT COUNT(*) FROM dbo.Drop_Item WHERE DropId BETWEEN 90001 AND 90030);
PRINT N'Bang lat bai moi: ' + CAST(@b AS nvarchar(10)) + N' bang, ' + CAST(@i AS nvarchar(10)) + N' dong do';
GO
