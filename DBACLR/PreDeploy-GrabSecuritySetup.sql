-- Make sure "CLR Integration" feature is enabled.
IF (EXISTS(
           SELECT   sc.*
           FROM     sys.configurations sc
           WHERE    sc.[name] = N'clr enabled'
           AND      sc.[value_in_use] = 0
          )
   )
BEGIN
    EXEC sp_configure 'clr enabled', 1;
    RECONFIGURE;
END;
GO

:r "C:\Users\andrew.lackenby\Documents\GitHub\DBACLR\AssemblySecuritySetup.sql"

GO
USE [$(DatabaseName)];
GO
