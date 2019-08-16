import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn import metrics
import xgboost as xgb
import vcf, os

vcf_file_mn = 'chm13/minimap2-nanosv/nanosv.vcf'
vcf_file_ms = 'chm13/minimap2-sniffles/sniffles.vcf'
vcf_file_nn = 'chm13/ngmlr-nanosv/nanosv.vcf'
vcf_file_ns = 'chm13/ngmlr-sniffles/sniffles.vcf'
vcf_file_gn = 'chm13/graphmap-nanosv/nanosv.vcf'
vcf_file_gs = 'chm13/graphmap-sniffles/sniffles.vcf'
vcf_file_lp = 'chm13/last-picky/picky.allsv.vcf'
true_ins = 'CHM13/trueset/nstd137.chr.ins.bp.sort.merge.bed'
true_del = 'CHM13/trueset/nstd137.chr.del.sort.merge.bed'

#create labels
print('Creating labels for minimap2-nanosv...')
if(not os.path.exists(vcf_file_mn+'_label.txt')):
	os.system('bash gen_label.sh'+' '+vcf_file_mn+' '+true_ins+' '+true_del)
else:
	print('Label exists.')
print('Creating labels for minimap2-sniffles...')
if(not os.path.exists(vcf_file_ms+'_label.txt')):
	os.system('bash gen_label.sh'+' '+vcf_file_ms+' '+true_ins+' '+true_del)
else:
	print('Label exists.')
print('Creating labels for ngmlr-nanosv...')
if(not os.path.exists(vcf_file_nn+'_label.txt')):
	os.system('bash gen_label.sh'+' '+vcf_file_nn+' '+true_ins+' '+true_del)
else:
	print('Label exists.')
print('Creating labels for ngmlr-sniffles...')
if(not os.path.exists(vcf_file_ns+'_label.txt')):
	os.system('bash gen_label.sh'+' '+vcf_file_ns+' '+true_ins+' '+true_del)
else:
	print('Label exists.')
print('Creating labels for graphpmap-nanosv...')
if(not os.path.exists(vcf_file_gn+'_label.txt')):
	os.system('bash gen_label.sh'+' '+vcf_file_gn+' '+true_ins+' '+true_del)
else:
	print('Label exists.')
print('Creating labels for graphmap-sniffles...')
if(not os.path.exists(vcf_file_gs+'_label.txt')):
	os.system('bash gen_label.sh'+' '+vcf_file_gs+' '+true_ins+' '+true_del)
else:
	print('Label exists.')
print('Creating labels for last-picky...')
if(not os.path.exists(vcf_file_lp+'_label.txt')):
	os.system('bash gen_label.sh'+' '+vcf_file_lp+' '+true_ins+' '+true_del)
else:
	print('Label exists.')

vcf_reader_mn = vcf.Reader(open(vcf_file_mn, 'r'))
vcf_reader_ms = vcf.Reader(open(vcf_file_ms, 'r'))
vcf_reader_nn = vcf.Reader(open(vcf_file_nn, 'r'))
vcf_reader_ns = vcf.Reader(open(vcf_file_ns, 'r'))
vcf_reader_gn = vcf.Reader(open(vcf_file_gn, 'r'))
vcf_reader_gs = vcf.Reader(open(vcf_file_gs, 'r'))
vcf_reader_lp = vcf.Reader(open(vcf_file_lp, 'r'))

flabel_mn = open(vcf_file_mn+'_label.txt')
flabel_ms = open(vcf_file_ms+'_label.txt')
flabel_nn = open(vcf_file_nn+'_label.txt')
flabel_ns = open(vcf_file_ns+'_label.txt')
flabel_gn = open(vcf_file_gn+'_label.txt')
flabel_gs = open(vcf_file_gs+'_label.txt')
flabel_lp = open(vcf_file_lp+'_label.txt')

df = pd.DataFrame(columns=['CHROM','START','END','SVTYPE','PRECISE','SVMETHOD','RE','CIPOS','CIEND','SVLEN','MAPQ','DEPTHPVAL', 'LABEL'])

