using Microsoft.SqlServer.Server;
using System;
using System.IO;


public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void uxp_DeleteFile (string filePath, out int returnCode)
    {
        try
        {
            File.Delete(filePath);
            returnCode =  0;
        }

        catch (Exception ex)
        {
            SqlContext.Pipe.Send(ex.ToString());
            returnCode =  1;
        }
    }
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void uxp_DeleteFolder(string filePath, out int returnCode)
    {
        try
        {
            Directory.Delete(filePath, true);
            returnCode = 0;
        }

        catch (Exception ex)
        {
            SqlContext.Pipe.Send(ex.ToString());
            returnCode = 1;
        }
    }
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void uxp_MoveFile(string sourceFile, string destinationFile, out int returnCode)
    {
        try
        {
            File.Move(sourceFile, destinationFile);
            returnCode = 0;
        }

        catch (Exception ex)
        {
            SqlContext.Pipe.Send(ex.ToString());
            returnCode = 1;
        }
    }
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void uxp_MoveFolder(string sourceFolder, string destinationFolder, out int returnCode)
    {
        try
        {
            Directory.Move(sourceFolder, destinationFolder);
            returnCode = 0;
        }

        catch (Exception ex)
        {
            SqlContext.Pipe.Send(ex.ToString());
            returnCode = 1;
        }
    }
}

