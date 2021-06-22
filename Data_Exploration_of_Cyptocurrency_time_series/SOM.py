import numpy as np
import random
import DataQuantizer

class SOM:

    def __init__(self, data, neuronsWidth, neuronsHeight):
        self.data = data
        dimData = np.size(data,1)
        self.neuronsWidth = neuronsWidth
        self.neuronsHeight = neuronsHeight
        self.neurons = np.zeros((neuronsHeight, neuronsWidth, dimData))
        for i in range(0,np.size(self.neurons,0)):
            for j in range(0,np.size(self.neurons,1)):
                for s in range(0,np.size(self.neurons,2)):
                    self.neurons[i,j,s] = random.random()

        self.dimData = dimData

    def trainOnline(self, eta, radius, epochs):
        neighborhoodCalculator = NeighborhoodCalculator()
        distanceCalculator = DataQuantizer.DistanceCalculator()
        nData = np.size(self.data,0)
        for i in range(0,epochs):
            #Vamos a ir disminuyendo linealmente el radio y la tasa de aprendizaje
            sigma = round(radius*(1 - (i-1)/epochs))
            learningRate = eta*(1 - 1/epochs)
            #Seleccionamos un vector aleatoriamente
            randVector = self.data[random.randint(0,nData - 1),:]
            #Encontramos el BMU
            ind1 = 0
            ind2 = 0
            minDistance = float('Inf')
            for row in range(0,self.neuronsHeight):
                for col in range(0,self.neuronsWidth):
                    dist = distanceCalculator.euclideanDistance(randVector, self.neurons[row,col,:])
                    if(dist < minDistance):
                        minDistance = dist
                        ind1 = row
                        ind2 = col

            indsToModify = neighborhoodCalculator.getInclusiveNeighborhood(ind1, ind2, self.neuronsWidth, self.neuronsHeight, sigma)
            bmuNeuron = self.neurons[ind1,ind2,:]

            for j in range(0,len(indsToModify)):
                inds = indsToModify[j]
                neuron = self.neurons[inds[0],inds[1],:]
                neighborhoodDist = neighborhoodCalculator.getNeighborhoodDistance(bmuNeuron, neuron)
                bmuDist = 1
                if(neighborhoodDist != 0):
                    norm = distanceCalculator.euclideanDistance(neuron, bmuNeuron)
                    bmuDist = np.exp(-(norm**2)/(2*neighborhoodDist**2))

                self.neurons[inds[0],inds[1],:] = self.neurons[inds[0],inds[1],:] - learningRate*bmuDist*(neuron - randVector)

    def getUMatrix(self):
        u = np.zeros((2*self.neuronsHeight - 1, 2*self.neuronsWidth - 1))
        neighborCalc = NeighborhoodCalculator()
        distCalc = DataQuantizer.DistanceCalculator()
        for i in range(0,self.neuronsHeight):
            for j in range(0,self.neuronsWidth):
                neighbors = neighborCalc.getInclusiveNeighborhood(i,j,self.neuronsWidth, self.neuronsHeight, 1)
                value = 0
                neuron = self.neurons[i,j,:]
                for k in range(0,len(neighbors)):
                    inds = neighbors[k]
                    dst = distCalc.euclideanDistance(neuron, self.neurons[inds[0],inds[1]])
                    value = value + (1/len(neighbors))*dst

                    if(inds[0] == i and inds[1] != j):
                        u[int(2*i - 1), int(2*np.min([inds[1],j]))] = dst
                    elif(inds[1] == j and inds[0] != i):
                        u[int(2*np.min([inds[0],i])),int(2*j -1)] = dst
                u[int(2*i - 1), int(2*j - 1)] = dst
        uHeight = np.size(u,0)
        uWidth = np.size(u,1)
        for i in range(0,uHeight):
            for j in range(0,uWidth):
                if(i%2 == 0 and j%2 == 0):
                    neighbors = neighborCalc.getInclusiveNeighborhood(i,j,uWidth, uHeight, 1)
                    s = 0
                    for k in range(0,len(neighbors)):
                        nInds = neighbors[k]
                        s = s + (1/len(neighbors))*u[nInds[0],nInds[1]]
                    u[i,j] = s
        return u

    def findWinner(self, vector):
       row = 0
       col = 0
       minDist = float('Inf')
       distanceCalculator = DataQuantizer.DistanceCalculator()
       for i in range(0,self.neuronsHeight):
           for j in range(0,self.neuronsWidth):
               neuron = self.neurons[i,j,:]
               dst = distanceCalculator.euclideanDistance(vector, neuron)
               if(dst < minDist):
                   row = i
                   col = j
                   minDist = dst
       return [row, col]         


class NeighborhoodCalculator:

    def getInclusiveNeighborhood(self, row, col, gridWidth, gridHeight, radius):
        inds = []
        inds.append([row,col])
        for i in range(0,radius):
            for p in range(0,len(inds)):
                pt = inds[p]
                neighbors = []
                for j in range(-1, 2):
                    for s in range(-1,2):
                        newInds = [pt[0] + j, pt[1] + s]
                        if(not (j == 0 and s== 0) and (j == 0 or s == 0) and newInds[0] >= 0 and newInds[0] < gridHeight and newInds[1] >= 0 and newInds[1] < gridWidth):
                            neighbors.append(newInds)

                for j in range(0,len(neighbors)):
                    neighbor = neighbors[j]

                    if(not neighbors in inds):
                        inds.append(neighbor)
        return inds


    def getNeighborhoodDistance(self, x1, x2):
        dst = 0
        if(len(x1) == len(x2)):
            for i in range(0,len(x1)):
                dst += np.abs(x1[i]-x2[i])
            return dst
        else:
            print("Operación invalida, los arreglos deben ser del mismo tamaño")

