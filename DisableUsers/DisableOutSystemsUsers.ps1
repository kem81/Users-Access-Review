# Defines the variables
$csvFilePath = "./OutSystemsUsers.csv"
$USER = $env:OutSystems_User
$PASS = $env:OutSystems_PWD
$serverName = "REMOVED FOR SECURITY"
$databaseName = "REMOVED FOR SECURITY"
$sqlQuery = "UPDATE dbo.users_db SET IsActive = 0 WHERE UserName = @UserName"
#imports the csv file
$users = Import-Csv -Path $csvFilePath
#Loop through each user from the csv and disable 
foreach ($user in $users) {
    $userName = $user.UserName
   
    $sqlParams = @{
        "UserName" = $userName
    }

    try {
        Start-Transcript -Path ./scriptlog.txt
      
        Invoke-Sqlcmd -ServerInstance $serverName -Database $databaseName -Query $sqlQuery -Username $USER -Password $PASS -Verbose -ErrorAction Stop -Parameter $sqlParams
        Write-Host "User '$userName' disabled successfully." | Export-Csv ./DisabledOSUsers.csv
    }
    catch {
        Write-Error "Error disabling user '$userName': $_"
        $error | Out-File ./errors.txt -Append
    }
}