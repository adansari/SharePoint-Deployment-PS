# Retract Remove Farm Solutions
#
# Description
# -----------
# Retract and remove farm solutions from the provided XmlElement with WebApp information
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
	
	# if solution exists in farm
	if($existing_sol -ne $null)
	{
			
			if($sol.webapp -eq $null -or $sol.webapp -eq '')
            {
                Write-Host "Retracting farm solution" $sol.id "..." -NoNewLine -ForegroundColor Green
            
			    Uninstall-SPSolution -Identity $sol.id  -Confirm:$false -ErrorAction:SilentlyContinue

			    WaitForJobToFinish $sol.id $existing_sol.SolutionId
			
		        Remove-SPSolution -Identity $sol.id -Confirm:$false

            }
            else
            {
                
                Write-Host "Retracting farm solution" $sol.id "..." -NoNewLine -ForegroundColor Green
            
			    Uninstall-SPSolution -Identity $sol.id -AllWebApplications:$true  -Confirm:$false -ErrorAction:SilentlyContinue

			    WaitForJobToFinish $sol.id $existing_sol.SolutionId
			
		        Remove-SPSolution -Identity $sol.id -Confirm:$false
            }
	}
}