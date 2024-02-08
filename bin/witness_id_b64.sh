#!/bin/bash

# Check if exactly two arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 witness_id"
    exit 1
fi

# Assign arguments to variables
witness_id=$1

# Encode the string in base64
encoded_witness_id=$(echo -n "\"$witness_id\"" | base64)

# Print the encoded string
echo $encoded_witness_id