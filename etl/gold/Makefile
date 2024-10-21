# Define variables for bucket and paths
BUCKET_NAME = stedi-etl
GLUE_SCRIPTS_PATH = glue/gold/scripts

# Customer variables
SCRIPT = main.py

# Phony targets
.PHONY: all push_customer push_step_trainer push_accelerometer

# Default target
all: push

# Upload customer script to S3
push:
	@echo "Pushing customer Glue job script to S3..."
	aws s3 cp $(SCRIPT) s3://$(BUCKET_NAME)/$(GLUE_SCRIPTS_PATH)/${SCRIPT}
	@echo "Customer job script pushed successfully."
