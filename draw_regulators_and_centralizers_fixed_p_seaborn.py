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
data = pd.concat([params_3, regulators_3, centralizer_index_3], axis=1)

import matplotlib.pyplot as plt
import seaborn as sns
from mpl_toolkits.mplot3d import Axes3D

# Set the style for seaborn
sns.set(style="whitegrid")

# Scatter plot of a vs b, color-coded by Regulator
plt.figure(figsize=(10, 6))
sns.scatterplot(x='a', y='b', hue='Regulator', data=data, palette='viridis', s=100)
plt.title('Scatter Plot of a vs b (Color-coded by Regulator)')
plt.xlabel('a')
plt.ylabel('b')
plt.legend(loc='upper right')
plt.show()

# Scatter plot of a vs b, color-coded by Centralizer
plt.figure(figsize=(10, 6))
sns.scatterplot(x='a', y='b', hue='Centralizer', data=data, palette='plasma', s=100)
plt.title('Scatter Plot of a vs b (Color-coded by Centralizer)')
plt.xlabel('a')
plt.ylabel('b')
plt.legend(loc='upper right')
plt.show()

# 3D scatter plot of a, b, and Regulator
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')
sc = ax.scatter(data['a'], data['b'], data['Regulator'], c=data['Regulator'], cmap='viridis', s=100)
plt.title('3D Scatter Plot of a, b, and Regulator')
ax.set_xlabel('a')
ax.set_ylabel('b')
ax.set_zlabel('Regulator')
plt.colorbar(sc)
plt.show()

# 3D scatter plot of a, b, and Centralizer
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')
sc = ax.scatter(data['a'], data['b'], data['Centralizer'], c=data['Centralizer'], cmap='plasma', s=100)
plt.title('3D Scatter Plot of a, b, and Centralizer')
ax.set_xlabel('a')
ax.set_ylabel('b')
ax.set_zlabel('Centralizer')
plt.colorbar(sc)
plt.show()

3D scatter plot of a, b, and Centralizer
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')
sc = ax.scatter(data['a'], data['b'], data['Centralizer']*data['Regulator'], c=data['Centralizer']*data['Regulator'], cmap='plasma', s=100)
plt.title('3D Scatter Plot of a, b, and Volume')
ax.set_xlabel('a')
ax.set_ylabel('b')
ax.set_zlabel('Volume')
ax.legend()
plt.colorbar(sc)
plt.show()
