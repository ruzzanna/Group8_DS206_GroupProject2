import utils
import os
import pyodbc
import pandas as pd
from pipeline_dimensional_data import config




def connect_db_create_cursor(database_conf_name):
    # Call to read the configuration file
    db_conf = utils.get_sql_config(config.sql_server_config, database_conf_name)
    # Create a connection string for SQL Server
    db_conn_str = 'Driver={};Server={};Database={};Trusted_Connection={};'.format(*db_conf)
    # Connect to the server and to the desired database
    db_conn = pyodbc.connect(db_conn_str)
    # Create a Cursor class instance for executing T-SQL statements
    db_cursor = db_conn.cursor()
    return db_cursor


def create_dimensional_tables(sql_dir, config_path):
    """
    Creates dimensional tables by executing SQL scripts in the given directory.

    Args:
        sql_dir (str): Path to the directory containing SQL scripts for table creation.
        config_path (str): Path to the database configuration file.
    """
    try:
        for file_name in os.listdir(sql_dir):
            if file_name.endswith("_create_table.sql"):
                sql_file_path = os.path.join(sql_dir, file_name)
                execute_sql_query(sql_file_path, config_path)
    except Exception as e:
        print(f"Error creating dimensional tables: {e}")
        raise
def create_dimensional_tables(sql_dir, config_path):
    """
    Creates dimensional tables by executing SQL scripts in the given directory.

    Args:
        sql_dir (str): Path to the directory containing SQL scripts for table creation.
        config_path (str): Path to the database configuration file.
    """
    try:
        for file_name in os.listdir(sql_dir):
            if file_name.endswith("_create_table.sql"):
                sql_file_path = os.path.join(sql_dir, file_name)
                execute_sql_query(sql_file_path, config_path)
    except Exception as e:
        print(f"Error creating dimensional tables: {e}")
        raise


def ingest_data_into_dimensional_tables(sql_dir, source_destination_mapping, start_date, end_date, config_path):
    """
    Ingests data into dimensional tables using SQL scripts.

    Args:
        sql_dir (str): Path to the directory containing SQL scripts for ingestion.
        source_destination_mapping (dict): Mapping of source to destination tables.
        start_date (str): Start date for data ingestion.
        end_date (str): End date for data ingestion.
        config_path (str): Path to the database configuration file.
    """
    try:
        for source_table, destination_table in source_destination_mapping.items():
            sql_file_name = f"{destination_table}_ingest.sql"
            sql_file_path = os.path.join(sql_dir, sql_file_name)

            # Define parameters for the SQL query
            params = {
                "SourceTable": source_table,
                "DestinationTable": destination_table,
                "StartDate": start_date,
                "EndDate": end_date
            }

            execute_sql_query(sql_file_path, config_path, params)
    except Exception as e:
        print(f"Error ingesting data into dimensional tables: {e}")
        raise
def load_query(query_name):
    for script in os.listdir(config.input_dir):
        if query_name in script:
            with open(config.input_dir + '\\' + script, 'r') as script_file:
                sql_script = script_file.read()
            break
    return sql_script
def sequential_pipeline(tasks):
    """
    Executes a list of tasks sequentially. Each task must succeed before the next task starts.

    Args:
        tasks (list): A list of tuples, where each tuple contains:
                      - task function
                      - positional arguments for the function
                      - keyword arguments for the function

    Returns:
        dict: Result of the pipeline execution, including success status and error (if any).
    """
    for task, args, kwargs in tasks:
        try:
            # Execute the task function
            result = task(*args, **kwargs)

            # Check if the task succeeded
            if not result.get("success"):
                print(f"Task {task.__name__} failed with error: {result.get('error')}")
                return {"success": False, "error": result.get("error")}

            # Log successful completion of the task
            print(f"Task {task.__name__} completed successfully.")

        except Exception as e:
            print(f"Task {task.__name__} failed with exception: {e}")
            return {"success": False, "error": str(e)}

    # If all tasks succeed
    return {"success": True}

def insert_into_Categories(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row['CategoryID'], row['CategoryName'], row['Description'])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

def insert_into_Customers(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row['CustomerID'], row['CompanyName'], row['ContactName'], row['ContactTitle'], row['Address'], row['City'], row['Region'], row['PostalCode'],  row['Country'], row['Phone'], row['Fax'])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

def insert_into_Employees(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row["EmployeeID"], row["LastName"], row["FirstName"], row["CustomerID"], row["TitleOfCourtesy"], row["BirthDate"], row["HireDate"], row["Address"], row["City"], row["Region"], row["PostalCode"], row["Country"], row["HomePhone"], row["Extension"], row["Notes"], row["ReportsTo"], row["PhotoPath"])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

def insert_into_Suppliers(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row["SupplierID"], row["CompanyName"], row["ContactName"], row["ContactTitle"], row["Address"], row["City"], row["Region"], row["PostalCode"], row["Country"], row["Phone"], row["Fax"], row["HomePage"])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

def insert_into_Shippers(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row["ShipperID"], row["CompanyName"], row["Phone"])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

def insert_into_Region(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row["RegionID"], row["RegionDescription"])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

def insert_into_Products(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row["ProductID"], row["ProductName"], row["SupplierID"], row["CategoryID"], row["QuantityPerUnit"], row["UnitPrice"], row["UnitsInStock"], row["UnitsOnOrder"], row["ReorderLevel"], row["Discontinued"])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

def insert_into_Territories(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row["TerritoryID"], row["TerritoryDescription"], row["RegionID"])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

def insert_into_Orders(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row["OrderID"], row["CustomerID"], row["EmployeeID"], row["OrderDate"], row["RequireDate"], row["ShippedDate"], row["ShippedVia"], row["Freight"], row["ShipName"], row["ShipAdrress"], row["ShipCity"], row["ShipRegion"], row["ShipPostalCode"], row["ShipCountry"], row["TerritoryID"])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

def insert_into_OrderDetails(cursor, table_name, db, schema, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name = table_name, header=0)

    insert_into_table_script = load_query('insert_into_{}'.format(table_name)).format(db=db, schema=schema)

    # Populate a table in sql server
    for index, row in df.iterrows():
        cursor.execute(insert_into_table_script, row["OrderID"], row["ProductID"], row["UnitPrice"], row["Quantity"], row["Discount"])
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {db}.{schema}.{table_name} table")

