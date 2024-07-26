#!/bin/bash

# Set the path to the directory containing Krita .kra files
input_directory="."

# Set the path to the directory where you want to save the converted .krz files
output_directory="."

# Create output directory if it doesn't exist
mkdir -p "$output_directory"

# Check if input directory exists
if [ ! -d "$input_directory" ]; then
    echo "Input directory does not exist: $input_directory"
    exit 1
fi

# Check if output directory is writable
if [ ! -w "$output_directory" ]; then
    echo "Output directory is not writable: $output_directory"
    exit 1
fi

# Loop through each .kra file in the input directory
for kra_file in "$input_directory"/*.kra; do
    # Check if there are .kra files to convert
    if [ -f "$kra_file" ]; then
        # Extract filename without extension
        filename=$(basename -- "$kra_file")
        filename_no_ext="${filename%.*}"

        # Set the output .krz file path
        krz_file="$output_directory/$filename_no_ext.krz"

        # Convert .kra to .krz using Krita's command-line interface
        # Note: You need to have Krita installed and the command line tools available
        krita "$kra_file" --export --export-filename "$krz_file"

        # Check if conversion was successful
        if [ $? -eq 0 ]; then
            echo "Conversion successful: $filename -> $filename_no_ext.krz"
            rm "$kra_file"
            if [ $? -eq 0 ]; then
                echo deleted "$kra_file"
            fi
        else
            echo "Error converting: $filename"
        fi
    fi
done

echo "Conversion complete."
