try {
    Start-Transcript -Path ./scriptlog.txt
    $Date = (Get-Date).AddDays(-30)
    $GitlabUsers = Import-Csv './GitlabUsers.csv' |
    where { ($_.Last_SignIn -as [datetime] -lt $Date) } | select user | 
    Export-Csv ./FilteredGitlabUsers.csv
    Stop-Transcript
}
catch {
    $error | out-file ./errors.txt
}