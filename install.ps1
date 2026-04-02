# PowerShell Installation script for Claw RS
# This will:
# 1. Build the release binary
# 2. Create a PowerShell wrapper
# 3. Add to PATH (optional)
# 4. Configure AI provider (interactive)

param(
    [switch]$SkipPath,
    [switch]$SkipConfig
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Claw RS - Windows Installer (PowerShell)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Get the script directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "[1/4] Building Claw RS (release mode)..." -ForegroundColor Yellow
Set-Location $SCRIPT_DIR

# Build the release version
cargo build --release

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Build failed! Please check the errors above." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/4] Creating PowerShell launcher..." -ForegroundColor Yellow

# Create a PowerShell function wrapper
$launcherScript = @"
# Claw RS Launcher for Windows
`$CLAW_BIN = Join-Path "$SCRIPT_DIR" "target\release\claw-rs.exe"

if (Test-Path `$CLAW_BIN) {
    & `$CLAW_BIN `$args
} else {
    Write-Host "[ERROR] claw-rs.exe not found at `$CLAW_BIN" -ForegroundColor Red
    Write-Host "Please rebuild the project first." -ForegroundColor Yellow
    exit 1
}
"@

# Save the launcher as a module file
$launcherPath = Join-Path $SCRIPT_DIR "claw.ps1"
Set-Content -Path $launcherPath -Value $launcherScript -Encoding UTF8

Write-Host ""
Write-Host "[3/4] Setting up environment..." -ForegroundColor Yellow

