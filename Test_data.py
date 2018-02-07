# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 14:37:05 2018

@author: zhaox
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

##Import data
parm1 = pd.read_excel('Test_record_2018_01.xlsx',sheet_name=0)
parm1.drop(parm1.columns[-2:],axis=1,inplace=True)
parm1.drop(parm1.index[-7:],axis=0,inplace=True)
#parm1['sheet']='Set 1'

parm2 = pd.read_excel('Test_record_2018_01.xlsx',sheet_name=1)
parm2.drop(parm2.index[-7:],axis=0,inplace=True)
#parm2['sheet']='Set 2'

parm3 = pd.read_excel('Test_record_2018_01.xlsx',sheet_name=2)
parm3.drop(parm3.index[-7:],axis=0,inplace=True)
#parm3['sheet']='Set 3'

## Draw parameter scatters
#ax1 = sns.jointplot(x='p1',y='p2',data=parm1, kind="reg")
#ax2 = sns.jointplot(x='p1',y='p2',data=parm2, kind="reg")
#ax3 = sns.jointplot(x='p1',y='p2',data=parm3, kind="reg")

data = pd.concat([parm1 , parm2 , parm3]) 

## Draw the frequency result
#g = sns.PairGrid(parm3.drop(parm3.columns[:4],axis=1) , diag_sharey=False)
#g.map_lower(sns.kdeplot, cmap="Blues_d")
#g.map_upper(plt.scatter)
#g.map_diag(sns.kdeplot, lw=3)

### Draw correlation matrix
## Compute the correlation matrix
#corr = parm3.drop(parm3.columns[2:4],axis=1).corr()
#
## Generate a mask for the upper triangle
#mask = np.zeros_like(corr, dtype=np.bool)
#mask[np.triu_indices_from(mask)] = True
#
## Set up the matplotlib figure
#f, ax = plt.subplots(figsize=(11, 9))
#
## Generate a custom diverging colormap
#cmap = sns.diverging_palette(220, 10, as_cmap=True)
#
## Draw the heatmap with the mask and correct aspect ratio
#sns.heatmap(corr, mask=mask, cmap=cmap,annot=True)

## Draw the bar plot of three sets
#parm1['Test set']='Set 1'
#parm2['Test set']='Set 2'
#parm3['Test set']='Set 3'
#data = pd.concat([parm1 , parm2 , parm3]) 
#data_mean=data.drop(data.columns[:4],axis=1).groupby('Test set').mean()
#data_std=data.drop(data.columns[:4],axis=1).groupby('Test set').std()
#
#data_mean.T.plot(kind='bar')
#data_std.T.plot(kind='bar')

# Draw the data of single set
plot_data=parm1.iloc[:,4:]
ax=plot_data.plot(kind='kde')
ax.set_xlabel('Frequencies(Hz)')
ax.set_ylabel('Distribution')




