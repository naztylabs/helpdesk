 function Say-RemoteText {
 <#

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
        
        function remote-text{
            param ([Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string] $Text)
            [Reflection.Assembly]::LoadWithPartialName('System.Speech') | Out-Null   
            $object = New-Object System.Speech.Synthesis.SpeechSynthesizer
            $object.Speak($Text)
        }
        
        say-text "$textinput"
	    
        Exit-PSSession
        }
 }