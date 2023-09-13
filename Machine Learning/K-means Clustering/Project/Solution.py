import pandas as pd
import matplotlib.pyplot as plt
from warnings import filterwarnings
from sklearn.preprocessing import MinMaxScaler
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

filterwarnings("ignore")

# Load data
data = pd.read_excel("cust_data.xlsx")
data["Gender"] = data["Gender"].fillna(method="ffill")
data['Gender'] = data.Gender.apply(lambda x : 1 if x=="M" else 0)

# Drop 'Cust_ID' column
X = data.drop('Cust_ID', axis=1)

# Scale the data
scaler = MinMaxScaler()
X_scaled = scaler.fit_transform(X)
X_scaled = pd.DataFrame(X_scaled, columns=X.columns)  # Convert back to DataFrame

# Elbow method
wcss = []
for i in range(1, 11):
    kmeans = KMeans(n_clusters=i, init='k-means++', random_state=42)
    kmeans.fit(X_scaled)
    wcss.append(kmeans.inertia_)

# Plot elbow graph
plt.plot(range(1, 11), wcss)
plt.title('The Elbow Method')
plt.xlabel('Number of clusters')
plt.ylabel('WCSS')
plt.show()

# Silhouette score
sil_scores = []
for i in range(2, 11):
    kmeans = KMeans(n_clusters=i, init='k-means++', random_state=42)
    kmeans.fit(X_scaled)
    sil_scores.append(silhouette_score(X_scaled, kmeans.labels_))

# Plot silhouette scores
plt.plot(range(2, 11), sil_scores, 'bx-')
plt.title('Silhouette Analysis For Optimal k')
plt.xlabel('Number of clusters')
plt.ylabel('Silhouette Score')
plt.show()

# Final clustering with 5 clusters
kmeans = KMeans(n_clusters=5, init='k-means++', random_state=42)
y_kmeans = kmeans.fit_predict(X_scaled)

# Add cluster labels to the original data
data['Cluster'] = y_kmeans

# Plot clusters
plt.scatter(X_scaled.loc[y_kmeans == 0, 'Gender'], X_scaled.loc[y_kmeans == 0, 'Orders'], s=100, c='red', label='Cluster 1')
plt.scatter(X_scaled.loc[y_kmeans == 1, 'Gender'], X_scaled.loc[y_kmeans == 1, 'Orders'], s=100, c='blue', label='Cluster 2')
plt.scatter(X_scaled.loc[y_kmeans == 2, 'Gender'], X_scaled.loc[y_kmeans == 2, 'Orders'], s=100, c='green', label='Cluster 3')
plt.scatter(X_scaled.loc[y_kmeans == 3, 'Gender'], X_scaled.loc[y_kmeans == 3, 'Orders'], s=100, c='cyan', label='Cluster 4')
plt.scatter(X_scaled.loc[y_kmeans == 4, 'Gender'], X_scaled.loc[y_kmeans == 4, 'Orders'], s=100, c='magenta', label='Cluster 5')
plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], s=300, c='yellow', label='Centroids')
plt.title('Clusters of customers')
plt.xlabel('Gender')
plt.ylabel('Orders')
plt.legend()
plt.show()