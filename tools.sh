#!/bin/bash


createmodel() {
  # print usage if no arguments are passed
  
  if [ "$#" -lt 1 ]; then
    echo "Usage: /bin/bash ./tools.sh createmodel <model-name> [--app <app-label>] [--char <field-name>] [--text <field-name>] [-- <field-name>] [--date <field-name>] [--datetime <field-name>] [--decimal <field-name>] [--email <field-name>] [--file <field-name>] [--float <field-name>] [--image <field-name>] [--integer <field-name>] [--json <field-name>] [--uuid <field-name>]"
    exit 1
  fi

  MODEL_NAME="$1"
  shift

  APP_LABEL=""
  if [[ "$1" == "--app" ]]; then
    APP_LABEL="$2"
    shift
    shift
  fi

  APP_DIR=""
  if [ -n "$APP_LABEL" ]; then
    APP_PY="$(find . -not -path "*site-packages*" -name 'apps.py' | xargs grep -E "label *= *'$APP_LABEL'")"
    if [ -z "$APP_PY" ]; then
      echo "Error: Could not find app directory for label $APP_LABEL"
      exit 1
    fi
    APP_DIR="$(dirname "$APP_PY")"
  fi

  FIELDS=""

  while [[ $# -gt 0 ]]
  do
    case "$1" in
        --char)
            FIELDS="$FIELDS\n    $2 = models.CharField(max_length=255)"
            shift
            shift
            ;;
        --text)
            FIELDS="$FIELDS\n    $2 = models.TextField()"
            shift
            shift
            ;;
        --date)
            FIELDS="$FIELDS\n    $2 = models.DateField()"
            shift
            shift
            ;;
        --datetime)
            FIELDS="$FIELDS\n    $2 = models.DateTimeField()"
            shift
            shift
            ;;
        --decimal)
            FIELDS="$FIELDS\n    $2 = models.DecimalField(max_digits=10, decimal_places=2)"
            shift
            shift
            ;;
        --email)
            FIELDS="$FIELDS\n    $2 = models.EmailField()"
            shift
            shift
            ;;
        --file)
            FIELDS="$FIELDS\n    $2 = models.FileField()"
            shift
            shift
            ;;
        --float)
            FIELDS="$FIELDS\n    $2 = models.FloatField()"
            shift
            shift
            ;;
        --image)
            FIELDS="$FIELDS\n    $2 = models.ImageField()"
            shift
            shift
            ;;
        --integer)
            FIELDS="$FIELDS\n    $2 = models.IntegerField()"
            shift
            shift
            ;;
        --json)
            FIELDS="$FIELDS\n    $2 = models.JSONField()"
            shift
            shift
            ;;
        --uuid)
            FIELDS="$FIELDS\n    $2 = models.UUIDField()"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: /bin/bash ./tools.sh createmodel <model-name> [--app <app-label>] [--char <field-name>] [--text <field-name>] [-- <field-name>] [--date <field-name>] [--datetime <field-name>] [--decimal <field-name>] [--email <field-name>] [--file <field-name>] [--float <field-name>] [--image <field-name>] [--integer <field-name>] [--json <field-name>] [--uuid <field-name>]"
            exit 1
            ;;
    esac
  done

  if [ -z "$FIELDS" ]; then
    echo "No fields specified."
  else
    echo -e "Creating a new Django model: $MODEL_NAME\n"

  MODEL_STRING="from django.db import models\n\nclass $MODEL_NAME(models.Model):$FIELDS\n"

  if [ -z "$APP_DIR" ]; then
    echo -e "App directory not specified. Please use the --app option to specify the app label.\n"
    exit 1
  fi

  MODELS_FILE="$APP_DIR/models.py"

  if [ ! -f "$MODELS_FILE" ]; then
    touch "$MODELS_FILE"
  fi

  echo -e "$MODEL_STRING" >> "$MODELS_FILE"

  echo "Model created successfully!"
fi
}


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
  createmodel)
    createmodel "$@"
    ;;

  *)
    echo "Unknown command: $COMMAND"
    echo "Usage: /bin/bash ./tools.sh <command> [arguments]"
    exit 1
    ;;
esac
