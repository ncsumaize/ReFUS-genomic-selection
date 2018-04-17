!W 9  !ARGS 11 !RENAME 1
# !WORKSPACE 100 !RENAME !ARGS // !DOPART $1
Title: All_Exp16.
#EXP_ID,PROJECT,LOC_ID,env,Year,PLOT,rep,block,material,source_id,femrow,seed_gen,entry,Plot_Fum,planting_date,Stand_Count,EHT_1,EHT_2,EHT_3,EHT_4,EHT_5,EH_MNH,EH_MN,PHT_1,PHT_2,PHT_3,PHT_4,PHT_5,PH_MNH,PH_MN,anth_date,silk_date,dta,dts,asi,Root_ldg,Stalk_ldg,Erect_plants,ER1,ER2,ER3,ER4,ER5,ER6,ER7,ER8,ER9,ER10,ER11,ER12,Ear_rot,yield_g,yield_plant,ear_count,Fumonisin_ppm,Plate,check_vs_exp,exp,check,z
#16,EXP16CLYThiago,1,CLY,2015,1,1,1,ReFUS_C3,12FL0022-5,12FL0022,S0:1,231,31,4/29/2015,12,75,90,75,65,85,77,78,165,170,145,155,165,159.5,160,7/2/2015,7/3/2015,64,65,1,0,2,0.833333333,0,0,5,10,30,0,5,5,5,5, , ,6.5,1042,104.2,10,1.253,CLY1,1,12FL0022-5,0,1
#16,EXP16CLYThiago,1,CLY,2015,2,1,1,ReFUS_C3,12FL0018-8,12FL0018,S0:1,182,350,4/29/2015,19,80,75,100,100,110,91,93,185,175,195,205,200,191.4,192,7/3/2015,7/7/2015,65,69,4,0,0,1,40,25,5,25,5,40,90,65,80, , , ,41.7,954,106,9,41.84,CLY5,1,12FL0018-8,0,1
#16,EXP16CLYThiago,1,CLY,2015,3,1,1,ReFUS_C3,12FL0025-8,12FL0025,S0:1,265,249,4/29/2015,15,90,65,80,70,80,76,77,180,150,215,160,175,173.4,176,7/3/2015,7/3/2015,65,65,0,1,2,0.8,5,75,100,5,0,10,1,1,1,15, , ,21.3,925,92.5,10,8.55,CLY3,1,12FL0025-8,0,1
#16,EXP16CLYThiago,1,CLY,2015,4,1,1,ReFUS_C3,12FL0004-7,12FL0004,S0:1,31,178,4/29/2015,16,95,95,80,75,105,88.6,90,200,200,185,170,215,192.8,194,6/30/2015,7/1/2015,62,63,1,3,1,0.75,5,5,5,5,20,25,60,10,20,5, , ,16,1031,103.1,10,0.66,CLY3,1,12FL0004-7,0,1

 EXP_ID *       # 16
 PROJECT  !A  !LL 20   !SORT     # EXP16CLYThiago
 LOC_ID !I        # 1
 env  !A      # CLY
 Year !I       # 2015
 PLOT *
 row  !I       # 4
 column !I
 rep  *       # 1
 block *         # 1
 material  !A      # ReFUS_C3
 source_id  !P !LL 20 !SORT #!L ReFUSC3_C4_K_line_order.txt   # 12FL0004-7
 femrow  !A      # 12FL0004
 seed_gen  !A      # S0:1
 group !A
 entry  !I      # 31
 Plot_Fum  !I      # 178
 planting_date  !I      # 4/29/2015
 Stand_Count  !I      # 16
 EHT_1  !I      # 95
 EHT_2  !I      # 95
 EHT_3  !I      # 80
 EHT_4  !I      # 75
 EHT_5  !I      # 105
 EH_MNH        # 88.6
 EH_MN        # 90
 PHT_1  !I      # 200
 PHT_2  !I      # 200
 PHT_3  !I      # 185
 PHT_4  !I      # 170
 PHT_5  !I      # 215
 PH_MNH        # 192.8
 PH_MN
 Ratio_PHEH        # 194
 anth_date  !I      # 6/30/2015
 silk_date  !I      # 7/1/2015
 dta        # 62
 dts        # 63
 asi         # 1
 Root_ldg         # 3
 Stalk_ldg         # 1
 Erect_plants        # 0.75
 ER1         # 5
 ER2         # 5
 ER3         # 5
 ER4         # 5
 ER5        # 20
 ER6        # 25
 ER7        # 60
 ER8        # 10
 ER9        # 20
 ER10         # 5
 ER11        # 16
 ER12        # 1031
 Ear_rot        # 103.1
 yield_g        # 10
 yield_plant        # 0.66
 ear_count
 Fumonisin_ppm
 test_weight
 density
 Plate  !A
 check_vs_exp !A
 exp  !A
 check !A
 z

 arcsRoot_ldg != Root_ldg !ARCSIN Stand_Count
 arcsStalk_ldg != Stalk_ldg !ARCSIN Stand_Count

 Ear_rot_1 !=  Ear_rot !+1
 logear_rot != Ear_rot_1 !^0
 fum_1 != Fumonisin_ppm  !+1
 logfum != fum_1  !^0