if (-not $SkipPath) {
    $response = Read-Host "Do you want to add Claw to your PATH? (Y/N)"
    
    if ($response -eq 'Y' -or $response -eq 'y') {
        Write-Host ""
        Write-Host "Adding to user PATH..." -ForegroundColor Green
        
        # Get current PATH
        $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        
        # Add to PATH if not already present
        if ($currentPath -notlike "*$SCRIPT_DIR*") {
            $newPath = $currentPath + ";" + $SCRIPT_DIR
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            Write-Host "✓ Added to PATH" -ForegroundColor Green
            Write-Host ""
            Write-Host "NOTE: You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
        } else {
            Write-Host "✓ Already in PATH" -ForegroundColor Green
        }
    } else {
        Write-Host ""
        Write-Host "You can manually run the tool using:" -ForegroundColor Yellow
        Write-Host "  .\$launcherPath" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Or add the directory to PATH manually." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "[4/4] AI Provider Configuration" -ForegroundColor Yellow

if (-not $SkipConfig) {
    Write-Host ""
    Write-Host "Claw RS needs an AI provider to work. Please choose one:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [1] Zhipu GLM API (Recommended for Chinese users)" -ForegroundColor White
    Write-Host "      - Good Chinese language support" -ForegroundColor Gray
    Write-Host "      - Cost-effective" -ForegroundColor Gray
    Write-Host "      - Models: glm-4, glm-3-turbo" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [2] Anthropic Claude API" -ForegroundColor White
    Write-Host "      - Excellent code understanding" -ForegroundColor Gray
    Write-Host "      - Higher quality responses" -ForegroundColor Gray
    Write-Host "      - Models: claude-sonnet-4, claude-opus" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [3] Skip configuration (configure manually later)" -ForegroundColor Yellow
    Write-Host ""
    
    $choice = Read-Host "Enter your choice (1/2/3)"
    
    if ($choice -eq '1') {
        Write-Host ""
        Write-Host "────────────────────────────────────────────" -ForegroundColor Cyan
        Write-Host "Configuring Zhipu GLM API" -ForegroundColor Cyan
        Write-Host "────────────────────────────────────────────" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "To get your API key:" -ForegroundColor Yellow
        Write-Host "  1. Visit: https://open.bigmodel.cn/" -ForegroundColor White
        Write-Host "  2. Login/Register" -ForegroundColor White
        Write-Host "  3. Go to API Console" -ForegroundColor White
        Write-Host "  4. Create a new API Key" -ForegroundColor White
        Write-Host ""
        
        $zhipuKey = Read-Host "Enter your Zhipu API Key"
        
        if ([string]::IsNullOrWhiteSpace($zhipuKey)) {
            Write-Host "API key cannot be empty. Skipping configuration..." -ForegroundColor Red
            $choice = '3'
        } else {
            $zhipuModel = Read-Host "Enter model name [glm-4]"
            if ([string]::IsNullOrWhiteSpace($zhipuModel)) {
                $zhipuModel = "glm-4"
            }
            
            # Create config directory
            $configDir = Join-Path $env:USERPROFILE ".claw-code-rust"
            if (-not (Test-Path $configDir)) {
                New-Item -ItemType Directory -Path $configDir | Out-Null
            }
            
            # Create config.json
            $config = @{
                provider = "openai"
                model = $zhipuModel
                base_url = "https://open.bigmodel.cn/api/paas/v4"
                api_key = $zhipuKey
            } | ConvertTo-Json -Depth 10
            
            Set-Content -Path (Join-Path $configDir "config.json") -Value $config -Encoding UTF8
            
            # Update launcher with default model
            $launcherContent = @"
# Claw RS Launcher for Windows
`$CLAW_BIN = Join-Path "$SCRIPT_DIR" "target\release\claw-rs.exe"

if (Test-Path `$CLAW_BIN) {
    & `$CLAW_BIN -m $zhipuModel `$args
} else {
    Write-Host "[ERROR] claw-rs.exe not found at `$CLAW_BIN" -ForegroundColor Red
    Write-Host "Please rebuild the project first." -ForegroundColor Yellow
    exit 1
}
"@
            
            Set-Content -Path (Join-Path $SCRIPT_DIR "claw.ps1") -Value $launcherContent -Encoding UTF8
            
            Write-Host ""
            Write-Host "✓ Zhipu GLM configuration saved!" -ForegroundColor Green
            Write-Host "  Model: $zhipuModel" -ForegroundColor Green
            Write-Host "  Default launcher updated to use: claw -m $zhipuModel" -ForegroundColor Green
        }
    }
    elseif ($choice -eq '2') {
        Write-Host ""
        Write-Host "────────────────────────────────────────────" -ForegroundColor Cyan
        Write-Host "Configuring Anthropic Claude API" -ForegroundColor Cyan
        Write-Host "────────────────────────────────────────────" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "To get your API key:" -ForegroundColor Yellow
        Write-Host "  1. Visit: https://console.anthropic.com/" -ForegroundColor White
        Write-Host "  2. Login/Register" -ForegroundColor White
        Write-Host "  3. Get your API Key" -ForegroundColor White
        Write-Host ""
        
        $anthropicKey = Read-Host "Enter your Anthropic API Key"
        
        if ([string]::IsNullOrWhiteSpace($anthropicKey)) {
            Write-Host "API key cannot be empty. Skipping configuration..." -ForegroundColor Red
            $choice = '3'
        } else {
            $anthropicModel = Read-Host "Enter model name [claude-sonnet-4-20250514]"
            if ([string]::IsNullOrWhiteSpace($anthropicModel)) {
                $anthropicModel = "claude-sonnet-4-20250514"
            }
            
            # Create config directory
            $configDir = Join-Path $env:USERPROFILE ".claw-code-rust"
            if (-not (Test-Path $configDir)) {
                New-Item -ItemType Directory -Path $configDir | Out-Null
            }
            
            # Create config.json
            $config = @{
                provider = "anthropic"
                model = $anthropicModel
                api_key = $anthropicKey
            } | ConvertTo-Json -Depth 10
            
            Set-Content -Path (Join-Path $configDir "config.json") -Value $config -Encoding UTF8
            
            # Update launcher with default model
            $launcherContent = @"
# Claw RS Launcher for Windows
`$CLAW_BIN = Join-Path "$SCRIPT_DIR" "target\release\claw-rs.exe"

if (Test-Path `$CLAW_BIN) {
    & `$CLAW_BIN -m $anthropicModel `$args
} else {
    Write-Host "[ERROR] claw-rs.exe not found at `$CLAW_BIN" -ForegroundColor Red
    Write-Host "Please rebuild the project first." -ForegroundColor Yellow
    exit 1
}
"@
            
            Set-Content -Path (Join-Path $SCRIPT_DIR "claw.ps1") -Value $launcherContent -Encoding UTF8
            
            Write-Host ""
            Write-Host "✓ Anthropic configuration saved!" -ForegroundColor Green
            Write-Host "  Model: $anthropicModel" -ForegroundColor Green
            Write-Host "  Default launcher updated to use: claw -m $anthropicModel" -ForegroundColor Green
        }
    }
    
    if ($choice -eq '3') {
        Write-Host ""
        Write-Host "You can configure the provider later by:" -ForegroundColor Yellow
        Write-Host "  1. Running: claw (interactive mode)" -ForegroundColor White
        Write-Host "  2. Or setting env: `$env:ZHIPU_API_KEY='your_key'" -ForegroundColor White
        Write-Host "  3. Or editing: %USERPROFILE%\.claw-code-rust\config.json" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   Installation Complete!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:" -ForegroundColor Cyan
Write-Host "  claw              - Start interactive chat" -ForegroundColor White
Write-Host "  claw -q 'hello'   - Single query mode" -ForegroundColor White
Write-Host "  claw -m glm-4     - Use specific model" -ForegroundColor White
Write-Host ""
Write-Host "Configuration location:" -ForegroundColor Cyan
Write-Host "  %USERPROFILE%\.claw-code-rust\config.json" -ForegroundColor Gray
Write-Host ""
Write-Host "============================================" -ForegroundColor Green
