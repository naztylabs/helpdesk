 function Say-RemoteText {
 <#
This function is mainly for Friday pranks. In its current form it requires a PSSession to function, so make sure everything lines up with your domain :)
.Example
	Say-RemoteText -ComputerName Domain.Computer -Credential Local.Admin -Textinput Look Dave, I can see you're really upset about this
 #>
[CmdletBinding(
 SupportsShouldProcess = $true
    )]

param(
    
    [Parameter(
        Mandatory = $true,
        Position = 0)]        
    [string]$ComputerName,
    
    
    [Parameter(
        Mandatory = $true,
        Position = 1)]        
    [string]$credential,
    
    [Parameter(
        Mandatory = $true,
        Position = 2)]        
    [string]$textinput
    
    )
         
     process{
        Enter-PSSession -ComputerName $COMPUTERNAME -Credential $credential
        
        function say-text{
            param ([Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string] $Text)
            [Reflection.Assembly]::LoadWithPartialName('System.Speech') | Out-Null   
            $object = New-Object System.Speech.Synthesis.SpeechSynthesizer
            $object.Speak($Text)
        }
        
        say-text "$textinput"
	    
        Exit-PSSession
        }
 }
