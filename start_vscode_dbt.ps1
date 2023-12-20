# Path to wher you would like to place the python virtual env
$dbtEnv_path = "C:\datavarehus\.dbtenv"
# Database schema
$schema = <schema>

#Function to set up a virtual env for dbt
function Add-dbtenv {
  # Create environment (https://docs.python.org/3/library/venv.html)
  python -m venv $dbtEnv_path
  # And activate
  iex $dbtEnv_path"/Scripts/activate.ps1"
  # Install these packages to forsce python to use Windows Certificate Store.
  python -m pip install setuptools-scm pip-system-certs --trusted-host pypi.org --trusted-host  files.pythonhosted.org
  # Latest pip
  python -m pip install --upgrade pip
  # Install the latest dbt
  python -m pip install -r requirements.txt
}


#path to dbt folder
if ($args[0]) {
  $dbtPath = $args[0]
  Write-Host "Starting dbt environment. Please wait ..."
} else {
  Write-Host "Missing dbt project path. Add c:\path\to\project\ as argument to this script"
  exit
}


Try {
  Write-Host "Checking if path $dbtPath exists ..."
  Set-Location $dbtPath -ErrorAction Stop
  Write-Host "Path $dbtPath found, continuing ..."
}
Catch [System.Management.Automation.ItemNotFoundException]{
  Write-Host "Unable to find path:" $dbtPath"."
  exit
}




$dbt_project_file = Test-Path -Path $dbtPath"\dbt_project.yml"

if ($dbt_project_file) {
  Write-Host "$dbtPath is a valid dbt project. Welcome!"
  Write-Host "Please enter environment details!"
} else {
  Write-Host "Invalid dbt project: "$dbtPath" (missing dbt_project.yml)"
  exit
}


$env:DBT_PROFILES_DIR = $dbtPath




#Targest database in profiles.yml
$target = Read-Host -Prompt "Target db"
$target = $target.ToUpper()

#Database creds
$creds = Get-Credential
$username = $creds.Username
$username += "[$schema]"

$env:DBT_DB_SCHEMA = $schema
$env:DBT_DB_TARGET = $target
$env:DBT_ENV_SECRET_USER = $username
$env:DBT_ENV_SECRET_PASS = $creds.GetNetworkCredential().password




#Check if environment exists
$dbtEnv_exists = Test-Path -Path $dbtEnv_path
if (-Not $dbtEnv_exists) {
  Add-dbtenv
}
Else{
  if ((Read-Host -Prompt "Update .dbtenv? (y/n)") -eq "y") {
    Add-dbtenv
  }
  Else {
    iex $dbtEnv_path"/Scripts/activate.ps1"
  }
}

iex $dbtEnv_path"/Scripts/activate.ps1"
dbt deps

# midlertidig fiks for thin client fra utviklerimage
Remove-Item -Path Env:https_proxy
$env:ORA_PYTHON_DRIVER_TYPE = "thin"
echo "ORA_PYTHON_DRIVER_TYPE: $env:ORA_PYTHON_DRIVER_TYPE"

code ../