$AccessToken = $($env:Gitlab_Access_Token)
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Bearer $AccessToken")
$pages = $null
$response1 = Invoke-RestMethod 'https://gitlab-private-endpoint/api/v4/users?active=true' -Method 'GET' -Headers $headers -ResponseHeadersVariable 'pages' 

#gets the current date
$date = Get-Date

#Sets a array list to store the users
$table = @()

#sets the total pages from the api response to a variable 
$value = ($pages).'x-total-pages'

#gets each user from the total amount of pages from the api response
for ($i = 1; $i -le [int]::Parse($value); $i++) {
    <# Action that will repeat until the condition is met #>
    #invokes a GET method on the Gitlab API - Can be modified for different data
    $response2 = Invoke-RestMethod "https://gitlab-private-endpoint/api/v4/users?active=true&page=$i" -Method 'GET' -Headers $headers
    
    
    #Creates table headers and adds each value from the api result to the table
    foreach ($user in $response2) {
        $row = "" | Select-Object user, State, Last_SignIn, id
        $row.user = $user.name
        $row.State = $user.state
        $row.Last_SignIn = $user.last_activity_on
        $row.id = $user.id
        $table += $row
    
    }
}

#Exports the table to a CSV
$table | Export-Csv './GitlabUsers.csv' -Force