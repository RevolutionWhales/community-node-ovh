#!/bin/bash

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 pub_key wif_key"
    exit 1
fi

# Assign arguments to variables
pub_key=$1
wif_key=$2

# Print the input arguments
# echo "Public Key: $pub_key"
# echo "WIF Key: $wif_key"

# Combine the keys into a JSON-like array string
keys_string="[\"$pub_key\", \"$wif_key\"]"

# Encode the string in base64
encoded_keys=$(echo -n "$keys_string" | base64)

# Print the encoded string
echo $encoded_keys