@echo off
setlocal
title El Lobito - Publicar en GitHub / Render
cd /d "C:\Dropbox\Claude\Stableford\Render Lobito"

echo ==========================================
echo    EL LOBITO - PUBLICAR NUEVA VERSION
echo ==========================================
echo.

:: Copiar El_Lobito.html como index.html
if exist "El_Lobito.html" (
    copy /y "El_Lobito.html" "index.html" >nul
    echo Copiado: El_Lobito.html -^> index.html
)

:: Actualizar VERSION con fecha y hora actuales
for /f %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmm"') do set NEWVER=%%d
echo Actualizando VERSION a: %NEWVER%
powershell -NoProfile -Command ^
  "(Get-Content 'index.html' -Encoding UTF8) -replace 'const VERSION = ""[^""]*""', 'const VERSION = ""%NEWVER%""' | Set-Content 'index.html' -Encoding UTF8"

echo.
echo [1/3] Preparando archivos...
git add -A

git diff --cached --quiet
if %errorlevel%==0 (
    echo.
    echo No hay cambios nuevos para guardar.
    pause
    exit /b 0
)

echo.
echo [2/3] Guardando cambios...
git commit -m "El Lobito v%NEWVER%"

if errorlevel 1 (
    echo ERROR al hacer commit.
    pause
    exit /b 1
)

echo.
echo [3/3] Subiendo a GitHub...
git push origin main

if errorlevel 1 (
    echo ==========================================
    echo ERROR: No se pudo subir a GitHub
    echo ==========================================
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   SUBIDO CORRECTAMENTE - v%NEWVER%
echo   Render hara el deploy automaticamente.
echo ==========================================
echo.
pause
