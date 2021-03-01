Import-Module activedirectory

function modelexport{
<#
	.Synopsis
		Quickly query all online domain-joined machines and store sorted information on them. 
	.Description
		This command searches all of Active Directory and pulls information from all availble and online machines. It stores that information into a CSV file called ModelExport.
		After the command has run once, it will check if any computers were unable to be contacted. It will then attempt to contact only those computers and add any new information
		into the CSV file. Finally, the command will sort the ModelExport file into a new CSV called SortedExport. 
	.Example
		PS C:\>modelexport
	.Notes
		Created by Nazty_Labs - 03/1/2021
#>

## Create an object of all AD Computers.
$ADComputers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
Write-Host("Running pass 1 of 2...") -ForegroundColor Green
	foreach ($ComputerName in $ADComputers){
		## Test connection to the AD Computer, if successful request model information from the machine.
		if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
			
			## Create two objects for gathering Name, Model, Manufacturer and Serial number information.
			$CompID = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $ComputerName -ErrorAction Ignore | Select-Object Name,Model,Manufacturer
			$ModelID = Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName -ErrorAction Ignore | Select-Object SerialNumber
			
			$clientRecordObject = New-Object psobject -Property @{
				Name = $ComputerName
				Model = $CompID.Model
				Manufacturer = $CompID.Manufacturer
				Serial = $ModelID.SerialNumber
			}

			## Export the record into a CSV, appending the file each time as to not overwrite.
			$clientRecordObject | Export-Csv -path C:\temp\modelexport.Csv -Append
		}
		## If connection fails, add the AD Computer number to a CSV called failedexport
		else {
			ForEach-Object {
				$FailedComputerObject = New-Object psobject -Property @{
					Name = $ComputerName
				}
			}
			$FailedComputerObject | Export-Csv -path C:\temp\failedexport.Csv -Append -ErrorAction Ignore
		}
	}
	
	## If computers were failed to be contacted, rerun the command using only the failed computers.
	if(Test-Path -Path C:\temp\failedexport.Csv -PathType Leaf){
		
		Write-Host("Some computers may not have been contacted - Retrying") -ForegroundColor Yellow
		Write-Host("Initiate cooldown: 15 seconds...") -ForegroundColor Red
		Start-Sleep -Seconds 15
		
		Write-Host("Running pass 2 of 2...") -ForegroundColor Green
		
		$FailedComputers = Import-CSV -path C:\temp\failedexport.Csv |
		Group-Object name|
		ForEach-Object($_.Group | Select-Object Name){
			$ComputerName = Import-CSV -path C:\temp\failedexport.csv | Select-Object Name
			
			## Retry connection to the machine.
			if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
			
			$CompID = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $ComputerName -ErrorAction SilentlyContinue | Select-Object Name,Model,Manufacturer
			$ModelID = Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName -ErrorAction SilentlyContinue | Select-Object SerialNumber
			
				$clientRecordObject = New-Object psobject -Property @{
					Name = $ComputerName
					Model = $CompID.Model
					Manufacturer = $CompID.Manufacturer
					Serial = $ModelID.SerialNumber
				}
			
			$clientRecordObject | Export-Csv -path C:\temp\modelexport.Csv -Append	
			
			}
		}
		
		Write-Host("File will be sorted for export...")

		## Sort the modelexport CSV and export it as SortedExport.CSV
		$SortExport = import-csv C:\temp\modelexport.csv
		$SortExport | Sort-Object [datetime]entrydate | Group-Object Serial | Foreach-Object {$_.Group | Select-Object -Last 1} | export-csv c:\temp\sortedexport.csv -NoTypeInformation

		Write-Host("File saved as c:\temp\sortedexport.csv")
		Write-Host("Please clean up temp folder before running again.")
	}

	## If all computers in the domain were contacted, end program.
	else {
		Write-Host("Command completed successfully. Clean up temp folder before running again.")
	}
}

