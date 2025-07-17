# ml2_analysis.py
# Machine Learning Bonus:
# Create a predictive model to forecast Carmen's next appearance:
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
import psycopg2

# Connect to database and load data
conn = psycopg2.connect(
    host="localhost",
    database="cascade_database",
    user="postgres",
    password= input("Enter your database password: "),
    port=5432
)

# Load fact table
df = pd.read_sql("SELECT * FROM carmen.fact_sightings", conn)

# Feature engineering
df['month'] = pd.to_datetime(df['date_witness']).dt.month
df['day_of_week'] = pd.to_datetime(df['date_witness']).dt.dayofweek

# Encode categorical variables
le_region = LabelEncoder()
le_behavior = LabelEncoder()

df['region_encoded'] = le_region.fit_transform(df['region'])
df['behavior_encoded'] = le_behavior.fit_transform(df['behavior'])

# Features for prediction
features = ['month', 'day_of_week', 'latitude', 'longitude', 'has_weapon', 'has_hat', 'has_jacket']
X = df[features]
y = df['region_encoded']

# Train model
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
rf_model = RandomForestClassifier(n_estimators=100, random_state=42)
rf_model.fit(X_train, y_train)

# Feature importance
feature_importance = pd.DataFrame({
    'feature': features,
    'importance': rf_model.feature_importances_
}).sort_values('importance', ascending=False)

print("Feature Importance for Predicting Carmen's Next Region:")
print(feature_importance)