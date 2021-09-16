
Some thoughts:

- Create PR on push to updates branch https://github.com/chadwcarlson/action-testing
- Tests examples (Lando): https://github.com/lando/lando/tree/main/.github/workflows
- Trigger additional workflows: (with data) https://dev.to/mattbloomfield/automate-pull-request-testing-using-cypress-dashboard-github-actions-and-platform-sh-22m 
- consider major version upstreams
- consider a lack of upstream (do we really want to keep these? just dep updates at that point)

Should include:

- upstream
- dependencies
- build dependencies
- infrastructure
- common documentation
- github token refresh on integrations
- updates to a common changelog
- tagging
- auto merging updates branch on passed tests

Some of these will be Source operations, others will be github actions, or combination of both. It would also be great to include activity scripts with these for our own monitoring and as an example, which would fall under (common). In those cases we would just use an action to look for upstream updates, and then update the project's activity script. 

Remember: doesn't work on Pull request environments.

Forwarding logs to integration/elsewhere.

```
Data in the activity: platform project:curl environments/files-ops/activities/wlu5pp6umglzs
Streaming logs for act: platform project:curl activities/wlu5pp6umglzs/log?max_items=0&max_delay=1000&start_at=0
```

Notes:

- This doesnt really handle the `files` directory or patches. For example, I'm losing the README file. 

```python
from .remote import RemoteProject

class Gatsby(RemoteProject):
    upstream_branch = "master"
    remote = 'https://github.com/gatsbyjs/gatsby-starter-blog.git'

    # Keeps package-lock.json out of repo. See notes.md (Yarn - Overwriting updateCommands) for more details.
    updateCommands = {
        'package.json': 'yarn upgrade'
    }
```

```
source:
    operations:
        upstream-update:
            command: |
                set -e
                git remote add upstream $UPSTREAM_REMOTE
                git fetch --all
                git merge upstream/master
```

```
source:
    operations:
        update:
            command: |
                npm update
                git commit -am "Update npm dependencies"
```

```
source:
   operations:
       update-wordpress:
           command: |
               set -e

               # Open a tunnel to the current environment, which allows us to get database credentials.
               ENVIRONMENT=$(git rev-parse --abbrev-ref HEAD)
               platform tunnel:open -p $PLATFORM_PROJECT -e $ENVIRONMENT -y

               # Export the relationships object and then our database credentials to the environment.
               export PLATFORM_RELATIONSHIPS="$(platform tunnel:info --encode)"
               export DB_NAME=$(echo $PLATFORM_RELATIONSHIPS | base64 --decode | jq -r ".database[0].path")
               export DB_HOST=$(echo $PLATFORM_RELATIONSHIPS | base64 --decode | jq -r ".database[0].host")
               export DB_PORT=$(echo $PLATFORM_RELATIONSHIPS | base64 --decode | jq -r ".database[0].port")
               export DB_USER=$(echo $PLATFORM_RELATIONSHIPS | base64 --decode | jq -r ".database[0].username")
               export DB_PASSWORD=$(echo $PLATFORM_RELATIONSHIPS | base64 --decode | jq -r ".database[0].password")
               export DB_HOST=$DB_HOST:$DB_PORT

               # Update WordPress with the WP CLI.
               wp core --path=$PLATFORM_SOURCE_DIR/wordpress update
               wp plugin --path=$PLATFORM_SOURCE_DIR/wordpress update-all
               wp theme update --path=$PLATFORM_SOURCE_DIR/wordpress --all

               # Stage changes, committing only when updates are available.
               git add .
               STAGED_UPDATES=$(git diff --cached)
               if [ ${#STAGED_UPDATES} -gt 0 ]; then
                   git commit -m "Gloriously autoupdated Wordpress."
               else
                   echo "No WordPress updates found."
               fi
              
               # Close the connection.
               platform tunnel:close -y
```


```
platform variable:create --environment files-ops --level environment --sensitive true --json false --visible-build true --name env:PLATFORMSH_CLI_TOKEN --value YOUR_API_TOKEN
```