import matplotlib.pyplot as plt
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

# Read the dataset
dataset = pd.read_csv(r'Mall_Customers.csv')

# Extract the relevant columns and convert to a NumPy array
X = dataset.iloc[:, [3, 4]].values

# WCSS calculation for the elbow method
wcss = []
for i in range(1, 11):
    kmean = KMeans(n_clusters=i, init='k-means++', random_state=42)
    kmean.fit(X)
    wcss.append(kmean.inertia_)

# Plot WCSS values for elbow method
plt.plot(range(1, 11), wcss)
plt.title('The Elbow Method')
plt.xlabel('Number of clusters')
plt.ylabel('WCSS')
plt.show()

# Silhouette score calculation
savg = []
for i in range(2, 11):
    kmean = KMeans(n_clusters=i, init='k-means++', random_state=42)
    kmean.fit(X)
    savg.append(silhouette_score(X, kmean.labels_, metric='euclidean'))

# Plot Silhouette scores
plt.plot(range(2, 11), savg, 'bx-')
plt.xlabel('Values of K')
plt.ylabel('Silhouette score')
plt.title('Silhouette analysis For Optimal k')
plt.show()

# Final clustering with K=5
kmean = KMeans(n_clusters=5, init='k-means++', random_state=42)
y_kmean = kmean.fit_predict(X)

# Scatter plot for the clusters
plt.scatter(X[y_kmean == 0, 0], X[y_kmean == 0, 1], s=100, c='red', label='Cluster 1')
plt.scatter(X[y_kmean == 1, 0], X[y_kmean == 1, 1], s=100, c='blue', label='Cluster 2')
plt.scatter(X[y_kmean == 2, 0], X[y_kmean == 2, 1], s=100, c='green', label='Cluster 3')
plt.scatter(X[y_kmean == 3, 0], X[y_kmean == 3, 1], s=100, c='cyan', label='Cluster 4')
plt.scatter(X[y_kmean == 4, 0], X[y_kmean == 4, 1], s=100, c='magenta', label='Cluster 5')
plt.scatter(kmean.cluster_centers_[:, 0], kmean.cluster_centers_[:, 1], s=300, c='yellow', label='Centroids')
plt.title('Clusters of customers')
plt.xlabel('Annual Income (k$)')
plt.ylabel('Spending Score (1-100)')
plt.legend()
plt.show()