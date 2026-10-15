SET NOCOUNT ON;
USE Db_Member;
UPDATE Server_List SET
  Host='localhost',
  Password='<SA_PASSWORD>',
  LinkCenter='http://127.0.0.1:2108/CenterService/?wsdl',
  LinkRequest='http://127.0.0.1/',
  LinkConfig='http://171.244.39.225:89/config.xml',
  LinkFlash='http://171.244.39.225:89/';
USE Db_Tank;
UPDATE AreaConfig SET
  DataSource='localhost',
  Password='<SA_PASSWORD>',
  RequestUrl='http://127.0.0.1/',
  ResourceLink='http://171.244.39.225:89';
PRINT '=== Db_Member.Server_List ===';
USE Db_Member;
SELECT Host,LinkCenter,LinkRequest,LinkConfig,LinkFlash FROM Server_List;
PRINT '=== Db_Tank.AreaConfig ===';
USE Db_Tank;
SELECT DataSource,RequestUrl,ResourceLink FROM AreaConfig;
GO
