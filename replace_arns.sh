#!/bin/bash

# Escape special characters for sed
escape_sed() {
    echo "$1" | sed -e 's/[\/&]/\\&/g'
}

# Extract ARN variable from multiple tfvars files
get_tfvar_variable() {
    local arn=$1
    local variable=""
    
    for tf_file in "${tfvars_files[@]}"; do
        if [ ! -f "$tf_file" ]; then
            echo "Warning: tfvars file not found: $tf_file"
            continue
        fi
        
        local found_var=$(grep -E " *= *\"$arn\"" "$tf_file" | cut -d '=' -f 1 | sed 's/^[[:space:]"]*//;s/[[:space:]"]*$//')
        
        if [ -n "$found_var" ]; then
            variable="$found_var"
            echo "Found variable '$variable' for ARN in file: $tf_file" >&2
            break
        fi
    done
    
    echo "$variable"
}

# Get UUID from full ARN
get_uuid_from_arn() {
    local arn=$1
    # Extract the UUID which is the last segment after "flow-module/" or after the last "/"
    local uuid=$(echo "$arn" | grep -o "[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}$")
    echo "$uuid"
}

process_file() {
    local file="$1"
    local processed=false

    echo "Processing file: \"$file\""

    # Make a temporary copy of the file to work with
    temp_file=$(mktemp)
    cp "$file" "$temp_file"

    # Detect and process full ARNs in the file using grep
    arns_in_file=$(grep -o '"arn:aws:[^"]*"' "$file" | tr -d '"')

    if [ -n "$arns_in_file" ]; then
        
        while IFS= read -r arn; do
            
            [ -z "$arn" ] && continue

            arn_variable=$(get_tfvar_variable "$arn")

            if [ -n "$arn_variable" ]; then
                
                escaped_arn=$(escape_sed "$arn")
                escaped_variable="\${$arn_variable}" 

                # Replace ARN with the variable in the temporary file
                sed -i '' "s|$escaped_arn|$escaped_variable|g" "$temp_file"
                echo "  ✓ Replaced full ARN $arn with \${$arn_variable}"
                processed=true
            else
                echo "  ⚠ No matching variable found for ARN: $arn"
            fi
        done <<< "$arns_in_file"
    else
        echo "No full ARNs found in \"$file\""
    fi

    # Extract all "FlowModuleId" or "ContactFlowId" blocks with their values
    flow_id_blocks=$(grep -A 1 '"FlowModuleId"\s*:' "$temp_file" && grep -A 1 '"ContactFlowId"\s*:' "$temp_file")
    uuids_in_flow_ids=$(echo "$flow_id_blocks" | grep -o '[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}')
    
    if [ -n "$uuids_in_flow_ids" ]; then
        while IFS= read -r uuid; do
            [ -z "$uuid" ] && continue
            
            # Search for variables that match this UUID directly
            uuid_variable=$(get_tfvar_variable "$uuid")
            
            if [ -z "$uuid_variable" ]; then
                for tf_file in "${tfvars_files[@]}"; do
                    if [ -f "$tf_file" ]; then
                        arn_with_uuid=$(grep -E "arn:aws:[^\"]*$uuid" "$tf_file" | head -1)
                        if [ -n "$arn_with_uuid" ]; then
                            uuid_variable=$(echo "$arn_with_uuid" | cut -d '=' -f 1 | sed 's/^[[:space:]"]*//;s/[[:space:]"]*$//')
                            echo "Found variable '$uuid_variable' for UUID as part of ARN in file: $tf_file" >&2
                            break
                        fi
                    fi
                done
            fi
            
            # If a variable is found, replace the UUID in the file
            if [ -n "$uuid_variable" ]; then
                escaped_uuid=$(escape_sed "$uuid")
                escaped_variable="\${$uuid_variable}"
                
                # Replace in FlowModuleId and ContactFlowId parameters
                sed -i '' "s/\(\"FlowModuleId\"[^\"]*\"[^\"]*\)$escaped_uuid/\1$escaped_variable/g" "$temp_file"
                sed -i '' "s/\(\"ContactFlowId\"[^\"]*\"[^\"]*\)$escaped_uuid/\1$escaped_variable/g" "$temp_file"
                
                echo "  ✓ Replaced UUID $uuid with \${$uuid_variable} in FlowModuleId/ContactFlowId"
                processed=true
            else
                echo "  ⚠ No matching variable found for UUID: $uuid"
            fi
        done <<< "$uuids_in_flow_ids"
    else
        echo "No standalone UUIDs found in FlowModuleId or ContactFlowId parameters in \"$file\""
    fi

    # Apply all the changes back to the original file
    cp "$temp_file" "$file"
    rm "$temp_file"

    if [ "$processed" = true ]; then
        echo "✓ Successfully processed \"$file\""
    else
        echo "- No replacements made in \"$file\""
    fi
    echo "----------------------------------------"
}

process_directory() {
    local dir="$1"

    if [ ! -d "$dir" ]; then
        echo "Error: Directory \"$dir\" not found"
        exit 1
    fi

    echo "Processing directory: \"$dir\""
    echo "========================================"

    # Use find with print0 to handle filenames with spaces and special characters
    # Count JSON and TFTPL files in directory
    file_count=$(find "$dir" -type f \( -name "*.json" -o -name "*.json.tftpl" \) -print0 | grep -zc .)

    if [ "$file_count" -eq 0 ]; then
        echo "No JSON or TFTPL files found in \"$dir\""
        exit 1
    fi

    processed_files=0

    # Process each JSON and TFTPL file in the directory
    while IFS= read -r -d $'\0' file; do
        process_file "$file"
        processed_files=$((processed_files + 1))
        echo "Progress: $processed_files/$file_count files processed"
    done < <(find "$dir" -type f \( -name "*.json" -o -name "*.json.tftpl" \) -print0)

    echo "Completed processing directory: \"$dir\""
    echo "Total files processed: $processed_files"
}

# Assign the tfvars files
tfvars_files=(
    "./terraform/platform-development/dev.auto.tfvars"
    "./terraform/platform-staging/dev.auto.tfvars"
    "./terraform/platform-production/dev.auto.tfvars"
)

# Check if at least one tfvars file exists
files_exist=false
for tf_file in "${tfvars_files[@]}"; do
    if [ -f "$tf_file" ]; then
        files_exist=true
        break
    fi
done

if [ "$files_exist" = false ]; then
    echo "Error: None of the specified tfvars files were found"
    echo "Looked for:"
    for tf_file in "${tfvars_files[@]}"; do
        echo "  - $tf_file"
    done
    exit 1
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dir)
            if [ -n "$2" ]; then
                process_directory "$2"
            else
                echo "Error: --dir requires a directory path"
                exit 1
            fi
            shift 2
            ;;
        --file)
            if [ -n "$2" ]; then
                if [ ! -f "$2" ]; then
                    echo "Error: File \"$2\" does not exist"
                    exit 1
                fi
                process_file "$2"
            else
                echo "Error: --file requires a file path"
                exit 1
            fi
            shift 2
            ;;
        *)
            echo "Usage: $0 [--dir <directory>] [--file \"file name with spaces.json\"]"
            exit 1
            ;;
    esac
done