/* Code 1: Data Load, Labelling and finding the missing values*/
LIBNAME glm '/home/u62518985';
FILENAME bcdata '/home/u62518985/GLM/breastcancer.csv';
proc import
datafile = bcdata
out = glm.breastcancerdata
dbms = csv
replace;
getnames = yes;
run;
data glm.breastcancerdata;
set glm.breastcancerdata;
if size = "<=20" then tumor_size = 2;
else if size = "20-50" then tumor_size = 1;
else if size = ">50" then tumor_size = 0;
run;
data glm.breastcancerdata;
set glm.breastcancerdata;
label
id='patient id'
pid='patient id within study'
year='year the patient underwent surgery'
age='age of patient during surgery'
meno='menopausal status (0=premenopausal, 1=postmenopausal)'
size='size of tumor'
grade='grade of tumor'
nodes='number of positive lymph nodes'
pgr='progesterone receptors(fmol/l)'
er='estrogen receptors (fmol/l)'
hormon='hormonal therapy (0=not received, 1=received)'
chemo='chemotherapy received or not (0=not received, 1=received)'
recurence_free='recurrence-free survival time (months) or last follow-up'
rtime ='days to relapse or last follow-up)'
recur = 'whether or not the patient experienced recurrence(0= no relapse, 1= relapse)'
dtime = 'days to relapse or last follow-up'
death='whether the patient died during the follow-up period 0=alive, 1=death'
tumor_size='size of tumor, <=20 is 1, 20-50 is 2 and >50 is 3';
run;
proc means data=glm.breastcancerdata nmiss;
var year age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime death;
run;
/* Code 2: Descriptive Statistics*/
proc means data=glm.breastcancerdata n mean median min max stddev skewness;
var age ;
run;
proc univariate data=glm.breastcancerdata noprint;
var age;
histogram / normal;
run;
proc univariate data=glm.breastcancerdata ;
var age;
qqplot / normal;
run;
proc corr data=glm.breastcancerdata;
var dtime rtime;
run;
proc freq data=glm.breastcancerdata;
table recur death;
run;
proc freq data=glm.breastcancerdata;
table chemo death;
run;
proc freq data=glm.breastcancerdata;
table hormon death;
run;
/*Code 3: Cox Proportional Hazard Model And Survival Curve*/
/*survival analysis*/
proc phreg data=glm.breastcancerdata;
model dtime*death(0) = age meno grade nodes pgr er hormon chemo recur/selection=stepwise slentry=0.20 slstay=0.15 covb;
run;
proc lifetest data=glm.breastcancerdata notable;
time dtime*death(0);
strata recur;
run;
proc lifetest data=glm.breastcancerdata notable;
time dtime*death(0);
strata grade;
run;
/* Code 4: Logistic Regression*/
proc logistic data= glm.breastcancerdata descending;
model death = age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime/selection=stepwise ;
output out=glm.logpred resdev=resdev dfbetas=dfbetas pred ;
run;
data glm.breastcancerdata;
set glm.breastcancerdata;
observation=_n_;
run;
proc sgplot data=glm.logpred;
scatter x=observation y=resdev / markerattrs=(symbol=circlefilled) markerfillattrs=(color=red);
xaxis label="observation";
yaxis label="residuals";
run;
/*Code 5: Poisson, Negative Binomal, Zero Inflated Poisson, Zero Inflated Negative*/
Binomial And The Assumption Of Independence For Zinb
title 'number of zeros in nodes';
proc sql;
select count(*) as num_zeros
from glm.breastcancerdata
where nodes = 0;
quit;
proc genmod data= glm.breastcancerdata;
model nodes = age meno death grade pgr er hormon chemo rtime recur/ dist =poisson link=log;
run;
proc means data=glm.breastcancerdata mean var;
var nodes;
run;
proc genmod data=glm.breastcancerdata;
model nodes = age meno death grade pgr er hormon chemo rtime recur/ dist =negbin link=log;
run;
proc genmod data=glm.breastcancerdata;
model nodes = age meno death grade pgr er hormon chemo rtime recur/ dist=zip link=log;
zeromodel age meno death pgr er hormon chemo rtime recur dtime ;
run;
proc genmod data=glm.breastcancerdata;
model nodes = age meno death grade pgr er hormon chemo rtime recur/ dist=zinb link = log ;
zeromodel age meno death pgr er hormon chemo rtime recur dtime ;
output out=glm.zinbresiduals pred=predicted reschi=reschi;
run;
data glm.breastcancerdata;
set glm.breastcancerdata;
observation=_n_;
run;
proc sgplot data=glm.zinbresiduals;
scatter x=observation y=reschi / markerattrs=(symbol=circlefilled) markerfillattrs=(color=red);
xaxis label="observation";
yaxis label="residuals";
run;