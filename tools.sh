#!/bin/bash

createapp() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: /bin/bash ./tools.sh createapp <app-name> [--ai settings-file-path]"
    exit 1
  fi

  APP_NAME=$1
  APP_DIR="apps/$APP_NAME"
  DJANGO_APP_NAME="apps.$APP_NAME"

  # Capitalize the first letter of the app name
  APP_NAME_CAP="$(tr '[:lower:]' '[:upper:]' <<< "${APP_NAME:0:1}")${APP_NAME:1}"

  echo "Creating a new Django app: $APP_NAME in directory: $APP_DIR with app name: $DJANGO_APP_NAME and label: $APP_NAME"

  # Create the app directory and run startapp
  mkdir -p $APP_DIR
  django-admin startapp $APP_NAME $APP_DIR

  # Replace the default AppConfig class in the apps.py file
  APP_CONFIG="from django.apps import AppConfig\n\n\nclass ${APP_NAME_CAP}Config(AppConfig):\n    default_auto_field = 'django.db.models.AutoField'\n    name = '$DJANGO_APP_NAME'\n    label = '$APP_NAME'"

  echo -e $APP_CONFIG > $APP_DIR/apps.py

  # Add the app to INSTALLED_APPS in settings.py if the --ai flag is set
  if [ "$#" -eq 3 ] && [ "$2" == "--ai" ]; then
    SETTINGS_FILE="$3"
    echo "Adding $DJANGO_APP_NAME to INSTALLED_APPS in $SETTINGS_FILE"
    awk -v app="$DJANGO_APP_NAME" 'BEGIN { in_installed_apps = 0 } /INSTALLED_APPS = \[/ { in_installed_apps = 1 } in_installed_apps && /\]/ { print "    \x27" app "\x27," }; { print } /INSTALLED_APPS = \[/ { getline; print } /]/ { in_installed_apps = 0 }' $SETTINGS_FILE > "$SETTINGS_FILE.tmp"
    mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
    echo "$DJANGO_APP_NAME added to INSTALLED_APPS."
  fi

  echo "App created successfully!"
  
}

# Add more functions for other commands here

if [ "$#" -eq 0 ]; then
  echo "Usage: /bin/bash ./tools.sh <command> [arguments]"
  exit 1
fi

COMMAND="$1"
shift

case "$COMMAND" in
  createapp)
    createapp "$@"
    ;;
  # Add more cases for other commands here
  *)
    echo "Unknown command: $COMMAND"
    echo "Usage: /bin/bash ./tools.sh <command> [arguments]"
    exit 1
    ;;
esac
