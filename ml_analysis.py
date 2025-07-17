# ml_analysis.py
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import classification_report, accuracy_score
# import psycopg2
from sqlalchemy import create_engine
import matplotlib.pyplot as plt
import seaborn as sns

def ml_analysis():
    """
    Perform machine learning analysis on Carmen Sandiego sighting data
    """
    try:
        # Connect to PostgreSQL database
        PASSWORD = input("Enter your database password: ")
        
        # Build SQLAlchemy connection string
        engine = create_engine(f"postgresql+psycopg2://postgres:{PASSWORD}@localhost:5432/cascade_database")

        # conn = psycopg2.connect(
        #     host="localhost",
        #     database="cascade_database",
        #     user="postgres",
        #     password= PASSWORD,
        #     port=5432
        # )
        print("✅ Connected to PostgreSQL database")
        
        # Define SQL query/Load the fact table
        query = """
        SELECT 
            date_witness,
            latitude,
            longitude,
            has_weapon,
            has_hat,
            has_jacket,
            behavior,
            region
        FROM carmen_marts.fact_sightings
        WHERE date_witness IS NOT NULL
        """
        # Load into DataFrame using SQLAlchemy engine
        df = pd.read_sql(query, engine)
        # df = pd.read_sql(query, conn)
        # conn.close()

        
        print(f"✅ Loaded {len(df)} sighting records")
        
        # Feature engineering
        df['date_witness'] = pd.to_datetime(df['date_witness'])
        df['month'] = df['date_witness'].dt.month
        df['day_of_week'] = df['date_witness'].dt.dayofweek
        df['season'] = df['month'].apply(lambda x: 
            'Spring' if x in [3,4,5] else
            'Summer' if x in [6,7,8] else
            'Fall' if x in [9,10,11] else 'Winter'
        )
        
        # Encode categorical variables
        le_behavior = LabelEncoder()
        le_region = LabelEncoder()
        le_season = LabelEncoder()
        
        df['behavior_encoded'] = le_behavior.fit_transform(df['behavior'].fillna('unknown'))
        df['region_encoded'] = le_region.fit_transform(df['region'])
        df['season_encoded'] = le_season.fit_transform(df['season'])
        
        # Prepare features for different prediction tasks
        
        # 1. Predict next region based on current features
        print("\n🔍 ANALYSIS 1: Predicting Carmen's Next Region")
        features_region = ['month', 'day_of_week', 'latitude', 'longitude', 
                          'has_weapon', 'has_hat', 'has_jacket', 'behavior_encoded']
        
        X_region = df[features_region]
        y_region = df['region_encoded']
        
        X_train, X_test, y_train, y_test = train_test_split(
            X_region, y_region, test_size=0.2, random_state=42
        )
        
        rf_region = RandomForestClassifier(n_estimators=100, random_state=42)
        rf_region.fit(X_train, y_train)
        
        y_pred = rf_region.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        
        print(f"Region Prediction Accuracy: {accuracy:.3f}")
        
        # Feature importance for region prediction
        feature_importance_region = pd.DataFrame({
            'feature': features_region,
            'importance': rf_region.feature_importances_
        }).sort_values('importance', ascending=False)
        
        print("\nFeature Importance for Region Prediction:")
        print(feature_importance_region)
        
        # 2. Predict behavior based on location and appearance
        print("\n🔍 ANALYSIS 2: Predicting Carmen's Behavior")
        features_behavior = ['month', 'latitude', 'longitude', 'has_weapon', 
                           'has_hat', 'has_jacket', 'region_encoded']
        
        X_behavior = df[features_behavior]
        y_behavior = df['behavior_encoded']
        
        X_train_b, X_test_b, y_train_b, y_test_b = train_test_split(
            X_behavior, y_behavior, test_size=0.2, random_state=42
        )
        
        rf_behavior = RandomForestClassifier(n_estimators=100, random_state=42)
        rf_behavior.fit(X_train_b, y_train_b)
        
        y_pred_b = rf_behavior.predict(X_test_b)
        accuracy_b = accuracy_score(y_test_b, y_pred_b)
        
        print(f"Behavior Prediction Accuracy: {accuracy_b:.3f}")
        
        # 3. Clustering analysis for pattern detection
        print("\n🔍 ANALYSIS 3: Pattern Detection")
        
        # Seasonal patterns
        seasonal_patterns = df.groupby(['season', 'region']).agg({
            'has_weapon': 'mean',
            'has_hat': 'mean',
            'has_jacket': 'mean',
            'latitude': 'mean',
            'longitude': 'mean'
        }).round(3)
        
        print("\nSeasonal Patterns by Region:")
        print(seasonal_patterns)
        
        # Behavior clustering
        behavior_stats = df.groupby('behavior').agg({
            'has_weapon': 'mean',
            'has_hat': 'mean',
            'has_jacket': 'mean',
            'region': 'count'
        }).round(3).sort_values('region', ascending=False)
        
        print("\nBehavior Statistics:")
        print(behavior_stats.head(10))
        
        # 4. Predictive insights
        print("\n🔍 ANALYSIS 4: Predictive Insights")
        
        # Most likely next appearance characteristics
        next_month = df['month'].mode()[0]  # Most common month
        avg_lat = df['latitude'].mean()
        avg_lng = df['longitude'].mean()
        
        # Predict for average conditions
        sample_prediction = rf_region.predict([[
            next_month, 1, avg_lat, avg_lng, 1, 0, 1, 
            df['behavior_encoded'].mode()[0]
        ]])[0]
        
        predicted_region = le_region.inverse_transform([sample_prediction])[0]
        
        print(f"\nPredicted next region for average conditions: {predicted_region}")
        
        # Risk assessment
        high_risk_conditions = df[
            (df['has_weapon'] == True) & 
            (df['has_jacket'] == True) & 
            (df['has_hat'] == False)
        ]
        
        if len(high_risk_conditions) > 0:
            risk_regions = high_risk_conditions['region'].value_counts()
            print(f"\nHigh-risk profile (Armed + Jacket + No Hat) most common in:")
            print(risk_regions.head(3))
        
        # 5. Recommendations for law enforcement
        print("\n🚨 LAW ENFORCEMENT RECOMMENDATIONS:")
        
        # Top 3 regions by frequency
        top_regions = df['region'].value_counts().head(3)
        print(f"\n1. Focus surveillance on top 3 regions:")
        for region, count in top_regions.items():
            print(f"   - {region}: {count} sightings")
        
        # Seasonal recommendations
        seasonal_freq = df.groupby('season')['region'].count()
        peak_season = seasonal_freq.idxmax()
        print(f"\n2. Increase patrols during {peak_season} season")
        
        # Behavioral patterns
        dangerous_behaviors = df[df['has_weapon'] == True]['behavior'].value_counts().head(3)
        print(f"\n3. Most dangerous behaviors when armed:")
        for behavior, count in dangerous_behaviors.items():
            print(f"   - {behavior}: {count} incidents")
        
        print("\n✅ Machine Learning Analysis Complete!")
        
    except Exception as e:
        print(f"❌ Error in ML analysis: {str(e)}")
        print("Make sure your dbt models have been run and the database is accessible")

if __name__ == "__main__":
    ml_analysis()