# Check/Correct these field definitions.
"ReFusC3_C4_fake_ped.txt"  !ALPHA
"ReFusC3_C4_K.grm"

"Q:/My Drive/GS_ReFUS_files/Predictions_2017/All_Exp16_pheno.csv"  !SKIP 1 !DOPATH $A  !NODISPLAY


#######BLUES - ALL ##############################################################################################################################################
######################################################################################################################################
!PATH 1 #source_id as fixed /// getting BLUES all experiments ///
!CYCLE  PH_MN EH_MN Ratio_PHEH  arcsRoot_ldg  arcsStalk_ldg
$I  ~ mu source_id,          # Specify fixed model
      !r Year*env rep.env.Year block.rep.env.Year source_id.Year source_id.env source_id.Year.env # Specify random model
residual sat(PROJECT).idv(units)  #separate error variance for each environment
predict source_id  !present source_id  !AVERAGE Year env rep block
######################################################################################################################################

######################################################################################################################################
!PATH 2 #source_id as fixed /// getting BLUES all experiments ///
!CYCLE  dts dta asi
!FILTER LOC_ID !SELECT 1
$I ~ mu source_id,          # Specify fixed model
      !r Year rep.Year block.rep.Year source_id.Year # Specify random model
residual sat(PROJECT,01,04,07).idv(units)  #separate error variance for each environment
predict source_id  !present source_id  !AVERAGE Year rep block
######################################################################################################################################

######################################################################################################################################
!PATH 3 #source_id as fixed /// getting BLUES all experiments ///
!CYCLE   logear_rot logfum  density yield_plant
$I !WT ear_count ~ mu source_id,          # Specify fixed model
      !r Year*env rep.env.Year block.rep.env.Year source_id.Year source_id.env source_id.Year.env # Specify random model
residual sat(PROJECT).idv(units)  #separate error variance for each environment
predict source_id  !present source_id  !AVERAGE Year env rep block
####################################################################################################################################################################



#BLUPS - All Experiment /// wighted for ear_count
######################################################################################################################################
!PATH 4 #source_id as random using dummie (z) variable /// weighting for ear_count/// EXP16_2014
!CYCLE  PH_MN EH_MN Ratio_PHEH  arcsRoot_ldg  arcsStalk_ldg
$I ~ mu check_vs_exp check_vs_exp.check,          # Specify fixed model
      !r  Year*env rep.env.Year block.rep.env.Year z.source_id z.source_id.Year z.source_id.env z.source_id.Year.env # Specify random model
residual sat(PROJECT).idv(units)  #separate error variance for each environment
predict check_vs_exp 1 z 1 source_id  !present check_vs_exp check source_id  !AVERAGE Year env rep block
######################################################################################################################################

######################################################################################################################################
!PATH 5 #source_id as random using dummie (z) variable /// weighting for ear_count/// EXP16_2014
!CYCLE  dts dta asi
!FILTER LOC_ID !SELECT 1
$I ~ mu check_vs_exp check_vs_exp.check,          # Specify fixed model
      !r  Year rep.Year block.rep.Year z.source_id z.source_id.Year # Specify random model
residual sat(PROJECT,01,04,07).idv(units)  #separate error variance for each environment
predict check_vs_exp 1 z 1 source_id  !present check_vs_exp check source_id  !AVERAGE Year rep block
######################################################################################################################################

