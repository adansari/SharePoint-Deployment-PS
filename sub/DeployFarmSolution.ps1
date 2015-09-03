# Deploy Farm Solutions
#
# Description
# -----------
# Deploy farm solutions from the provided XmlElement with WebApp information
#
# Command line arguments
# ----------------------
# xmlElement: XML element containing WebApplication configuration parameters

Param([xml.XmlElement]$xmlElement)

if($xmlElement -eq $null)
{
	Write-Host "No global farm solutions have been defined in the script. Skipping step." -ForeGroundColor Green
	exit
}


$solution_path = ".\solutions"

# Function for waiting until a solution deployment TimerJob has finished
function WaitForJobToFinish([string]$SolutionFileName, [string]$solutionId)
{ 	
	# A TimerJob may exist in the format "solution-deployment-<wspname>" or "solution-deployment-<first 25 chars of wspname>-<solutionguid>-0"
	$JobName1 = "solution-deployment-$SolutionFileName*"
	$JobName2 = "solution-deployment-*-$solutionId-?"

	# Check if a TimerJob exits with one of the above formats
	if($solutionId -ne $null)
	{
		$job = Get-SPTimerJob | Where { ($_.Name -like $JobName1) -or ($_.Name -like $JobName2) }
	}
	else
	{
		$job = Get-SPTimerJob | Where { ($_.Name -like $JobName1) }
	}
	if ($job -ne $null) 
	{		       
		# Wait for the TimerJob to be removed so we know it's done deploying the solution package
		while ((Get-SPTimerJob $job.Name) -ne $null) 
		{
			Write-Host . -NoNewLine -ForeGroundColor Green
			Start-Sleep -Seconds 2
		}
	}
	Write-Host "DONE"
}

Foreach($sol in $xmlElement.solution)
{    
	$existing_sol=Get-SPSolution | Where {$_.Name -eq $sol.id}
	$sol_item = Get-ChildItem -Path $solution_path | Where {$_.Name -eq $sol.id }	
	
	# if solution doesnt exists in farm
	if($existing_sol -eq $null)
	{      
		#if solution exists in file system
		if($sol_item -ne $null)
		{
			Write-Host "Adding farm solution" $sol.id "..."  -NoNewLine -ForegroundColor Green
			
			$new_sol = Add-SPSolution -LiteralPath $sol_item.FullName
            
            if($sol.webapp -eq $null -or $sol.webapp -eq '')
            {
                Install-SPSolution -Identity $sol.id -GACDeployment:$true -Force:$true | Out-Null
            }
            else
            {
                Install-SPSolution -Identity $sol.id -GACDeployment:$true -Force:$true –WebApplication:$sol.webapp | Out-Null
            }
			
			WaitForJobToFinish $new_sol $new_sol.SolutionId
			
		}
		else
		{
			Write-Host "Farm solution" $sol.id "does not exists in folder" $solution_path -ForegroundColor Red
		}
	}
	else
	{
		
		#if solution exists in file system
		if($sol_item -ne $null)
		{		
			if($sol.webapp -eq $null -or $sol.webapp -eq '')
            {
                Write-Host "Retracting farm solution" $sol.id "..." -NoNewLine -ForegroundColor Green
            
			    Uninstall-SPSolution -Identity $sol.id  -Confirm:$false -ErrorAction:SilentlyContinue

			    WaitForJobToFinish $sol.id $existing_sol.SolutionId
			
		        Remove-SPSolution -Identity $sol.id -Confirm:$false
			
			    Write-Host "Adding farm solution" $sol.id "..." -NoNewLine -ForegroundColor Green
			
			    $new_sol = Add-SPSolution -LiteralPath $sol_item.FullName
                
                Install-SPSolution -Identity $sol.id -GACDeployment:$true -Force:$true | Out-Null
            }
            else
            {
                
                Write-Host "Retracting farm solution" $sol.id "..." -NoNewLine -ForegroundColor Green
            
			    Uninstall-SPSolution -Identity $sol.id -AllWebApplications:$true  -Confirm:$false -ErrorAction:SilentlyContinue

			    WaitForJobToFinish $sol.id $existing_sol.SolutionId
			
		        Remove-SPSolution -Identity $sol.id -Confirm:$false
			
			    Write-Host "Adding farm solution" $sol.id "..." -NoNewLine -ForegroundColor Green
			
			    $new_sol = Add-SPSolution -LiteralPath $sol_item.FullName
                
                Install-SPSolution -Identity $sol.id -GACDeployment:$true -Force:$true –WebApplication:$sol.webapp | Out-Null
            }

			WaitForJobToFinish $new_sol $new_sol.SolutionId
		}
		else
		{
			Write-Host "Farm solution" $sol.id "does not exists in folder" $solution_path -ForegroundColor Red
		}
	}
}