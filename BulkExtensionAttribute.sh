#!/bin/bash

# JAMF Pro URL and API credentials
JAMF_URL="https://your-jamf-url.com"
API_USER="your-api-username"
API_PASS="your-api-password"

# Bearer token generation
JAMFAPIToken=$(curl -X POST -u "$API_USER:$API_PASS" -s "$JAMF_URL/api/v1/auth/token" | plutil -extract token raw -)

# Target group and extension attribute details
GROUP_ID="your-target-group-id"
EXTENSION_ATTRIBUTE_ID="extension-attribute-id"
EXTENSION_ATTRIBUTE_VALUE="assigned-value"

# Function to get the list of computers in the group
get_computers_in_group() {
    curl -X GET -H "Authorization: Bearer $JAMFAPIToken" -s "$JAMF_URL/JSSResource/computergroups/id/$GROUP_ID" -H "accept: text/xml" |
        xmllint --xpath "//computer_group/computers/computer/serial_number/text()" -
}

# Function to update the extension attribute for the computer by serial number
update_extension_attribute_by_serial() {
    local serial_number="$1"
    curl -X PUT -H "Authorization: Bearer $JAMFAPIToken" -H "Content-Type: application/xml" \
        -d "<computer><extension_attributes><extension_attribute><id>$EXTENSION_ATTRIBUTE_ID</id><value>$EXTENSION_ATTRIBUTE_VALUE</value></extension_attribute></extension_attributes></computer>" \
        "$JAMF_URL/JSSResource/computers/serialnumber/$serial_number"
}

# Main script logic
serial_numbers=$(get_computers_in_group)

# Loop through each serial number and update the extension attribute
for serial in $serial_numbers; do
    echo "Assigning extension attribute to serial number $serial..."
    update_extension_attribute_by_serial "$serial"
done
