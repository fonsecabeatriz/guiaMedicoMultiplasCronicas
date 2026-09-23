@echo off
title Guia de Medicos MC - servidor
cd /d "%~dp0"
echo [%date% %time%] iniciando > server.log
where node >> server.log 2>&1
start "" cmd /c "timeout /t 6 /nobreak >nul & start http://localhost:3000"
where node >nul 2>nul
if %errorlevel%==0 (
  echo usando node >> server.log
  node server.js >> server.log 2>&1
) else (
  echo usando powershell >> server.log
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0server.ps1" >> server.log 2>&1
)
echo [%date% %time%] servidor parou, codigo %errorlevel% >> server.log
echo O servidor parou. Veja server.log nesta pasta.
pause
