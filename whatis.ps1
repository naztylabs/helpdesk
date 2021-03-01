Import-Module activedirectory

function whatis {

<#
.Synopsis
    Defines a computer make, model, monitors, and displays BIOS information of the machine. 
.Description
    This command leverages the Get-CIMinstance command to quickly grab BIOS information, monitor information, as well as the make and model of the computer in question. 
.Parameter ComputerName
    The computername you wish to identify
.Example
    PS C:\>whatis -ComputerName DSKTP401
    PS C:\>whatis LEAFEON
.Notes
    Created by Nazty_Labs - 08/07/2019; updated 03/1/2021
#>

[CmdletBinding()]

param(
    [parameter(Mandatory=$true)]        
    [string]$ComputerName
    )

    Process {
        Write-Host ("Checking connection to {0}" -f $ComputerName) -ForegroundColor Yellow
            if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
                ## Grab the information for the owner, model, OS architecture, and bios serial number:
                $owner = Search-AD -Computer $ComputerName | Select-Object Description
                $model = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $ComputerName -ErrorAction SilentlyContinue | Select-Object Name,Manufacturer,Model
                $arch = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName -ErrorAction SilentlyContinue | Select-Object Caption,Version,OSArchitecture 
                $bios = Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName -ErrorAction SilentlyContinue | Select-Object Manufacturer,Name,SerialNumber
                
                ## Get Monitor make, model, and serial information and display it nicely:
                $monitor = Get-CimInstance -Namespace root\wmi -ClassName wmimonitorid -ComputerName $ComputerName -ErrorAction SilentlyContinue | 
                    foreach {
                        New-Object -TypeName psobject -Property @{
                            Computer = $ComputerName
                            Make = ($_.ManufacturerName -notmatch '^0$' | foreach {[char]$_}) -join ""
                            Name = ($_.UserFriendlyName -notmatch '^0$' | foreach {[char]$_}) -join ""
                            ID = ($_.ProductCodeID -notmatch '^0$' | foreach {[char]$_}) -join ""
                            Serial = ($_.SerialNumberID -notmatch '^0$' | foreach {[char]$_}) -join ""
                            Year = $_.YearOfManufacture
                        }
                    }
                
                ## Create the Client Information Object:
                $ClientInfo = New-Object psobject -Property @{
                    Name = $ComputerName
                    Owner = $owner.Description
                    Model = $model.model
                    Manufacturer = $model.Manufacturer
                    Serial = $bios.SerialNumber
                    OSVersion = $arch.Caption
                    OSBuild = $arch.Version
                    OSArch = $arch.OSArchitecture
                    Monitors = $monitor.name
                    MonitorSN = $monitor.Serial
                    MonitorBuildDate = $monitor.Year
                }

                ##Output the Client Information Object
                $ClientInfo | Select-Object Name,Owner,Model,Manufacturer,Serial,OSVersion,OSBuild,OSArch,Monitors,MonitorSN

            }
        else {
            Write-Error ("Could not connect to {0}, verify the computer is on and connected to the network." -f $ComputerName)
        }
    }
}
