# -*- coding: utf-8 -*-
'''
A script to take in a csv file with sequencing library plate layouts in grid format 
and return meta data files for use with RedRep SNP calling pipeline.

We assume that each library consists of 2 96-well plates.
Samples are arranged sorted within rows then by columns.
First half of plate 1 uses Illumina adaptor i05
Second half of plate 1 uses Illumina adaptor i06
First half of plate 2 uses Illumina adaptor i12
Second half of plate 2 uses Illumina adaptor i19
   
   
Goal is to create metadata files with the following columns:
    
unique_id	library_id	person	date_submit	date_return	gbs_protocol	
illumina_type	entry	p1_enzyme	p1_recog_site	p1_hang_seq	p1_index	
p1_index_seq	p1_expect_seq	p2_enzyme	p2_recog_site	p2_hang_seq	p2_index	
p2_index_seq	p2_expect_seq	comment
          
'''
import os as os
import pandas as pd
import re as re
import math as math

#make some global variables
projectName = "JJSG" #Jesus Sanchez Gonzalez
idPrefix = "JJSG" #could be prefix for nursery source of tissue, eg, "18CL"

os.chdir("Q:/My Drive/Abraham")
layout = pd.read_csv("UdG teoNILs plate layout Lib2.csv")
layout.head()

v_vars=['Col' + str(x) for x in range(1,13)]
layout2 = layout.melt(id_vars=['Library', 'Plate', 'Row'], value_vars=v_vars, var_name='Col', value_name='Row_Plant', col_level=None)
layout2.Col = layout2.Col.str.replace('Col', '',)
layout2 = layout2.astype({'Col': 'int', 'Library': 'str'})

#make sure to sort in same order as indexer info!!!!
layout2.sort_values(by = ['Library', 'Plate', 'Col', 'Row'], inplace = True)
layout2.reset_index(drop = True, inplace = True)

#make library_id
layout2['library_id'] = projectName + '_' + layout2['Library']

#get the indexer info 
#repeat this indexer info 2 times for each plate, which = nrow of layout/4.
#Do this in a dumb way by concatenating the original index info (nrow of layout/4 minus 1) times:
p1_index_info = pd.read_csv('p1_index_info.csv')
p1_add = p1_index_info
for i in range(int((layout.shape[0]/float(4))-1)): 
    p1_index_info = p1_index_info.append(p1_add,  ignore_index=True)

#add the indexer info to the data frame
layout2 = layout2.merge(p1_index_info, left_index=True, right_index=True)

#create the info for 2nd indexer
layout2['half'] = layout2.Col.apply(lambda x: math.ceil(x/6))
layout2['p2_index'] = 'Pi05'
layout2.loc[(layout2.Plate == 1) & (layout2.half == 2),'p2_index'] = 'Pi06'
layout2.loc[(layout2.Plate == 2) & (layout2.half == 1),'p2_index'] = 'Pi12'
layout2.loc[(layout2.Plate == 2) & (layout2.half == 2),'p2_index'] = 'Pi19'

#make a dict with common values to be used for EVERY entry
common_vals = {'person':'Josie_Bloom', 'date_submit':'6/20/2018', 'date_return':'8/14/2018', 
'gbs_protocol':'RW-Lab', 'illumina_type':'HiSeq2500',  'p1_enzyme':'Csp6I', 'p1_recog_site':'GTAC', 
'p1_hang_seq':'C','p2_enzyme':'NgoMIV', 'p2_recog_sit':'GCCGGC', 'p2_hang_seq':'C', 
'p2_index_seq':'N/A','p2_expect_seq':'N/A', 'comment':'N/A'}

#use list comprehension to assign the common values to columns
#notice that dictionary keys are unordered, so order or columns will be random
for cname in common_vals.keys():
    layout2[cname] = common_vals[cname]

#create the entry and unique_id fields
layout2['entry'] = idPrefix + layout2.Row_Plant.astype('str')
layout2.loc[layout2.entry.isnull(), 'entry'] = 'blank'
layout2['unique_id'] = layout2.p1_index + '_' + layout2.entry + '_' + layout2.p2_index

#trim the P suffix from unique_id
layout2['unique_id'] = layout2.unique_id.str.replace('^P', '') #gets the first P
layout2['unique_id'] = layout2.unique_id.str.replace('_P', '_') #gets the 2nd P

#print out results, with the columns in desired order
col_order = ['unique_id', 'library_id', 'person', 'date_submit', 'date_return', 
'gbs_protocol', 'illumina_type', 'entry', 'p1_enzyme', 'p1_recog_site', 
'p1_hang_seq', 'p1_index', 'p1_index_seq', 'p1_expect_seq', 'p2_enzyme', 
'p2_recog_sit', 'p2_hang_seq', 'p2_index', 'p2_index_seq','p2_expect_seq', 'comment']

#sort Row within Col
layout2.sort_values(by = ['Library', 'Plate', 'Col', 'Row'], inplace = True)
layout2.to_csv('layout2.txt', sep='\t', index = False)


#get the library number values to generate metadata for
libNums = layout.Library.unique()
startLib = libNums.min()
endLib = libNums.max()

if startLib == endLib: #we only have one library
    library = startLib
    for plate in [1,2]:
        for half in [1,2]:
            layout3 = layout2.loc[(layout2.Library == str(library)) & (layout2.Plate == plate) & (layout2.half == half), ]
            layout3 = layout3[col_order]
            fname = 'meta' + str(library) + '-' + str(((plate - 1)*2) + half) + '.txt'
            layout3.to_csv(fname, sep='\t', index = False)
    
else: #for more than one library
    for library in [1,2]:
        for plate in [1,2]:
            for half in [1,2]:
                layout3 = layout2.loc[(layout2.Library == str(library)) & (layout2.Plate == plate) & (layout2.half == half), ]
                layout3 = layout3[col_order]
                fname = 'meta' + str(library) + '-' + str(((plate - 1)*2) + half) + '.txt'
                layout3.to_csv(fname, sep='\t', index = False)
            

