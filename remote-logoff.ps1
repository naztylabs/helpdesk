function Remote-Logoff{
<#
.Synopsis
    Remotely logoff current user.
.Description
    Quick command that leverages Qwinsta to query the machine and then uses the Logoff command to log off the current "console" user, where console is the user logged into the physical device. 
    This will not log off a RDP session as that requires the console variable in the command line to be changed to rdp-tcp. You can also leverage Show-LOU to grab a logged in Session ID and then run the Logoff command with that specific session id 
.Parameter Keyword
.Example
    PS C:\>Remote-Logoff -ComputerName FSO0198 -ID 2
.Example
    PS C:\>Remote-Logoff FSO0198 3
.Example
    PS C:\>Logoff /Server:ComputerName 3
    *In these examples please note that ComputerName refers to the computer you're contacting and the number 3 is a session ID that is displayed by the Qwinsta or Show-LoggedOnUser command.*
.Notes
    Created by Tyler Nazifi. With great power comes great responsibility. Verify that logging off the user will cause no damage as the Logoff command does not always wait for documents to save.
#>

[CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param(
    
    [Parameter(
        Mandatory = $true,
        Position = 0)]
    $ComputerName,

    [Parameter(
        Mandatory = $true,
        Position = 1)]
    [string]$ID

    )

Process {
        Write-Host ("Attempting to logoff the specified user on {0}" -f $ComputerName)
         if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
                Logoff  /server:$ComputerName $ID
         }
         else {
                Write-Error ("Could not logoff the specified user on {0}, verify the computer is on and connected to the network. User remains logged in." -f $ComputerName)
         }
     }
}