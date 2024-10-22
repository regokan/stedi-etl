# Define variables for bucket and paths
BUCKET_NAME = stedi-etl
GLUE_SCRIPTS_PATH = glue/silver/scripts

# Customer Curated script
CUSTOMER_SCRIPT = customer_trusted_to_curated.py

# Step trainer Curated script
STEP_TRAINER_SCRIPT = step_trainer_trusted.py

# Machine learning Curated script
MACHINE_LEARNING_SCRIPT = machine_learning_curated.py

# Phony targets
.PHONY: all push_customer push_step_trainer push_machine_learning

# Default target
all: push_customer push_step_trainer push_machine_learning

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

push_machine_learning:
	@echo "Pushing machine learning Glue job script to S3..."
	aws s3 cp $(MACHINE_LEARNING_SCRIPT) s3://$(BUCKET_NAME)/$(GLUE_SCRIPTS_PATH)/machine_learning.py
	@echo "Machine Learning job script pushed successfully."
