@echo off
cd /d "%~dp0"

REM ===== CONFIG =====
set REMOTE_URL=https://github.com/atm-2025/tutomind
set BRANCH=main

REM ===== INIT IF NEEDED =====
if not exist ".git" (
    echo [INFO] Git not initialized. Initializing...
    git init
    git remote add origin %REMOTE_URL%
    git branch -M %BRANCH%
)

REM ===== ONLY STAGE MODIFIED FILES =====
for /f "delims=" %%f in ('git ls-files -m') do (
    echo [MODIFIED] %%f
    git add "%%f"
)

REM ===== ONLY STAGE NEW FILES (not ignored) =====
for /f "delims=" %%f in ('git ls-files -o --exclude-standard') do (
    echo [NEW] %%f
    git add "%%f"
)

REM ===== COMMIT IF ANYTHING IS STAGED =====
git diff --cached --quiet
IF %ERRORLEVEL%==0 (
    echo [INFO] Nothing to commit.
    pause
    exit /b
)

for /f %%i in ('powershell -command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set timestamp=%%i
git commit -m "Auto commit %timestamp%"

REM ===== PUSH =====
git push -u origin %BRANCH%

echo [SUCCESS] Changes pushed (no deletions).
pause
