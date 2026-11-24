@echo off
setlocal
cd /d "%~dp0"
if not exist "veyra_qml_ui.exe" (
  echo Erro: execute este arquivo ao lado de veyra_qml_ui.exe.
  pause
  exit /b 1
)
echo XeSS 5X/6X experimental - pode falhar ou travar. Use a versao oficial como backup.
echo Desative a selecao automatica de multiplicador e teste 4X, 5X e depois 6X.
set "VEYRA_XESS_EXPERIMENTAL_6X=1"
start "" /wait "%~dp0veyra_qml_ui.exe"
exit /b %ERRORLEVEL%
