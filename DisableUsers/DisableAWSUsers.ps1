try {
    Start-Transcript -Path ./scriptlog.txt
    #Imports users csv
    $users = Import-Csv ./AWSUsersToBeDisabled.csv
    #Loops through each user and removes there aws console password
    foreach ($user in $users) {
        Write-Output "Processing user: $($user.Users)"

        # Removes the AWS console password for each user here
        Remove-IAMLoginProfile -UserName $user.UserName
        Write-Output "AWS console password for $($user.Username) has been removed"
    }

    Stop-Transcript
}
catch {
    $error | Out-File ./errors.txt -Append
}


