# User Provisioning
Documentation, scripts, and related information regarding user provisioning in GitHub

## Scripts
### github_invite.pl
**github_invite.pl** is a simple perl script that invites users to an organization using the GitHub API and a personal access token

>example commands:  
>github_invite.pl -user=clhawk -token=SECRET_TOKEN -email=c_l_hawk@yahoo.com -org_name=UOFITestOrg1  
>github_invite.pl -user=clhawk -token=SECRET_TOKEN -file=invitations.csv  
>
>The **-role** parameter is optional with inputs of either admin (owner) or direct_member (member).  This defaults to direct_member if unspecified.
>
>Alternatively, the **-file** parameter can be given with a comma separated file of invitations to send out.  This file would need to be in the format of *email,org_name,role*  
>
>Basic API call:  
>curl -u "*username*:*personal_token*" -X POST -H "Accept: application/vnd.github.v3+json" https://api.github.com/orgs/ORG_NAME/invitations -d '{"email":*email*,"role":*role*}'
>
>More detailed information on this API can be found at: https://docs.github.com/en/free-pro-team@latest/rest/reference/orgs#create-an-organization-invitation

### ssoUsernameByOrg.py
**ssoUsernameByOrg.py** is a python3 script to run a graphQL query to GitHub to receive a list of users in the organization and their SSO identity.

Pre-requisite installs
>pip3 install -r requirements.txt

Put your Personal Access Token in a `GITHUB_TOKEN` environment variable, or in a `.env` file

Usage
> python3 ssoUsernameByOrg.py GitHubOrganizationName

Returns
CSV of `githubUsername,SsoIdentity`
