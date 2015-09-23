# SharePoint Auto Deployment PowerShell
Configurable Oneclick SharePoint deployment powershell scripts


Solutions: This folder contains all the WSPs to be deployed by the PowerShell, Build   the solution and put latest WSP in this folder.

Sub: This folder contains the all PowerShell scripts.

Config.xml: This is a XML configuration file used by PowerShell installer, please confirm the URLs and Account details provided in this XML, for more details refer to attached word docx file.

deploy.ps1: This is a PowerShell scripts which to deploy the WSPs to the farm.

configure.ps1: This is a PowerShell scripts which to deploy the WSPs to the farm.
       
Installation:

      a.      User with appropriate permissions can open the Windows PowerShell console.
      b.      Navigate to the package folder and run the 1deploy.ps1
      c.      Once 1deploy.ps1 completes the execution successfully close the Windows PowerShell console and reopen it again.
      d.      Navigate to the package folder and run the 2configure.ps1
      e.      Successful execution of the 2configure.ps1 completes the installation.
