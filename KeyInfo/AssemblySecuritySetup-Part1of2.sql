/**********************************************
 * Script:  AssemblySecuritySetup.sql
 * Date:    2016-01-20
 * By:      Solomon Rutzky
 * Of:      Sql Quantum Leap ( http://SqlQuantumLeap.com )
 * 
 * Stairway to SQLCLR - Level 6: Development Tools
 *
 * Stairway to SQLCLR series:
 * http://www.sqlservercentral.com/stairway/105855/
 * 
 **********************************************/


USE [master];
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO
--------------------------------------------------------------------------------

DECLARE @ErrorMessage NVARCHAR(4000);


-- We first need to create the Assembly containing just
-- the Key info so that we can get the "thumbprint" /
-- "publickeytoken" value from it. That value is used to
-- determine if the Asymmetric Key and Login already exist.
--
-- We only need this Assembly temporarily, so create within
-- a transaction to guarantee cleanup if something fails.

DECLARE	@AssemblyName sysname, -- keep lower-case for servers with case-sensitive / binary collations
		@AsymmetricKeyName sysname, -- keep lower-case for servers with case-sensitive / binary collations
		@LoginName sysname, -- keep lower-case for servers with case-sensitive / binary collations
		@PublicKeyToken VARBINARY(32),
		@SQL NVARCHAR(MAX);

SET @AssemblyName = N'$StairwayToSQLCLR-TEMPORARY-KeyInfo$';

SET @AsymmetricKeyName = N'StairwayToSQLCLR-06_PermissionKey';
SET @LoginName = N'StairwayToSQLCLR-06_PermissionLogin';

BEGIN TRY
	BEGIN TRAN;

	IF (NOT EXISTS(
				SELECT	*
				FROM		[sys].[assemblies] sa
				WHERE	[sa].[name] = @AssemblyName
			)
		)
	BEGIN
		SET @SQL = N'
		CREATE ASSEMBLY [' + @AssemblyName + N']
			AUTHORIZATION [dbo]
-- Insert the result of the following command, found in _TempAssembly.sql, here:
-- FINDSTR /I /C:"FROM 0x" KeyInfo_Create.sql > _TempAssembly.sql
		