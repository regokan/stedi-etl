# Define variables for bucket and paths
BUCKET_NAME = stedi-etl
GLUE_SCRIPTS_PATH = glue/bronze/scripts

# Step trainer variables
STEP_TRAINER_SCRIPT = step_trainer.py

# Accelerometer variables
ACCELEROMETER_SCRIPT = accelerometer.py

# Customer variables
CUSTOMER_SCRIPT = customer.py

# Phony targets
.PHONY: all push_customer push_step_trainer push_accelerometer

# Default target
all: push_customer push_step_trainer push_accelerometer

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

# Upload accelerometer script to S3
push_accelerometer:
	@echo "Pushing accelerometer Glue job script to S3..."
	aws s3 cp $(ACCELEROMETER_SCRIPT) s3://$(BUCKET_NAME)/$(GLUE_SCRIPTS_PATH)/accelerometer.py
	@echo "Accelerometer job script pushed successfully."
