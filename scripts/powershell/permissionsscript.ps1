# Replace 'domain\username' with the actual domain and username
$user = "domain\username"

# Replace 'C:\path\to\folder' with the actual path to the directory
$directory = "C:\path\to\folder"

# Function to set permissions
function Set-Permissions {
    param (
        [string]$path,
        [string]$user,
        [string]$permission
    )
    $acl = Get-Acl -Path $path
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, $permission, "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($accessRule)
    Set-Acl -Path $path -AclObject $acl
}

# Set read-only permissions for the main directory
Set-Permissions -path $directory -user $user -permission "ReadAndExecute"

# Recursively set permissions for subdirectories named "FULL or "TEST"
Get-ChildItem -Path $directory -Recurse -Directory | ForEach-Object {
    if ($_.Name -eq "FULL -or $_.Name -eq "TEST") {
        Set-Permissions -path $_.FullName -user $user -permission "FullControl"
    } else {
        Set-Permissions -path $_.FullName -user $user -permission "ReadAndExecute"
    }
}

Write-Output "Permissions have been updated."
