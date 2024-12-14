# Group8_DS206_GroupProject2

This project implements a **Dimensional Data Store (DDS)** with SQL Server, Python ETL pipelines, and Power BI dashboard visualizations. The DDS includes staging, dimensional, and fact tables for managing and analyzing data.

## **Project Overview**

The project consists of the following main tasks:
1. Create an SQL Server database with staging, dimensional, and fact tables.
2. Develop Python ETL tasks for:
   - Table creation
   - Data ingestion into dimension and fact tables
   - Logging and error handling

## **Setup Instructions**

Follow the steps below to set up the project environment.

---

### **Step 1: Clone the Repository**
To get started, clone the repository from GitHub:
```bash
git clone https://github.com/<your-repo-name>/dds_project.git
cd dds_project
```

### **Step 2: Create a Virtual Environment
```bash
python3 -m venv venv
venv\Scripts\activate
```

### **Step 3: Install Python Dependencies
```bash
pip3 install -r requirements.txt
```

### **Step 4:Update the Configuration File:

Open sql_server_config.cfg and update it with your SQL Server details based on your computer.


### **Step 5:Run the Pipeline
```bash
python3 main.py
``
