#Sets the Gitlab endpoint and accesstoken
$BlockUsersEndpoint = "https://gitlab-private-endpoint/api/v4/users"  
$PersonalAccessToken = $($env:Gitlab_Access_Token)
#Sets the csv to import
$UsersToBlockFile = "./GitlabUsersToBeDisabled.csv"

# Imports users from CSV
$UsersToBlock = Import-Csv -Path $UsersToBlockFile | Select-Object id
#Loops through each id and assigns it to the variable
foreach ($User in $UsersToBlock) {
    $UserID = $User.id

    try {
        Start-Transcript -Path ./scriptlog.txt
        # Blocks the users using the post method
        $BlockUserRequest = Invoke-RestMethod -Method Post -Uri "$BlockUsersEndpoint/$UserID/block" -Headers @{ "PRIVATE-TOKEN" = $PersonalAccessToken }

        Write-Host "User with ID $UserID has been blocked successfully."
        Stop-Transcript
    }
    catch {
        Write-Warning "Failed to block user with ID $UserID"
        $error | Out-File ./errors.txt -Append
    }
}
