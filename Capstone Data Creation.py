# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd
import numpy as np
import os

os.chdir(r'C:\Users\asus\Documents\Masters Stuff\MIS581 Capstone')

#%% Free Agent Contract Data

df = pd.concat(pd.read_excel(r'MLB_Free_Agents_Data.xlsx', sheet_name=None),ignore_index=True)
df = df[df['Years']>=1]
df.head()

df = df[["Player", "Pos'n", "Age", "New Club", "Years", "Guarantee", "Term", "AAV"]]
df = df.rename(columns={"Pos'n":"Position"})

df2=df

#Cleaning up column values
df2[['Term Start', 'Term End']] = df2.Term.str.split("-", expand = True)
df2[['Last Name', 'First Name']] = df2.Player.str.split(",", expand = True)

df2['ID'] = df2['Last Name'].astype(str)+"_"+df2['Term Start'].astype('str')


# Calculating AAV Percentages by Year
AAV_sum = df2.groupby(['Term Start'], as_index=False).agg({'AAV': 'sum'})
AAV_sum = AAV_sum.rename(columns={'Term Start':'Sign Year', 'AAV':'AAV sum'})

df3 = df2.merge(AAV_sum, left_on='Term Start', right_on='Sign Year', how='left')
df3 = df3.drop(columns=['Sign Year'])

df3['cumsum'] = df3.groupby(['Term Start'], as_index=False)['AAV'].cumsum()
df3['AAV_perc'] =  (100*df3['cumsum'])/(df3['AAV sum'].astype(float))

# Standardizing Player Positions
pos_mapping = pd.read_csv(r'position_mapping_file.csv')
pos_mapping.head()

df3 = df3.merge(pos_mapping, on='Position', how='left')

# Remove unneccary columns
FA_Data = df3[["ID","Last Name", "First Name","Position Group","Age", "New Club", "Years", "Guarantee", "Term","Term Start", "AAV","AAV sum", "AAV_perc"]]

# Identifying "large" contracts
FA_Data['Large'] = np.where(FA_Data['AAV_perc']<46,1,0)

# Standardize Team Names for easier merging
FA_Data = FA_Data[FA_Data['New Club']!='NPB']
FA_Data.loc[FA_Data["New Club"] == "MON", "New Club"] = 'WAS'
FA_Data.loc[FA_Data["New Club"] == "KC", "New Club"] = 'KCA'
FA_Data.loc[FA_Data["New Club"] == "FLA", "New Club"] = 'MIA'

FA_Data.columns
FA_Data.to_excel('FA_Data_Final.xlsx')

#%% MLB Team Data
Team_df = pd.concat(pd.read_excel(r'MLB_Team_Data.xlsx', sheet_name=None),ignore_index=True)
Team_df.head() 
Team_df.Champion.sum() #28
Team_df =Team_df.fillna(0)
Team_df.shape #(834,27)

# Remove unneccary columns
Team_df = Team_df[['Year','Tm','W','L','W-L%','Playoffs']]
Team_df.shape # (834,6)

# Bring in file to map team names with team name abbreviations
name_mapping = pd.read_excel(r'team_name_mapping.xlsx')
name_mapping.head()

Team_full = Team_df.merge(name_mapping, left_on='Tm',right_on='Full Team Name', how='left')
Team_full

Team_full = Team_full[['Year','Abv','W-L%','Playoffs']]
Team_full = Team_full.rename(columns={'W-L%':'WL_Perc'})
Team_full['Year'] = Team_full['Year'].astype(int)
Team_full.columns

#%% Preparing Final Data Set

FA_Data['Year 0'] = FA_Data['Term Start'].astype(int)
FA_Data['Year -1']= FA_Data['Year 0'] - 1
FA_Data['Year -2']= FA_Data['Year 0'] - 2
FA_Data['Year 1']= FA_Data['Year 0'] + 1
FA_Data['Year 2']= FA_Data['Year 0'] + 2
FA_Data['Year 3']= FA_Data['Year 0'] + 3
FA_Data['Year 4']= FA_Data['Year 0'] + 4
FA_Data['Year 5']= FA_Data['Year 0'] + 5

FA_Data.columns

Final = FA_Data.copy()

# Team data for Year -2
Final = Final.merge(Team_full, left_on=['Year -2','New Club'],right_on=['Year','Abv'],how='left')
Final = Final.drop(columns=['Year','Abv'])
Final = Final.rename(columns={'WL_Perc':'WL_Perc Year -2', 'Playoffs': 'Playoffs Year -2'})
Final.columns
# Team data for Year -1
Final = Final.merge(Team_full, left_on=['Year -1','New Club'],right_on=['Year','Abv'],how='left')
Final = Final.drop(columns=['Year','Abv'])
Final = Final.rename(columns={'WL_Perc':'WL_Perc Year -1', 'Playoffs': 'Playoffs Year -1'})

# Team data for Year 0
Final = Final.merge(Team_full, left_on=['Year 0','New Club'],right_on=['Year','Abv'],how='left')
Final = Final.drop(columns=['Year','Abv'])
Final = Final.rename(columns={'WL_Perc':'WL_Perc Year 0', 'Playoffs': 'Playoffs Year 0'})

