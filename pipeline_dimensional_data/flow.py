import uuid
import os
import sys

# Add parent directory to the module search path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from custom_logging import setup_logger


class DimensionalDataFlow:
    def __init__(self, sql_dir, config_path, logger):
        self.sql_dir = sql_dir
        self.config_path = config_path
        self.execution_id = str(uuid.uuid4())
        self.logger = logger

        self.logger.info("DimensionalDataFlow instance initialized.")
        self.logger.debug(f"SQL Directory: {self.sql_dir}, Config Path: {self.config_path}")

    def exec(self, start_date, end_date):
        self.logger.info(f"Execution started for date range {start_date} to {end_date}.")
        try:
            # Simulate creating dimensional tables
            self.create_dimensional_tables()

            # Simulate execution success
            self.logger.info("Pipeline execution completed successfully.")
            return {"success": True}
        except Exception as e:
            self.logger.error(f"Pipeline execution failed: {e}", exc_info=True)
            return {"success": False, "error": str(e)}

    def create_dimensional_tables(self):
        """
        Reads SQL scripts from the specified directory and executes them to create dimensional tables.
        """
        self.logger.info("Creating dimensional tables...")
        try:
            # Iterate over all SQL files in the directory
            for sql_file in os.listdir(self.sql_dir):
                file_path = os.path.join(self.sql_dir, sql_file)
                if file_path.endswith(".sql"):
                    with open(file_path, "r") as file:
                        sql_script = file.read()

                        # Example: Pass dates as parameters if needed
                        params = (self.execution_id,)
                        self.execute_sql(sql_script, params)

                        self.logger.debug(f"Executed SQL script: {file_path}")

            self.logger.info("All dimensional tables created successfully.")
        except Exception as e:
            self.logger.error(f"Error creating dimensional tables: {e}", exc_info=True)
            raise

    def execute_sql(self, query, params=None):
        """
        Executes a SQL query using the database configuration.
        Args:
            query (str): The SQL query to execute.
            params (tuple): Parameters to pass into the query for parameterized execution.
        """
        self.logger.debug(f"Executing SQL: {query}")
        try:
            # Connect to the database
            conn = pyodbc.connect(self.config_path)  # Use your config path for connection
            cursor = conn.cursor()

            # Execute the query with or without parameters
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)

            # Commit the transaction
            conn.commit()
            self.logger.debug("SQL executed successfully.")
        except Exception as e:
            self.logger.error(f"Failed to execute query: {query} - Error: {e}", exc_info=True)
            raise
        finally:
            cursor.close()
            conn.close()
