import pymysql
import os

def save_table_to_markdown(query, filename):
    try:
        # Connect to MySQL
        print("Connecting to the database...")
        conn = pymysql.connect(
            host="localhost",         # Replace with your MySQL host, e.g., 'localhost'
            user="root",              # Replace with your MySQL username
            password="Laestedes6",    # Replace with your MySQL password
            database="patients"       # Replace with your database name
        )
        print("Connection successful!")  # If this doesn't print, connection failed.

        cursor = conn.cursor()

        print("Executing query...")
        cursor.execute(query)
        print("Query executed successfully!")

        # Fetch column names
        print("Fetching column names...")
        columns = [desc[0] for desc in cursor.description]
        print(f"Columns: {columns}")

        # Fetch rows
        print("Fetching rows...")
        rows = cursor.fetchall()
        print(f"Rows: {rows}")

        # Check if rows are returned
        if not rows:
            print("No rows returned from the query.")
            return

        # Generate Markdown table
        print("Generating Markdown table...")
        markdown_table = "| " + " | ".join(columns) + " |\n"
        markdown_table += "| " + " | ".join(["-" * len(col) for col in columns]) + " |\n"

        for row in rows:
            markdown_table += "| " + " | ".join(str(value) for value in row) + " |\n"

        # Ensure the output directory exists
        output_dir = "output_tables"
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

        # Save the Markdown table to a file
        output_file = os.path.join(output_dir, filename)
        print(f"Saving Markdown table to '{output_file}'...")
        with open(output_file, "w") as file:
            file.write(markdown_table)

        print(f"Markdown table saved to '{output_file}'.")

    except pymysql.MySQLError as err:
        print(f"Database connection error: {err}")  # Detailed error message

    except Exception as e:
        print(f"Unexpected error: {e}")

    finally:
        # Ensure the connection is closed
        try:
            cursor.close()
            conn.close()
            print("Database connection closed.")
        except:
            print("Connection was not established.")


# SQL Queries and Saving to Markdown

queries = [
    {
        "query": """
        

        SELECT BMI_Category, Round(AVG(charges),2)AVG_Charges
        FROM BMI_table
        GROUP BY 1
        ORDER BY 2; 
        """,
        "filename": "bmi_category_avg_charges.md"
    },
    {
        "query": """
        SELECT Obese, Round(AVG(charges),2) AVG_Charges
        FROM BMI_table
        GROUP BY 1
        ORDER BY 2; 
        """,
        "filename": "obese_avg_charges.md"
    }
]

# Execute all queries and save the results
for query_data in queries:
    save_table_to_markdown(query_data["query"], query_data["filename"])
