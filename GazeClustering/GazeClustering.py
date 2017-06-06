import math
import numpy as np
import scipy.io as sio
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

rawData = sio.loadmat('coutrot_database1.mat', struct_as_record=False, squeeze_me=True).get('Coutrot_Database1')

auditory_Condition = rawData._fieldnames
del(auditory_Condition[5])

data = []

for i in auditory_Condition:
    rawData_con = rawData.__dict__[i]
    clip_nb = rawData_con._fieldnames
    if 'clip_1' in clip_nb:
        rawDatum = rawData_con.__dict__['clip_1'].__dict__['data']
        #print(rawDatum.shape)
        data.append(rawDatum)

del(data[0])


print('Preprocessing...')
forTest = []
for record in data:
    participants = record.transpose((2, 1, 0))
    for participant in participants:
        partLen = len(participant)
        firstNonNan = 0
        while math.isnan(participant[firstNonNan][0]) and math.isnan(participant[firstNonNan][1]): firstNonNan += 1
        firstnonNanX = participant[firstNonNan][0]
        firstnonNanY = participant[firstNonNan][1]
        for i in range(firstNonNan, -1, -1):
            participant[i][0] = firstnonNanX
            participant[i][1] = firstnonNanY
        for i in range(partLen):
            if math.isnan(participant[i][0]): participant[i][0] = participant[i-1][0]
            if math.isnan(participant[i][1]): participant[i][1] = participant[i-1][1]
        forTest.append(participant)

forTest = np.array(forTest)
forTest = forTest.reshape((forTest.shape[0], forTest.shape[1] * forTest.shape[2]))

print('Clustering...')
k = 2
kmeans = KMeans(k)
kmeans.fit(forTest)
predicts = kmeans.predict(forTest)
score = silhouette_score(forTest, predicts)
print('k =', k, ', Score =', score)
while True:
    k += 1
    newTrial = KMeans(k)
    newTrial.fit(forTest)
    newPredicts = newTrial.predict(forTest)
    curScore = silhouette_score(forTest, predicts)
    print('k =', k, ', Score =', curScore)
    if curScore < score:
        break
    score = curScore
    kmeans = newTrial
    predicts = newPredicts
k -= 1
print('Done. The best k is', k)
print('Centroids Shape :', kmeans.cluster_centers_.shape)
print('Prediction :', predicts)
np.savetxt('data.txt', forTest, fmt='%d')
np.savetxt('means.txt', kmeans.cluster_centers_, fmt='%d')
np.savetxt('predicts.txt', predicts)
print('Data', forTest.shape, "were saved as 'data.txt'")
print('Centroids', kmeans.cluster_centers_.shape, "were saved as 'means.txt'")
print('Predicts', predicts.shape, "were saved as 'predicts.txt'")
