ALTER FUNCTION ValidarDniNie (@DniNie VARCHAR(9))
RETURNS BIT
AS
BEGIN
    DECLARE @Resultado BIT = 0;
    DECLARE @Numero VARCHAR(8);
    DECLARE @Letra CHAR(1);
    DECLARE @LetrasControl VARCHAR(23) = 'TRWAGMYFPDXBNJZSQVHLCKE';
    DECLARE @NumInicial char(1);
	DECLARE @nuevoNie varchar(9);

    SET @DniNie = UPPER(LTRIM(RTRIM(@DniNie)));

    IF LEN(@DniNie) = 9 AND ISNUMERIC(SUBSTRING(@DniNie, 1, 8)) = 1 
		BEGIN
			SET @Numero = SUBSTRING(@DniNie, 1, 8);
			SET @Letra = SUBSTRING(@DniNie, 9, 1);
        
			-- Cálculo letra
			IF SUBSTRING(@LetrasControl, (CAST(@Numero AS BIGINT) % 23) + 1, 1) = @Letra
				SET @Resultado = 1;
		END
    
	ELSE
		BEGIN
			-- Lógica para NIE (X, Y, Z) 
			IF LEN(@DniNie) = 9 
				BEGIN
					SET @Numero = SUBSTRING(@DniNie, 1, 8);
					SET @Letra = SUBSTRING(@DniNie, 9, 1);
					SET @NumInicial = 
					CASE  
						WHEN SUBSTRING(@DniNie, 1, 1)='X'  THEN '0'
						WHEN SUBSTRING(@DniNie, 1, 1)='Y'  THEN '1'
						WHEN SUBSTRING(@DniNie, 1, 1)='Z'  THEN '2'
						Else '9'
					END
					SET @nuevoNie = CONCAT(@NumInicial,SUBSTRING(@DniNie,2,LEN(@DniNie)-1))
					IF ISNUMERIC(SUBSTRING(@nuevoNie, 1, 8)) = 1
						BEGIN
							IF SUBSTRING(@LetrasControl, (CAST(SUBSTRING(@nuevoNie, 1, 8) AS BIGINT) % 23) + 1, 1) = @Letra
							SET @Resultado = 1;
						END
					ELSE
						SET @Resultado = 2;
				END
				ELSE SET @Resultado = 2;
		END
		RETURN @Resultado;
END
GO