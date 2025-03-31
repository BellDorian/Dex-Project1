CREATE TRIGGER CleanPhoneNumberTrigger
ON Customers
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @rawPhone VARCHAR(255);  -- Column 'Phone' contains the raw phone number
    DECLARE @cleanedPhone VARCHAR(12);

    -- Handle INSERT scenario
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Get the raw phone number from the inserted row
        SELECT @rawPhone = Phone FROM inserted;

        -- Initialize the cleaned phone number variable
        SET @cleanedPhone = '';

        -- Step 1. Process first 3 digits (area code)
        DECLARE @i INT = 1;
        DECLARE @count_i INT = 0;

        WHILE @i <= 17 AND @count_i < 3
        BEGIN
            IF SUBSTRING(@rawPhone, @i, 1) LIKE '[0-9]'
            BEGIN
                SET @cleanedPhone = @cleanedPhone + SUBSTRING(@rawPhone, @i, 1);
                SET @count_i = @count_i + 1;
            END
            SET @i = @i + 1;
        END
        SET @cleanedPhone = @cleanedPhone + '-';

        -- Step 2. Process next 3 digits (middle part of the number)
        SET @count_i = 0;
        WHILE @i <= 17 AND @count_i < 3
        BEGIN
            IF SUBSTRING(@rawPhone, @i, 1) LIKE '[0-9]'
            BEGIN
                SET @cleanedPhone = @cleanedPhone + SUBSTRING(@rawPhone, @i, 1);
                SET @count_i = @count_i + 1;
            END
            SET @i = @i + 1;
        END
        SET @cleanedPhone = @cleanedPhone + '-';

        -- Step 3. Process final 4 digits (last part of the number)
        SET @count_i = 0;
        WHILE @i <= 17 AND @count_i < 4
        BEGIN
            IF SUBSTRING(@rawPhone, @i, 1) LIKE '[0-9]'
            BEGIN
                SET @cleanedPhone = @cleanedPhone + SUBSTRING(@rawPhone, @i, 1);
                SET @count_i = @count_i + 1;
            END
            SET @i = @i + 1;
        END

        -- If the phone number is valid (12 characters long), update the row with the cleaned phone number
        IF LEN(@cleanedPhone) = 12
        BEGIN
            -- Update the 'Phone' column with the cleaned phone number
            UPDATE Customers
            SET Phone = @cleanedPhone
            FROM Customers
            WHERE Phone = @rawPhone;  -- Ensure this condition uses the raw phone column
        END
        ELSE
        BEGIN
            -- If the phone number doesn't meet the criteria, you can either do nothing or set it to NULL
            UPDATE Customers
            SET Phone = NULL
            WHERE Phone = @rawPhone;  -- Ensure this condition uses the raw phone column
        END
    END

    -- Handle UPDATE scenario
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Get the raw phone number from the deleted row (old value before update)
        SELECT @rawPhone = Phone FROM deleted;

        -- Initialize the cleaned phone number variable
        SET @cleanedPhone = '';

        -- Step 1. Process first 3 digits (area code)
        DECLARE @j INT = 1;
        DECLARE @count_j INT = 0;

        WHILE @j <= 17 AND @count_j < 3
        BEGIN
            IF SUBSTRING(@rawPhone, @j, 1) LIKE '[0-9]'
            BEGIN
                SET @cleanedPhone = @cleanedPhone + SUBSTRING(@rawPhone, @j, 1);
                SET @count_j = @count_j + 1;
            END
            SET @j = @j + 1;
        END
        SET @cleanedPhone = @cleanedPhone + '-';

        -- Step 2. Process next 3 digits (middle part of the number)
        SET @count_j = 0;
        WHILE @j <= 17 AND @count_j < 3
        BEGIN
            IF SUBSTRING(@rawPhone, @j, 1) LIKE '[0-9]'
            BEGIN
                SET @cleanedPhone = @cleanedPhone + SUBSTRING(@rawPhone, @j, 1);
                SET @count_j = @count_j + 1;
            END
            SET @j = @j + 1;
        END
        SET @cleanedPhone = @cleanedPhone + '-';

        -- Step 3. Process final 4 digits (last part of the number)
        SET @count_j = 0;
        WHILE @j <= 17 AND @count_j < 4
        BEGIN
            IF SUBSTRING(@rawPhone, @j, 1) LIKE '[0-9]'
            BEGIN
                SET @cleanedPhone = @cleanedPhone + SUBSTRING(@rawPhone, @j, 1);
                SET @count_j = @count_j + 1;
            END
            SET @j = @j + 1;
        END

        -- If the phone number is valid (12 characters long), update the row with the cleaned phone number
        IF LEN(@cleanedPhone) = 12
        BEGIN
            -- Update the 'Phone' column with the cleaned phone number
            UPDATE Customers
            SET Phone = @cleanedPhone
            FROM Customers
            WHERE Phone = @rawPhone;  -- Ensure this condition uses the raw phone column
        END
        ELSE
        BEGIN
            -- If the phone number doesn't meet the criteria, you can either do nothing or set it to NULL
            UPDATE Customers
            SET Phone = NULL
            WHERE Phone = @rawPhone;  -- Ensure this condition uses the raw phone column
        END
    END
END;
