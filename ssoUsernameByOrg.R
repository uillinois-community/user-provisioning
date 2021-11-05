#!/usr/bin/Rscript

library(ghql)
library(jsonlite)

token <- Sys.getenv("GITHUB_GRAPHQL_TOKEN")
con <- GraphqlClient$new(url = "https://api.github.com/graphql",
                         headers = list(Authorization = paste0("Bearer ", token)))

qry <- Query$new()
qry$query("account2netid", 'query query($organization: String!) {
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
} ')

vars <- list(organization = "illinois-stat447")
x <- con$exec(qry$queries$account2netid, vars)
res <- jsonlite::fromJSON(x)
sub <- res$data$organization$samlIdentityProvider$externalIdentities$edges
df <- data.frame(samlId = unname(sub$node$samlIdentity),
                 user = unname(sub$node$user))
#df <- df[order(df$samlId), ]
print( df[nchar(df[,1]) < 40,] )

if (dir.exists("../roster"))
    saveRDS(df[nchar(df[,1]) < 40,], "../roster/netid2github.rds")
