#!/bin/bash

# Function to validate directory argument
validate_dir() {
  if [[ ! -d "$1" ]]; then
    echo "Error: '$1' is not a directory."
    exit 1
  fi
}

# Collect directory argument
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Validate directory
validate_dir "$1"

# Directory path
dir="$1"

# File name (replace with your desired filename)
filename="wildfly-ds.xml"

# Full file path
filepath="$dir/$filename"

# Create the file
cat << EOF > "$filepath"
<datasources xmlns="http://www.jboss.org/ironjacamar/schema/datasources_1_1.xsd">
  <datasource enabled="true" jndi-name="${JNDI_NAME}" pool-name="${POOL_NAME}" use-java-context="true">
    <connection-url>${CONNECTION_URL}</connection-url>
    <driver-class>${DRIVER_CLASS}</driver-class>
    <driver>${DRIVER}</driver>
    <security>
      <user-name>${DB_USER}</user-name>
      <password>${DB_PASSWORD}</password>
    </security>
  </datasource>
</datasources>
EOF

# Informative message
echo "File '$filepath' created with placeholders for environment variables."

# Optional: Prompt user to edit the file for specific replacements
# read -p "Would you like to use specific values instead of environment variables? (y/N) " -n 1 -r
# if [[ $REPLY =~ ^[Yy]$ ]]; then
#   # Open the file in a text editor for manual adjustments
#   nano "$filepath"
# fi

