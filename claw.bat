@echo off
REM Claw RS Launcher for Windows
set "CLAW_BIN=C:\Users\54708\Desktop\claw\claw-code-rust\target\release\claw-rs.exe"
if exist "%CLAW_BIN%" (
    "%CLAW_BIN%" -m glm-4 %*
) else (
    echo [ERROR] claw-rs.exe not found at %CLAW_BIN%
    echo Please rebuild the project first.
    exit /b 1
)
