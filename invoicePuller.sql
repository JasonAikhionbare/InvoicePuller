/*Version 2*/

/* Create the table that will store the image and binary information*/

CREATE TABLE InvoiceImage
(
  PictureName NVARCHAR(40) PRIMARY KEY NOT NULL,
  picFileName NVARCHAR(100),
  PictureData VARBINARY(max)
  )
  GO
  
 /* Setting and activitating OLE Automation procedures on the SQL Server for the image
 export action and envoking BulkAdmin privieldge*/
 
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
  Go
  /* Image import stored porocedure */
 

/*CREATE PROCEDURE dbo.usp_ImportImage 
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
    SET @tsql = 'insert into InvoiceImage(pictureName, picFileName, PictureData)' +
                ' SELECT ' + '''' + @PicName + '''' + ',' + '''' + ',*' + 
                   'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img'
    EXEC (@tsql) 
    SET NOCOUNT OFF
   END
   GO*/
        
        /*Image Export Stored Procedure*/
        
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
GO
        
        /*To import the image into the SQl server*/
        
    /*EXEC dbo.usp_ImportImage 'File.prefix', 'C:\MyPictures\Input','File.jpg'*/ 
        
        /* To Export the file */
    EXEC dbo.usp_ExportImage 'File.prefix','C:\MyPictures\Input', 'File.jpg' 
        