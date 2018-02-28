from sklearn.datasets import load_svmlight_file
#from sklearn.linear_model import LogisticRegression
from sklearn.neural_network import MLPClassifier
from sklearn import metrics
import numpy as np
import sys

input_dimension = sys.argv[1]
ith_experiment = sys.argv[2]

train_data = load_svmlight_file(f='tempdata/traindata_'+ith_experiment, n_features=int(input_dimension), zero_based=False)
test_data = load_svmlight_file(f='tempdata/testdata_'+ith_experiment, n_features=int(input_dimension), zero_based=False)

model = MLPClassifier(hidden_layer_sizes=(32, 32, 16), alpha=1e-3, batch_size=128, learning_rate_init=0.001, max_iter=100, verbose=True, early_stopping=False, tol=-10000)

model.fit(X=train_data[0], y=train_data[1])
predictions = model.predict(X=test_data[0])

fpr, tpr, thresholds = metrics.roc_curve(test_data[1], predictions, pos_label=1)
auc = metrics.auc(fpr, tpr)
print(auc)

np.savetxt('tempdata/test_log_scores_'+ith_experiment+'.asc', predictions) 
