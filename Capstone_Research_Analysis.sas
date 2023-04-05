
/* Importing Dataset */
FILENAME REFFILE '/home/u60962916/Capstone/Capstone_Research_Dataset.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.'Data'n;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.'Data'n; RUN;


/* Importing Data for Teams Who Signed Large Contracts */
FILENAME REFFILE '/home/u60962916/Capstone/Capstone_Research_Large.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.'Large'n;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.'Large'n; RUN;


/* Performing Chi-Square Tests to Test 1st Research Question */
PROC FREQ data=Data;
    TABLE Large*Success_Year_0 / CHISQ NOROW NOCOL NOPERCENT;
RUN;

PROC FREQ data=Data;
    TABLE Large*Success_Year_1 / CHISQ NOROW NOCOL NOPERCENT;
RUN;

PROC FREQ data=Data;
    TABLE Large*Success_Year_2 / CHISQ NOROW NOCOL NOPERCENT;
RUN;

PROC FREQ data=Data;
    TABLE Large*Success_Year_3 / CHISQ NOROW NOCOL NOPERCENT;
RUN;

PROC FREQ data=Data;
    TABLE Large*Success_Year_4 / CHISQ NOROW NOCOL NOPERCENT;
RUN;

/* Conducting ANOVAs to Compare Winning % to Previous Success for Teams Who Signed Large Contract */
/* Year 1 of Contract */
proc glm data=WORK.LARGE plots=none;
	class Success_Year_min_1;
	model WL_Perc_Year_0=Success_Year_min_1;
	means Success_Year_min_1 / hovtest=levene welch plots=none;
	lsmeans Success_Year_min_1 / adjust=tukey pdiff alpha=.05 plots=none;
	run;
quit;
/* Year 2 of Contract */
proc glm data=WORK.LARGE plots=none;
	class Success_Year_0;
	model WL_Perc_Year_1=Success_Year_0;
	means Success_Year_0 / hovtest=levene welch plots=none;
	lsmeans Success_Year_0 / adjust=tukey pdiff alpha=.05 plots=none;
	run;
quit;
/* Year 3 of Contract */
proc glm data=WORK.LARGE plots=none;
	class Success_Year_1;
	model WL_Perc_Year_2=Success_Year_1;
	means Success_Year_1 / hovtest=levene welch plots=none;
	lsmeans Success_Year_1 / adjust=tukey pdiff alpha=.05 plots=none;
	run;
quit;
/* Year 4 of Contract */
proc glm data=WORK.LARGE plots=none;
	class Success_Year_2;
	model WL_Perc_Year_3=Success_Year_2;
	means Success_Year_2 / hovtest=levene welch plots=none;
	lsmeans Success_Year_2 / adjust=tukey pdiff alpha=.05 plots=none;
	run;
quit;
/* Year 5 of Contract */
proc glm data=WORK.LARGE plots=none;
	class Success_Year_3;
	model WL_Perc_Year_4=Success_Year_3;
	means Success_Year_3 / hovtest=levene welch plots=none;
	lsmeans Success_Year_3 / adjust=tukey pdiff alpha=.05 plots=none;
	run;
quit;


/* Box Plot to Visualize Significant Results */
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.DATA;
	title height=14pt "Winning % in Year 0 vs Success in Year -1 for Teams that Signed Large Contracts";
	vbox WL_Perc_Year_0 / category='Success_Year_-1'n group=Large;
	xaxis label="Success in Year -1";
	yaxis grid label="Winning % in Year 0";
run;

ods graphics / reset;
title;


/* Scatter Plots to Visualize Relationship between AAV of Contract and Yearly Winning % */
/* Year 1 of Contract */
proc sgplot data=WORK.LARGE;
	title height=14pt "Team Winning % in 1st Year of Large Player Contract vs AAV";
	reg x=AAV y=WL_Perc_Year_0 / nomarkers degree=2 cli alpha=0.05;
	scatter x=AAV y=WL_Perc_Year_0 /;
	xaxis grid label="AAV of Player's Contract (in USD)";
	yaxis min=0.25 max=0.75 grid label="Team Winning % in 1st Year of Contract";
run;

ods graphics / reset;
title;
/* Year 2 of Contract */
proc sgplot data=WORK.LARGE;
	title height=14pt "Team Winning % in 2nd Year of Large Player Contract vs AAV";
	reg x=AAV y=WL_Perc_Year_1 / nomarkers degree=2 cli alpha=0.05;
	scatter x=AAV y=WL_Perc_Year_1 /;
	xaxis grid label="AAV of Player's Contract (in USD)";
	yaxis min=0.25 max=0.75 grid label="Team Winning % in 2nd Year of Contract";
run;

ods graphics / reset;
title;
/* Year 3 of Contract */
proc sgplot data=WORK.LARGE;
	title height=14pt "Team Winning % in 3rd Year of Large Player Contract vs AAV";
	reg x=AAV y=WL_Perc_Year_2 / nomarkers degree=2 cli alpha=0.05;
	scatter x=AAV y=WL_Perc_Year_2 /;
	xaxis grid label="AAV of Player's Contract (in USD)";
	yaxis min=0.25 max=0.75 grid label="Team Winning % in 3rd Year of Contract";
run;

ods graphics / reset;
title;
/* Year 4 of Contract */
proc sgplot data=WORK.LARGE;
	title height=14pt "Team Winning % in 4th Year of Large Player Contract vs AAV";
	reg x=AAV y=WL_Perc_Year_3 / nomarkers degree=2 cli alpha=0.05;
	scatter x=AAV y=WL_Perc_Year_3 /;
	xaxis grid label="AAV of Player's Contract (in USD)";
	yaxis min=0.25 max=0.75 grid label="Team Winning % in 4th Year of Contract";
run;

