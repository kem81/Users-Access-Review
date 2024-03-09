Install-Module SQLServer -Force
Import-module SQLServer

#Defines the variables
$USER = $env:OutSystems_User
$PASS = $env:OutSystems_PWD
$UATENDPOINT = $env:outsys_endpoint
$TXT_FILES = Get-ChildItem -Path "./ExportUsers/All-OutSystems-Users.txt"

#Gets the sql query from the text file
$QUERY = Get-Content -Raw $TXT_FILES

#Connects to the sql DB and runs the query
$RESULT = Invoke-Sqlcmd -ServerInstance $UATENDPOINT -Query $QUERY -Username $USER -Password $PASS -TrustServerCertificate

#Exports the users to csv file
$RESULT | Export-Csv "./OutSystemsUsers.csv" -Append -Force