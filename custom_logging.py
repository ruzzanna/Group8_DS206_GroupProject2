import logging
import os
import uuid


def setup_logger(execution_id=None):
    """
    Set up a logger for the Dimensional Data Flow pipeline.

    Args:
        execution_id (str): UUID for the execution instance. If not provided, it will generate one.

    Returns:
        logging.Logger: Configured logger instance.
    """
    # Generate execution_id if not provided
    if execution_id is None:
        execution_id = str(uuid.uuid4())

    # Ensure the logs directory exists
    log_dir = "logs"
    os.makedirs(log_dir, exist_ok=True)

    # Configure the logger
    logger = logging.getLogger(f"dimensional_data_flow_{execution_id}")
    logger.setLevel(logging.DEBUG)

    # Create a file handler
    log_file = os.path.join(log_dir, "logs_dimensional_data_pipeline.txt")
    file_handler = logging.FileHandler(log_file, mode="a", encoding="utf-8")
    file_handler.setLevel(logging.DEBUG)

    # Create a console handler (optional)
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)

    # Define log format
    log_format = logging.Formatter(
        f"%(asctime)s | Execution ID: {execution_id} | %(levelname)s | %(message)s"
    )
    file_handler.setFormatter(log_format)
    console_handler.setFormatter(log_format)

    # Add handlers to logger
    logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    return logger