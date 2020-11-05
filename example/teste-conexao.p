USING FtpUtil.*.

DEFINE VARIABLE FtpObject AS CLASS FtpUtil NO-UNDO.

DO ON ERROR UNDO, LEAVE:
    FtpObject = NEW FtpUtil(
      "<host address>", // host
      "<ftp username>", // user
      "<ftp password>", // passwd
      "<protocol>" // FTP or SFTP
    ).

    /** Upload
     * Par�metro 1 : Arquivo que ser� enviado (aceita caracter coringa)
     * Par�metro 2 : Pasta, no servidor remoto, onde o arquivo ser� salvo
     */
    IF FtpObject:Upload("C:\temp\foo.txt", "/foo/") THEN DO:
        MESSAGE "Upload conclu�do com sucesso"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    
    OS-DELETE VALUE("C:\temp\teste.txt").
    
    PAUSE.
    
    /** Download
     * Par�metro 1 : Endere�o dos arquivos no servidor remoto (aceita caracter coringa)
     * Par�metro 2 : Pasta local onde os arquivos ser�o salvos
     */
    IF FtpObject:Download("/moderna/*", "c:\temp\") THEN DO:
        MESSAGE "Download conclu�do com sucesso"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

    FtpObject = ?.

    CATCH ex AS Progress.Lang.AppError:
        MESSAGE ex:GetMessage(1)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END CATCH.

END.