ods graphics / reset;
title;
/* Year 5 of Contract */
proc sgplot data=WORK.LARGE;
	title height=14pt "Team Winning % in 5th Year of Large Player Contract vs AAV";
	reg x=AAV y=WL_Perc_Year_4 / nomarkers degree=2 cli alpha=0.05;
	scatter x=AAV y=WL_Perc_Year_4 /;
	xaxis grid label="AAV of Player's Contract (in USD)";
	yaxis min=0.25 max=0.75 grid label="Team Winning % in 5th Year of Contract";
run;

ods graphics / reset;
title;


/* Correlation Analysis Comparing Player Age to Team Success Over Time */
proc sort data=WORK.LARGE out=Work.SortTempTableSorted;
	by Success_Year_min_1;
run;

proc corr data=Work.SortTempTableSorted pearson nosimple noprob plots=none;
	var Age;
	with Success_Year_0 Success_Year_1 Success_Year_2 Success_Year_3 
		Success_Year_4;
	by Success_Year_min_1;
run;

proc delete data=Work.SortTempTableSorted;
run;


/* Correlation Analysis Comparing Player Contract Length to Team Success Over Time */
proc sort data=WORK.LARGE out=Work.SortTempTableSorted;
	by Success_Year_min_1;
run;

proc corr data=Work.SortTempTableSorted pearson nosimple noprob plots=none;
	var Years;
	with Success_Year_0 Success_Year_1 Success_Year_2 Success_Year_3 
		Success_Year_4;
	by Success_Year_min_1;
run;

proc delete data=Work.SortTempTableSorted;
run;


/* Binary Logistic Regression Models for Team Success Over Time */
/* Model for Year 1 */
proc logistic data=WORK.LARGE plots=none;
	class Position_Group Success_Year_min_1 Years / param=glm;
	model Success_Year_0(event='1')=Position_Group Success_Year_min_1 Years Age 
		AAV WL_Perc_Year_min_2 WL_Perc_Year_min_1 / link=logit selection=stepwise 
		slentry=0.05 slstay=0.05 hierarchy=single technique=fisher;
run;
/* Model for Year 2 */
proc logistic data=WORK.LARGE plots=none;
	class Position_Group Success_Year_0 Years / param=glm;
	model Success_Year_1(event='1')=Position_Group Success_Year_0 Years Age 
		AAV WL_Perc_Year_min_1 WL_Perc_Year_0 / link=logit selection=stepwise 
		slentry=0.05 slstay=0.05 hierarchy=single technique=fisher;
run;
/* Model for Year 3 */
proc logistic data=WORK.LARGE plots=none;
	class Position_Group Success_Year_1 Years / param=glm;
	model Success_Year_2(event='1')=Position_Group Success_Year_1 Years Age 
		AAV WL_Perc_Year_0 WL_Perc_Year_1 / link=logit selection=stepwise 
		slentry=0.05 slstay=0.05 hierarchy=single technique=fisher;
run;
/* Model for Year 4 */
proc logistic data=WORK.LARGE plots=none;
	class Position_Group Success_Year_2 Years / param=glm;
	model Success_Year_3(event='1')=Position_Group Success_Year_2 Years Age 
		AAV WL_Perc_Year_1 WL_Perc_Year_2 / link=logit selection=stepwise 
		slentry=0.05 slstay=0.05 hierarchy=single technique=fisher;
run;
/* Model for Year 5 */
proc logistic data=WORK.LARGE plots=none;
	class Position_Group Success_Year_3 Years / param=glm;
	model Success_Year_4(event='1')=Position_Group Success_Year_3 Years Age 
		AAV WL_Perc_Year_2 WL_Perc_Year_3 / link=logit selection=stepwise 
		slentry=0.05 slstay=0.05 hierarchy=single technique=fisher;
run;


/* Linear Regression Models for Team Winning % Over Time */
/* Model for Year 1 */
proc glmselect data=WORK.LARGE plots=(criterionpanel);
	class Position_Group Success_Year_min_1 Years / param=glm;
	model WL_Perc_Year_0=Position_Group Success_Year_min_1 Years Age AAV 
		WL_Perc_Year_min_2 WL_Perc_Year_min_1 / selection=stepwise
(select=sbc) hierarchy=single;
run;
/* Model for Year 2 */
proc glmselect data=WORK.LARGE plots=(criterionpanel);
	class Position_Group Success_Year_0 Years / param=glm;
	model WL_Perc_Year_1=Position_Group Success_Year_0 Years Age AAV 
		WL_Perc_Year_min_1 WL_Perc_Year_0 / selection=stepwise
(select=sbc) hierarchy=single;
run;
/* Model for Year 3 */
proc glmselect data=WORK.LARGE plots=(criterionpanel);
	class Position_Group Success_Year_1 Years / param=glm;
	model WL_Perc_Year_2=Position_Group Success_Year_1 Years Age AAV 
		WL_Perc_Year_0 WL_Perc_Year_1 / selection=stepwise
(select=sbc) hierarchy=single;
run;
/* Model for Year 4 */
proc glmselect data=WORK.LARGE plots=(criterionpanel);
	class Position_Group Success_Year_2 Years / param=glm;
	model WL_Perc_Year_3=Position_Group Success_Year_2 Years Age AAV 
		WL_Perc_Year_2 WL_Perc_Year_1 / selection=stepwise
(select=sbc) hierarchy=single;
run;
/* Model for Year 5 */
proc glmselect data=WORK.LARGE plots=(criterionpanel);
	class Position_Group Success_Year_3 Years / param=glm;
	model WL_Perc_Year_4=Position_Group Success_Year_3 Years Age AAV 
		WL_Perc_Year_3 WL_Perc_Year_2 / selection=stepwise
(select=sbc) hierarchy=single;
run;
