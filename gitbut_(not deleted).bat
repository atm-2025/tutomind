@echo off
cd /d "%~dp0"

REM ====== CONFIGURE ======
set REMOTE_URL=https://github.com/atm-2025/tutomind
set BRANCH=main

REM ====== INIT IF NEEDED ======
if not exist ".git" (
    echo [INFO] Git not initialized. Initializing...
    git init
    git remote add origin %REMOTE_URL%
    git branch -M %BRANCH%
)

REM ====== ADD NEW & MODIFIED FILES ONLY ======
echo [INFO] Adding new and modified files only...
git add .

REM ====== UNSTAGE DELETED FILES SO THEY WON'T BE COMMITTED ======
for /f "delims=" %%f in ('git ls-files --deleted') do (
    echo [INFO] Ignoring deletion of: %%f
    git reset HEAD "%%f"
)

REM ====== COMMIT WITH TIMESTAMP ======
for /f %%i in ('powershell -command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set timestamp=%%i

git commit -m "Auto commit %timestamp%" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Nothing to commit.
    pause
    exit /b
)

REM ====== PUSH TO GITHUB ======
echo [INFO] Pushing to GitHub...
git push -u origin %BRANCH%

echo [SUCCESS] Changes pushed (deletions ignored).
pause
