import pandas as pd
import os

# Create seeds directory if it doesn't exist
if os.path.exists('./seeds') == False:
    os.makedirs('./seeds')

# Load the Excel file
xls = pd.ExcelFile('./data/carmen_sightings_20220629061307.xlsx')
print("Available sheets:", xls.sheet_names,'\n---')

# Extract each sheet inro 8 individual CSV seed files
for sheet_name in xls.sheet_names:
    print (f"Extracting: {sheet_name}")
    df = pd.read_excel(xls, sheet_name=sheet_name)

    # Added 'region' column 
    df['region'] = sheet_name.lower()

    # AFRICA edit - Fill NaN values in 'country' column with "Namibia"
    if sheet_name == 'AFRICA':
        df['country'] = df['country'].fillna("Namibia")

    # Save the DataFrame to a CSV file
    df.to_csv(f'./seeds/raw_{sheet_name.lower()}.csv', index=False)
    print(f"Saved: raw_{sheet_name.lower()}.csv")
    print(f"Columns: {list(df.columns)}")
    print(f"Rows: {len(df)}")
    print("---")