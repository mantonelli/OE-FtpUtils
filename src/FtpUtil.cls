/**
 * Classe para envio e recebimento de arquivos em servidores FTP
 *
 * Autor: Matheus Antonelli (matheus.antonelli@gmail.com)
 * Data: 09/2020
 *
 */

using System.*.
using WinSCP.*.

CLASS FtpUtil:

    DEFINE VARIABLE cHost AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cUser AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cPass AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cType AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cKey  AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE sessionOptions AS CLASS WinSCP.SessionOptions NO-UNDO.

    CONSTRUCTOR FtpUtil(
        INPUT pHost AS CHARACTER,
        INPUT pUser AS CHARACTER,
        INPUT pPass AS CHARACTER,
        INPUT pType AS CHARACTER):
        
        ASSIGN cHost = pHost
               cUser = pUser
               cPass = pPass
               cType = pType.
               
        sessionOptions = new SessionOptions().
        sessionOptions:Protocol = IF pType = "SFTP" THEN WinSCP.Protocol:Sftp ELSE WinSCP.Protocol:FTP.
        sessionOptions:HostName = cHost.
        sessionOptions:UserName = cUser.
        sessionOptions:Password = cPass.
    
    END CONSTRUCTOR.
    
    METHOD PUBLIC LOGICAL Upload(INPUT localPath AS CHARACTER,
                                 INPUT remotePath AS CHARACTER):
        
        DEFINE VARIABLE sessionCls AS CLASS WinSCP.Session NO-UNDO.
        DEFINE VARIABLE transferOptions AS CLASS WinSCP.TransferOptions NO-UNDO.
        DEFINE VARIABLE transferResult AS CLASS TransferOperationResult NO-UNDO.
        
        DO:
            sessionCls = NEW WinSCP.Session().

            IF cType = "SFTP" THEN DO:
              sessionOptions:SshHostKeyFingerprint = sessionCls:ScanFingerPrint(sessionOptions, "SHA-256").
            END.
            
            sessionCls:Open(sessionOptions).
            
            // Upload files
            transferOptions = new TransferOptions().
            transferOptions:TransferMode = TransferMode:BINARY.
 
            transferResult = sessionCls:PutFiles(localPath, remotePath, false, transferOptions).
 
            // Throw on any error
            transferResult:Check().
            
            sessionCls:Close().
            
            RETURN TRUE.
        END.
        
        CATCH e AS System.Exception:
            RETURN FALSE.
        END.
        
    END METHOD.
    
    METHOD PUBLIC LOGICAL Download(INPUT remotePath AS CHARACTER,
                                   INPUT localPath AS CHARACTER):
        
        DEFINE VARIABLE sessionCls AS CLASS WinSCP.Session NO-UNDO.
        DEFINE VARIABLE transferOptions AS CLASS WinSCP.TransferOptions NO-UNDO.
        DEFINE VARIABLE transferResult AS CLASS TransferOperationResult NO-UNDO.
        
        DO:
            sessionCls = NEW WinSCP.Session().

            IF cType = "SFTP" THEN DO:
              sessionOptions:SshHostKeyFingerprint = sessionCls:ScanFingerPrint(sessionOptions, "SHA-256").
            END.
            
            sessionCls:Open(sessionOptions).
            
            // Upload files
            transferOptions = new TransferOptions().
            transferOptions:TransferMode = TransferMode:BINARY.
 
            transferResult = sessionCls:GetFiles(remotePath, localPath, false, transferOptions).
 
            // Throw on any error
            transferResult:Check().
            
            sessionCls:Close().
            
            RETURN TRUE.
        END.
        
        CATCH e AS System.Exception:
          MESSAGE e:GetMessage(1)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN FALSE.
        END.
        
    END METHOD.

END CLASS.
