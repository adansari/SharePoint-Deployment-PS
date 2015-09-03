$SnapInName = "Microsoft.SharePoint.PowerShell"

#Get the Microsoft.Sharepoint.Powershell snapin
if ( (Get-PSSnapin -Name $SnapInName -ErrorAction SilentlyContinue) -eq $null )
{
	Add-PsSnapin $SnapInName
	Write-Host $("PowerShell SnapIn '" + $SnapInName + "' has been loaded") -ForeGroundColor Green
}
else
{
	Write-Host $("PowerShell SnapIn '" + $SnapInName + "' was already loaded") -ForeGroundColor Green
}