def gen_df(reader, label):

	print('Reading into dataframe...')
	label_list = []

	for l in label:
		label_list.append(l.strip())
	print("#Label: "+str(len(label_list)))

	record_list = []

	for record in reader:
		
		# Normalizing data
		if 'SVLEN' in record.INFO:
			if isinstance(record.INFO['SVLEN'],int):
				svlen = float(record.INFO['SVLEN'])
			else:
				svlen = float(record.INFO['SVLEN'][0])
		else:
			svlen = np.nan

		if 'PRECISE' in record.INFO:
			precise = 1
		elif 'IMPRECISE' in record.INFO:
			precise = 0
		else:
			precise = 1

		record_list.append({
			'CHROM': record.CHROM,
			'START': record.POS,
			'END': record.POS+1,
			'SVTYPE': record.INFO['SVTYPE'],
			'PRECISE': float(precise),
			'SVMETHOD': record.INFO['SVMETHOD'],
			'RE': record.INFO['RE'] if 'RE' in record.INFO else np.nan,
			'CIPOS': float(abs(record.INFO['CIPOS'][1])+abs(record.INFO['CIPOS'][0])) if 'CIPOS' in record.INFO else np.nan,
			'CIEND': float(abs(record.INFO['CIEND'][1])+abs(record.INFO['CIEND'][0])) if 'CIEND' in record.INFO else np.nan,
			'SVLEN': svlen,
			'MAPQ': float(record.INFO['MAPQ'][0]+record.INFO['MAPQ'][1]) if 'MAPQ' in record.INFO else np.nan,
			'DEPTHPVAL': record.INFO['DEPTHPVAL'] if 'DEPTHPVAL' in record.INFO else np.nan
		})
	print("#SV before filtering: "+str(len(record_list)))

	my_df = pd.DataFrame(record_list, columns=['CHROM','START','END','SVTYPE','PRECISE','SVMETHOD','RE','CIPOS','CIEND','SVLEN','MAPQ','DEPTHPVAL','LABEL'])

	my_df['LABEL'] = label_list

	# Filtering
	my_df = my_df[(my_df['SVTYPE']=='DEL')]
	#my_df = my_df[(my_df['SVTYPE']=='INS') | (my_df['SVTYPE']=='DUP')]
	my_df = my_df[my_df['SVLEN']>30]
	my_df = my_df[my_df['SVLEN']<=100000]
	print("#SV after filtering: "+str(len(my_df)))

	return my_df

df = df.append(gen_df(vcf_reader_mn, flabel_mn), ignore_index = True)
df = df.append(gen_df(vcf_reader_ms, flabel_ms), ignore_index = True)
df = df.append(gen_df(vcf_reader_nn, flabel_nn), ignore_index = True)
df = df.append(gen_df(vcf_reader_ns, flabel_ns), ignore_index = True)
df = df.append(gen_df(vcf_reader_gn, flabel_gn), ignore_index = True)
df = df.append(gen_df(vcf_reader_gs, flabel_gs), ignore_index = True)
df = df.append(gen_df(vcf_reader_lp, flabel_lp), ignore_index = True)
#print(df)

print('Running classifier...')

# Fitting
X=df[['PRECISE','CIPOS','CIEND','RE','SVLEN','MAPQ','DEPTHPVAL']]
y=df['LABEL']

X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=0.2)

clf=xgb.XGBRFClassifier(n_estimators=100)
clf.fit(X_train,y_train)

y_pred=clf.predict(X_test)

print("Accuracy:",metrics.accuracy_score(y_test, y_pred))
print("Precision:",metrics.precision_score(y_test, y_pred, pos_label="True"))
print("Recall:",metrics.recall_score(y_test, y_pred, pos_label="True"))
print("F1 score:",metrics.f1_score(y_test, y_pred, pos_label="True"))

callset=[i for i, x in enumerate(y_pred) if x == 'True']
print('Callset:',len(callset))
trueset=[i for i, x in enumerate(y_test) if x == 'True']
print('Trueset:',len(trueset))
intersect=[value for value in callset if value in trueset]
print('Intersect:',len(intersect))


feature_imp = pd.Series(clf.feature_importances_,index=['PRECISE','CIPOS','CIEND','RE','SVLEN','MAPQ','DEPTHPVAL']).sort_values(ascending=False)

print(feature_imp)
