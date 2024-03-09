try {
        Start-Transcript -Path './AWSUserScriptLog.txt'
        #Installs the required modules for the script to run
        $modules = "AWS.Tools.Installer", "AWS.Tools.Common", "AWS.Tools.IdentityManagement"
        write-host "Installing dependencies - AWS.Tools.Module"
        foreach ($module in $modules){
                write-host "Installed module" $module
                install-module $module -Force
                import-module $module 
}
        #Sets the AWS credentials to use
        Set-AWSCredential -AccessKey $($env:AWS_ACCESS_KEY_ID) -SecretKey $($env:AWS_SECRET_ACCESS_KEY) -StoreAs myCredentials
        $Date = Get-Date
        
        Set-DefaultAWSRegion eu-west-2
        Request-IAMCredentialReport -ProfileName myCredentials
        Start-Sleep -Seconds 10
        Get-IAMCredentialReport -ProfileName myCredentials -AsTextArray | Out-File ./CredentialsReport.csv
        $CredentialsReport = Import-Csv ./CredentialsReport.csv
        $myTable = @()
        foreach ($user in $CredentialsReport){
                Write-Host "Working on User" $user.user
                $row = "" | Select-Object user, PasswordEnabled, PasswordLastUsed, AccessKeyStatus1, AccessKey1LastUsed, Accesskey1LastRotated, AccessKeyStatus2, AccessKey2LastUsed, Accesskey2LastRotated 
                $row.user = $user.user
                $row.PasswordEnabled = $user.password_enabled 
                $row.PasswordLastUsed = $user.password_last_used -replace ("N/A", $date.AddDays(-40)) -replace ("no_information", $date.AddDays(-40))
                $row.AccessKeyStatus1 = $user.access_key_1_active
                $row.AccessKey1LastUsed = $user.access_key_1_last_used_date -replace ("N/A", $date.AddDays(-40))
                $row.Accesskey1LastRotated = $user.access_key_1_last_rotated -replace ("N/A", $date.AddDays(-40))
                $row.AccessKeyStatus2 = $user.access_key_2_active
                $row.AccessKey2LastUsed = $user.access_key_2_last_used_date -replace ("N/A", $date.AddDays(-40))
                $row.Accesskey2LastRotated = $user.access_key_2_last_rotated -replace ("N/A", $date.AddDays(-40))
                $myTable += $row
}
                $myTable | Export-Csv './AllAWSUsers.csv'
                Stop-Transcript
        
}
catch {
        $Error | Out-File ./errors.txt -Append -Force
}