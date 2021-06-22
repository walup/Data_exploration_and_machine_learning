import numpy as np
import random
from scipy.stats import wasserstein_distance
import scipy.stats as stats
class DistributionComparator:

    def getDistribution(self, data):
        nData = len(data)
        nBins = int(np.sqrt(nData))
        minData = np.min(data)
        maxData = np.max(data)
        binSize = (maxData - minData)/nBins

        hist = np.zeros(nBins)

        for i in range(0,nData):
            bin = int((data[i]-minData) // binSize)
            if(bin == nBins):
                bin = bin - 1
            hist[bin] += 1

        probabilityDistribution = hist/sum(hist)
        return np.linspace(minData, maxData, nBins), probabilityDistribution


    def getEuclideanDistance(self, data1, data2):
        """
        Obtiene la distancia euclidiana entre las distribuciones de probabilidad de 2 series de tiempo
        """
        if(len(data1) != len(data2)):
            print("El tamaño de las series de tiempo debe ser igual")
        nData = len(data1)
        nBins = int(np.sqrt(nData))
        minData1 = np.min(data1)
        maxData1 = np.max(data1)
        binSize = (maxData1 - minData1)/nBins

        hist1 = np.zeros(nBins)

        for i in range(0,nData):
            bin = int((data1[i]-minData1) // binSize)
            if(bin == nBins):
                bin = bin - 1
            hist1[bin] += 1

        probabilityDistribution1 = hist1/sum(hist1)
        
        minData2 = np.min(data2)
        maxData2 = np.max(data2)
        binSize = (maxData2 - minData2)/nBins
        hist2 = np.zeros(nBins)
        for i in range(0,nData):
            bin = int((data2[i] - minData2) // binSize)
            if(bin == nBins):
                bin = bin - 1
            hist2[bin] += 1

        probabilityDistribution2 = hist2/sum(hist2)

        euclideanDistance = 0
        for i in range(0,nBins):
            euclideanDistance += (probabilityDistribution1[i] - probabilityDistribution2[i])**2
        euclideanDistance = np.sqrt(euclideanDistance)
        return euclideanDistance

    def getNormalDistance(self,data1, data2):
        """
        Obtiene la distancia normal entre las distribuciones de 2 series de tiempo
        """
        if(len(data1) != len(data2)):
            print("El tamaño de las series de tiempo debe ser igual")
        nData = len(data1)
        nBins = int(np.sqrt(nData))
        minData1 = np.min(data1)
        maxData1 = np.max(data1)
        binSize = (maxData1 - minData1)/nBins

        hist1 = np.zeros(nBins)

        for i in range(0,nData):
            bin = int((data1[i]-minData1) // binSize)
            if(bin == nBins):
                bin = bin - 1
            hist1[bin] += 1

        probabilityDistribution1 = hist1/sum(hist1)
        
        minData2 = np.min(data2)
        maxData2 = np.max(data2)
        binSize = (maxData2 - minData2)/nBins
        hist2 = np.zeros(nBins)
        for i in range(0,nData):
            bin = int((data2[i] - minData2) // binSize)
            if(bin == nBins):
                bin = bin - 1
            hist2[bin] += 1

        probabilityDistribution2 = hist2/sum(hist2)

        normalDistance = 0
        for i in range(0,nBins):
            normalDistance += np.abs(probabilityDistribution1[i] - probabilityDistribution2[i])

        return normalDistance


    def computeWassersteinDistance(self, data1, data2):

        if(len(data1) != len(data2)):
            print("El tamaño de las series de tiempo debe ser igual")
        nData = len(data1)
        nBins = int(np.sqrt(nData))
        minData1 = np.min(data1)
        maxData1 = np.max(data1)
        binSize = (maxData1 - minData1)/nBins

        hist1 = np.zeros(nBins)

        for i in range(0,nData):
            bin = int((data1[i]-minData1) // binSize)
            if(bin == nBins):
                bin = bin - 1
            hist1[bin] += 1

        probabilityDistribution1 = hist1/sum(hist1)
        
        minData2 = np.min(data2)
        maxData2 = np.max(data2)
        binSize = (maxData2 - minData2)/nBins
        hist2 = np.zeros(nBins)
        for i in range(0,nData):
            bin = int((data2[i] - minData2) // binSize)
            if(bin == nBins):
                bin = bin - 1
            hist2[bin] += 1

        probabilityDistribution2 = hist2/sum(hist2)
        n = len(probabilityDistribution1)

        sample1 = random.choices(np.linspace(0, nBins, nBins), weights = probabilityDistribution1, k = 10000)
        sample2 = random.choices(np.linspace(0, nBins, nBins), weights = probabilityDistribution2, k = 10000)

        return wasserstein_distance(sample1, sample2)
    

    def kolmogorovTest(self, data1, data2):
        if(len(data1) != len(data2)):
            print("El tamaño de las series de tiempo debe ser igual")
        nData = len(data1)
        nBins = int(np.sqrt(nData))
        minData1 = np.min(data1)
        maxData1 = np.max(data1)
        binSize = (maxData1 - minData1)/nBins

        hist1 = np.zeros(nBins)

        for i in range(0,nData):
            bin = int((data1[i]-minData1) // binSize)
            if(bin == nBins):
                bin = bin - 1
            hist1[bin] += 1

        probabilityDistribution1 = hist1/sum(hist1)
        
        minData2 = np.min(data2)
        maxData2 = np.max(data2)
        binSize = (maxData2 - minData2)/nBins
        hist2 = np.zeros(nBins)
        for i in range(0,nData):
            bin = int((data2[i] - minData2) // binSize)
            if(bin == nBins):
                bin = bin - 1
            hist2[bin] += 1

        probabilityDistribution2 = hist2/sum(hist2)
        n = len(probabilityDistribution1)

        sample1 = random.choices(np.linspace(0, nBins, nBins), weights = probabilityDistribution1, k = 10000)
        sample2 = random.choices(np.linspace(0, nBins, nBins), weights = probabilityDistribution2, k = 10000)
        #Hacemos la prueba de hipótesis
        statistic, pValue = stats.kstest(sample1, sample2)
        return pValue







