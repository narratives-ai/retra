$ErrorActionPreference = "Stop"
$MinimumPython = "3.9"
$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$RetrospectiveScript = Join-Path $ScriptDirectory "retrospective.py"

function Test-CompatiblePython {
    param([string[]]$Invocation)
    if ($env:RETROSPECTIVE_FORCE_PYTHON_MISSING -eq "1") { return $false }
    try {
        $command = $Invocation[0]
        $prefix = @()
        if ($Invocation.Count -gt 1) { $prefix = $Invocation[1..($Invocation.Count - 1)] }
        & $command @prefix -c "import sqlite3, sys, zoneinfo; raise SystemExit(0 if sys.version_info >= (3, 9) else 1)" 2>$null
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

function Find-CompatiblePython {
    $candidates = @()
    if ($env:RETROSPECTIVE_PYTHON) {
        $candidates += ,@($env:RETROSPECTIVE_PYTHON)
    }
    $candidates += ,@("py", "-3")
    $candidates += ,@("python3")
    $candidates += ,@("python")
    foreach ($candidate in $candidates) {
        if (Test-CompatiblePython $candidate) { return $candidate }
    }
    $runtimeRoots = @(
        (Join-Path $HOME ".cache\codex-runtimes"),
        (Join-Path $HOME ".codex\runtimes")
    )
    foreach ($root in $runtimeRoots) {
        if (-not (Test-Path $root)) { continue }
        $bundled = Get-ChildItem -Path $root -Filter "python.exe" -File -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -match "[\\/]dependencies[\\/]python[\\/]" } |
            Select-Object -First 1
        if ($null -ne $bundled) {
            $candidate = @($bundled.FullName)
            if (Test-CompatiblePython $candidate) { return $candidate }
        }
    }
    return $null
}

function Get-RecommendedInstaller {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        return "winget install --id Python.Python.3.12 --exact --accept-package-agreements --accept-source-agreements"
    }
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        return "choco install python312 -y"
    }
    return "Install Python 3.9 or newer from https://www.python.org/downloads/windows/"
}

function Write-DoctorResult {
    $python = Find-CompatiblePython
    if ($null -ne $python) {
        $command = $python[0]
        $prefix = @()
        if ($python.Count -gt 1) { $prefix = $python[1..($python.Count - 1)] }
        $version = & $command @prefix -c "import platform; print(platform.python_version())"
        @{
            ok = $true
            platform = "Windows"
            minimum_python = $MinimumPython
            python = ($python -join " ")
            version = $version
            install_required = $false
        } | ConvertTo-Json -Compress
    } else {
        @{
            ok = $false
            platform = "Windows"
            minimum_python = $MinimumPython
            python = $null
            install_required = $true
            recommended_command = Get-RecommendedInstaller
        } | ConvertTo-Json -Compress
    }
}

function Install-Runtime {
    $python = Find-CompatiblePython
    if ($null -ne $python) {
        Write-DoctorResult
        return
    }
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        & winget install --id Python.Python.3.12 --exact --accept-package-agreements --accept-source-agreements
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        & choco install python312 -y
    } else {
        throw "No supported package manager was found. Install Python 3.9 or newer from https://www.python.org/downloads/windows/."
    }
    if ($null -eq (Find-CompatiblePython)) {
        throw "Python was installed, but a compatible interpreter is not yet available in PATH. Restart Codex and rerun onboarding."
    }
    Write-DoctorResult
}

$CommandName = if ($args.Count -gt 0) { $args[0] } else { "" }
if ($CommandName -eq "doctor") {
    Write-DoctorResult
    exit 0
}
if ($CommandName -eq "install-runtime") {
    Install-Runtime
    exit 0
}

$python = Find-CompatiblePython
if ($null -eq $python) {
    # Hooks stay non-blocking until onboarding installs the runtime.
    exit 0
}
$command = $python[0]
$prefix = @()
if ($python.Count -gt 1) { $prefix = $python[1..($python.Count - 1)] }
& $command @prefix $RetrospectiveScript @args
exit $LASTEXITCODE
