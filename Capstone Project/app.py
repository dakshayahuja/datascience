from flask import Flask, request, jsonify, render_template
from main import recommend_songs, df

app = Flask(__name__)

@app.route('/')
def index():
    # This route will render the main page with the form.
    return render_template('index.html')

@app.route('/recommend', methods=['POST'])
def recommend():
    user_song_input = request.form['song_name'].lower()

    try:
        num_recommendations_input = int(request.form['num_recommendations'])
    except ValueError:
        num_recommendations_input = 5  # Fallback to 5 recommendations if input is invalid.

    # Call the recommend_songs function from main.py, make sure it returns a DataFrame.
    recommendations = recommend_songs(df.iloc[:, 6:17], user_song_input, num_recommendations_input)

    # Check if recommendations were found
    if recommendations is not None and not recommendations.empty:
        # Construct the data to be returned as JSON
        recommendations_data = [{
            "Song Name": row['name'].title(),
            "Artists": row['artists'],
            "Year": row['year']
        } for index, row in recommendations.iterrows()]
        return jsonify(recommendations_data)
    else:
        # Return an error message if no recommendations are found
        return jsonify({'error': 'No recommendations found for the given song name.'})

if __name__ == '__main__':
    app.run(debug=True)
