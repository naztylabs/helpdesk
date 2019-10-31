Import-Module activedirectory

function whatis {

<#
.Synopsis
    Defines a computer make, model, monitors, and displays BIOS information of the machine. 
.Description
    This command leverages the Get-CIMinstance command to quickly grab BIOS information, monitor information, as well as the make and model of the computer in question. 
    Will also grab the current user and their logon time.
.Parameter ComputerName
    The Computer you wish to identify
.Parameter Credential
    The elevated account you wish to run the command as. 
    Only necessary for the PSSession to authorize (and if you wish to use IP instead of ComputerName)
.Example
    PS C:\>whatis -ComputerName Computer.Desktop -Credential Local.Admin
.Notes
    Created by Tyler Nazifi - 08/07/2019; updated 08/23/2019
    08/21/2019 - This function will now grab monitor make, model, ID, and serial.
    08/23/2019 - I had the output of the monitor information format as a table so it can be easily inserted into a spreadsheet. 
#>

[CmdletBinding()]

param(
    [parameter(Mandatory=$true)]        
    [string]$ComputerName
    )

    Process {
        Write-Host ("Checking connection to {0}" -f $ComputerName) -ForegroundColor Yellow
            if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
                    ## Grab Computer Make and Model
                Write-Host("The following contains Computer Make/Model information") -ForegroundColor Yellow
                Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $ComputerName | Format-List -Property Name,Manufacturer,Model
                    ## Grab OS and build number
                Write-Host("The following contains Computer Operating System, Revision, and architect information") -ForegroundColor Yellow
                Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName | Format-List -Property Caption, Version, OSArchitecture 
                    ## Get BIOS information including serial number of the device:
                Write-Host("The following contains BIOS information") -ForegroundColor Yellow
                Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName | Format-List -Property Manufacturer,Name,SerialNumber
                    ## Get Monitor make, model, and serial information and display it nicely:
                Write-Host("The following table contains monitor information.") -ForegroundColor Yellow
                Get-CimInstance -Namespace root\wmi -ClassName wmimonitorid -ComputerName $ComputerName | 
                    foreach {
                        New-Object -TypeName psobject -Property @{
                            Computer = $ComputerName
                            Make = ($_.ManufacturerName -notmatch '^0$' | foreach {[char]$_}) -join ""
                            Name = ($_.UserFriendlyName -notmatch '^0$' | foreach {[char]$_}) -join ""
                            ID = ($_.ProductCodeID -notmatch '^0$' | foreach {[char]$_}) -join ""
                            Serial = ($_.SerialNumberID -notmatch '^0$' | foreach {[char]$_}) -join ""
                            Year = $_.YearOfManufacture
                            Time = Get-Date
                        } | Format-List -Property Computer,Make,Name,Serial,ID,Year,Time
                    }
                    ## Use Quser to grab logon information
                Write-Host("The following user accounts are logged in currently") -ForegroundColor Yellow
                Quser /server:$ComputerName
            }
        else {
            Write-Error ("Could not connect to {0}, verify the computer is on and connected to the network." -f $ComputerName)
        }
    }
}
