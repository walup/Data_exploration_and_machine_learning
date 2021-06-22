from SOM import SOM
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE
from sklearn.manifold import Isomap
import numpy as np


class DimReductor:

    def SOMReduction(self, X, neuronsHeight, neuronsWidth, radius, learningRate, epochs):
        #Entrenemos 
        som = SOM(X, neuronsHeight, neuronsWidth)
        som.trainOnline(learningRate, radius, epochs)
        nData = np.size(X, 0)
        winners = []
        for i in range(0,nData):
            #Almacenamos las coordenadas de la neurona ganadora.
            winners.append(som.findWinner(X[i,:]))
        
        return som.getUMatrix(), winners
    
    def PCAReduction(self, X, nComponents):
        pca = PCA(n_components=nComponents)
        pca.fit(X)
        return pca.transform(X)
    
    def tSNEReduction(self, X, nComponents):
        nFeatures = np.size(X,1)
        tsne = TSNE(n_components = nComponents)
        return tsne.fit_transform(X)
    
    def isomapReduction(self, X,nComponents):
        nFeatures = np.size(X,1)
        embedding = Isomap(n_components=nComponents)
        return embedding.fit_transform(X)




