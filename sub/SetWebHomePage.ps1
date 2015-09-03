# Set Web Home Page
#
# Description
# -----------
# Set the Web welcome page
#
# Command line arguments
# ----------------------
# webUrl: url of web
# pageUrl: url of page
Param([string]$webUrl, [string]$pageUrl)

if($webUrl -eq $null -or $webUrl -eq '')
{
	# No web url provided to set Home page
	exit
}

if($pageUrl -eq $null -or $pageUrl -eq '')
{
	# No page url provided to set as Home page
	exit
}

$web=Get-SPWeb -Identity "$webUrl"

if($web -ne $null)
{
    Write-Host "Setting the web home page as: " -ForegroundColor Green -NoNewline 
    $rootFolder=$web.RootFolder
    $rootFolder.WelcomePage= $pageUrl
    $rootFolder.Update()

    Write-Host $web.RootFolder.WelcomePage "...Done" -ForegroundColor Green 
    
    if($web -ne $null){$web.Dispose()}
}