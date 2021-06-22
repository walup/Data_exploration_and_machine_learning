import cv2
import numpy as np
import matplotlib.pyplot as plt
from scipy import interpolate
from sklearn.cluster import KMeans
from sklearn.cluster import AffinityPropagation
from random import randrange
import random
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE
from sklearn.manifold import Isomap
from SOM import SOM




class DataQuantizer:

    def applyKMeans(self, k, X):
        nData = np.size(X,0)
        nFeatures = np.size(X,1)
        #Inicializamos el arreglo de centroides
        centroids = np.zeros((k,nFeatures))
        for i in range(0, k):
            randInt = random.randint(0,nData-1)
            centroids[i,:] = X[randInt,:]
        
        changedAssignments = True
        maxEpochs = 1000
        dataLabels = np.zeros(nData)
        epoch = 1
        distanceCalculator = DistanceCalculator()
        centroidCounts = np.zeros(k)
        while(changedAssignments and epoch <= maxEpochs):
            changedAsssignments = False
            for i in range(0,nData):
                vector = X[i,:]
                minDist = float('Inf')
                label = dataLabels[i]
                for j in range(0,k):
                    centroid = centroids[j,:]
                    dst = distanceCalculator.euclideanDistance(vector, centroid)
                    if(dst < minDist):
                        label = j
                        minDist = dst
                prevLabel = int(dataLabels[i])
                if(label != prevLabel and epoch != 1):
                    changedAssignments = True
                    #Modificamos el valor de los centroides
                    newCentroidCount = centroidCounts[label]
                    centroids[label,:] = (newCentroidCount*centroids[label,:] + vector)/(newCentroidCount + 1)
                    centroidCounts[label] = centroidCounts[label] + 1
                    if(centroidCounts[prevLabel] >=2):
                        prevCentroidCount = centroidCounts[prevLabel]
                        centroids[prevLabel,:] = (prevCentroidCount*centroids[prevLabel,:] - vector)/(prevCentroidCount - 1)
                        centroidCounts[prevLabel]  = centroidCounts[prevLabel]  - 1
                    dataLabels[i] = label
                elif(epoch == 1):
                    changedAssignments = True
                    #Modificamos el valor de los centroides
                    newCentroidCount = centroidCounts[label]
                    centroids[label,:] = (newCentroidCount*centroids[label,:] + vector)/(newCentroidCount + 1)
                    centroidCounts[label] = centroidCounts[label] + 1
                    dataLabels[i] = label              
            epoch += 1
        
        return centroids, dataLabels
    
    def computeMedian(self, x):
        dim = len(x[0])
        med = np.zeros(dim)
        nData = len(x)
        for i in range(0,dim):
            med[i] = np.median([p[i] for p in x])
        return med

    def applyKMedians(self, k, X):
        #Para K Medianas la dinámica será similar, excepto que ahora en vez de calcular
        #el centroide, vamos a sustituir por la mediana
        nData = np.size(X, 0)
        nFeatures = np.size(X, 1)
        medCentroids = np.zeros((k, nFeatures))
        dataLabels = np.zeros(nData)
        
        for i in range(0, k):
            randInt = random.randint(0,nData-1)
            medCentroids[i,:] = X[randInt,:]
            
        #K -means es posible implementarlo sin tener que guardar los clusters
        #explicitamente, sin embargo para la mediana debemos conocer la distribución.
        clusters = {}
        for i in range(0,k):
            clusters[i] = []
        changedAssignments = True
        epoch = 1
        maxEpochs = 1000
        distanceCalculator = DistanceCalculator()
        while(changedAssignments and epoch <= maxEpochs):
            changedAsssignments = False
            
            for i in range(0,nData):
                vector = X[i,:]
                minDist = float('Inf')
                label = dataLabels[i]
                for j in range(0,k):
                    medCentroid = medCentroids[j,:]
                    #Para K medians usamos la distancia Manhattan
                    dst = distanceCalculator.manhattanDistance(vector, medCentroid)
                    if(dst < minDist):
                        label = j
                        minDist = dst
                prevLabel = int(dataLabels[i])
                if(label != prevLabel and epoch != 1):
                    changedAssignments = True
                    clusters[label].append(X[i,:].tolist())
                    medCentroids[label,:] = self.computeMedian(clusters[label])
                    clusters[prevLabel].remove(X[i,:].tolist())
                    if(len(clusters[prevLabel]) != 0):
                        medCentroids[prevLabel,:] = self.computeMedian(clusters[prevLabel])
                    dataLabels[i] = label
                    
                elif(epoch == 1):
                    changedAssignments = True
                    #Modificamos el valor de los centroides de mediana 
                    clusters[label].append(X[i,:].tolist())
                    dataLabels[i] = label
                    medCentroids[label,:] = self.computeMedian(clusters[label])
            epoch += 1
        
        return medCentroids, dataLabels
         
    def applySOM(self, X, neuronsWidth, neuronsHeight, radius, learningRate, epochs):
        
        som  = SOM(X, neuronsWidth, neuronsHeight)
        som.trainOnline(learningRate, radius, epochs)
        
        centers = som.neurons
        labels = []
        for i in range(0,np.size(X,0)):
            labels.append(som.findWinner(X[i,:]))

        return centers, labels
        
            
    def applyAffinityPropagation(self, X):
        clustering = AffinityPropagation(random_state=5).fit(X)
        dataLabels =  clustering.labels_
        centers = clustering.cluster_centers_
        
        return centers, dataLabels

class DistanceCalculator:
    
    def euclideanDistance(self, x, y):
        n = len(x)
        d = 0
        for i in range(0,n):
            d += (x[i] - y[i])**2
        return np.sqrt(d)
    
    def manhattanDistance(self, x, y):
        n = len(x)
        d = 0
        for i in range(0,n):
            d += np.abs(x[i] - y[i])
        
        return d




