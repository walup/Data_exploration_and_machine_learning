import numpy as np
from scipy.fft import fft, ifft


class FeatureCalculator:

    #Vamos a extraer algunas características
    def getMean(self, x):
        return np.mean(x)

    def getStd(self, x):
        return np.std(x)

    def skewness(self, x):
        n = len(x)
        mu = self.getMean(x)
        sigma = self.getStd(x)
        s = 0;
        factor = (1/(n*sigma**3))
        for i in range(0,n):
            s = s + factor*(x[i] - mu)**3
        return s

    def getKurtosis(self, x):
        mu = self.getMean(x)
        sigma = self.getStd(x)
        n = len(x)
        k = 0
        factor = (1/(n*sigma**4))
        for i in range(0,n):
            k = k + factor*(x[i] - mu)**4
        return k

    #Rango intercuartil
    def interquantileRange(sekf,x):
        firstQuantile = np.quantile(x,0.25)
        thirdQuantile = np.quantile(x,0.75)
        return thirdQuantile - firstQuantile

    def peak2Peak(self, x):
        minX = np.min(x)
        maxX = np.max(x)

        return maxX - minX

    def rms(self, x):
        n = len(x)
        rms = 0
        for i in range(0,n):
            rms = rms + (1/n)*x[i]**2
        rms = np.sqrt(rms)

        return rms

    def waveformLength(self, x):
        n = len(x)
        wfl = 0
        for i in range(0,n-1):
            wfl = wfl + np.abs(x[i+1] - x[i])

        return wfl

    def getNumberOfFeatures(self):
        return 19

    def zeroCrossing(self, x):
        zc = 0
        n = len(x)
        thresh = 0.01
        for i in range(0,n-1):
            zci = np.sign(-x[i]*x[i+1])
            dist = abs(x[i]-x[i+1])
            zi = 0
            if(dist > thresh):
                zi = 1
            zc = zc + zi*zci
        return zc

    def slopeSignChange(self, x):
        n = len(x)
        thresh = 0.01
        ssc = 0
        for i in range(1,n-1):
            ssci = np.sign((x[i] - x[i-1])*(x[i] - x[i+1]))
            si = 0
            if(np.abs(x[i]-x[i+1])>thresh and np.abs(x[i] - x[i-1])>thresh):
                si = 1
            ssc  = ssc + si*ssci

        return ssc
    def wilsonAmplitude(self, x):
        wa = 0
        n = len(x)
        thresh = 0.01
        for i in range(0,n-1):
            wa = wa + np.sign(np.abs(x[i+1] - x[i]) - thresh)

        return wa

    def logDetector(self, x):
        ld = 0
        n = len(x)
        for i in range(0,n):
            ld = ld + (1/n)*np.log(np.abs(x[i]))
        ld = np.exp(ld)
        return ld


    def energy(self, x):
        n = len(x)
        e = 0
        for i in range(0,n):
            e = e + (1/n)*np.abs(x[i])**2
        return e

    def modifiedMeanAbsoluteValue(self, x):
        n = len(x)
        mmav = 0
        for i in range(0,n):
            wi = 0
            if(i >= 0.25*n and i<=0.75*n):
                wi = 1
            mmav = mmav +(1/n)*wi*np.abs(x[i])
        return mmav

    def meanPowerFrequency(self, x, t):
        Fs = len(t)/(t[-1]-t[0])
        ps = np.abs(fft(x))**2
        freqInterval = np.linspace(0, Fs, len(t))
        ps = ps[0:int(len(t)/2)]
        freqInterval = freqInterval[0:int(len(t)/2)]
        dist = ps/sum(ps)
        mpf = 0
        for i in range(0,len(freqInterval)):
            mpf = mpf + freqInterval[i]*dist[i]
        return mpf


    def medianFrequency(self, x, t):
        Fs = len(t)/(t[-1]-t[0])
        ps = np.abs(fft(x))**2
        freqInterval = np.linspace(0, Fs, len(t))
        freqInterval = freqInterval[0:int(len(t)/2)]
        ps = ps[0:int(len(t)/2)]
        dist = ps/sum(ps)
        s = 0
        mf = 0
        for i in range(0,len(dist)):
            s = s + dist[i]
            if(s >= 0.5):
                mf = freqInterval[i]
                break
        return mf

    def oneQuarterFrequency(self, x, t):
        Fs = len(t)/(t[-1]-t[0])
        ps = np.abs(fft(x))**2
        freqInterval = np.linspace(0, Fs, len(t))
        freqInterval = freqInterval[0:int(len(t)/2)]
        ps = ps[0:int(len(t)/2)]
        dist = ps/sum(ps)
        s = 0
        oqf = 0
        for i in range(0,len(dist)):
            s = s + dist[i]
            if(s >= 0.25):
                oqf = freqInterval[i]
                break
        return oqf

    def threeQuarterFrequency(self,x,t):
        Fs = len(t)/(t[-1]-t[0])
        ps = np.abs(fft(x))**2
        freqInterval = np.linspace(0, Fs, len(t))
        freqInterval = freqInterval[0:int(len(t)/2)]
        ps = ps[0:int(len(t)/2)]
        dist = ps/sum(ps)

        s = 0
        tqf = 0
        for i in range(0,len(dist)):
            s = s + dist[i]
            if(s >= 0.75):
                tqf = freqInterval[i]
                break
        return tqf

    def entropy(self,x,t):
        Fs = len(t)/(t[-1]-t[0])
        ps = np.abs(fft(x))**2
        freqInterval = np.linspace(0, Fs, len(t))
        freqInterval = freqInterval[0:int(len(t)/2)]
        ps = ps[0:int(len(t)/2)]
        dist = ps/sum(ps)
        e = 0

        for i in range(0,len(dist)):
            e -= dist[i]*np.log2(dist[i])

        return e


    def computeAllFeatureVector(self, x, t):
        mu = self.getMean(x)
        sigma = self.getStd(x)
        sk = self.skewness(x)
        k = self.getKurtosis(x)
        iqr = self.interquantileRange(x)
        p2p = self.peak2Peak(x)
        rms = self.rms(x)
        wfl = self.waveformLength(x)
        zc = self.zeroCrossing(x)
        sc = self.slopeSignChange(x)
        wa = self.wilsonAmplitude(x)
        ld = self.logDetector(x)
        en  = self.energy(x)
        mmav = self.modifiedMeanAbsoluteValue(x)
        mpf = self.meanPowerFrequency(x,t)
        mf = self.medianFrequency(x,t)
        oqf = self.oneQuarterFrequency(x,t)
        tqf = self.threeQuarterFrequency(x,t)
        e = self.entropy(x,t)

        vector = [mu, sigma, sk, k, iqr, p2p, rms, wfl, zc, sc, wa, ld, en, mmav, mpf, mf, oqf, tqf, e]

        return vector













