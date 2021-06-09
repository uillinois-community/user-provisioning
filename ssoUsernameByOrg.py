#! /usr/bin/python3
#
# Pre-reqs:
#    pip3 install -r requirements.txt
#
# Usage: python3 ssoUsernameByOrg github-organization-name
#
# Returns CSV of    GithubUsername,netid@illinois.edu
#
# Set GITHUB_TOKEN environment variable (or .env file) to your personal access token
#
from github import Github
import requests
import json
import argparse

from pprint import pprint
from dotenv import load_dotenv

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('org')
args = arg_parser.parse_args()

load_dotenv()
token = os.getenv('GITHUB_TOKEN', '...')

g = Github(token)

query = """
query($organization: String!) {
  organization(login: $organization) {
    samlIdentityProvider {
      ssoUrl,
      externalIdentities(first: 100) {
        edges {
          node {
            guid,
            samlIdentity {
              nameId
            }
            user {
              login
            }
          }
        }
      }
    }
  }
}"""

variables = {
    'organization': args.org,
}

headers = {
    'authorization': 'bearer ' + token,
    'content-type': 'application/json'
}

r = requests.post('https://api.github.com/graphql',
        json={'query': query, 'variables': variables}, headers=headers)
#pprint(r.json())

out_j = r.json()

for node in out_j["data"]["organization"]["samlIdentityProvider"]["externalIdentities"]["edges"]:
    username = node["node"]["user"]["login"]
    samlId = node["node"]["samlIdentity"]["nameId"]
    print("{},{}".format(username, samlId))
