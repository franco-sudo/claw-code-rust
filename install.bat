@echo off
REM Windows Installation script for Claw RS
REM This will:
REM 1. Build the release binary
REM 2. Create Windows launcher
REM 3. Add to PATH (optional)
REM 4. Configure AI provider (interactive)

setlocal enabledelayedexpansion

echo ============================================
echo    Claw RS - Windows Installer
echo ============================================
echo.

REM Get the script directory
set "SCRIPT_DIR=%~dp0"

echo [1/4] Building Claw RS (release mode)...
echo.
cd /d "%SCRIPT_DIR%"
cargo build --release

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Build failed! Please check the errors above.
    exit /b 1
)

echo.
echo [2/4] Creating Windows launcher...
echo.

REM Create a batch file wrapper for claw
set "LAUNCHER_PATH=%SCRIPT_DIR%claw.bat"
(
    echo @echo off
    echo REM Claw RS Launcher for Windows
    echo set "CLAW_BIN=%SCRIPT_DIR%target\release\claw-rs.exe"
    echo if exist "%%CLAW_BIN%%" ^(
    echo     "%%CLAW_BIN%%" %%*
    echo ^) else ^(
    echo     echo [ERROR] claw-rs.exe not found at %%CLAW_BIN%%
    echo     echo Please rebuild the project first.
    echo     exit /b 1
    echo ^)
) > "%LAUNCHER_PATH%"

echo.
echo [3/4] Setting up environment...
echo.

REM Check if user wants to add to PATH
set /p ADD_TO_PATH="Do you want to add Claw to your PATH? (Y/N): "
if /i "!ADD_TO_PATH!"=="Y" (
    echo.
    echo Adding to PATH using setx...
    setx CLAW_HOME "%SCRIPT_DIR%"
    
    REM Append to PATH (Windows-specific)
    for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do (
        set "CURRENT_PATH=%%B"
    )
    
    if "!CURRENT_PATH!"=="" (
        setx PATH "%SCRIPT_DIR%"
    ) else (
        setx PATH "!CURRENT_PATH!;%SCRIPT_DIR%"
    )
    
    echo.
    echo ✓ Added to PATH
    echo.
    echo NOTE: You may need to restart your terminal or log out/in for PATH changes to take effect.
) else (
    echo.
    echo You can manually run the tool using:
    echo   %SCRIPT_DIR%claw.bat
    echo.
    echo Or add the directory to PATH manually.
)

echo.
echo [4/4] AI Provider Configuration
echo.
echo Claw RS needs an AI provider to work. Please choose one:
echo.
echo   [1] Zhipu GLM API (Recommended for Chinese users)
echo       - Good Chinese language support
echo       - Cost-effective
echo       - Models: glm-4, glm-3-turbo
echo.
echo   [2] Anthropic Claude API
echo       - Excellent code understanding
echo       - Higher quality responses
echo       - Models: claude-sonnet-4, claude-opus
echo.
echo   [3] Skip configuration (configure manually later)
echo.

set /p PROVIDER_CHOICE="Enter your choice (1/2/3): "

if "%PROVIDER_CHOICE%"=="1" (
    goto :CONFIG_ZHIPU
) else if "%PROVIDER_CHOICE%"=="2" (
    goto :CONFIG_ANTHROPIC
) else (
    goto :SKIP_CONFIG
)

:CONFIG_ZHIPU
echo.
echo ────────────────────────────────────────────
echo Configuring Zhipu GLM API
echo ────────────────────────────────────────────
echo.
echo To get your API key:
echo   1. Visit: https://open.bigmodel.cn/
echo   2. Login/Register
echo   3. Go to API Console
echo   4. Create a new API Key
echo.
set /p ZHIPU_KEY="Enter your Zhipu API Key: "
if "!ZHIPU_KEY!"=="" (
    echo API key cannot be empty. Skipping configuration...
    goto :SKIP_CONFIG
)

echo.
set /p ZHIPU_MODEL="Enter model name [glm-4]: "
if "!ZHIPU_MODEL!"=="" set "ZHIPU_MODEL=glm-4"

