# Users-Access-Review
Automation scripts to export users from AWS, Gitlab and OutSystems for quarterly review. Runs in a Gitlab pipeline on a schedule.

This projects goal was to part automate the quarterly user access review.

The solution is centralised, automated, secure and significantly reduces the overall time it takes to complete a user review. The process will have one centralised system where the reviewer can login and review access for AWS, OutSystems and GitLab.

The solution includes several scripts that are run on a schedule currently set to a quarterly basis and organised in a GitLab pipeline. The pipeline includes several stages where the scripts are run against all the listed platforms to provide a list of users that have not logged in to that system for a period exceeding 30 days. The last phase of the pipeline is configured to be initiated manually after the reviewer's assessment of users (in a CAB meeting and approval).