# Team data for Year 1
Final = Final.merge(Team_full, left_on=['Year 1','New Club'],right_on=['Year','Abv'],how='left')
Final = Final.drop(columns=['Year','Abv'])
Final = Final.rename(columns={'WL_Perc':'WL_Perc Year 1', 'Playoffs': 'Playoffs Year 1'})

# Team data for Year 2
Final = Final.merge(Team_full, left_on=['Year 2','New Club'],right_on=['Year','Abv'],how='left')
Final = Final.drop(columns=['Year','Abv'])
Final = Final.rename(columns={'WL_Perc':'WL_Perc Year 2', 'Playoffs': 'Playoffs Year 2'})

# Team data for Year 3
Final = Final.merge(Team_full, left_on=['Year 3','New Club'],right_on=['Year','Abv'],how='left')
Final = Final.drop(columns=['Year','Abv'])
Final = Final.rename(columns={'WL_Perc':'WL_Perc Year 3', 'Playoffs': 'Playoffs Year 3'})

# Team data for Year 4
Final = Final.merge(Team_full, left_on=['Year 4','New Club'],right_on=['Year','Abv'],how='left')
Final = Final.drop(columns=['Year','Abv'])
Final = Final.rename(columns={'WL_Perc':'WL_Perc Year 4', 'Playoffs': 'Playoffs Year 4'})

# Team data for Year 5
Final = Final.merge(Team_full, left_on=['Year 5','New Club'],right_on=['Year','Abv'],how='left')
Final = Final.drop(columns=['Year','Abv'])
Final = Final.rename(columns={'WL_Perc':'WL_Perc Year 5', 'Playoffs': 'Playoffs Year 5'})

#%% Calculate "Success"
Final2 = Final.copy()

Final2['Success Year -1'] = np.where((Final2['Playoffs Year -2'] == 0) & ((Final2['WL_Perc Year -1'] >= 1.1*Final2['WL_Perc Year -2'])|(Final2['Playoffs Year -1'] == 1)),1,
     np.where((Final2['Playoffs Year -2'] == 1) & (Final2['Playoffs Year -1'] == 1),1,0))

Final2['Success Year 0'] = np.where((Final2['Playoffs Year -1'] == 0) & ((Final2['WL_Perc Year 0'] >= 1.1*Final2['WL_Perc Year -1'])|(Final2['Playoffs Year 0'] == 1)),1,
     np.where((Final2['Playoffs Year -1'] == 1) & (Final2['Playoffs Year 0'] == 1),1,0))

Final2['Success Year 1'] = np.where((Final2['Playoffs Year 0'] == 0) & ((Final2['WL_Perc Year 1'] >= 1.1*Final2['WL_Perc Year 0'])|(Final2['Playoffs Year 1'] == 1)),1,
     np.where((Final2['Playoffs Year 0'] == 1) & (Final2['Playoffs Year 1'] == 1),1,0))

Final2['Success Year 2'] = np.where((Final2['Playoffs Year 1'] == 0) & ((Final2['WL_Perc Year 2'] >= 1.1*Final2['WL_Perc Year 1'])|(Final2['Playoffs Year 2'] == 1)),1,
     np.where((Final2['Playoffs Year 1'] == 1) & (Final2['Playoffs Year 2'] == 1),1,0))

Final2['Success Year 3'] = np.where((Final2['Playoffs Year 2'] == 0) & ((Final2['WL_Perc Year 3'] >= 1.1*Final2['WL_Perc Year 2'])|(Final2['Playoffs Year 3'] == 1)),1,
     np.where((Final2['Playoffs Year 2'] == 1) & (Final2['Playoffs Year 3'] == 1),1,0))

Final2['Success Year 4'] = np.where((Final2['Playoffs Year 3'] == 0) & ((Final2['WL_Perc Year 4'] >= 1.1*Final2['WL_Perc Year 3'])|(Final2['Playoffs Year 4'] == 1)),1,
     np.where((Final2['Playoffs Year 3'] == 1) & (Final2['Playoffs Year 4'] == 1),1,0))

Final2['Success Year 5'] = np.where((Final2['Playoffs Year 4'] == 0) & ((Final2['WL_Perc Year 5'] >= 1.1*Final2['WL_Perc Year 4'])|(Final2['Playoffs Year 5'] == 1)),1,
     np.where((Final2['Playoffs Year 4'] == 1) & (Final2['Playoffs Year 5'] == 1),1,0))

Final2.to_excel('succ.xlsx')

#%% Final Dataset

Final2 = Final2.drop(columns=['Year -2', 'Year -1', 'Year 0', 'Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5'])
Final2.shape # (2048, 37)

Final2.to_excel('Capstone_Research_Dataset.xlsx')

#%% Only Teams Who Signed Large Contracts

Final3 = Final2.loc[Final2['Large']==1]
Final3.to_excel('Capstone_Research_Large.xlsx')