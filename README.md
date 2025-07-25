Amazon Connect Resource  Deployment

#connect-flows
This repository is a sample that can be used to deploy amazon connect resources. This repo focuses on contact flow and modules resources. There are 2 bash scripts in the top level directory (replace_arns.sh and replace_lambda_arns.sh). The replace_arns.sh script replaces the arns for resources(queues, flows, modules etc) other than Lambda with the variables defined in the locals.tf or dev.auto.tfvars file while the replace_lambda_arns.sh specifically replaces the region, environment and account-id. Since the lambda function Name/ID would likely remain the same across all environments unlike other resources that would have different IDs

# Environments & Mapping
platform-development ⇒ Amazon Connect Development (as labeled in Okta)
platform-staging ⇒ Amazon Connect Staging (as labeled in Okta)
platform-production ⇒ Amazon Connect (as labeled in Okta)

# Deployment Process
# Clone Repo
Git clone https://github.com/connect-resources

# Create new branch
Git checkout -b <branch-name>

# Upload Contact Flow / Module
Upload flows/modules to the respective directory. contact-flows for flows and contact-flow-modules for modules. Note: There is a symbolic link for these directories in each environment meaning any file uploaded to the any of the directories would cascade to all the other environments.

# Run Variable (ARN) Substitution
``` bash
make flows # Variable/ARN Substitution for all flows in the contact-flows directory
make flows # Variable/ARN Substitution for all modules in the contact-flow-modules directory
make file FILE="path/to/file.json" # Variable/ARN Substitution for a single file 
Example: make file FILE="contact-flows/Default agent hold.json.tftpl"
```

# Update the main.tf file
Depending on the environment you are deploying changes to. Create (for new resources) or update the existing resource in the main.tf file for the respective environment for the changes to apply in Amazon Connect.

# Stage Changes
git add . 

# Commit Changes
git commit -m "<commit message>"

# Push Changes and Create PR
git push origin <branch-name>


# Troubleshooting
Common Error Messages

Error: creating Connect Contact Flow (Test Chat Flow): InvalidParameter: 1 validation error(s) found.
- missing required field, CreateContactFlowInput.Content.

What does this mean?

This error typically occurs when the JSON file for the contact flow/module is empty or missing required fields. Ensure the contact flow or module JSON file content isn’t empty or missing important fields. See [1,2] for more info on required fields.

Error: file name too long

What does this mean?
This error typically occurs when the filename attribute is being set to the actual file contents instead of the file path. Ensure the file path is specified in the main.tf file and not the actual file.

Error: Invalid multi-line string or Error: Invalid string literal

What does this mean?
Quoted strings may not be split over multiple lines. The incorrect quotation marks are making Terraform interpret this as an attempt to create a multi-line string. Correct the syntax error in the resource declaration to mitigate this misinterpretation.

Error: Extraneous label for resource

What does this mean?

The resource declaration has incorrect quotation marks, making Terraform think there are more than 2 labels. Ensure the resource blocks should only have two labels: resource type and resource name - Both should be in quotes and separated by a space

References:
[1]https://registry.terraform.io/providers/hashicorp/aws/3.76.1/docs/resources/connect_contact_flow_module
[2]https://registry.terraform.io/providers/hashicorp/aws/3.76.1/docs/resources/connect_contact_flow
[3]https://docs.google.com/document/d/184NEISdDl4Rg1UA5ItyOfx4WLES6nkxDSCHlRvh4UPw
