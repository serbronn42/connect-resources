#!/bin/bash

set -e

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

WORKSPACES="platform-development platform-staging platform-production"

get_account_id() {
  local workspace=$1
  case "$workspace" in
    "platform-development")
      echo "700773733825"
      ;;
    "platform-staging")
      echo "443253666325"
      ;;
    "platform-production")
      echo "935080769565"
      ;;
    *)
      echo ""
      ;;
  esac
}

all_checks_passed=true

echo -e "${BOLD}🚀 Running Terraform validation checks...${NC}"

# Function to check for duplicate IDs in import blocks
check_duplicate_import_ids() {
  local terraform_dir=$1
  local main_tf="$terraform_dir/main.tf"
  
  echo -e "\n${BOLD}🔍 Checking for duplicate import IDs in $main_tf...${NC}"
  
  if [[ ! -f "$main_tf" ]]; then
    echo -e "   ${YELLOW}⚠️ main.tf not found, skipping check${NC}"
    return 0
  fi
  
  temp_uuids_file=$(mktemp)
  
  import_start_lines=$(grep -n "^import {" "$main_tf" | cut -d: -f1 || true)
  import_end_lines=$(grep -n "^}" "$main_tf" | cut -d: -f1 || true)
  
  if [[ -z "$import_start_lines" ]]; then
    echo -e "   ${GREEN}✅ No import blocks found${NC}"
    rm -f "$temp_uuids_file"
    return 0
  fi
  
  import_idx=0
  for start_line in $import_start_lines; do
    end_line=""
    for close_line in $import_end_lines; do
      if [[ $close_line -gt $start_line ]]; then
        end_line=$close_line
        break
      fi
    done
    
    resource_line=$(sed -n "${start_line},${end_line}p" "$main_tf" | grep "to =" || true)
    if [[ -z "$resource_line" ]]; then
      continue
    fi
    
    resource=""
    if [[ "$resource_line" =~ to[[:space:]]*=[[:space:]]*([a-zA-Z0-9_\.]+) ]]; then
      resource="${BASH_REMATCH[1]}"
      resource="${resource// /}"  
    fi
    
    id_line=$(sed -n "${start_line},${end_line}p" "$main_tf" | grep "id =" || true)
    if [[ -z "$id_line" ]]; then
      continue
    fi
    
    # Extract import ID based on import block structure id = "${var.connect_instance_id}:55028806-a226-4796-ac7f-10395724d5d0"
    
    uuid=""
    if [[ "$id_line" =~ :[[:space:]]*([a-zA-Z0-9-]+) ]]; then
      uuid="${BASH_REMATCH[1]}"
    elif [[ "$id_line" =~ ([a-f0-9-]{36}) ]]; then
      uuid="${BASH_REMATCH[1]}"
    elif [[ "$id_line" =~ id[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
      uuid="${BASH_REMATCH[1]}"
    else
      uuid=$(echo "$id_line" | sed 's/.*id[[:space:]]*=[[:space:]]*//')
    fi
    
    uuid="${uuid//\"/}"  
    uuid="${uuid//\}/}"  
    
    if [[ -n "$uuid" ]]; then
      echo "$uuid|$resource|$start_line" >> "$temp_uuids_file"
    fi
    
    import_idx=$((import_idx + 1))
  done
  
  has_duplicates=false
  
  temp_uuids_only=$(mktemp)
  cut -d'|' -f1 "$temp_uuids_file" > "$temp_uuids_only"
  
  duplicate_uuids=$(sort "$temp_uuids_only" | uniq -d || true)
  
  if [[ -n "$duplicate_uuids" ]]; then
    echo -e "   ${RED}❌ Duplicate import IDs found${NC}"
    has_duplicates=true
    
    while IFS= read -r uuid; do
      echo -e "   ${RED}Duplicate UUID: ${uuid}${NC}"
      grep "^$uuid|" "$temp_uuids_file" | while IFS= read -r line; do
        IFS='|' read -r _uuid resource line_num <<< "$line"
        echo -e "      - Used for: ${resource} (line ${line_num})"
      done
    done <<< "$duplicate_uuids"
  fi
  
  rm -f "$temp_uuids_file" "$temp_uuids_only"
  
  if [[ "$has_duplicates" == "false" ]]; then
    echo -e "   ${GREEN}✅ No duplicate import IDs found${NC}"
    return 0
  else
    return 1
  fi
}

check_duplicate_variables() {
  local terraform_dir=$1
  local locals_tf="$terraform_dir/locals.tf"
  local tfvars="$terraform_dir/dev.auto.tfvars"
  local success=true
  
  echo -e "\n${BOLD}🔍 Checking for duplicate variable assignments in $terraform_dir...${NC}"
  
  if [[ ! -f "$locals_tf" ]]; then
    echo -e "   ${YELLOW}⚠️ locals.tf not found, skipping check${NC}"
  else
    echo -e "   Checking locals.tf..."
    
    vars_with_lines=$(grep -n "^[[:space:]]*[a-zA-Z0-9_]\+[[:space:]]*=" "$locals_tf" | grep -v "^[[:space:]]*#" || true)
    
    temp_var_file=$(mktemp)
    has_duplicates=false
    
    while IFS=: read -r line_num content; do
      if [[ "$content" =~ ^[[:space:]]*([a-zA-Z0-9_]+)[[:space:]]*= ]]; then
        var_name="${BASH_REMATCH[1]}"
        
        if grep -q "^$var_name|" "$temp_var_file"; then
          original_line=$(grep "^$var_name|" "$temp_var_file" | cut -d'|' -f2)
          echo -e "   ${RED}❌ Duplicate variable found in locals.tf: ${var_name}${NC}"
          echo -e "      - First defined at line: ${original_line}"
          echo -e "      - Duplicated at line: ${line_num}"
          has_duplicates=true
          success=false
        else
          echo "$var_name|$line_num" >> "$temp_var_file"
        fi
      fi
    done <<< "$vars_with_lines"
    
    rm -f "$temp_var_file"
    
    if [[ "$has_duplicates" == "false" ]]; then
      echo -e "   ${GREEN}✅ No duplicate variables found in locals.tf${NC}"
    fi
  fi
  
  if [[ ! -f "$tfvars" ]]; then
    echo -e "   ${YELLOW}⚠️ dev.auto.tfvars not found, skipping check${NC}"
  else
    echo -e "   Checking dev.auto.tfvars..."
    
    # Extract variable assignments from dev.auto.tfvars
    vars_with_lines=$(grep -n "^[[:space:]]*[a-zA-Z0-9_]\+[[:space:]]*=" "$tfvars" | grep -v "^[[:space:]]*#" || true)
    
    temp_var_file=$(mktemp)
    temp_var_values_file=$(mktemp)
    temp_arn_file=$(mktemp)
    has_duplicates=false
    
    while IFS=: read -r line_num content; do
      # Extract variable name and value
      if [[ "$content" =~ ^[[:space:]]*([a-zA-Z0-9_]+)[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
        var_name="${BASH_REMATCH[1]}"
        var_value="${BASH_REMATCH[2]}"
        
        # Check for duplicate variable names
        if grep -q "^$var_name|" "$temp_var_file"; then
          original_line=$(grep "^$var_name|" "$temp_var_file" | cut -d'|' -f2)
          echo -e "   ${RED}❌ Duplicate variable found in dev.auto.tfvars: ${var_name}${NC}"
          echo -e "      - First defined at line: ${original_line}"
          echo -e "      - Duplicated at line: ${line_num}"
          has_duplicates=true
          success=false
        else
          echo "$var_name|$line_num" >> "$temp_var_file"
          echo "$var_name|$var_value" >> "$temp_var_values_file"
        fi
        
        # Check for duplicate ARN assignments
        if [[ "$var_value" == arn:aws:* ]]; then
          if grep -q "^$var_value|" "$temp_arn_file"; then
            original_var=$(grep "^$var_value|" "$temp_arn_file" | cut -d'|' -f2)
            echo -e "   ${RED}❌ Duplicate ARN assignment found in dev.auto.tfvars:${NC}"
            echo -e "      - ARN: ${var_value}"
            echo -e "      - First assigned to: ${original_var}"
            echo -e "      - Also assigned to: ${var_name}"
            has_duplicates=true
            success=false
          else
            echo "$var_value|$var_name" >> "$temp_arn_file"
          fi
        fi
      fi
    done <<< "$vars_with_lines"
    
    # Check for duplicate values assigned to different variables
    cat "$temp_var_values_file" | cut -d'|' -f2 | sort | uniq -c | while read -r count value; do
      if [[ "$count" -gt 1 && "$value" != arn:aws:* ]]; then
        echo -e "   ${RED}❌ Duplicate value assignment found in dev.auto.tfvars:${NC}"
        echo -e "      - Value: ${value}"
        echo -n "      - Assigned to: "
        
        vars_with_value=$(grep "|$value$" "$temp_var_values_file" | cut -d'|' -f1)
        echo "$vars_with_value" | tr '\n' ' '
        echo
        
        has_duplicates=true
        success=false
      fi
    done
    
    rm -f "$temp_var_file" "$temp_var_values_file" "$temp_arn_file"
    
    if [[ "$has_duplicates" == "false" ]]; then
      echo -e "   ${GREEN}✅ No duplicate assignments found in dev.auto.tfvars${NC}"
    fi
  fi
  
  if [[ "$success" == "true" ]]; then
    return 0
  else
    return 1
  fi
}

extract_account_id() {
  local arn=$1
  if [[ "$arn" =~ arn:aws:[^:]*:[^:]*:([0-9]+): ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo ""
  fi
}

check_account_ids_in_arns() {
  local terraform_dir=$1
  local workspace=$2
  local expected_account_id=$(get_account_id "$workspace")
  local success=true
  
  echo -e "\n${BOLD}🔍 Checking account IDs in ARNs for $terraform_dir...${NC}"
  
  if [[ -z "$expected_account_id" ]]; then
    echo -e "   ${RED}❌ No account ID mapping found for workspace: ${workspace}${NC}"
    return 1
  fi
  
  local account_id_var=""
  
  local tfvars="$terraform_dir/dev.auto.tfvars"
  if [[ -f "$tfvars" ]]; then
    account_id_line=$(grep "^[[:space:]]*account_id[[:space:]]*=" "$tfvars" || true)
    if [[ -n "$account_id_line" && "$account_id_line" =~ account_id[[:space:]]*=[[:space:]]*\"([0-9]+)\" ]]; then
      account_id_var="${BASH_REMATCH[1]}"
      
      if [[ "$account_id_var" != "$expected_account_id" ]]; then
        echo -e "   ${RED}❌ account_id in dev.auto.tfvars (${account_id_var}) doesn't match expected value for ${workspace} (${expected_account_id})${NC}"
        success=false
      else
        echo -e "   ${GREEN}✅ account_id in dev.auto.tfvars matches expected value: ${account_id_var}${NC}"
        
        arn_mismatch_found=false
        while IFS= read -r line; do
          if [[ "$line" =~ =.*\"(arn:aws:[^\"]+)\" ]]; then
            arn="${BASH_REMATCH[1]}"
            arn_account_id=$(extract_account_id "$arn")
            
            if [[ -n "$arn_account_id" && "$arn_account_id" != "$account_id_var" ]]; then
              if [[ "$line" =~ ^[[:space:]]*([a-zA-Z0-9_]+)[[:space:]]*= ]]; then
                var_name="${BASH_REMATCH[1]}"
                echo -e "   ${RED}❌ ARN in dev.auto.tfvars uses incorrect account ID:${NC}"
                echo -e "      - Variable: ${var_name}"
                echo -e "      - ARN: ${arn}"
                echo -e "      - ARN account ID: ${arn_account_id}"
                echo -e "      - Expected account ID: ${account_id_var}"
                arn_mismatch_found=true
                success=false
              fi
            fi
          fi
        done < "$tfvars"
        
        if [[ "$arn_mismatch_found" == "false" ]]; then
          echo -e "   ${GREEN}✅ All ARNs in dev.auto.tfvars use the correct account ID${NC}"
        fi
      fi
    else
      echo -e "   ${YELLOW}⚠️ account_id variable not found in dev.auto.tfvars${NC}"
    fi
  fi
  
  local locals_tf="$terraform_dir/locals.tf"
  if [[ -f "$locals_tf" ]]; then
    # For ARN validation in locals.tf, the account_id from dev.auto.tfvars is used to validate the arns 
    # Because account id in locals.tf is pointing to a variable
    local locals_account_id=""
    if [[ -n "$account_id_var" ]]; then
      locals_account_id="$account_id_var"
    else
      locals_account_id="$expected_account_id"
    fi
    
    arn_mismatch_found=false
    while IFS= read -r line; do
      if [[ "$line" =~ =.*\"(arn:aws:[^\"]+)\" ]]; then
        arn="${BASH_REMATCH[1]}"
        arn_account_id=$(extract_account_id "$arn")
        
        if [[ -n "$arn_account_id" && "$arn_account_id" != "$locals_account_id" ]]; then
          if [[ "$line" =~ ^[[:space:]]*([a-zA-Z0-9_]+)[[:space:]]*= ]]; then
            var_name="${BASH_REMATCH[1]}"
            echo -e "   ${RED}❌ ARN in locals.tf uses incorrect account ID:${NC}"
            echo -e "      - Variable: ${var_name}"
            echo -e "      - ARN: ${arn}"
            echo -e "      - ARN account ID: ${arn_account_id}"
            echo -e "      - Expected account ID: ${locals_account_id}"
            arn_mismatch_found=true
            success=false
          fi
        fi
      fi
    done < "$locals_tf"
    
    if [[ "$arn_mismatch_found" == "false" ]]; then
      echo -e "   ${GREEN}✅ All ARNs in locals.tf use the correct account ID${NC}"
    fi
  fi
  
  if [[ "$success" == "true" ]]; then
    return 0
  else
    return 1
  fi
}

# Function to run all checks
for workspace in $WORKSPACES; do
  terraform_dir="terraform/${workspace}"
  echo -e "\n${BOLD}📂 Checking workspace: ${workspace}${NC}"
  
  if [[ ! -d "$terraform_dir" ]]; then
    echo -e "   ${YELLOW}⚠️ Workspace directory not found: ${terraform_dir}${NC}"
    continue
  fi
  
  check_duplicate_import_ids "$terraform_dir"
  import_check_result=$?
  
  check_duplicate_variables "$terraform_dir"
  variables_check_result=$?
  
  check_account_ids_in_arns "$terraform_dir" "$workspace"
  account_check_result=$?
  
  if [[ $import_check_result -ne 0 || $variables_check_result -ne 0 || $account_check_result -ne 0 ]]; then
    all_checks_passed=false
  fi
done

echo -e "\n${BOLD}📋 Validation summary:${NC}"
if [[ "$all_checks_passed" == "true" ]]; then
  echo -e "${GREEN}✅ All checks passed successfully${NC}"
  exit 0
else
  echo -e "${RED}❌ Some checks failed - see details above${NC}"
  exit 1
fi