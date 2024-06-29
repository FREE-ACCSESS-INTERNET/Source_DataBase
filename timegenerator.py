import pandas as pd

# Define the start and end of the period
start_date = '2023-01-01 00:00:00'
end_date = '2026-12-31 23:59:00'

# Generate a date range at minute intervals
date_range = pd.date_range(start=start_date, end=end_date, freq='T')

# Create a DataFrame
df = pd.DataFrame(date_range, columns=['datetime'])

# Add an ID column starting from 1
df['id'] = range(1, len(df) + 1)

# Extract date and time components
df['date'] = df['datetime'].dt.date
df['year'] = df['datetime'].dt.year
df['month'] = df['datetime'].dt.month
df['day'] = df['datetime'].dt.day
df['weekday'] = df['datetime'].dt.weekday
df['hour'] = df['datetime'].dt.hour
df['minute'] = df['datetime'].dt.minute

# Function to determine the season
def get_season(month):
    if month in (3, 4, 5):
        return 'Spring'
    elif month in (6, 7, 8):
        return 'Summer'
    elif month in (9, 10, 11):
        return 'Autumn'
    else:
        return 'Winter'

# Apply function to determine the season
df['season'] = df['month'].apply(get_season)

# Drop the initial datetime column as it's no longer needed
df.drop('datetime', axis=1, inplace=True)

# Reorder columns so ID is first
df = df[['id', 'date', 'year', 'month', 'day', 'weekday', 'hour', 'minute', 'season']]

# Save the DataFrame to a CSV file
df.to_csv('time_dimension.csv', index=False)

print("CSV file with ID column has been created successfully!")
