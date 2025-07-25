# Variables
LAMBDA_SCRIPT := ./replace_lambda_arns.sh
ARN_SCRIPT := ./replace_arns.sh
FLOWS_DIR := ./contact-flows
MODULES_DIR := ./contact-flow-modules

# Ensure the scripts are executable
$(LAMBDA_SCRIPT) $(ARN_SCRIPT):
	@chmod +x $@

# Process all files in contact-flows directory with both scripts
.PHONY: flows
flows: $(LAMBDA_SCRIPT) $(ARN_SCRIPT)
	@echo "Processing all files in $(FLOWS_DIR) directory with both scripts..."
	@echo "\n=== Running Lambda script ==="
	@$(LAMBDA_SCRIPT) --dir "$(FLOWS_DIR)"
	@echo "\n=== Running ARN replacement script ==="
	@$(ARN_SCRIPT) --dir "$(FLOWS_DIR)"
	@echo "\n=== Processing complete ==="

# Process all files in contact-flow-modules directory with both scripts
.PHONY: modules
modules: $(LAMBDA_SCRIPT) $(ARN_SCRIPT)
	@echo "Processing all files in $(MODULES_DIR) directory with both scripts..."
	@echo "\n=== Running Lambda script ==="
	@$(LAMBDA_SCRIPT) --dir "$(MODULES_DIR)"
	@echo "\n=== Running ARN replacement script ==="
	@$(ARN_SCRIPT) --dir "$(MODULES_DIR)"
	@echo "\n=== Processing complete ==="

# Process a single file with both scripts
# Usage: make file FILE="path/to/your file with spaces.json"
.PHONY: file
file: $(LAMBDA_SCRIPT) $(ARN_SCRIPT)
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please specify a file using FILE=\"path/to/file.json\""; \
		echo "Example: make file FILE=\"contact-flows/CX - Hold_back Ofgn test .json\""; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "Error: File \"$(FILE)\" does not exist"; \
		exit 1; \
	fi
	@echo "Processing single file: $(FILE) with both scripts"
	@echo "\n=== Running Lambda script ==="
	@$(LAMBDA_SCRIPT) --file "$(FILE)"
	@echo "\n=== Running ARN replacement script ==="
	@$(ARN_SCRIPT) --file "$(FILE)"
	@echo "\n=== Processing complete ==="

# Run a single script on the flows directory
# Usage: make lambda-flows or make arn-flows
.PHONY: lambda-flows arn-flows
lambda-flows: $(LAMBDA_SCRIPT)
	@echo "Processing all files in $(FLOWS_DIR) directory with Lambda script only..."
	@$(LAMBDA_SCRIPT) --dir "$(FLOWS_DIR)"

arn-flows: $(ARN_SCRIPT)
	@echo "Processing all files in $(FLOWS_DIR) directory with ARN script only..."
	@$(ARN_SCRIPT) --dir "$(FLOWS_DIR)"

# Run a single script on the modules directory
# Usage: make lambda-modules or make arn-modules
.PHONY: lambda-modules arn-modules
lambda-modules: $(LAMBDA_SCRIPT)
	@echo "Processing all files in $(MODULES_DIR) directory with Lambda script only..."
	@$(LAMBDA_SCRIPT) --dir "$(MODULES_DIR)"

arn-modules: $(ARN_SCRIPT)
	@echo "Processing all files in $(MODULES_DIR) directory with ARN script only..."
	@$(ARN_SCRIPT) --dir "$(MODULES_DIR)"

# Help command
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make flows   - Process all files in contact-flows directory with both scripts"
	@echo "  make modules - Process all files in contact-flow-modules directory with both scripts"
	@echo "  make file FILE=\"path/to/file.json\" - Process a single file with both scripts"
	@echo ""
	@echo "Single script commands:"
	@echo "  make lambda-flows   - Process contact-flows with Lambda script only"
	@echo "  make lambda-modules - Process contact-flow-modules with Lambda script only"
	@echo "  make arn-flows      - Process contact-flows with ARN replacement script only"
	@echo "  make arn-modules    - Process contact-flow-modules with ARN replacement script only"
	@echo ""
	@echo "Note: When specifying a file with spaces, enclose the path in quotes:"
	@echo "Example: make file FILE=\"contact-flows/CX - Hold_back Ofgn test .json\""