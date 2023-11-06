import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics.pairwise import cosine_similarity
import pickle

# Set display options
pd.options.display.max_columns = None
pd.options.display.max_rows = 80

# Configure warnings and matplotlib
import warnings
warnings.filterwarnings('ignore')

# Load dataset
df = pd.read_csv('dataset/tracks_features.csv')
df = df[df['year'] > 2009]

# Data cleaning and feature engineering
df['name'] = df['name'].astype(str)
df = df[~df['name'].str.contains('live', case=False)]
df = df[~df['name'].str.contains('remix', case=False)]
df = df[~df['name'].str.contains('mix', case=False)]
df = df[~df.iloc[:, 8:21].duplicated()]

# Convert explicit column to numerical
df['explicit'] = df['explicit'].apply(lambda x: 0 if x else 1)

# Convert duration from ms to mins
df['duration_mins'] = df['duration_ms'].apply(lambda col: round(col / 60000, 2))
df.drop(columns=['duration_ms', 'album_id', 'track_number', 'disc_number', 'release_date', 'duration_mins', 'time_signature'], inplace=True)

# Normalize certain columns
columns_to_normalize = ['explicit', 'danceability', 'energy', 'key', 'loudness', 'mode', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo']
for col in columns_to_normalize:
    max_value = df[col].max()
    min_value = df[col].min()
    df[col] = (df[col] - min_value) / (max_value - min_value)

# Convert song names to lowercase
df['name'] = df['name'].str.lower()

with open('processed_dataset.pkl', 'wb') as f:
    pickle.dump(df, f)

# Function to print basic feature information
def print_basic_features(data):
    print("Column Name", "Number of Unique Features")
    for col in data.columns:
        print(f"{col}    {data[col].nunique()}")
        if data[col].value_counts().count() < 15:
            print(data[col].value_counts(dropna=False))
        else:
            pass

def recommend_songs(model_dataset, user_song_name, num_recommendations=5):
    recommended_songs = pd.DataFrame()
    # Ensure there's at least one match for the song in the dataset
    if not df[df['name'] == user_song_name].empty:
        user_song_X = df[df['name'] == user_song_name].iloc[:1, 6:17]
        cosine_sim = cosine_similarity(model_dataset, user_song_X)
        song_similarity_scores = cosine_sim.flatten()
        sorted_song_indices = np.argsort(song_similarity_scores)[::-1]
        top_n_recommendations = sorted_song_indices[1:num_recommendations+1]
        
        recommended_songs = df.iloc[top_n_recommendations]
        for index, song in recommended_songs.iterrows():
            print(f"Song Name: {song['name'].title()}")
            print(f"Artists: {song['artists']}")
            print(f"Year: {song['year']}")
            print("----------")
    
    return recommended_songs
# Main execution
if __name__ == '__main__':
    # User input for song recommendation
    # Name should be accurate like mentioned in the dataset, examples - something just like this, hello, i'm getting old 
    # any typo mistake could lead to problem
    user_song_input = input("Enter Song: ").lower()  # Ensuring the song name is in lowercase
    total_dataset = df.iloc[:, 6:17]
    
    try:
        num_recommendations_input = int(input("Enter the number of songs you want to be recommended: "))
    except ValueError:
        print("Please enter a valid number.")
        num_recommendations_input = 5  # Fallback to default if invalid input
    
    # Recommend songs
    recommend_songs(total_dataset, user_song_input, num_recommendations_input)
