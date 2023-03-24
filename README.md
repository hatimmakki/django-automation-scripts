# Django App Creator Script

This repository contains a Bash script to automate the process of creating a new Django app within a project, with the option to add the app to the `INSTALLED_APPS` list in a specified settings file.

# Tools

## `createapp` Command

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

## `createmodel` Command

The createmodel command is a shell script function used to create or update Django models with specified fields. It allows you to automate the process of creating or updating models in your Django project.

```bash
/bin/bash ./tools.sh createmodel <model-name> [--app <app-label>] [--char <field-name>] [--text <field-name>] [--date <field-name>] [--datetime <field-name>] [--decimal <field-name>] [--email <field-name>] [--file <field-name>] [--float <field-name>] [--image <field-name>] [--integer <field-name>] [--json <field-name>] [--uuid <field-name>]
```

### Arguments

<model-name>: The name of the Django model to create or update.

- [--app <app-label>]: (Optional) The label of the Django app where the model should be created or updated. If not provided, the script will search for the app with the specified label in your project.
Field options: For each field you want to add to the model, you can use one of the following options followed by the desired field name:
- [--char <field-name>]: Create a CharField with a maximum length of 255 characters.
- [--text <field-name>]: Create a TextField.
- [--date <field-name>]: Create a DateField.
- [--datetime <field-name>]: Create a DateTimeField.
- [--decimal <field-name>]: Create a DecimalField with a maximum of 10 digits and 2 decimal places.
- [--email <field-name>]: Create an EmailField.
- [--file <field-name>]: Create a FileField.
- [--float <field-name>]: Create a FloatField.
- [--image <field-name>]: Create an ImageField.
- [--integer <field-name>]: Create an IntegerField.
- [--json <field-name>]: Create a JSONField.
- [--uuid <field-name>]: Create a UUIDField.

### Example

To create a new model named UserProfile with an email field, a username field, and a date_of_birth field in an app with the label user_dashboard, run the following command:

```bash
/bin/bash ./tools.sh createmodel UserProfile --app user_dashboard --email email --char username --date date_of_birth
```



### License

This project is open source and available under the MIT License.

