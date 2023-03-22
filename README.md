# Django App Creator Script

This repository contains a Bash script to automate the process of creating a new Django app within a project, with the option to add the app to the `INSTALLED_APPS` list in a specified settings file.

# Tools

## Create New App

```bash
/bin/bash ./tools.sh createapp <app-name> [--ai <settings-file-path>]
```

### Arguments

`<app-name>`: The name of the Django app you want to create. This should be a valid Python identifier.
`--ai`: (Optional) Pass this flag if you want to add the new app to the INSTALLED_APPS list in the specified settings file.
`<settings-file-path>`: (Optional) The path to the settings file where the new app should be added to the INSTALLED_APPS list. This argument is required if the --ai flag is used.

### Example

Create a new Django app named user_dashboard and add it to the INSTALLED_APPS list in the config/settings.py file:

```bash
/bin/bash ./tools.sh createapp user_dashboard --ai 'config/settings.py'
```

### License

This project is open source and available under the MIT License.

