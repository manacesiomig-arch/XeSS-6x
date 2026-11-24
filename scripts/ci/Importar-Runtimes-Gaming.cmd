@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File "%~dp0Importar-Runtimes-Gaming.ps1" %*
set "rc=%ERRORLEVEL%"
if not "%rc%"=="0" echo Falha: codigo %rc%
pause
exit /b %rc%
