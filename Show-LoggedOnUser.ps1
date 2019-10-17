Import-Module activedirectory

Function Show-LoggedOnUser {
<#
.Synopsis
    Shows all currently logged in users to a specified Computer.
.Description
    Quick command that leverages quser to query the specified computer and show all logged in users (remotely or otherwise). Ideally, ComputerName should be used when available as IP address can cause issues with quser and have it report back that no session exists when in fact it does. 
    
    This can be used in conjunction with the Remote-Logoff function to remotely log off the console user. 
.Parameter ComputerName
    The Computer you wish to query
.Example
    PS C:\>Show-LoggedOnUser -ComputerName FSO0198
.Example
    PS C:\>Show-LoggedOnUser FSO0198
.Example
    PS C:\>Show-LoggedOnUser 10.192.224.X
.Notes
    Common errors:
        If Qwinsta reports: No session exists for *; this means that the ping to the computer was successful however there are no logged in user sessions. Verify that the computer is turned on and has a logged in user. 
        
        If Qwinsta reports Error 5: RPC server is unavailable; this means that the ping is successful however quser does not recognize your account as being elevated. The only work around seems to be to try again in an elevated user session (i.e. sign in with your LA or DA)
        
        If Quser reports Error enumerating sessionnames/Error 1722 RPC server is unavailable; this means that the ping is successful however quser does not recognize your account as being elevated. 
        
        Will test to see if possibly entering a PSSession solves these errors. 
#>

[CmdletBinding()]
param(
    [Parameter(
        Mandatory = $true,
        Position = 0)]
    [string]$ComputerName
)

Process {
    Write-Host ("Connecting to {0}" -f $ComputerName)
        if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
            quser /server:$ComputerName
        }
        else {
            Write-Error ("Could not connect to {0}, verify the computer is on and connected to the network." -f $ComputerName)
        }
    }
}
