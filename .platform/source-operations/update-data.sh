#!/usr/bin/env bash

set -e 

# This script updates the template's data.yaml file for visibility elsewhere for Platform.sh

cat >meta.py <<'END_SCRIPT'
import os
import os.path
import yaml

template_data = {"runtimes": [], "services": []}
ROOTDIR = os.getcwd()

# Get runtimes.
for directory in os.walk(ROOTDIR):
    if '.platform.app.yaml' in directory[2]:
        with open('{}/.platform.app.yaml'.format(directory[0]), 'r') as file:
            data = yaml.safe_load(file)
            runtime = {
                data["type"].split(":")[0]: {
                    "version": data["type"].split(":")[1]
                }
            }
            template_data["runtimes"].append(runtime)

# Get services.
with open('{}/.platform/services.yaml'.format(ROOTDIR), 'r') as file:
    data = yaml.safe_load(file)
    if (data is not None):
        for service in data:
            info = {
                data[service]["type"].split(":")[0]: {
                    "version": data[service]["type"].split(":")[1]
                }
            }
            template_data["services"].append(info)

# Get catalog details.
with open('{}/.platform/template.yaml'.format(ROOTDIR), 'r') as file:
    data = yaml.safe_load(file)
    repo = data["initialize"]["repository"].split("//")[1].split("@")[0].split(".git")[0]
    info = {
        "name": data["info"]["name"],
        "shortname": repo.split("platformsh-templates/")[1],
        "repo": "https://" + repo,
        "description": data["info"]["description"],
        "image": data["info"]["image"],
        "content": data["info"]["notes"][0]["content"],
        "deploy": "https://console.platform.sh/projects/create-project?template=https://raw.githubusercontent.com/{}/main/.platform/template.yaml".format(repo.split(".com/")[1])
    }
    template_data.update(info)

with open('{}/.platform/data.yaml'.format(ROOTDIR), 'w') as file:
    yaml.dump(template_data, file, indent=4, default_flow_style=False)
END_SCRIPT

python meta.py
rm meta.py
