Import-Module \\fso\core\Scripts\include\Get_Functions.psm1
Import-Module \\fso\core\Scripts\include\FSOAD_Functions.psm1
Import-Module \\FSO0360\C$\Users\latylernazifi\Documents\PowerShell\Data.psm1

Function HelpDesk{
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.AutoSize                   = $true
$Form.ClientSize                 = '600,500'
$Form.text                       = "HelpDesk Functions"
$Form.TopMost                    = $false

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Request Data from Computer:"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(38,33)
$Label1.Font                     = 'Microsoft Sans Serif,10'

$RESET                           = New-Object system.Windows.Forms.Button
$RESET.text                      = "Reset"
$RESET.width                     = 88
$RESET.height                    = 43
$RESET.location                  = New-Object System.Drawing.Point(450,75)
$RESET.Font                      = 'Microsoft Sans Serif,10'

$SCT                             = New-Object system.Windows.Forms.Button
$SCT.text                        = "SCT-Desktop"
$SCT.width                       = 156
$SCT.height                      = 42
$SCT.location                    = New-Object System.Drawing.Point(39,101)
$SCT.Font                        = 'Microsoft Sans Serif,10'

$SAD                             = New-Object system.Windows.Forms.Button
$SAD.text                        = "Search-AD"
$SAD.width                       = 88
$SAD.height                      = 43
$SAD.location                    = New-Object System.Drawing.Point(216,100)
$SAD.Font                        = 'Microsoft Sans Serif,10'

$Data                            = New-Object system.Windows.Forms.Button
$Data.text                       = "Get-Data"
$Data.width                      = 105
$Data.height                     = 42
$Data.location                   = New-Object System.Drawing.Point(321,100)
$Data.Font                       = 'Microsoft Sans Serif,10'

$SCTL                            = New-Object system.Windows.Forms.Button
$SCTL.text                       = "SCT-Laptop"
$SCTL.width                      = 126
$SCTL.height                     = 51
$SCTL.location                   = New-Object System.Drawing.Point(98,172)
$SCTL.Font                       = 'Microsoft Sans Serif,10'

$RDP                             = New-Object system.Windows.Forms.Button
$RDP.text                        = "RDP"
$RDP.width                       = 109
$RDP.height                      = 51
$RDP.location                    = New-Object System.Drawing.Point(271,172)
$RDP.Font                        = 'Microsoft Sans Serif,10'

$ComputerText                    = New-Object system.Windows.Forms.TextBox
$ComputerText.multiline          = $false
$ComputerText.width              = 389
$ComputerText.height             = 20
$ComputerText.Text               = ''
$ComputerText.location           = New-Object System.Drawing.Point(38,58)
$ComputerText.Font               = 'Microsoft Sans Serif,10'

$DataBox                         = New-Object system.Windows.Forms.TextBox
$DataBox.multiline               = $true    
$DataBox.text                    = ''
$DataBox.AutoSize                = $true
$DataBox.ScrollBars              = "Vertical"
$DataBox.Size                    = New-Object System.Drawing.Size(500,250)
$DataBox.location                = New-Object System.Drawing.Point(50,250)
$DataBox.Font                    = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($Label1,$Reset,$SCT,$SAD,$Data,$SCTL,$RDP,$ComputerText, $DataBox))

    $SCT.Add_MouseClick({  
        Set-ComputerTemplate -ComputerName $ComputerText.Text -Template D
        $DataBox.Text = 'ComputerTemplate of {0} has been updated to Desktop.' -f $ComputerText.Text
    })

    $SAD.Add_MouseClick({  
        $DataBox.Text = Search-AD $ComputerText.Text | Select-Object Description, DistinguishedName, Name, SamAccountName | Format-List -Property Description,DistinguishedName,Name,SamAccountName | Out-String
    })

    $Data.Add_MouseClick({  
        $DataBox.Text = get-data -ComputerName $ComputerText.Text 
    })

    $SCTL.Add_MouseClick({  
        Set-ComputerTemplate -ComputerName $ComputerText.Text -Template L
        $DataBox.Text = 'ComputerTemplate of {0} has been updated to Laptop/Tablet/Mobile.' -f $ComputerText.Text
    })

    $RDP.Add_MouseClick({  
        RDPME $ComputerText.Text
    })

    $Reset.Add_MouseClick({
        $DataBox.Text = ''
        $ComputerText.Text = ''
    })

    $Form.ShowDialog()
}

HelpDesk
