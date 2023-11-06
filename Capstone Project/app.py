from flask import Flask, render_template, request, redirect, url_for, flash
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import os

app = Flask(__name__)
app.secret_key = os.urandom(24)

df = pd.read_csv('dataset/final_data.csv')
total_dataset = df.iloc[:, 6:17]

def model(user_song_X, total_dataset, N_recommend):
    cosine_sim = cosine_similarity(total_dataset, user_song_X)
    song_similarity_scores = cosine_sim.flatten()
    sorted_song_indices = song_similarity_scores.argsort()[::-1]
    top_n_recommendations = sorted_song_indices[1:N_recommend+1]
    return recommend_N(top_n_recommendations)

def recommend_N(top_n_recommendations):
    recommended_songs = df.iloc[top_n_recommendations]
    formatted_songs = []

    for index, song in recommended_songs.iterrows():
        formatted_song = {
            'track_id': song['id'],
            'name': song['name'].title(),
            'artists': ', '.join(eval(song['artists'])),
            'year': song['year'],
            'genres': song['genres'].title()
        }
        formatted_songs.append(formatted_song)

    return formatted_songs

@app.route('/', methods=['GET', 'POST'])
def index():
    recommendations = None
    if request.method == 'POST':
        user_song = request.form['song']
        n_recommendations = int(request.form['number'])
        user_song_X = df[df['name'].str.lower() == user_song.lower()].iloc[:1, 6:17]

        if not user_song_X.empty:
            recommendations = model(user_song_X, total_dataset, n_recommendations)
            return render_template('index.html', formatted_songs=recommendations)
        else:
            flash("Song not found in the dataset.")
    return render_template('index.html', formatted_songs=recommendations)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
