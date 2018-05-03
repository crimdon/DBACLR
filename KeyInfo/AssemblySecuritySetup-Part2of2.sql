';
		EXEC (@SQL);
	END;


	SET @PublicKeyToken = CONVERT(VARBINARY(32), ASSEMBLYPROPERTY(@AssemblyName, 'PublicKey'));

	IF (NOT EXISTS(
				SELECT	*
				FROM		[sys].[asymmetric_keys] sak
				WHERE	sak.[thumbprint] = @PublicKeyToken
			)
		)
	BEGIN
		SET @SQL = N'
		CREATE ASYMMETRIC KEY [' + @AsymmetricKeyName + N']
			AUTHORIZATION [dbo]
			FROM ASSEMBLY [' + @AssemblyName + N'];';
		EXEC (@SQL);
	END;

	SET @SQL = N'DROP ASSEMBLY [' + @AssemblyName + N'];';
	EXEC (@SQL);

	COMMIT TRAN;
END TRY
BEGIN CATCH
	IF (@@TRANCOUNT > 0)
	BEGIN
		ROLLBACK TRAN;
	END;

	SET @ErrorMessage = ERROR_MESSAGE();
	RAISERROR(@ErrorMessage, 16, 1);
	RETURN; -- exit the script
END CATCH;


-- If the Asymmetric Key exists but the Login does not exist, we need to:
-- 1) Create the Login
-- 2) Grant the appropriate permission
IF (EXISTS(
			SELECT	*
			FROM		[sys].[asymmetric_keys] sak
			WHERE	sak.[thumbprint] = @PublicKeyToken
		)
	) AND
	(NOT EXISTS(
			SELECT		*
			FROM			[sys].[server_principals] sp
			INNER JOIN	[sys].[asymmetric_keys] sak
					ON	sak.[sid] = sp.[sid]
			WHERE	sak.[thumbprint] = @PublicKeyToken
		)
	)
BEGIN
	BEGIN TRY
		BEGIN TRAN;

		SET @SQL = N'
		CREATE LOGIN [' + @LoginName + N']
			FROM ASYMMETRIC KEY [' + @AsymmetricKeyName + N'];';
		EXEC (@SQL);

		SET @SQL = N'
		GRANT EXTERNAL ACCESS ASSEMBLY TO [' + @LoginName + N'];
		-- OR, comment out the GRANT statement above, and uncomment the following:
		-- GRANT UNSAFE ASSEMBLY TO [' + @LoginName + N'];
		';
		EXEC (@SQL);

		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRAN;
		END;

		SET @ErrorMessage = ERROR_MESSAGE();
		RAISERROR(@ErrorMessage, 16, 1);
		RETURN; -- exit the script
	END CATCH;
END;
--------------------------------------------------------------------------------


