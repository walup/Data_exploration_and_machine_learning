import numpy as np
import math
import scipy.stats as stats


class CorrelationCalculator:
    def getPearsonCorrelation(self, data1, data2):
        
        """
        Obtiene el coeficiente de Pearson entre dos arreglos data1 y data2. 
        Adicionalmente regresa el valor p de la prueba estadística con t student para decidir si los
        datos se encuentran correlacionados.
        """

        if(len(data1) != len(data2)):
            print("Error: el tamaño de los arreglos debe ser igual para calcular la correlación de Pearson")
        else:

            return stats.pearsonr(data1,data2)

    def getMutualInformation(self, data1, data2):
        """
        Calcula la información mutua entre 2 series de tiempo. 

        
        """


        if(len(data1) != len(data2)):
            print("El tamaño de los arreglos debe ser igual")
            return None

        #Entropia del primer arreglo
        n1 = len(data1)
        min1 = np.min(data1)
        max1 = np.max(data1)
        nBins1 = int(np.sqrt(n1))
        binLength1 = (max1 - min1)/nBins1
        hist1 = np.zeros(nBins1)
        
        for i in range(0,n1):
            bin = int((data1[i] - min1)//binLength1)
            if(bin == nBins1):
                bin = bin - 1
            hist1[bin] += 1

        probabilityDistribution1 = hist1/sum(hist1)

        entropy1 = 0
        for i in range(0,len(probabilityDistribution1)):
            if(probabilityDistribution1[i] != 0):
                entropy1 -= probabilityDistribution1[i]*math.log2(probabilityDistribution1[i])

        #Entropia del segundo arreglo
        n2 = len(data2)
        min2 = np.min(data2)
        max2 = np.max(data2)
        nBins2 = int(np.sqrt(n2))
        binLength2 = (max2 - min2)/nBins2
        hist2 = np.zeros(nBins2)

        for i in range(0,n2):
            bin = int((data2[i]-min2)//binLength2)
            if(bin == nBins2):
                bin = bin - 1
            hist2[bin] += 1

        probabilityDistribution2 = hist2/sum(hist2)
        entropy2 = 0
        for i in range(0,len(probabilityDistribution2)):
            if(probabilityDistribution2[i] != 0):
                entropy2 -= probabilityDistribution2[i] * math.log2(probabilityDistribution2[i])

        #Finalmente calculamos la entropia conjunta
        jointHistogram = np.zeros((nBins1, nBins2))
        for i in range(0,n1):
            bin1 = int((data1[i] - min1)//binLength1)
            bin2 = int((data2[i] - min2)//binLength2)
            if(bin1 == nBins1):
                bin1 = bin1 - 1
            if(bin2 == nBins2):
                bin2 = bin2 - 1

            jointHistogram[bin1, bin2] += 1

        jointEntropy = 0
        jointProbabilityDistribution = jointHistogram/sum(sum(jointHistogram))
        for i in range(0,nBins1):
            for j in range(0,nBins2):
                prob = jointProbabilityDistribution[i,j]
                if(prob != 0):
                    jointEntropy -= prob*math.log2(prob)

        return entropy1 + entropy2 - jointEntropy



























