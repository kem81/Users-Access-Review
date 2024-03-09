import-csv -path (Get-ChildItem -path './FilterGitLabUsers.csv') | 
select user | 
export-csv ./GitlabUsersToBeDisabled.csv -Verbose