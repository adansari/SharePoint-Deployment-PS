# SharePoint-Deployment-PS
Configurable Oneclick SharePoint deployment powershell scripts


PowerShell Config XML Nodes:
1. Solutions  
Solution
ID – Name of the WSP file which need to be deployed.
PATH – Physical path for WSP file where needs to be deployed.
WEBAPP – URL of the web application where WSP will be deployed.

2. Webapps (All the Web apps must exist before the execution of this script)
Webapp 
URL – Web application URL

Features / Feature
ID – Unique id for the feature to be deployed
Name – Name of the feature
Mode – contains value “act” or “skip” defined whether feature need to be activated or skipped. Default is “act”

Sites / Site (Site collections will be created by script and will confirm to overwrite incase if it’s already exists)
TITLE   – Title of the site collection
URL     –  URL for the site collection
ADMIN – Account name for the admin of the site 
Temp   – Template type for site which need to be created for
               
Features / Feature
ID – Unique id for the feature to be deployed.
Name – Name of the feature.
Mode – contains value “act” or “skip” defined whether feature need to be activated or skipped. Default is “act”.

Webs / Web (Sub sites will be created by script and will confirm to overwrite incase if it’s already exists)
Title – Title of the sub site.
URL – Relative URL for the sub site if any. 
HOMEPAGE – Relative URL for the page which will be set as HOME PAGE for the Sub site
TEMP – Template type for site which need to be created for e.g. Publishing site / Team site etc.

Propertybag / Property (InnerXML of this tag will contain “Value” for the key )
Key – “key” name for the property to be added.

Features / Feature
ID – Unique id for the feature to be deployed.
Name – Name of the feature.
Mode – contains value “act” or “skip” defined whether feature need to be activated or skipped. Default is “act”.
