-- mo-pho-ban-dac-biet.sql: hien 4 pho ban dac biet (loai 6, pho ban su do) trong tab "Pho ban dac biet".
-- Client chi hien pho ban co Ordering >= 1; ban goc de 0 nen tab nay trong (ca tren server goc).
-- Server xu ly phong su do nhu pho ban thuong (khong bat buoc cap su do). Chi co do kho Thuong.
-- Di kem: Request/LoadPVEItems.xml (client) da doi Ordering tuong ung.
USE Db_Tank;
GO
UPDATE Pve_Info SET Ordering = CASE ID WHEN 8 THEN 1 WHEN 9 THEN 2 WHEN 10 THEN 3 WHEN 11 THEN 4 END WHERE ID IN (8,9,10,11);
SELECT ID, Name, Ordering FROM Pve_Info WHERE ID IN (8,9,10,11);
GO