echo.
echo Creating configuration file...
set "CONFIG_DIR=%USERPROFILE%\.claw-code-rust"
if not exist "!CONFIG_DIR!" mkdir "!CONFIG_DIR!"

(
    echo {
    echo   "provider": "openai",
    echo   "model": "!ZHIPU_MODEL!",
    echo   "base_url": "https://open.bigmodel.cn/api/paas/v4",
    echo   "api_key": "!ZHIPU_KEY!"
    echo }
) > "!CONFIG_DIR!\config.json"

echo.
echo Updating launcher with default model...
REM Update claw.bat to include the model parameter by default
(
    echo @echo off
    echo REM Claw RS Launcher for Windows
    echo set "CLAW_BIN=%SCRIPT_DIR%target\release\claw-rs.exe"
    echo if exist "%%CLAW_BIN%%" ^(
    echo     "%%CLAW_BIN%%" -m !ZHIPU_MODEL! %%*
    echo ^) else ^(
    echo     echo [ERROR] claw-rs.exe not found at %%CLAW_BIN%%
    echo     echo Please rebuild the project first.
    echo     exit /b 1
    echo ^)
) > "%LAUNCHER_PATH%"

echo ✓ Zhipu GLM configuration saved!
echo   Model: !ZHIPU_MODEL!
echo   Default launcher updated to use: claw -m !ZHIPU_MODEL!
goto :INSTALL_COMPLETE

:CONFIG_ANTHROPIC
echo.
echo ────────────────────────────────────────────
echo Configuring Anthropic Claude API
echo ────────────────────────────────────────────
echo.
echo To get your API key:
echo   1. Visit: https://console.anthropic.com/
echo   2. Login/Register
echo   3. Get your API Key
echo.
set /p ANTHROPIC_KEY="Enter your Anthropic API Key: "
if "!ANTHROPIC_KEY!"=="" (
    echo API key cannot be empty. Skipping configuration...
    goto :SKIP_CONFIG
)

echo.
set /p ANTHROPIC_MODEL="Enter model name [claude-sonnet-4-20250514]: "
if "!ANTHROPIC_MODEL!"=="" set "ANTHROPIC_MODEL=claude-sonnet-4-20250514"

echo.
echo Creating configuration file...
set "CONFIG_DIR=%USERPROFILE%\.claw-code-rust"
if not exist "!CONFIG_DIR!" mkdir "!CONFIG_DIR!"

(
    echo {
    echo   "provider": "anthropic",
    echo   "model": "!ANTHROPIC_MODEL!",
    echo   "api_key": "!ANTHROPIC_KEY!"
    echo }
) > "!CONFIG_DIR!\config.json"

echo.
echo Updating launcher with default model...
REM Update claw.bat to include the model parameter by default
(
    echo @echo off
    echo REM Claw RS Launcher for Windows
    echo set "CLAW_BIN=%SCRIPT_DIR%target\release\claw-rs.exe"
    echo if exist "%%CLAW_BIN%%" ^(
    echo     "%%CLAW_BIN%%" -m !ANTHROPIC_MODEL! %%*
    echo ^) else ^(
    echo     echo [ERROR] claw-rs.exe not found at %%CLAW_BIN%%
    echo     echo Please rebuild the project first.
    echo     exit /b 1
    echo ^)
) > "%LAUNCHER_PATH%"

echo ✓ Anthropic configuration saved!
echo   Model: !ANTHROPIC_MODEL!
echo   Default launcher updated to use: claw -m !ANTHROPIC_MODEL!
goto :INSTALL_COMPLETE

:SKIP_CONFIG
echo.
echo You can configure the provider later by:
echo   1. Running: claw (interactive mode)
echo   2. Or setting environment variable: setx ZHIPU_API_KEY "your_key"
echo   3. Or editing: %USERPROFILE%\.claw-code-rust\config.json
echo.

:INSTALL_COMPLETE
echo.
echo ============================================
echo    Installation Complete!
echo ============================================
echo.
echo Usage:
echo   claw              - Start interactive chat
echo   claw -q "hello"   - Single query mode
echo   claw -m glm-4     - Use specific model
echo.
echo Configuration location:
echo   %USERPROFILE%\.claw-code-rust\config.json
echo.
echo ============================================

pause
