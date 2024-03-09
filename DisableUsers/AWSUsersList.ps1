#Gets all the AWS users from each CSV file and outputs to one file for review
$ErrorActionPreference = 'Continue'
$folderpath = "./"
$outputFilePath = "./AWSUsersToBeDisabled.csv"
    
# Initialize an empty array to store the values
$values = @()
    
# Loop through each CSV file in the specified folder
foreach ($file in (Get-ChildItem -Path $folderpath -Recurse -Filter "*.csv" -Exclude FilteredGitlabUsers.csv*, GitlabUsers.csv*, CredentialsReport.csv*, AllAWSUsers.csv* -Force)) {
    # Import the CSV file
    $csvData = Get-Content -Path $file.FullName
        
    # Add the values to the array
    $values += $csvData
}

# Create a new CSV file with the collected values
$values | Select-Object @{Name = 'Username'; Expression = { $_.@{n = 'Name' } } }, 'Username', 'ID', 'User Email', 'Creation Date', 'Last Login', 'Is_Active' | Export-Csv -Path $outputFilePath -NoTypeInformation -Delimiter "," 
