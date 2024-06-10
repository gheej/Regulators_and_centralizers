import pandas as pd

# Load the CSV files
params_3 = pd.read_csv('params_3.csv')
regulators_3 = pd.read_csv('regulators_3.csv')
centralizer_index_3 = pd.read_csv('centralizer_index_3.csv')

# Rename columns for better readability
params_3.columns = ['a', 'b']
regulators_3.columns = ['Regulator']
centralizer_index_3.columns = ['Centralizer']

# Combine the dataframes into a single dataframe
data_3 = pd.concat([params_3, regulators_3, centralizer_index_3], axis=1)
data_3['Dataset'] = '3'


# Load the CSV files
params_1 = pd.read_csv('params_1.csv')
regulators_1 = pd.read_csv('regulators_1.csv')
centralizer_index_1 = pd.read_csv('centralizer_index_1.csv')

# Rename columns for better readability
params_1.columns = ['a', 'b']
regulators_1.columns = ['Regulator']
centralizer_index_1.columns = ['Centralizer']

# Combine the dataframes into a single dataframe
data_1 = pd.concat([params_1, regulators_1, centralizer_index_1], axis=1)
data_1['Dataset'] = '1'


# Load the CSV files
params_4 = pd.read_csv('params_4.csv')
regulators_4 = pd.read_csv('regulators_4.csv')
centralizer_index_4 = pd.read_csv('centralizer_index_4.csv')

# Rename columns for better readability
params_4.columns = ['a', 'b']
regulators_4.columns = ['Regulator']
centralizer_index_4.columns = ['Centralizer']

# Combine the dataframes into a single dataframe
data_4 = pd.concat([params_4, regulators_4, centralizer_index_4], axis=1)
data_4['Dataset'] = '4'

data = pd.concat([data_1, data_3, data_4]).reset_index(drop=True)


import matplotlib.pyplot as plt
import seaborn as sns
from mpl_toolkits.mplot3d import Axes3D

# Set the style for seaborn
sns.set(style="whitegrid")

# # Scatter plot of a vs b, color-coded by Regulator
# plt.figure(figsize=(10, 6))
# sns.scatterplot(x='a', y='b', hue='Regulator', data=data, palette='viridis', s=100)
# plt.title('Scatter Plot of a vs b (Color-coded by Regulator)')
# plt.xlabel('a')
# plt.ylabel('b')
# plt.legend(loc='upper right')
# plt.show()

# # Scatter plot of a vs b, color-coded by Centralizer
# plt.figure(figsize=(10, 6))
# sns.scatterplot(x='a', y='b', hue='Centralizer', data=data, palette='plasma', s=100)
# plt.title('Scatter Plot of a vs b (Color-coded by Centralizer)')
# plt.xlabel('a')
# plt.ylabel('b')
# plt.legend(loc='upper right')
# plt.show()
 
# 3D scatter plot of a, b, and Regulator
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')
# sc = ax.scatter(data['a'], data['b'], data['Regulator'], c=data['Regulator'], cmap='viridis', s=100)

ax.scatter(data_1['a'], data_1['b'], data_1['Regulator'], c='white', edgecolors='black', label='Unramified', s=50)
ax.scatter(data_3['a'], data_3['b'], data_3['Regulator'], c='green', label='Ramified nonsplit', s=50)
ax.scatter(data_4['a'], data_4['b'], data_4['Regulator'], c='blue', label='Completely split', s=50)

plt.title('3D Scatter Plot of a, b, and Regulator')
ax.set_xlabel('a')
ax.set_ylabel('b')
ax.set_zlabel('Regulator')
ax.legend()
# plt.colorbar(sc)
plt.show()


# # 3D scatter plot of a, b, and Centralizer
# fig = plt.figure(figsize=(10, 8))
# ax = fig.add_subplot(111, projection='3d')
# sc = ax.scatter(data['a'], data['b'], data['Centralizer'], c=data['Centralizer'], cmap='plasma', s=100)
# plt.title('3D Scatter Plot of a, b, and Centralizer')
# ax.set_xlabel('a')
# ax.set_ylabel('b')
# ax.set_zlabel('Centralizer')
# plt.colorbar(sc)
# plt.show()
# 
# # 3D scatter plot of a, b, and Centralizer
# fig = plt.figure(figsize=(10, 8))
# ax = fig.add_subplot(111, projection='3d')
# sc = ax.scatter(data['a'], data['b'], data['Centralizer']*data['Regulator'], c=data['Centralizer']*data['Regulator'], cmap='plasma', s=100)
# plt.title('3D Scatter Plot of a, b, and Volume')
# ax.set_xlabel('a')
# ax.set_ylabel('b')
# ax.set_zlabel('Volume')
# ax.legend()
# plt.colorbar(sc)
# plt.show()
