# Define variables for bucket and paths
BUCKET_NAME = stedi-etl
GLUE_SCRIPTS_PATH = glue/silver/scripts

# Step trainer variables
STEP_TRAINER_SCRIPT = step_trainer.py

# Customer variables
CUSTOMER_SCRIPT = customer.py

# Phony targets
.PHONY: all push_customer push_step_trainer

# Default target
all: push_customer push_step_trainer

# Upload customer script to S3
push_customer:
	@echo "Pushing customer Glue job script to S3..."
	aws s3 cp $(CUSTOMER_SCRIPT) s3://$(BUCKET_NAME)/$(GLUE_SCRIPTS_PATH)/customer.py
	@echo "Customer job script pushed successfully."

# Upload step_trainer script to S3
push_step_trainer:
	@echo "Pushing step_trainer Glue job script to S3..."
	aws s3 cp $(STEP_TRAINER_SCRIPT) s3://$(BUCKET_NAME)/$(GLUE_SCRIPTS_PATH)/step_trainer.py
	@echo "Step Trainer job script pushed successfully."
