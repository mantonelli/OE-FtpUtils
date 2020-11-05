# OE-FtpUtils

Classe que permite o acesso a servidores FTP e SFTP através do utilitário WinSCP em projetos que utilizam Progress Openedge.

Instruções:
----------------------------
1. Compilar a classe FtpUtils.cls e salvar o arquivo .r em uma pasta acessível no Propath
2. Baixar WinSCP .NET Assembly / COM Library (https://winscp.net/eng/downloads.php) e extrair os arquivos
3. Atualizar o arquivo .pf, incluindo o parâmetro -assemblies, referenciando a pasta onde os arquivos do WinSCP foram extraídos
4. Testar a conexão

