# Define variables
CLUSTER_IDENTIFIER = stedi-redshift-cluster
DATABASE = stedi_db
DB_USER = redshiftuser

all: create_all_tables

# Create Customer Table
create_customer_table:
	@echo "Creating customer table in Redshift..."
	aws redshift-data execute-statement \
		--cluster-identifier $(CLUSTER_IDENTIFIER) \
		--database $(DATABASE) \
		--db-user $(DB_USER) \
		--sql "CREATE TABLE customer ( \
			customer_id INT IDENTITY(1, 1) PRIMARY KEY, \
			customerName VARCHAR(255) NOT NULL, \
			email VARCHAR(255) UNIQUE NOT NULL, \
			phone VARCHAR(15), \
			birthDay DATE, \
			registrationDate BIGINT, \
			lastUpdateDate BIGINT, \
			shareWithResearchAsOfDate BIGINT, \
			shareWithPublicAsOfDate BIGINT, \
			shareWithFriendsAsOfDate BIGINT, \
			serialNumber VARCHAR(255) \
		);"
	@echo "Customer table created."

# Create Step Trainer Table
create_step_trainer_table:
	@echo "Creating step_trainer table in Redshift..."
	aws redshift-data execute-statement \
		--cluster-identifier $(CLUSTER_IDENTIFIER) \
		--database $(DATABASE) \
		--db-user $(DB_USER) \
		--sql "CREATE TABLE step_trainer ( \
			step_trainer_id INT IDENTITY(1, 1) PRIMARY KEY, \
			sensorReadingTime BIGINT, \
			distanceFromObject INT, \
			serialNumber VARCHAR(255), \
			customer_id INT REFERENCES customer(customer_id) \
		);"
	@echo "Step trainer table created."

# Create Accelerometer Table
create_accelerometer_table:
	@echo "Creating accelerometer table in Redshift..."
	aws redshift-data execute-statement \
		--cluster-identifier $(CLUSTER_IDENTIFIER) \
		--database $(DATABASE) \
		--db-user $(DB_USER) \
		--sql "CREATE TABLE accelerometer ( \
			accelerometer_id INT IDENTITY(1, 1) PRIMARY KEY, \
			timestamp BIGINT, \
			x FLOAT, \
			y FLOAT, \
			z FLOAT, \
			customer_id INT REFERENCES customer(customer_id) \
		);"
	@echo "Accelerometer table created."

# Create all tables
create_all_tables: create_customer_table create_step_trainer_table create_accelerometer_table
	@echo "All tables created in Redshift."
