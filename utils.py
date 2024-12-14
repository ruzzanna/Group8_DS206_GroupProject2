import os
import pyodbc
import uuid

def generate_uuid():
    """
    Generate a unique UUID for tracking executions.

    Returns:
        str: A string representation of the UUID.
    """
    return str(uuid.uuid4())


def read_sql_file(file_path):
    """
    Reads an SQL script from the specified .sql file.

    Args:
        file_path (str): The path to the .sql file.

    Returns:
        str: The contents of the SQL script as a string.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"The file '{file_path}' does not exist.")

    with open(file_path, 'r', encoding='utf-8') as file:
        sql_script = file.read()

    return sql_script


def execute_sql_script(connection, sql_script, params=None):
    """
    Executes an SQL script using the provided database connection.

    Args:
        connection (pyodbc.Connection): The active database connection.
        sql_script (str): The SQL script to execute.
        params (dict, optional): Parameters to use in the SQL script.

    Returns:
        None
    """
    cursor = connection.cursor()
    try:
        if params:
            cursor.execute(sql_script, params)
        else:
            cursor.execute(sql_script)
        connection.commit()
    except pyodbc.Error as e:
        print(f"Error executing SQL script: {e}")
        connection.rollback()
        raise
    finally:
        cursor.close()


def get_database_connection(server, database, username, password, driver="{ODBC Driver 17 for SQL Server}"):
    """
    Establishes a connection to the database.

    Args:
        server (str): The database server name or IP address.
        database (str): The name of the database.
        username (str): The username for authentication.
        password (str): The password for authentication.
        driver (str): The ODBC driver to use.

    Returns:
        pyodbc.Connection: The database connection object.
    """
    try:
        connection_string = (
            f"DRIVER={driver};"
            f"SERVER={server};"
            f"DATABASE={database};"
            f"UID={username};"
            f"PWD={password}"
        )
        connection = pyodbc.connect(connection_string)
        return connection
    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        raise


def run_sql_from_file(connection, file_path, params=None):
    """
    Reads an SQL script from a file and executes it using the provided connection.

    Args:
        connection (pyodbc.Connection): The active database connection.
        file_path (str): Path to the .sql file containing the script.
        params (dict, optional): Parameters to use in the SQL script.

    Returns:
        None
    """
    try:
        sql_script = read_sql_file(file_path)
        execute_sql_script(connection, sql_script, params)
    except Exception as e:
        print(f"Failed to execute SQL script from file: {e}")
        raise