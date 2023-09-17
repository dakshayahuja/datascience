import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import datetime as dt
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
raw_data = pd.read_csv('houseprice.csv')
raw_data.head()
# the parameter 'index_col' will change the index to the specified column
raw_data = pd.read_csv('houseprice.csv', index_col=0)
raw_data.head()
raw_data.info()

print(raw_data.shape)
# use 'for' loop to change the data type of a large number of columns
for feature in ['MSSubClass','OverallQual','OverallCond']:
    raw_data[feature] = raw_data[feature].astype('object')
raw_data.dtypes

# 'now().year' gives the current year, store the year as 'current_year'
current_year = int(dt.datetime.now().year)

# creating 2 new columns as 'Buiding_age' and 'Remoel_age' 
Buiding_age = current_year - raw_data.YearBuilt
Remodel_age = current_year - raw_data.YearRemodAdd
raw_data['Buiding_age'] = Buiding_age
raw_data['Remodel_age'] = Remodel_age
raw_data.head()
raw_data.shape

Total = raw_data.isnull().sum().sort_values(ascending=False)
Percent = (raw_data.isnull().sum()*100/raw_data.isnull().count()).sort_values(ascending=False)   

missing_data = pd.concat([Total, Percent], axis=1, keys=['Total', 'Percent'])    
missing_data

raw_data['Alley'].fillna('No alley access' , inplace = True)
raw_data['MasVnrType'].fillna('None' , inplace = True)

for col in ['BsmtQual','BsmtCond','BsmtExposure','BsmtFinType1','BsmtFinType2']:
    raw_data[col].fillna('No Basement' , inplace = True)

raw_data['Electrical'].fillna('SBrkr' , inplace = True)
raw_data['FireplaceQu'].fillna('No Fireplace' , inplace = True)

for col in ['GarageType','GarageFinish','GarageQual','GarageCond']:
    raw_data[col].fillna('No Garage' , inplace = True)

raw_data['PoolQC'].fillna('No Pool' , inplace = True)
raw_data['Fence'].fillna('No Fence' , inplace = True)
raw_data['MiscFeature'].fillna('None' , inplace = True)
raw_data['LotFrontage'].fillna(raw_data['LotFrontage'].median() , inplace = True)
raw_data['MasVnrArea'].fillna(0 , inplace = True)
raw_data['GarageYrBlt'].fillna(0 , inplace = True)

raw_data.isnull().any().sum()  

# Compute Principal Components (from scratch)

df_numeric_features = raw_data.select_dtypes(include=[np.number])
df_num = df_numeric_features.drop('SalePrice',axis=1)
df_num.head()

# fit_transform() transforms the data by first computing the mean and sd and later scaling the data
df_num_std = StandardScaler().fit_transform(df_num)
print(df_num_std)
print(df_num_std.shape)

# generate the covariance matrix using 'cov' function
cov_mat = np.cov(df_num_std.T)
print(cov_mat[0:5])

#Compute Eigenvalues and Eigenvectors

# use 'eig' function to compute eigenvalues and eigenvectors of the covariance matrix
eig_val, eig_vec = np.linalg.eig(cov_mat)
print('Eigenvalues:','\n','\n', eig_val,"\n")
print('Eigenvectors:','\n','\n',eig_vec,'\n')

#Decide Number of Principal Components

# create a list of eigenvalues
eig_val = list(eig_val)
eig_val.sort(reverse = True)
print(eig_val)

# 'bp' represents blue color and pentagonal shape of points
plt.plot(eig_val,'bp')
plt.plot(eig_val) 
plt.xlabel('Principal Components')
plt.ylabel('Percentage of explained variance')      
plt.annotate(text ='Elbow Point', xy=(4,1.5), xytext=(5, 2.5), arrowprops=dict(facecolor='black', arrowstyle = 'simple'))
plt.title('Scree Plot')
plt.show()

#Calculate Principal Components
eigenvector = eig_vec[:,0:5]

# create a dataframe of principal components
df_pca = pd.DataFrame(df_num_std.dot(eigenvector), columns= ['PC1','PC2','PC3','PC4','PC5'])
df_pca.head()
df_pca.shape

#PCA using sklearn

# specify required no of components, take 'n_components=5' based on the analysis of scree plot
pca = PCA(n_components=5, random_state=0)
PrincipalComponents = pca.fit_transform(df_num_std)

PCA_df = pd.DataFrame(data = PrincipalComponents, columns = ['PC1', 'PC2','PC3','PC4','PC5'])
PCA_df.head()