Import-Module activedirectory

function get-data {

<#
.Synopsis
    WhatIs but tailored to run within HelpDesk.ps1
.Description
    See WhatIs
.Parameter ComputerName
.Example
.Notes
    Created by Tyler Nazifi
#>

[CmdletBinding()]

param(
    [parameter(Mandatory=$true)]        
    [string]$ComputerName
    )

    Process {
        $computer = Get-CimInstance Win32_ComputerSystem -computername $ComputerName -ErrorAction SilentlyContinue
        Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $ComputerName |Select-Object Name,Manufacturer,Model | Format-List -Property Name,Manufacturer,Model |Out-String
        Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName |Select-Object Manufacturer,Name,SerialNumber | Format-List -Property Manufacturer,Name,SerialNumber |Out-String
        Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName | Select-Object Caption, Version, OSArchitecture | Format-List -Property Caption,Version,OSArchitecture | Out-String
        Get-CimInstance -Namespace root\wmi -ClassName wmimonitorid -ComputerName $ComputerName | 
            foreach {
                New-Object -TypeName psobject -Property @{
                    Make = ($_.ManufacturerName -notmatch '^0$' | foreach {[char]$_}) -join ""
                    Name = ($_.UserFriendlyName -notmatch '^0$' | foreach {[char]$_}) -join ""
                    ID = ($_.ProductCodeID -notmatch '^0$' | foreach {[char]$_}) -join ""
                    Serial = ($_.SerialNumberID -notmatch '^0$' | foreach {[char]$_}) -join ""
                    Year = $_.YearOfManufacture
                    Time = Get-Date
                    } | 
                        Format-List -Property Computer,Make,Name,Serial,ID,Year,Time
                    } |
            Out-String
        QUser /Server:$ComputerName
    }
}