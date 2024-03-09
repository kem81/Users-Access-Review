function Remove-SA {
    param (
        [string[]]$users
    )

    $list = "root", "service", "terraform", "deploy", "pentest", "deployment"
    
    $pattern = ($list | ForEach-Object { [regex]::Escape($_) }) -join '|'
    $filteredUsers = $users | Where-Object { $_ -notmatch $pattern }

    if ($filteredUsers.Count -gt 0) {
        $filteredUsers | ForEach-Object {
            $_ | Out-File './UsersAccessKey2B.csv' -Append
        }
    }
}
try {
    $Date = (Get-Date).AddDays(-30)
    Start-Transcript -Path './functionscripterrors.txt'

    $data = Import-Csv "./AllAWSUsers.csv"
    
    $usernames = $data | Where-Object {
        $_.PasswordEnabled -eq "FALSE" -and
        $_.PasswordLastUsed -as [datetime] -lt $Date -and
        $_.AccessKeyStatus2 -eq "TRUE" -and
        $_.AccessKey2LastUsed -as [datetime] -lt $Date -and
        $_.Accesskey2LastRotated -as [datetime] -lt $Date} | Select-Object -ExpandProperty User
        
    Remove-SA -users $usernames

    Stop-Transcript
}
catch {
    $_ | Out-File './Function_Errors.txt'
}