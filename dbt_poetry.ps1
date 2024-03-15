param (
    [string]$dbtProjectPath,
    [string]$schemaName
)

# Check if $schemaName is empty
if (-not $schemaName) {
    Write-Host "Error: Schema name cannot be empty."
    exit 1
}

# Convert schemaName to uppercase
$schemaName = $schemaName.ToUpper()

# Set environment variables
$env:https_proxy = 'http://webproxy-utvikler.nav.no:8088'

# Check if the dbt project path is provided
if (-not $dbtProjectPath) {
    Write-Host "Error: Please provide the path to a valid dbt project using -dbtProjectPath."
    exit 1
}

# Verify correct directory
Set-Location -Path $dbtProjectPath -ErrorAction Stop

# Function to find the pyproject.toml file
function Find-RequirementsFile {
    $dbtRequirementsPath = Join-Path $dbtProjectPath pyproject.toml
    $parentRequirementsPath = Join-Path (Get-Item $dbtProjectPath).Parent.FullName pyproject.toml

    if (Test-Path $dbtRequirementsPath) {
        Write-Host "REQUIREMENTS FILE FOUND: $dbtRequirementsPath"
        return $dbtRequirementsPath
    }
    elseif (Test-Path $parentRequirementsPath) {
        Write-Host "REQUIREMENTS FILE FOUND: $parentRequirementsPath"
        return $parentRequirementsPath
    }
    else {
        Write-Host "Error: pyproject.toml file not found in the specified dbt project or its parent folder."
        exit 1
    }
}

# Check if requirements.txt file exists before proceeding
$requirementsFile = Find-RequirementsFile

# Set environment variables
$env:ORA_PYTHON_DRIVER_TYPE = "thin"
$env:DBT_PROFILES_DIR = Get-Location
$env:DBT_DB_SCHEMA = $schemaName
$target = (Read-Host -Prompt "Target db").ToUpper()
$creds = Get-Credential

$username = $creds.Username
if ($schemaName) {
    $username += "[$schemaName]"
}
$env:DBT_DB_TARGET = $target
$env:DBT_ENV_SECRET_USER = $username
$env:DBT_ENV_SECRET_PASS = $creds.GetNetworkCredential().Password

# Function to set up a virtual env for dbt
function Add-dbtenv {
    # Create environment
    poetry install

    # Removing proxy
    Remove-Item -Path Env:https_proxy
}
# Activate the virtual environment
Add-dbtenv

# Construct the path to the dbt_packages folder
$DbtPackagesFolder = Join-Path -Path $dbtProjectPath -ChildPath "dbt_packages"

# Check if the dbt_packages folder exists
if (Test-Path -Path $DbtPackagesFolder -PathType Container) {
    # Get the count of items (files and folders) within the dbt_packages folder
    $ItemCount = (Get-ChildItem -Path $DbtPackagesFolder | Measure-Object).Count

    # Check if the dbt_packages folder is empty
    if ($ItemCount -eq 0) {
        Write-Host "The 'dbt_packages' folder is empty."
    } else {
        # Install dependencies
        dbt deps
    }
} else {
    Write-Host "The 'dbt_packages' folder does not exist in the current directory."
}

# Clear command history
Clear-History

# Start VS Code
code ..

# Optional: Close PowerShell session
exit
