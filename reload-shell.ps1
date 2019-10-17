function reload-shell{
<#
.Synopsis
Reloads your shell. 
.Description
This command will kill your current shell and reopen it as an admin using the credentials specified.
In PowerShell Core it opens a cmd window to start the process. No idea why that is.
.Parameter Version
Which version of PowerShell you wish, accepts either pwsh or core. 
Pwsh being Windows PowerShell. Core being PowerShell Core
.Parameter Credential
The elevated account you wish to open the shell as. 
.Example
    PS C:\>reload-shell -credential latylernazifi
.Example
    PS C:\>reload-shell -credential latylernazifi -version core
.Notes
    Created by Tyler Nazifi
#>

[CmdletBinding()]
param(
   [Parameter(
        Mandatory = $true,
        Position = 0)]
    [string]$Credential,

    [Parameter(
        Mandatory = $true,
        Position = 1)]
    [string]$Version

)

    process{
        if($Version -like 'pwsh'){
            Write-Host ("Starting Windows PowerShell")
                start-process PowerShell -Credential FSO\$Credential
                exit       
        }
        else{if($version -like 'core'){
            Write-Host ("Starting PowerShell Core")
                start-process pwsh
                exit
            }
            else{
            Write-Host("Something went wrong :(") -foregroundcolor Red
            }
        }
    }
}