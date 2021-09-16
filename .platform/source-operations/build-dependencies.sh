#!/usr/bin/env bash

# This script really goofs up the YAML formatting. 

bump_version () {

cat >bump.py <<'END_SCRIPT'
import sys
import yaml

latest = sys.argv[3]
if ('v' in sys.argv[3]):
    latest = sys.argv[3][1:]

with open('.platform/applications.yaml', 'r') as file:
    data = yaml.safe_load(file)
    current = data[0]['dependencies'][sys.argv[1]][sys.argv[2]]
    if (latest > current):
        data[0]['dependencies'][sys.argv[1]][sys.argv[2]] = latest
        with open('.platform/applications.yaml', 'w') as file:
            yaml.dump(data, file, indent=4, default_flow_style=True)
END_SCRIPT

python bump.py $1 $2 $3
rm bump.py

}

VERSIONS="https://api.github.com/repos/platformsh/platformsh-cli/releases/latest"
LATEST=$(curl -s https://api.github.com/repos/platformsh/platformsh-cli/releases/latest | jq -r '.tag_name')

bump_version $1 $2 $LATEST