######################################################################################################################################
!PATH 6 #source_id as random using dummie (z) variable /// weighting for ear_count///
!CYCLE  logear_rot logfum  yield_plant
$I  !WT ear_count ~ mu check_vs_exp check_vs_exp.check,          # Specify fixed model
      !r  Year*env rep.env.Year block.rep.env.Year z.source_id z.source_id.Year z.source_id.env z.source_id.Year.env # Specify random model
residual sat(PROJECT).idv(units)  #separate error variance for each environment
predict check_vs_exp 1 z 1 source_id  !present check_vs_exp check source_id  !AVERAGE Year env rep block
######################################################################################################################################

######################################################################################################################################
!PATH 7 #source_id as random using dummie (z) variable /// weighting for ear_count/// EXP16_2014
!ASUV
logear_rot  logfum  ~ Trait Trait.check_vs_exp Trait.check_vs_exp.check !f mv,          # Specify fixed model
   !r corgh(Trait).id(Year.env),
      corgh(Trait).id(rep.env.Year),
      corgh(Trait).id(block.rep.env.Year),
      corgh(Trait).id(z.source_id),
      corgh(Trait).id(z.source_id.Year),
      corgh(Trait).id(z.source_id.env),
      corgh(Trait).id(z.source_id.Year.env)
       # Specify random model
residual sat(PROJECT).id(units).us(Trait)  #separate error variance for each environment
predict check_vs_exp 1 z 1 source_id  !present check_vs_exp check source_id  !AVERAGE Year env rep block
######################################################################################################################################


############# G-BLUP ###################################################################################################################################
################################################################################################################
!PATH 8  #weighted traits with GRM and GRM x Env, heterogenous residuals, random Year*env BUT average over year env rep block in prediction!
!CYCLE  PH_MN EH_MN
$I   ~ mu,        # Specify fixed model
   !r Year*env rep.env.Year block.rep.env.Year grm(source_id) grm(source_id).Year.env
residual sat(PROJECT).idv(units)  #separate error variance for each environment
predict source_id  !AVERAGE Year env rep block

################################################################################################################
!PATH 9  #weighted traits with GRM and GRM x Env, heterogenous residuals, random Year*env BUT average over year env rep block in prediction!
!CYCLE  dts dta asi
!FILTER LOC_ID !SELECT 1
$I   ~ mu,        # Specify fixed model
   !r Year rep.Year block.rep.Year grm(source_id) grm(source_id).Year
residual sat(PROJECT,01,04,07).idv(units)  #separate error variance for each environment
predict source_id  !AVERAGE Year rep block

################################################################################################################
!PATH 10  #weighted traits with GRM and GRM x Env, heterogenous residuals, random Year*env BUT average over year env rep block in prediction!
!CYCLE   logfum  logear_rot  yield_plant
$I   !WT ear_count ~ mu,        # Specify fixed model
   !r Year*env rep.env.Year block.rep.env.Year grm(source_id) grm(source_id).Year.env
residual sat(PROJECT).idv(units)  #separate error variance for each environment
predict source_id  !AVERAGE Year env rep block

#############################################################################################################################

#############################################################################################################################
!PATH 11 #MULTIVARIATE logfum AND ear rot with GRM and GRM x Env, heterogenous residuals, random Year*env BUT average over year env rep block in prediction!
#DROP weight by ear_count because it causes convergence problems
# DROP GxE term: us(Trait).grm(source_id).Year.env because it is very small for both traits and causes convergence problems
#!TSV #provide starting values from 2016 analysis, since without, convergence fails, start with zero covariances
!ASUV !MAXITER 25 !CONTINUE   #use !CONTINUE FOR MORE ITERATIONS AFTER STARTING WITH TXV
logfum logear_rot  ~ mu Trait Tr.Year.env !f mv,   # Specify fixed model !WT ear_count THIS CAUSES FAILURE
   !r  us(Tr).rep.env.Year us(Tr).block.rep.env.Year  us(Tr).grm(source_id)
residual sat(PROJECT).id(units).us(Tr)  #separate error variance/covariance for each environment
predict source_id  !AVERAGE Year env rep block

VPREDICT !DEFINE
R gencorr  us(Tr).grm(source_id)
#############################################################################################################################

