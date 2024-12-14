from pipeline_dimensional_data.flow import DimensionalDataFlow
from custom_logging import setup_logger

# Configure paths
sql_dir = "infrastructure_initiation"
config_path = "DRIVER={SQL Server};SERVER=localhost;DATABASE=testdb;UID=user;PWD=password"

# Set up logger
execution_id = "885d28a2-ef92-40de-8bc4-67b1994cffe7"  # Optional; generate if None
logger = setup_logger(execution_id)

# Initialize DimensionalDataFlow
try:
    data_flow = DimensionalDataFlow(sql_dir=sql_dir, config_path=config_path, logger=logger)
except Exception as e:
    logger.error(f"Failed to initialize DimensionalDataFlow: {e}", exc_info=True)
    exit(1)

# Execute the pipeline
start_date = "2024-01-01"
end_date = "2024-12-31"

try:
    result = data_flow.exec(start_date=start_date, end_date=end_date)
    if result["success"]:
        logger.info("Pipeline executed successfully!")
    else:
        logger.error(f"Pipeline execution failed: {result['error']}")
except Exception as e:
    logger.error(f"Pipeline execution failed: {e}", exc_info=True)
    exit(1)