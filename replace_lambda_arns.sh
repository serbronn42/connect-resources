#!/bin/bash

# Usage: ./omer_lambda.sh [--dir <directory_path> | --file <file_path>]

# Default values
directory_path=""
file_path=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dir)
            directory_path="$2"
            shift 2
            ;;
        --file)
            file_path="$2"
            shift 2
            ;;
        *)
            echo "Error: Unknown option $1"
            echo "Usage: $0 [--dir <directory_path> | --file <file_path>]"
            exit 1
            ;;
    esac
done

# Validate input arguments
if [[ -z "$directory_path" && -z "$file_path" ]]; then
    echo "Error: Either --dir or --file must be specified"
    echo "Usage: $0 [--dir <directory_path> | --file <file_path>]"
    exit 1
fi

if [[ -n "$directory_path" && -n "$file_path" ]]; then
    echo "Error: Cannot specify both --dir and --file"
    echo "Usage: $0 [--dir <directory_path> | --file <file_path>]"
    exit 1
fi

# Process directory
if [[ -n "$directory_path" ]]; then
    # Ensure the directory exists
    if [ ! -d "$directory_path" ]; then
        echo "Error: Directory $directory_path not found."
        exit 1
    fi

    echo "Processing directory: $directory_path"
    
    # Define patterns for matching
    region_pattern="[a-z]{2}-[a-z]+-[0-9]"            # Matches AWS regions (e.g., us-east-1, us-west-2)
    account_id_pattern="[0-9]{12}"                    # Matches 12-digit AWS account IDs
    env_pattern="-?(development|staging|production)-?" # Matches environments with surrounding hyphens

    # Process all JSON and JSON.tftpl files within the directory (including subdirectories)
    find "$directory_path" -type f \( -name "*.json" -o -name "*.json.tftpl" \) | while read -r file; do
        echo "Processing file: $file"

        # Use platform-appropriate sed command
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS/BSD sed requires an empty string with -i
            sed -i '' -E "
                /\"LambdaFunctionARN\"/{
                    s/$region_pattern/\${aws_region}/g;                     # Replace region
                    s/$account_id_pattern/\${account_id}/g;                 # Replace account ID
                    s/(-?)(development|staging|production)(-?)/\1\${environment}\3/g; # Replace environment with hyphen handling
                }
                /\"displayName\"/{
                    s/(-?)(development|staging|production)(-?)/\1\${environment}\3/g; # Replace environment in displayName
                }
            " "$file"
        else
            # Linux/GNU sed doesn't need the empty string
            sed -i -E "
                /\"LambdaFunctionARN\"/{
                    s/$region_pattern/\${aws_region}/g;                     # Replace region
                    s/$account_id_pattern/\${account_id}/g;                 # Replace account ID
                    s/(-?)(development|staging|production)(-?)/\1\${environment}\3/g; # Replace environment with hyphen handling
                }
                /\"displayName\"/{
                    s/(-?)(development|staging|production)(-?)/\1\${environment}\3/g; # Replace environment in displayName
                }
            " "$file"
        fi

        echo " Updated: $file"
    done

    echo " Lambda ARN and displayName replacements complete for all JSON and TFTPL files in: $directory_path"
# Process single file
elif [[ -n "$file_path" ]]; then
    # Ensure the file exists
    if [ ! -f "$file_path" ]; then
        echo "Error: File $file_path not found."
        exit 1
    fi

    # Check if the file is a JSON or JSON.tftpl file
    if [[ "$file_path" != *.json && "$file_path" != *.json.tftpl ]]; then
        echo "Error: File $file_path is not a JSON or JSON.tftpl file."
        exit 1
    fi

    echo "Processing file: $file_path"
    
    # Define patterns for matching
    region_pattern="[a-z]{2}-[a-z]+-[0-9]"            # Matches AWS regions (e.g., us-east-1, us-west-2)
    account_id_pattern="[0-9]{12}"                    # Matches 12-digit AWS account IDs
    env_pattern="-?(development|staging|production)-?" # Matches environments with surrounding hyphens

    # Use platform-appropriate sed command
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS/BSD sed requires an empty string with -i
        sed -i '' -E "
            /\"LambdaFunctionARN\"/{
                s/$region_pattern/\${aws_region}/g;                     # Replace region
                s/$account_id_pattern/\${account_id}/g;                 # Replace account ID
                s/(-?)(development|staging|production)(-?)/\1\${environment}\3/g; # Replace environment with hyphen handling
            }
            /\"displayName\"/{
                s/(-?)(development|staging|production)(-?)/\1\${environment}\3/g; # Replace environment in displayName
            }
        " "$file_path"
    else
        # Linux/GNU sed doesn't need the empty string
        sed -i -E "
            /\"LambdaFunctionARN\"/{
                s/$region_pattern/\${aws_region}/g;                     # Replace region
                s/$account_id_pattern/\${account_id}/g;                 # Replace account ID
                s/(-?)(development|staging|production)(-?)/\1\${environment}\3/g; # Replace environment with hyphen handling
            }
            /\"displayName\"/{
                s/(-?)(development|staging|production)(-?)/\1\${environment}\3/g; # Replace environment in displayName
            }
        " "$file_path"
    fi

    echo " Updated: $file_path"
    echo " Lambda ARN and displayName replacements complete for: $file_path"
fi