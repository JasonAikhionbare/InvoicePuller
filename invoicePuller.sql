--EXTRACTION OF BINARY INFORMATION
--Testing commits

  CREATE TABLE [dbo].[Invoice]
  (
[Inv_Num] [numeric](500, 0) IDENTITY(1,1) NOT NULL,
[Extension] [varchar](50) NULL,
[InvoiceName] [varchar](200) NULL,
[Inv_Content] [varbinary](max) NULL
  ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

  --TESTING BY SAVING TWO FILES IN OUR TABLE USING FOLLOWING QUERIES
  INSERT [dbo].[Invoice] ([Extension], [InvoiceName], [Inv_Content])
  SELECT 'pdf' , 'InvoiceTest.pdf', [Inv_Data].*
  FROM Openrowset
    (BULK 'C:\Documents\Jason_Aikhionbare_ProjectWork\InvoiceTest.pdf', SINGLE_BLOB) [Inv_Data]
  INSERT [dbo].[Invoice] ([Extension], [InvoiceName], [Inv_Content])
  SELECT 'pdf', 'InvoiceTest2.pdf', [Inv_Data].*
  FROM Openrowset
    (BULK 'C:\Documents\Jason_Aikhionbare_ProjectWork\InvoiceTest2.pdf', SINGLE_BLOB) [Inv_Data]

    --creating a folder, saving blob as a file on local disc and iterating through all invoice documents

    USE [POC]
    DECLARE @outPutPath VARCHAR(50) = 'C:\Documents\Jason_Aikhionbare_ProjectWork\SQL Server\Extract Blob',
    @i BIGINT,
    @init INT,
    @data VARBINARY(max),
    @fpath VARCHAR(max),
    @folderpath VARCHAR(max)

    --Getting data inot a temp table to be iterated over
    DECLARE @InvTable TABLE (id INT IDENTITY(1,1), [Inv_Num] VARCHAR(100), [InvoiceName] VARCHAR(100), [Inv_Content] VARBINARY(max))

    INSERT INTO @InvTable([Inv_Num], [InvoiceName], [Inv_Content])
    SELECT [Inv_Num], [InvoiceName], [Inv_Content] FROM [dbo].[invoice]

    SELECT @i = COUNT(1) FROM @InvTable

    WHILE @i >= 1
    BEGIN
    
        SELECT
        @data = [Inv_Content],
        @fpath = @outPutPath + '\'+ [Inv_Num] + '\' +[InvoiceName],
        @folderPath = @outPutPath + '\'+ [Inv_Num]
        FROM @InvTable WHERE id = @i

        EXEC  [dbo].[CreateFolder]  @folderPath
        EXEC SqlCLR 'ADODB.Stream', @init OUTPUT; 
        EXEC sp_OASetProperty @init, 'Type', 1;  
        EXEC sp_OAMethod @init, 'Open'; 
        EXEC sp_OAMethod @init, 'Write', NULL, @data; 
        EXEC sp_OAMethod @init, 'SaveToFile', NULL, @fPath, 2; 
        EXEC sp_OAMethod @init, 'Close'; 
        EXEC sp_OADestroy @init; 
        
        print 'Document Generated at - '+  @fPath  
        
        
        --Reset the variables for next use
  /*      SELECT @data = NULL  
        , @init = NULL
        , @fPath = NULL  Cannot add the server principal 'Enter here the Login Name that will execute the Import', because it does not exist or you do not have permission.

        , @folderPath = NULL
        SET @i -= 1
        END 
*/
  


/*---------------------------------------------------------------------------------------------------------------------------------------------*/




/*find d:\malware -name *.dat -type f > out.txt*/
/*THIS WILL CREATE THE OUT.TXT FILES WITH NAMES IN IT*/

/* Create the table that will store the image information*/
/*
CREATE TABLE InvoiceImage
(
  PictureName NVARCHAR(40) PRIMARY KEY NOT NULL,
  picFileName NVARCHAR(100),
  PictureData VARBINARY(max)
  )
  GO*/
  
 /* Setting and activitating OLE Automation procedures on the SQL Server for the image
 export action and envoking BulkAdmin privieldge*/
 /*
  Use master
  GO
  EXEC sp_configure 'show advanced options', 1;
  GO
  RECONFIGURE;
  GO
  EXEC sp_configure 'Automation Procedures', 1;
  GO
  RECONFIGURE;
  GO
  ALTER SERVER ROLE [bulkadmin] ADD MEMBER [Enter here the Login Name will wxwcite the Import]
  Go*/
  --Image import stored porocedure 
 /*

CREATE PROCEDURE dbo.usp_ImportImage 
(
    @PicName NVARCHAR(100),
    @ImageFolderPath NVARCHAR(1000),
    @FileName NVARCHAR(1000)
    )
    AS 
    BEGIN
    DECLARE @Path2OutFile NVARCHAR (2000);
    DECLARE @tsql NVARCHAR(2000);
    SET @Path2OutFile= CONCAT (
        @ImageFolderPath,
        '\ ',
        @FileName
    SET (@tsql) = 'insert into InvoiceImage(pictureName, picFileName, PictureData)' +
                ' SELECT ' + '''' + @PicName + '''' + ',' + '''' + ',*' + 
                   'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img'
    EXEC (@tsql) 
    SET NOCOUNT OFF
   END
   GO
       */ 
        --Image Export Stored Procedure
 /*       
CREATE PROCEDURE dbo.usp_ExportImage
(
    @PicName NVARCHAR (100),
    @ImageFolderPath NVARCHAR (1000),
    @FileName NVARCHAR(1000)
    )
AS 
     BEGIN
        DECLARE @ImageData VARBINARY (max);
        DECLARE @Path2OutFile NVARCHAR(2000);
        DECLARE @Obj INT
        
        SET NOCOUNT ON
        
        SELECT @ImageData = (
            SELECT convert (VARBINARY (max), PictureData, 1)
            FROM InvoiceImage
            WHERE PictureName = @PicName
            );
        BEGIN TRY
            EXEC SqlCLR ' ADODB.Stream' ,@Obj OUTPUT;
            EXEC sp_OASetProperty @bj ,'Type', 1;
            EXEC sp_OAMethod @Obj, 'Write' , NULL, @Path2OutFile, 2;
            EXEC sp_OAMethod @Obj,
        END TRY 
        BEGIN CATCH
            EXEC sp_OADestroy @Obj;
        END CATCH
        
        SET NOCOUNT OFF
        
END 
GO*/
/*BINARY FILE TABLE PREP*/
/*CREATE TABLE BinaryInfo
(
    filepath varchar (512),
    FILE_IDEX INT IDENTITY(1,1)

)

BULK INSERT BinaryPrep
FROM 'd:\out.txt'
WITH (
    FIELDTERMINATOR='',
    ROWTERMINATOR='\n',
    CODEPAGE=1251);
 */
 /*BINARY TABLE ITSELF*/
/*
CREATE TABLE InvoiceData
(
    data varbinary
)
*/
        /*To import the image into the SQl server*/
        
    /*EXEC dbo.usp_ImportImage 'File.prefix', 'C:\MyPictures\Input','File.jpg'*/ 
        
        /* To Export the file */
  /*  EXEC dbo.usp_ExportImage 'File.prefix','C:\MyPictures\Input', 'File.jpg' 

  /*------------------------------------------------------------------------------------------*