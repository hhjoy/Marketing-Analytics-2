# Load the package
library(RODBC)
library(ggplot2)
# Connect to MySQL (my credentials are mysql_server_64/root/.)
db = odbcConnect("mysql_server_64", uid="root", pwd="root")
sqlQuery(db, "USE ma_charity_full")

#------------------------------------------------------------------------
# A. Extract the data from database
#------------------------------------------------------------------------
#1. DO MA
query="Select a.amount, a.act_date, a.act_type_id, a.payment_method_id, a.channel_id, b.id as contact_id, b.zip_code , b.prefix_id , b.active , b.code_geo
from acts as a
left join (select *
from contacts ) b
On a.contact_id = b.id
where (a.act_type_id Like 'DO') and (a.channel_id like 'MA' ) and (year(a.act_date) > 2012)"
dataset_DO_MA = sqlQuery(db, query)

#Replace the missing values 
dataset_DO_MA$prefix_id  [which(is.na(dataset_DO_MA$prefix_id)) ] =  tail(names(sort(table(dataset_DO_MA$prefix_id))), 1)
dataset_DO_MA$zip_code  [which(is.na(dataset_DO_MA$zip_code)) ] =  tail(names(sort(table(dataset_DO_MA$zip_code))), 1)
dataset_DO_MA$code_geo  [which(is.na(dataset_DO_MA$code_geo)) ] =  tail(names(sort(table(dataset_DO_MA$code_geo))), 1)

#Add a variable "Gender" based on the prefix_id
dataset_DO_MA$gender [which (dataset_DO_MA$prefix_id == "MR")] = 0
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "DR")] = 0
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "ME")] = 0
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "MME")] = 1
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "MLLE")] = 1
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "MMME")] = 2
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "AU")] = 3
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "NA")] = 3

#Transform the column data 
dataset_DO_MA$act_date <- as.Date(dataset_DO_MA$act_date , format = "%Y-%m-%d")

######################Extract Infos 
#1.Group by contact Id 
DO_MA_distinct_contacts = unique(dataset_DO_MA$contact_id)
Info_DO_MA= data.frame(DO_MA_distinct_contacts)
contact=106
for (contact in DO_MA_distinct_contacts)
{
  donations=data.frame()
  idx =which(Info_DO_MA$DO_MA_distinct_contacts==contact)
  donations= dataset_DO_MA[which(dataset_DO_MA$contact_id==contact),]
}



#2. DO WW
query="Select a.amount, a.act_date, a.act_type_id, a.payment_method_id, a.channel_id, b.id as contact_id, b.zip_code , b.prefix_id , b.active , b.code_geo
from acts as a
left join (select *
from contacts ) b
On a.contact_id = b.id
where (a.act_type_id Like 'DO') and (a.channel_id like 'WW' ) and (year(a.act_date) > 2009)"
dataset_DO_WW = sqlQuery(db, query)

#Replace the missing values 
dataset_DO_WW$prefix_id  [which(is.na(dataset_DO_WW$prefix_id)) ] =  tail(names(sort(table(dataset_DO_WW$prefix_id))), 1)
dataset_DO_WW$zip_code  [which(is.na(dataset_DO_WW$zip_code)) ] =  tail(names(sort(table(dataset_DO_WW$zip_code))), 1)
dataset_DO_WW$code_geo  [which(is.na(dataset_DO_WW$code_geo)) ] =  tail(names(sort(table(dataset_DO_WW$code_geo))), 1)

#Add a variable "Gender" based on the prefix_id
dataset_DO_WW$gender [which (dataset_DO_WW$prefix_id == "MR")] = 0
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "DR")] = 0
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "ME")] = 0
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "MME")] = 1
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "MLLE")] = 1
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "MMME")] = 2
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "AU")] = 3
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "NA")] = 3

#Transform the column data 
dataset_DO_WW$act_date <- as.Date(dataset_DO_WW$act_date , format = "%Y-%m-%d")



#3. PA MA
query="Select a.amount, a.act_date, a.act_type_id, a.payment_method_id, a.channel_id, b.id as contact_id, b.zip_code , b.prefix_id , b.active , b.code_geo
from acts as a
left join (select *
from contacts ) b
On a.contact_id = b.id
where (a.act_type_id Like 'PA') and (a.channel_id like 'MA' ) and (year(a.act_date) > 2009)"
dataset_PA_MA = sqlQuery(db, query)

#Replace the missing values 
dataset_PA_MA$prefix_id  [which(is.na(dataset_PA_MA$prefix_id)) ] =  tail(names(sort(table(dataset_PA_MA$prefix_id))), 1)
dataset_PA_MA$zip_code  [which(is.na(dataset_PA_MA$zip_code)) ] =  tail(names(sort(table(dataset_PA_MA$zip_code))), 1)
dataset_PA_MA$code_geo  [which(is.na(dataset_PA_MA$code_geo)) ] =  tail(names(sort(table(dataset_PA_MA$code_geo))), 1)

#Add a variable "Gender" based on the prefix_id
dataset_PA_MA$gender [which (dataset_PA_MA$prefix_id == "MR")] = 0
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "DR")] = 0
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "ME")] = 0
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "MME")] = 1
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "MLLE")] = 1
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "MMME")] = 2
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "AU")] = 3
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "NA")] = 3

#Transform the column data 
dataset_PA_MA$act_date <- as.Date(dataset_PA_MA$act_date , format = "%Y-%m-%d")



#4. PA WW
query="Select a.amount, a.act_date, a.act_type_id, a.payment_method_id, a.channel_id, b.id as contact_id, b.zip_code , b.prefix_id , b.active , b.code_geo
from acts as a
left join (select *
from contacts ) b
On a.contact_id = b.id
where (a.act_type_id Like 'PA') and (a.channel_id like 'WW' ) and (year(a.act_date) > 2009)"
dataset_PA_WW = sqlQuery(db, query)

#Replace the missing values 
dataset_PA_WW$prefix_id  [which(is.na(dataset_PA_WW$prefix_id)) ] =  tail(names(sort(table(dataset_PA_WW$prefix_id))), 1)
dataset_PA_WW$zip_code  [which(is.na(dataset_PA_WW$zip_code)) ] =  tail(names(sort(table(dataset_PA_WW$zip_code))), 1)
dataset_PA_WW$code_geo  [which(is.na(dataset_PA_WW$code_geo)) ] =  tail(names(sort(table(dataset_PA_WW$code_geo))), 1)

#Add a variable "Gender" based on the prefix_id
dataset_PA_WW$gender [which (dataset_PA_WW$prefix_id == "MR")] = 0
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "DR")] = 0
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "ME")] = 0
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "MME")] = 1
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "MLLE")] = 1
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "MMME")] = 2
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "AU")] = 3
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "NA")] = 3

#Transform the column data 
dataset_PA_WW$act_date <- as.Date(dataset_PA_WW$act_date , format = "%Y-%m-%d")


#------------------------------------------------------------------------
# B. General Overview
#------------------------------------------------------------------------
##1. 4 Evolutions of DO / PA amounts also showing web and mail (line)
query = "SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, SUM(Amount) AS amount 
FROM acts 
where (act_type_id Like 'DO') and (channel_id Like 'MA')  and (YEAR(Act_Date)  > 2011)
GROUP BY    
ORDER BY 1"
df_Amount_DO_MA = sqlQuery(db, query)

query ="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, SUM(Amount) AS amount 
FROM acts 
where (act_type_id Like 'DO') and (channel_id Like 'MA')  and (YEAR(Act_Date)  > 2011)
group by 1,2"
df = sqlQuery(db, query)

years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_Amount_DO_MA= data.frame(years)
df_Amount_DO_MA$Amount_DO_MA = 0

df_Amount_DO_MA[1,'Amount_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'amount'])
df_Amount_DO_MA[2,'Amount_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'amount'])
df_Amount_DO_MA[3,'Amount_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'amount'])
df_Amount_DO_MA[4,'Amount_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'amount'])
df_Amount_DO_MA[5,'Amount_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'amount'])

gr = ggplot(data = df_Amount_DO_MA, aes(x = years, y = Amount_DO_MA, group = 1)) +
  geom_point() +
  geom_line()
print(gr)

######################

query ="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, SUM(Amount) AS amount 
FROM acts 
where (act_type_id Like 'DO') and (channel_id Like 'WW')  and (YEAR(Act_Date)  > 2011)
group by 1,2"
df = sqlQuery(db, query)

years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_Amount_DO_WW= data.frame(years)
df_Amount_DO_WW$Amount_DO_WW = 0

df_Amount_DO_WW[1,'Amount_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'amount'])
df_Amount_DO_WW[2,'Amount_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'amount'])
df_Amount_DO_WW[3,'Amount_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'amount'])
df_Amount_DO_WW[4,'Amount_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'amount'])
df_Amount_DO_WW[5,'Amount_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'amount'])

gr = ggplot(data = df_Amount_DO_WW, aes(x = years, y = Amount_DO_WW, group = 1)) +
  geom_point() +
  geom_line()
print(gr)


######################
query ="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, SUM(Amount) AS amount 
FROM acts 
where (act_type_id Like 'PA') and (channel_id Like 'WW')  and (YEAR(Act_Date)  > 2011)
group by 1,2"
df = sqlQuery(db, query)

years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_Amount_PA_WW= data.frame(years)
df_Amount_PA_WW$Amount_PA_WW = 0

df_Amount_PA_WW[1,'Amount_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'amount'])
df_Amount_PA_WW[2,'Amount_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'amount'])
df_Amount_PA_WW[3,'Amount_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'amount'])
df_Amount_PA_WW[4,'Amount_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'amount'])
df_Amount_PA_WW[5,'Amount_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'amount'])

gr = ggplot(data = df_Amount_PA_WW, aes(x = years, y = Amount_PA_WW, group = 1)) +
  geom_point() +
  geom_line()
print(gr)

######################
query ="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, SUM(Amount) AS amount 
FROM acts 
where (act_type_id Like 'PA') and (channel_id Like 'MA')  and (YEAR(Act_Date)  > 2011)
group by 1,2"
df = sqlQuery(db, query)

years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_Amount_PA_MA= data.frame(years)
df_Amount_PA_MA$Amount_PA_MA = 0

df_Amount_PA_MA[1,'Amount_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'amount'])
df_Amount_PA_MA[2,'Amount_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'amount'])
df_Amount_PA_MA[3,'Amount_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'amount'])
df_Amount_PA_MA[4,'Amount_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'amount'])
df_Amount_PA_MA[5,'Amount_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'amount'])

gr = ggplot(data = df_Amount_PA_MA, aes(x = years, y = Amount_PA_MA, group = 1)) +
  geom_point() +
  geom_line()
print(gr)

##2. 4 Evolution of DO / PA number of donations also showing web and mail (bar)
query ="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, COUNT(*) AS count 
FROM acts 
where (act_type_id Like 'DO') and (channel_id Like 'MA')  and (YEAR(Act_Date)  > 2011)
group by 1,2"
df = sqlQuery(db, query)

years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_NbDonations_DO_MA= data.frame(years)
df_NbDonations_DO_MA$NbDonations_DO_MA = 0

df_NbDonations_DO_MA[1,'NbDonations_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'count'])
df_NbDonations_DO_MA[2,'NbDonations_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'count'])
df_NbDonations_DO_MA[3,'NbDonations_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'count'])
df_NbDonations_DO_MA[4,'NbDonations_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'count'])
df_NbDonations_DO_MA[5,'NbDonations_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'count'])

p <- ggplot(data=df_NbDonations_DO_MA, aes(x=years, y=NbDonations_DO_MA)) 
p = p + geom_bar(stat="identity")
print(p)



query ="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, COUNT(*) AS count 
FROM acts 
where (act_type_id Like 'DO') and (channel_id Like 'WW')  and (YEAR(Act_Date)  > 2011)
group by 1,2"
df = sqlQuery(db, query)

years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_NbDonations_DO_WW= data.frame(years)
df_NbDonations_DO_WW$NbDonations_DO_WW = 0

df_NbDonations_DO_WW[1,'NbDonations_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'count'])
df_NbDonations_DO_WW[2,'NbDonations_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'count'])
df_NbDonations_DO_WW[3,'NbDonations_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'count'])
df_NbDonations_DO_WW[4,'NbDonations_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'count'])
df_NbDonations_DO_WW[5,'NbDonations_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'count'])

p <- ggplot(data=df_NbDonations_DO_WW, aes(x=years, y=NbDonations_DO_WW)) 
p = p + geom_bar(stat="identity")
print(p)




query ="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, COUNT(*) AS count 
FROM acts 
where (act_type_id Like 'PA') and (channel_id Like 'WW')  and (YEAR(Act_Date)  > 2011)
group by 1,2"
df = sqlQuery(db, query)

years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_NbDonations_PA_WW= data.frame(years)
df_NbDonations_PA_WW$NbDonations_PA_WW = 0

df_NbDonations_PA_WW[1,'NbDonations_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'count'])
df_NbDonations_PA_WW[2,'NbDonations_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'count'])
df_NbDonations_PA_WW[3,'NbDonations_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'count'])
df_NbDonations_PA_WW[4,'NbDonations_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'count'])
df_NbDonations_PA_WW[5,'NbDonations_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'count'])

p <- ggplot(data=df_NbDonations_PA_WW, aes(x=years, y=NbDonations_PA_WW)) 
p = p + geom_bar(stat="identity")
print(p)



query ="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, COUNT(*) AS count 
FROM acts 
where (act_type_id Like 'PA') and (channel_id Like 'MA')  and (YEAR(Act_Date)  > 2011)
group by 1,2"
df = sqlQuery(db, query)

years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_NbDonations_PA_MA= data.frame(years)
df_NbDonations_PA_MA$NbDonations_PA_MA = 0

df_NbDonations_PA_MA[1,'NbDonations_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'count'])
df_NbDonations_PA_MA[2,'NbDonations_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'count'])
df_NbDonations_PA_MA[3,'NbDonations_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'count'])
df_NbDonations_PA_MA[4,'NbDonations_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'count'])
df_NbDonations_PA_MA[5,'NbDonations_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'count'])

p <- ggplot(data=df_NbDonations_PA_MA, aes(x=years, y=NbDonations_PA_MA)) 
p = p + geom_bar(stat="identity")
print(p)


##3. 4 Evolution of DO / PA number of donors also showing web and mail (bar)
# Active donors each year by type

query="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, COUNT( DISTINCT contact_id) As Number_Of_Donors
FROM acts WHERE (act_type_id Like 'DO') and (channel_id Like 'WW') and (YEAR(Act_Date)  > 2011)
GROUP BY 1,2"
df = sqlQuery(db, query)
years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_Number_Of_Donors_DO_WW= data.frame(years)
df_Number_Of_Donors_DO_WW$Number_Of_Donors_DO_WW = 0

df_Number_Of_Donors_DO_WW[1,'Number_Of_Donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'Number_Of_Donors'])
df_Number_Of_Donors_DO_WW[2,'Number_Of_Donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'Number_Of_Donors'])
df_Number_Of_Donors_DO_WW[3,'Number_Of_Donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'Number_Of_Donors'])
df_Number_Of_Donors_DO_WW[4,'Number_Of_Donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'Number_Of_Donors'])
df_Number_Of_Donors_DO_WW[5,'Number_Of_Donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'Number_Of_Donors'])

p <- ggplot(data=df_Number_Of_Donors_DO_WW, aes(x=years, y=Number_Of_Donors_DO_WW)) 
p = p + geom_bar(stat="identity")
print(p)



query="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, COUNT( DISTINCT contact_id) As Number_Of_Donors
FROM acts WHERE (act_type_id Like 'DO') and (channel_id Like 'MA') and (YEAR(Act_Date)  > 2011)
GROUP BY 1,2"
df = sqlQuery(db, query)
years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_Number_Of_Donors_DO_MA= data.frame(years)
df_Number_Of_Donors_DO_MA$Number_Of_Donors_DO_MA = 0

df_Number_Of_Donors_DO_MA[1,'Number_Of_Donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'Number_Of_Donors'])
df_Number_Of_Donors_DO_MA[2,'Number_Of_Donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'Number_Of_Donors'])
df_Number_Of_Donors_DO_MA[3,'Number_Of_Donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'Number_Of_Donors'])
df_Number_Of_Donors_DO_MA[4,'Number_Of_Donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'Number_Of_Donors'])
df_Number_Of_Donors_DO_MA[5,'Number_Of_Donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'Number_Of_Donors'])

p <- ggplot(data=df_Number_Of_Donors_DO_MA, aes(x=years, y=Number_Of_Donors_DO_MA)) 
p = p + geom_bar(stat="identity")
print(p)





query="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, COUNT( DISTINCT contact_id) As Number_Of_Donors
FROM acts WHERE (act_type_id Like 'PA') and (channel_id Like 'WW') and (YEAR(Act_Date)  > 2011)
GROUP BY 1,2"
df = sqlQuery(db, query)
years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_Number_Of_Donors_PA_WW= data.frame(years)
df_Number_Of_Donors_PA_WW$Number_Of_Donors_PA_WW = 0

df_Number_Of_Donors_PA_WW[1,'Number_Of_Donors_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'Number_Of_Donors'])
df_Number_Of_Donors_PA_WW[2,'Number_Of_Donors_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'Number_Of_Donors'])
df_Number_Of_Donors_PA_WW[3,'Number_Of_Donors_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'Number_Of_Donors'])
df_Number_Of_Donors_PA_WW[4,'Number_Of_Donors_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'Number_Of_Donors'])
df_Number_Of_Donors_PA_WW[5,'Number_Of_Donors_PA_WW']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'Number_Of_Donors'])

p <- ggplot(data=df_Number_Of_Donors_PA_WW, aes(x=years, y=Number_Of_Donors_PA_WW)) 
p = p + geom_bar(stat="identity")
print(p)



query="SELECT Month(act_Date) as month , YEAR(Act_Date) AS Year, COUNT( DISTINCT contact_id) As Number_Of_Donors
FROM acts WHERE (act_type_id Like 'PA') and (channel_id Like 'MA') and (YEAR(Act_Date)  > 2011)
GROUP BY 1,2"
df = sqlQuery(db, query)
years = c('2012/2013', '2013/2014','2014/2015', '2015/2016','2016/2017')
df_Number_Of_Donors_PA_MA= data.frame(years)
df_Number_Of_Donors_PA_MA$Number_Of_Donors_PA_MA = 0

df_Number_Of_Donors_PA_MA[1,'Number_Of_Donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'Number_Of_Donors'])
df_Number_Of_Donors_PA_MA[2,'Number_Of_Donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'Number_Of_Donors'])
df_Number_Of_Donors_PA_MA[3,'Number_Of_Donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'Number_Of_Donors'])
df_Number_Of_Donors_PA_MA[4,'Number_Of_Donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'Number_Of_Donors'])
df_Number_Of_Donors_PA_MA[5,'Number_Of_Donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'Number_Of_Donors'])

p <- ggplot(data=df_Number_Of_Donors_PA_MA, aes(x=years, y=Number_Of_Donors_PA_MA)) 
p = p + geom_bar(stat="identity")
print(p)




##4. Evolution of DO / PA number of donors acquired showing web and mail (line)
# PA MA 
query="Select  month, Year  ,  COUNT(*) As Nb_new
From
( SELECT contact_id, Month (MIN(Act_Date)) as month, Year (MIN(Act_Date)) AS Year 

FROM acts
Where  Act_Type_id LIKE 'PA' and channel_id like 'MA'
GROUP BY 1) as A
where Year>2011
Group By  Year, month
Order by   Year, month"
df = sqlQuery(db, query)
years = c(2012, 2013,2014, 2015,2016)
df_Number_new_Donors_PA_MA= data.frame(years)
df_Number_new_Donors_PA_MA$Nb_new_donors_PA_MA = 0
df_Number_new_Donors_PA_MA[1,'Nb_new_donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'Nb_new'])
df_Number_new_Donors_PA_MA[2,'Nb_new_donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'Nb_new'])
df_Number_new_Donors_PA_MA[3,'Nb_new_donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'Nb_new'])
df_Number_new_Donors_PA_MA[4,'Nb_new_donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'Nb_new'])
df_Number_new_Donors_PA_MA[5,'Nb_new_donors_PA_MA']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'Nb_new'])

page <- ggplot(df_Number_new_Donors_PA_MA, aes(x = years, y = Nb_new_donors_PA_MA)) + geom_point() + stat_smooth(method=lm, fullrange = TRUE) 
print(page)


# PA WW 
query="Select  month, Year  ,  COUNT(*) As Nb_new
From
( SELECT contact_id, Month (MIN(Act_Date)) as month, Year (MIN(Act_Date)) AS Year 

FROM acts
Where  Act_Type_id LIKE 'PA' and channel_id like 'WW'
GROUP BY 1) as A
where Year>2011
Group By  Year, month
Order by   Year, month"
df = sqlQuery(db, query)
years = c(2012, 2013,2014, 2015,2016)
df_Number_new_DonorsPA_WW= data.frame(years)
df_Number_new_DonorsPA_WW$Nb_new_DonorsPA_WW = 0
df_Number_new_DonorsPA_WW[1,'Nb_new_DonorsPA_WW']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'Nb_new'])
df_Number_new_DonorsPA_WW[2,'Nb_new_DonorsPA_WW']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'Nb_new'])
df_Number_new_DonorsPA_WW[3,'Nb_new_DonorsPA_WW']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'Nb_new'])
df_Number_new_DonorsPA_WW[4,'Nb_new_DonorsPA_WW']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'Nb_new'])
df_Number_new_DonorsPA_WW[5,'Nb_new_DonorsPA_WW']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'Nb_new'])

PAge <- ggplot(df_Number_new_DonorsPA_WW, aes(x = years, y = Nb_new_DonorsPA_WW)) + geom_point() + stat_smooth(method=lm, fullrange = TRUE) 
print(PAge)


# DO MA 
query="Select  month, Year  ,  COUNT(*) As Nb_new
From
( SELECT contact_id, Month (MIN(Act_Date)) as month, Year (MIN(Act_Date)) AS Year 

FROM acts
Where  Act_Type_id LIKE 'DO' and channel_id like 'MA'
GROUP BY 1) as A
where Year>2011
Group By  Year, month
Order by   Year, month"
df = sqlQuery(db, query)
years = c(2012, 2013,2014, 2015,2016)
df_Number_new_Donors_DO_MA= data.frame(years)
df_Number_new_Donors_DO_MA$Nb_new_donors_DO_MA = 0
df_Number_new_Donors_DO_MA[1,'Nb_new_donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'Nb_new'])
df_Number_new_Donors_DO_MA[2,'Nb_new_donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'Nb_new'])
df_Number_new_Donors_DO_MA[3,'Nb_new_donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'Nb_new'])
df_Number_new_Donors_DO_MA[4,'Nb_new_donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'Nb_new'])
df_Number_new_Donors_DO_MA[5,'Nb_new_donors_DO_MA']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'Nb_new'])

DOge <- ggplot(df_Number_new_Donors_DO_MA, aes(x = years, y = Nb_new_donors_DO_MA)) + geom_point() + stat_smooth(method=lm, fullrange = TRUE) 
print(DOge)

# DO WW 
query="Select  month, Year  ,  COUNT(*) As Nb_new
From
( SELECT contact_id, Month (MIN(Act_Date)) as month, Year (MIN(Act_Date)) AS Year 

FROM acts
Where  Act_Type_id LIKE 'DO' and channel_id like 'WW'
GROUP BY 1) as A
where Year>2011
Group By  Year, month
Order by   Year, month"
df = sqlQuery(db, query)
years = c(2012, 2013,2014, 2015,2016)
df_Number_new_Donors_DO_WW= data.frame(years)
df_Number_new_Donors_DO_WW$Nb_new_donors_DO_WW = 0
df_Number_new_Donors_DO_WW[1,'Nb_new_donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2012)) | ((df$month<6) & (df$Year==2013))) , 'Nb_new'])
df_Number_new_Donors_DO_WW[2,'Nb_new_donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2013)) | ((df$month<6) & (df$Year==2014))) , 'Nb_new'])
df_Number_new_Donors_DO_WW[3,'Nb_new_donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2014)) | ((df$month<6) & (df$Year==2015))) , 'Nb_new'])
df_Number_new_Donors_DO_WW[4,'Nb_new_donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2015)) | ((df$month<6) & (df$Year==2016))) , 'Nb_new'])
df_Number_new_Donors_DO_WW[5,'Nb_new_donors_DO_WW']=sum(df[which( ((df$month>5) & (df$Year==2016)) | ((df$month<6) & (df$Year==2017))) , 'Nb_new'])

DOge <- ggplot(df_Number_new_Donors_DO_WW, aes(x = years, y = Nb_new_donors_DO_WW)) + geom_point() + stat_smooth(method=lm, fullrange = TRUE)
print(DOge)


#------------------------------------------------------------------------
# C. Dashboards
#------------------------------------------------------------------------
dashboards_summary <- data.frame(matrix(ncol =13 , nrow = 4))
x <- c("channel","total_nb_transactions", "avg_donations", "avg_length_relashionship", "avg_freq", "avg_recency","total_donors","nb_active", "nb_nonactive", "nb_female","nb_male","nb_couples", "nb_others")
colnames(dashboards_summary) <- x
dashboards_summary$channel = c('DO-MA', 'DO-WW', 'PA-MA', 'PA-WW')

###DO MA
query= "Select contact_id,avg(amount) as AVG_amount, DATEDIFF( MAX(Act_Date),Min( act_date) )/365  as length , DATEDIFF(20170626, MAX(Act_Date)) / 365 AS recency, COUNT(amount)  AS frequency , Max(act_date) as lastDonation,active, prefix_id
from acts a
Left join(select id, active, prefix_id
from contacts ) b
On  a.contact_id = b.id              
where (act_type_id Like 'DO') and (channel_id like 'MA' ) and  (act_date> 20140531)
group by contact_id "

dashboard_DO_MA = sqlQuery(db, query)

#Replace the missing values 
dashboard_DO_MA$prefix_id  [which(is.na(dashboard_DO_MA$prefix_id)) ] =  tail(names(sort(table(dashboard_DO_MA$prefix_id))), 1)

dashboard_DO_MA$gender=0
#Add a variable "Gender" based on the prefix_id
dashboard_DO_MA$gender [ which (dashboard_DO_MA$prefix_id == "MR")] = 0
dashboard_DO_MA$gender [ which (dashboard_DO_MA$prefix_id == "MME")] = 1
dashboard_DO_MA$gender [ which (dashboard_DO_MA$prefix_id == "MLLE")] = 1
dashboard_DO_MA$gender [ which (dashboard_DO_MA$prefix_id == "MMME")] = 2   #Couple
dashboard_DO_MA$gender [ which (dashboard_DO_MA$prefix_id == "AU")] = 3     #Autre
dashboard_DO_MA$gender [ which (dashboard_DO_MA$prefix_id == "NA")] = 3     

####Half split between men and women
idx =  which (dashboard_DO_MA$prefix_id == "DR")
idx_male= idx[1: round(length(idx)/2)]
idx_female= idx[round(length(idx)/2)+1 :length(idx) ]
dashboard_DO_MA$gender [idx_male] = 0
dashboard_DO_MA$gender [idx_female] = 1

idx =  which (dashboard_DO_MA$prefix_id == "ME")
idx_male= idx[1: round(length(idx)/2)]
idx_female= idx[round(length(idx)/2)+1 :length(idx) ]
dashboard_DO_MA$gender [idx_male] = 0
dashboard_DO_MA$gender [idx_female] = 1

# Fill the table
dashboards_summary$total_donors[1]= nrow(dashboard_DO_MA)
dashboards_summary$nb_active[1]= length(which (dashboard_DO_MA$active == 1))
dashboards_summary$nb_nonactive[1]= length(which (dashboard_DO_MA$active == 0))
dashboards_summary$nb_male[1]= length(which (dashboard_DO_MA$gender == 0))
dashboards_summary$nb_female[1]= length(which (dashboard_DO_MA$gender == 1))
dashboards_summary$nb_couples[1]= length(which (dashboard_DO_MA$gender == 2))
dashboards_summary$nb_others[1]= length(which (dashboard_DO_MA$gender == 3))
dashboards_summary$avg_donations[1]= mean(dashboard_DO_MA$AVG_amount)
dashboards_summary$avg_freq[1]= mean(dashboard_DO_MA$frequency)/3
dashboards_summary$avg_recency[1]= mean(dashboard_DO_MA$recency)
dashboards_summary$avg_length_relashionship[1]= mean(dashboard_DO_MA$length)

#Charts
#1. Active/non active
slices <- c(dashboards_summary$nb_active[1] , dashboards_summary$nb_nonactive[1]) 
lbls <- c("Active", "Non Active" )
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) # add percents to labels 
lbls <- paste(lbls,"%",sep="") #ad % to labels 
pie(slices,labels = lbls, col=c("#F35E5A", "#17B3B7"),
    main="Active donors DO MA" )

#2. Repartition of payment methods
query="Select payment_method_id , count(payment_method_id) as count
from acts 
where (act_type_id Like 'DO') and (channel_id like 'MA' ) and  (act_date> 20140531)
group by 1;"
repartition_pay_meth_DO_MA = sqlQuery(db, query)
dashboards_summary$total_nb_transactions[1]= sum(repartition_pay_meth_DO_MA$count)

ggplot(repartition_pay_meth_DO_MA, aes(reorder(payment_method_id,count),count)) +
  geom_bar(stat='identity') +
  coord_flip() +
  scale_fill_grey() 



###DO WW
query= "Select contact_id,avg(amount) as AVG_amount, DATEDIFF( MAX(Act_Date),Min( act_date) )/365  as length , DATEDIFF(20170626, MAX(Act_Date)) / 365 AS recency, COUNT(amount)  AS frequency , MAX(act_date) as lastDonation,active, prefix_id
from acts a
Left join(select id, active, prefix_id
from contacts ) b
On  a.contact_id = b.id              
where (act_type_id Like 'DO') and (channel_id like 'WW' ) and  (act_date> 20140531)
group by contact_id "

dashboard_DO_WW = sqlQuery(db, query)

#Replace the missing values 
dashboard_DO_WW$prefix_id  [which(is.na(dashboard_DO_WW$prefix_id)) ] =  tail(names(sort(table(dashboard_DO_WW$prefix_id))), 1)

dashboard_DO_WW$gender=0
#Add a variable "Gender" based on the prefix_id
dashboard_DO_WW$gender [ which (dashboard_DO_WW$prefix_id == "MR")] = 0
dashboard_DO_WW$gender [ which (dashboard_DO_WW$prefix_id == "MME")] = 1
dashboard_DO_WW$gender [ which (dashboard_DO_WW$prefix_id == "MLLE")] = 1
dashboard_DO_WW$gender [ which (dashboard_DO_WW$prefix_id == "MMME")] = 2   #Couple
dashboard_DO_WW$gender [ which (dashboard_DO_WW$prefix_id == "AU")] = 3     #Autre
dashboard_DO_WW$gender [ which (dashboard_DO_WW$prefix_id == "NA")] = 3     

####Half split between men and women
idx =  which (dashboard_DO_WW$prefix_id == "DR")
idx_male= idx[1: round(length(idx)/2)]
idx_female= idx[round(length(idx)/2)+1 :length(idx) ]
dashboard_DO_WW$gender [idx_male] = 0
dashboard_DO_WW$gender [idx_female] = 1

idx =  which (dashboard_DO_WW$prefix_id == "ME")
idx_male= idx[1: round(length(idx)/2)]
idx_female= idx[round(length(idx)/2)+1 :length(idx) ]
dashboard_DO_WW$gender [idx_male] = 0
dashboard_DO_WW$gender [idx_female] = 1

# Fill the table
dashboards_summary$total_donors[2]= nrow(dashboard_DO_WW)
dashboards_summary$nb_active[2]= length(which (dashboard_DO_WW$active == 1))
dashboards_summary$nb_nonactive[2]= length(which (dashboard_DO_WW$active == 0))
dashboards_summary$nb_male[2]= length(which (dashboard_DO_WW$gender == 0))
dashboards_summary$nb_female[2]= length(which (dashboard_DO_WW$gender == 1))
dashboards_summary$nb_couples[2]= length(which (dashboard_DO_WW$gender == 2))
dashboards_summary$nb_others[2]= length(which (dashboard_DO_WW$gender == 3))
dashboards_summary$avg_donations[2]= mean(dashboard_DO_WW$AVG_amount)
dashboards_summary$avg_freq[2]= mean(dashboard_DO_WW$frequency)/3
dashboards_summary$avg_recency[2]= mean(dashboard_DO_WW$recency)
dashboards_summary$avg_length_relashionship[2]= mean(dashboard_DO_WW$length)

#Charts
#1. Active/non active
slices <- c(dashboards_summary$nb_active[2] , dashboards_summary$nb_nonactive[2]) 
lbls <- c("Active", "Non Active" )
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) # add percents to labels 
lbls <- paste(lbls,"%",sep="") # ad % to labels 
pie(slices,labels = lbls, col=c("#F35E5A", "#17B3B7"),
    main="Active donors DO WW" )

#2. Repartition of payment methods
query="Select payment_method_id , count(payment_method_id) as count
from acts 
where (act_type_id Like 'DO') and (channel_id like 'WW' ) and  (act_date> 20140531)
group by 1;"
repartition_pay_meth_DO_WW = sqlQuery(db, query)
dashboards_summary$total_nb_transactions[2]= sum(repartition_pay_meth_DO_WW$count)

ggplot(repartition_pay_meth_DO_WW, aes(reorder(payment_method_id,count),count)) +
  geom_bar(stat='identity') +
  coord_flip() +
  scale_fill_grey() 


###PA MA
query= "Select contact_id,avg(amount) as AVG_amount, DATEDIFF( MAX(Act_Date),Min( act_date) )/365  as length , DATEDIFF(20170626, MAX(Act_Date)) / 365 AS recency, COUNT(amount)  AS frequency , Max(act_date) as lastdonation,active, prefix_id
from acts a
Left join(select id, active, prefix_id
from contacts ) b
On  a.contact_id = b.id              
where (act_type_id Like 'PA') and (channel_id like 'MA' ) and  (act_date> 20140531)
group by contact_id "

dashboard_PA_MA = sqlQuery(db, query)

#Replace the missing values 
dashboard_PA_MA$prefix_id  [which(is.na(dashboard_PA_MA$prefix_id)) ] =  tail(names(sort(table(dashboard_PA_MA$prefix_id))), 1)

dashboard_PA_MA$gender=0
#Add a variable "Gender" based on the prefix_id
dashboard_PA_MA$gender [ which (dashboard_PA_MA$prefix_id == "MR")] = 0
dashboard_PA_MA$gender [ which (dashboard_PA_MA$prefix_id == "MME")] = 1
dashboard_PA_MA$gender [ which (dashboard_PA_MA$prefix_id == "MLLE")] = 1
dashboard_PA_MA$gender [ which (dashboard_PA_MA$prefix_id == "MMME")] = 2   #Couple
dashboard_PA_MA$gender [ which (dashboard_PA_MA$prefix_id == "AU")] = 3     #Autre
dashboard_PA_MA$gender [ which (dashboard_PA_MA$prefix_id == "NA")] = 3     

####Half split between men and women
idx =  which (dashboard_PA_MA$prefix_id == "DR")
idx_male= idx[1: round(length(idx)/2)]
idx_female= idx[round(length(idx)/2)+1 :length(idx) ]
dashboard_PA_MA$gender [idx_male] = 0
dashboard_PA_MA$gender [idx_female] = 1

idx =  which (dashboard_PA_MA$prefix_id == "ME")
idx_male= idx[1: round(length(idx)/2)]
idx_female= idx[round(length(idx)/2)+1 :length(idx) ]
dashboard_PA_MA$gender [idx_male] = 0
dashboard_PA_MA$gender [idx_female] = 1

# Fill the table
dashboards_summary$total_donors[3]= nrow(dashboard_PA_MA)
dashboards_summary$nb_active[3]= length(which (dashboard_PA_MA$active == 1))
dashboards_summary$nb_nonactive[3]= length(which (dashboard_PA_MA$active == 0))
dashboards_summary$nb_male[3]= length(which (dashboard_PA_MA$gender == 0))
dashboards_summary$nb_female[3]= length(which (dashboard_PA_MA$gender == 1))
dashboards_summary$nb_couples[3]= length(which (dashboard_PA_MA$gender == 2))
dashboards_summary$nb_others[3]= length(which (dashboard_PA_MA$gender == 3))
dashboards_summary$avg_donations[3]= mean(dashboard_PA_MA$AVG_amount)
dashboards_summary$avg_freq[3]= mean(dashboard_PA_MA$frequency)/3
dashboards_summary$avg_recency[3]= mean(dashboard_PA_MA$recency)
dashboards_summary$avg_length_relashionship[3]= mean(dashboard_PA_MA$length)

#Charts
#1. Active/non active
slices <- c(dashboards_summary$nb_active[3] , dashboards_summary$nb_nonactive[3]) 
lbls <- c("Active", "Non Active" )
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) # add percents to labels 
lbls <- paste(lbls,"%",sep="") # ad % to labels 
pie(slices,labels = lbls, col=c("#F35E5A", "#17B3B7"),
    main="Active donors PA MA" )

#2. Repartition of payment methods
query="Select payment_method_id , count(payment_method_id) as count
from acts 
where (act_type_id Like 'PA') and (channel_id like 'MA' ) and  (act_date> 20140531)
group by 1;"
repartition_pay_meth_PA_MA = sqlQuery(db, query)
dashboards_summary$total_nb_transactions[3]= sum(repartition_pay_meth_PA_MA$count)

ggplot(repartition_pay_meth_PA_MA, aes(reorder(payment_method_id,count),count)) +
  geom_bar(stat='identity') +
  coord_flip() +
  scale_fill_grey() 


###PA WW
query= "Select contact_id,avg(amount) as AVG_amount, DATEDIFF( MAX(Act_Date),Min( act_date) )/365  as length , DATEDIFF(20170626, MAX(Act_Date)) / 365 AS recency, COUNT(amount)  AS frequency , MAX(act_date) as lastdonation,active, prefix_id
from acts a
Left join(select id, active, prefix_id
from contacts ) b
On  a.contact_id = b.id              
where (act_type_id Like 'PA') and (channel_id like 'WW' ) and  (act_date> 20140531)
group by contact_id "

dashboard_PA_WW = sqlQuery(db, query)

#Replace the missing values 
dashboard_PA_WW$prefix_id  [which(is.na(dashboard_PA_WW$prefix_id)) ] =  tail(names(sort(table(dashboard_PA_WW$prefix_id))), 1)

dashboard_PA_WW$gender=0
#Add a variable "Gender" based on the prefix_id
dashboard_PA_WW$gender [ which (dashboard_PA_WW$prefix_id == "MR")] = 0
dashboard_PA_WW$gender [ which (dashboard_PA_WW$prefix_id == "MME")] = 1
dashboard_PA_WW$gender [ which (dashboard_PA_WW$prefix_id == "MLLE")] = 1
dashboard_PA_WW$gender [ which (dashboard_PA_WW$prefix_id == "MMME")] = 2   #Couple
dashboard_PA_WW$gender [ which (dashboard_PA_WW$prefix_id == "AU")] = 3     #Autre
dashboard_PA_WW$gender [ which (dashboard_PA_WW$prefix_id == "NA")] = 3     

####Half split between men and women
idx =  which (dashboard_PA_WW$prefix_id == "DR")
idx_male= idx[1: round(length(idx)/2)]
idx_female= idx[round(length(idx)/2)+1 :length(idx) ]
dashboard_PA_WW$gender [idx_male] = 0
dashboard_PA_WW$gender [idx_female] = 1

idx =  which (dashboard_PA_WW$prefix_id == "ME")
idx_male= idx[1: round(length(idx)/2)]
idx_female= idx[round(length(idx)/2)+1 :length(idx) ]
dashboard_PA_WW$gender [idx_male] = 0
dashboard_PA_WW$gender [idx_female] = 1

# Fill the table
dashboards_summary$total_donors[4]= nrow(dashboard_PA_WW)
dashboards_summary$nb_active[4]= length(which (dashboard_PA_WW$active == 1))
dashboards_summary$nb_nonactive[4]= length(which (dashboard_PA_WW$active == 0))
dashboards_summary$nb_male[4]= length(which (dashboard_PA_WW$gender == 0))
dashboards_summary$nb_female[4]= length(which (dashboard_PA_WW$gender == 1))
dashboards_summary$nb_couples[4]= length(which (dashboard_PA_WW$gender == 2))
dashboards_summary$nb_others[4]= length(which (dashboard_PA_WW$gender == 3))
dashboards_summary$avg_donations[4]= mean(dashboard_PA_WW$AVG_amount)
dashboards_summary$avg_freq[4]= mean(dashboard_PA_WW$frequency)/3
dashboards_summary$avg_recency[4]= mean(dashboard_PA_WW$recency)
dashboards_summary$avg_length_relashionship[4]= mean(dashboard_PA_WW$length)

#Charts
#1. Active/non active
slices <- c(dashboards_summary$nb_active[4] , dashboards_summary$nb_nonactive[4]) 
lbls <- c("Active", "Non Active" )
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) # add percents to labels 
lbls <- paste(lbls,"%",sep="") # ad % to labels 
pie(slices,labels = lbls, col=c("#F35E5A", "#17B3B7"),
    main="Active donors PA WW" )

#2. Repartition of payment methods
query="Select payment_method_id , count(payment_method_id) as count
from acts 
where (act_type_id Like 'PA') and (channel_id like 'WW' ) and  (act_date> 20140531)
group by 1;"
repartition_pay_meth_PA_WW = sqlQuery(db, query)
dashboards_summary$total_nb_transactions[4]= sum(repartition_pay_meth_PA_WW$count)

ggplot(repartition_pay_meth_PA_WW, aes(reorder(payment_method_id,count),count)) +
  geom_bar(stat='identity') +
  coord_flip() +
  scale_fill_grey() 

#------------------------------------------------------------------------
# D. Channels Transition Matrices
#------------------------------------------------------------------------

library(knitr)
library(reshape2)

transition_matrice <- function(old_period,new_period) 
{query <- paste("SELECT old.segment AS old_seg , new.segment AS new_seg, COUNT(new.segment) AS count
                FROM segments_channel old,
                segments_channel new
                WHERE (old.contact_id = new.contact_id) AND
                (old.period_id = ",old_period,") AND
                (new.period_id = ",new_period,")
                GROUP BY 1, 2
                ORDER BY 1, 2;")

trans_df=sqlQuery(db, query)
query <- paste("SELECT segment AS old_seg, COUNT(segment) AS oldseg_count
               FROM segments_channel 
               WHERE period_id = ",old_period,"
               GROUP BY 1;")

oldseg_count=sqlQuery(db,query)

trans_df=merge.data.frame(trans_df, oldseg_count,by = "old_seg")
trans_df$trans_ratio = with(trans_df, trans_df$count / trans_df$oldseg_count)
trans_df$trans_ratio[is.na(trans_df$trans_ratio)] = 0

trans_mat = acast(trans_df, old_seg~new_seg, value.var="trans_ratio")
trans_mat[is.na(trans_mat)] = 0

trans_mat= trans_mat[1:4,1:4]

filename= paste("/Users/sarahlina/Documents/Cours ESSEC/Business Analytics/Marketing Analytics/Assignment 3/matrice",old_period,new_period,".csv" )
print(filename)
write.table(trans_mat, file = filename, sep=",")
}


old=1
new =0
for (i in 0:5)
{
  transition_matrice(old+i,new+i)
}

#------------------------------------------------------------------------
# E. Plotting maps per channel
#------------------------------------------------------------------------
library('rgdal')      # Reading and projecting shapefiles
library('plotrix')    # Creating color scales
library('classInt')   # Assigning colors to data

# Reading departements
departements <- readOGR(dsn="C:/Users/dorak/Downloads/GEOFLA_2-2_DEPARTEMENT_SHP_LAMB93_FXX_2016-06-28/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00235/GEOFLA_2-2_SHP_LAMB93_FR-ED161/DEPARTEMENT",  layer="DEPARTEMENT")

# Reading departements boundaries in order to plot France boundaries
bounderies <- readOGR(dsn="C:/Users/dorak/Downloads/GEOFLA_2-2_DEPARTEMENT_SHP_LAMB93_FXX_2016-06-28/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00235/GEOFLA_2-2_SHP_LAMB93_FR-ED161/DEPARTEMENT",  layer="LIMITE_DEPARTEMENT")
bounderies <- bounderies[bounderies$NATURE %in% c('Fronti\xe8re internationale','Limite c\xf4ti\xe8re'),]

# Reading shapefile
communes <- readOGR(dsn="C:/Users/dorak/Downloads/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00236/GEOFLA_2-2_SHP_LAMB93_FR-ED161/COMMUNE", layer="COMMUNE")

#2. DO MA
query="Select a.amount, a.act_date, a.act_type_id, a.payment_method_id, a.channel_id, b.id as contact_id, b.zip_code , b.prefix_id , b.active , b.code_geo
from acts as a
left join (select *
from contacts ) b
On a.contact_id = b.id
where (a.act_type_id Like 'DO') and (a.channel_id like 'MA' ) and (a.act_date >= 2012-06-01)"
dataset_DO_MA = sqlQuery(db, query)

#Replace the missing values 
dataset_DO_MA$prefix_id  [which(is.na(dataset_DO_MA$prefix_id)) ] =  tail(names(sort(table(dataset_DO_MA$prefix_id))), 1)
dataset_DO_MA$zip_code  [which(is.na(dataset_DO_MA$zip_code)) ] =  tail(names(sort(table(dataset_DO_MA$zip_code))), 1)
dataset_DO_MA$code_geo  [which(is.na(dataset_DO_MA$code_geo)) ] =  tail(names(sort(table(dataset_DO_MA$code_geo))), 1)

#Add a variable "Gender" based on the prefix_id
dataset_DO_MA$gender [which (dataset_DO_MA$prefix_id == "MR")] = 0
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "DR")] = 0
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "ME")] = 0
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "MME")] = 1
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "MLLE")] = 1
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "MMME")] = 1
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "AU")] = 3
dataset_DO_MA$gender [ which (dataset_DO_MA$prefix_id == "NA")] = 3

#Prepare to merge with Communes
df_DO_MA <- data.frame("COMMUNE" = dataset_DO_MA$code_geo, "amount" = dataset_DO_MA$amount)
df_DO_MA <- aggregate(df_DO_MA$amount, by=list(Category=df_DO_MA$COMMUNE), FUN=sum)
df_DO_MA <- data.frame("COMMUNE" = df_DO_MA$Category, "amount" = df_DO_MA$x)

# Loading communes data
communes_doma <- merge(communes, df_DO_MA, by.x="INSEE_COM", by.y="COMMUNE")
communes_doma$amount[is.na(communes_doma$amount)] <- 0

# Setting the colors
col <- findColours(classIntervals(
  communes_doma$amount, 100, style="fixed", fixedBreaks=c(0,120,1000,1891515)),
  smoothColors("#FFFFD7",98,"#F3674C"))

leg <- findColours(classIntervals(
  round(communes_doma$amount,0), 4, style="fixed", fixedBreaks=c(0,120,1000,1891515)),
  smoothColors("#FFFFD7",2,"#F3674C"),
  under="<", over=">", between="–",
  cutlabels=FALSE)

# Plotting
cairo_pdf('DO_MA.pdf',width=6,height=4.7)
par(mar=c(0,0,0,0),family="Myriad Pro",ps=8)

plot(bounderies, col="#FFFFFF")
plot(bounderies, col="#D8D6D4", lwd=6, add=TRUE)
plot(communes_doma,   col=col, border=col, lwd=.1, add=TRUE)
plot(bounderies, col="#666666", lwd=1, add=TRUE)

dev.off()



#2. DO WW
query="Select a.amount, a.act_date, a.act_type_id, a.payment_method_id, a.channel_id, b.id as contact_id, b.zip_code , b.prefix_id , b.active , b.code_geo
from acts as a
left join (select *
from contacts ) b
On a.contact_id = b.id
where (a.act_type_id Like 'DO') and (a.channel_id like 'WW' ) and (a.act_date >= 2012-06-01)"
dataset_DO_WW = sqlQuery(db, query)
odbcClose(db)

#Replace the missing values 
dataset_DO_WW$prefix_id  [which(is.na(dataset_DO_WW$prefix_id)) ] =  tail(names(sort(table(dataset_DO_WW$prefix_id))), 1)
dataset_DO_WW$zip_code  [which(is.na(dataset_DO_WW$zip_code)) ] =  tail(names(sort(table(dataset_DO_WW$zip_code))), 1)
dataset_DO_WW$code_geo  [which(is.na(dataset_DO_WW$code_geo)) ] =  tail(names(sort(table(dataset_DO_WW$code_geo))), 1)

#Add a variable "Gender" based on the prefix_id
dataset_DO_WW$gender [which (dataset_DO_WW$prefix_id == "MR")] = 0
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "DR")] = 0
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "ME")] = 0
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "MME")] = 1
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "MLLE")] = 1
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "MMME")] = 1
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "AU")] = 3
dataset_DO_WW$gender [ which (dataset_DO_WW$prefix_id == "NA")] = 3

df_DO_WW <- data.frame("COMMUNE" = dataset_DO_WW$code_geo, "amount" = dataset_DO_WW$amount)
df_DO_WW <- aggregate(df_DO_WW$amount, by=list(Category=df_DO_WW$COMMUNE), FUN=sum)
df_DO_WW <- data.frame("COMMUNE" = df_DO_WW$Category, "amount" = df_DO_WW$x)

# Loading communes data
communes_doww <- merge(communes, df_DO_WW, by.x="INSEE_COM", by.y="COMMUNE")
communes_doww$amount[is.na(communes_doww$amount)] <- 0

# Setting the colors
col <- findColours(classIntervals(
  communes_doww$amount, 100, style="fixed", fixedBreaks=c(0,120,1000,1891515)),
  smoothColors("#FFFFD7",98,"#F3674C"))

leg <- findColours(classIntervals(
  round(communes_doww$amount,0), 4, style="fixed", fixedBreaks=c(0,120,1000,1891515)),
  smoothColors("#FFFFD7",2,"#F3674C"),
  under="<", over=">", between="–",
  cutlabels=FALSE)

# Plotting
cairo_pdf('DO_WW.pdf',width=6,height=4.7)
par(mar=c(0,0,0,0),family="Myriad Pro",ps=8)

plot(bounderies, col="#FFFFFF")
plot(bounderies, col="#D8D6D4", lwd=6, add=TRUE)
plot(communes_doww,   col=col, border=col, lwd=.1, add=TRUE)
plot(bounderies, col="#666666", lwd=1, add=TRUE)

dev.off()



#3. PA MA
query="Select a.amount, a.act_date, a.act_type_id, a.payment_method_id, a.channel_id, b.id as contact_id, b.zip_code , b.prefix_id , b.active , b.code_geo
from acts as a
left join (select *
from contacts ) b
On a.contact_id = b.id
where (a.act_type_id Like 'PA') and (a.channel_id like 'MA' ) and (a.act_date >= 2012-06-01)"
dataset_PA_MA = sqlQuery(db, query)
odbcClose(db)

#Replace the missing values 
dataset_PA_MA$prefix_id  [which(is.na(dataset_PA_MA$prefix_id)) ] =  tail(names(sort(table(dataset_PA_MA$prefix_id))), 1)
dataset_PA_MA$zip_code  [which(is.na(dataset_PA_MA$zip_code)) ] =  tail(names(sort(table(dataset_PA_MA$zip_code))), 1)
dataset_PA_MA$code_geo  [which(is.na(dataset_PA_MA$code_geo)) ] =  tail(names(sort(table(dataset_PA_MA$code_geo))), 1)

#Add a variable "Gender" based on the prefix_id
dataset_PA_MA$gender [which (dataset_PA_MA$prefix_id == "MR")] = 0
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "DR")] = 0
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "ME")] = 0
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "MME")] = 1
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "MLLE")] = 1
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "MMME")] = 1
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "AU")] = 3
dataset_PA_MA$gender [ which (dataset_PA_MA$prefix_id == "NA")] = 3

df_PA_MA <- data.frame("COMMUNE" = dataset_PA_MA$code_geo, "amount" = dataset_PA_MA$amount)
df_PA_MA <- aggregate(df_PA_MA$amount, by=list(Category=df_PA_MA$COMMUNE), FUN=sum)
df_PA_MA <- data.frame("COMMUNE" = df_PA_MA$Category, "amount" = df_PA_MA$x)

# Loading communes data
communes_pama <- merge(communes, df_PA_MA, by.x="INSEE_COM", by.y="COMMUNE")
communes_pama$amount[is.na(communes_pama$amount)] <- 0

# Setting the colors
col <- findColours(classIntervals(
  communes_pama$amount, 100, style="fixed", fixedBreaks=c(0,120,1000,1891515)),
  smoothColors("#FFFFD7",98,"#F3674C"))

leg <- findColours(classIntervals(
  round(communes_pama$amount,0), 4, style="fixed", fixedBreaks=c(0,120,1000,1891515)),
  smoothColors("#FFFFD7",2,"#F3674C"),
  under="<", over=">", between="–",
  cutlabels=FALSE)

# Plotting
cairo_pdf('PA_MA.pdf',width=6,height=4.7)
par(mar=c(0,0,0,0),family="Myriad Pro",ps=8)

plot(bounderies, col="#FFFFFF")
plot(bounderies, col="#D8D6D4", lwd=6, add=TRUE)
plot(communes_pama,   col=col, border=col, lwd=.1, add=TRUE)
plot(bounderies, col="#666666", lwd=1, add=TRUE)

dev.off()



#4. PA WW
query="Select a.amount, a.act_date, a.act_type_id, a.payment_method_id, a.channel_id, b.id as contact_id, b.zip_code , b.prefix_id , b.active , b.code_geo
from acts as a
left join (select *
from contacts ) b
On a.contact_id = b.id
where (a.act_type_id Like 'PA') and (a.channel_id like 'WW' ) and (a.act_date >= 2012-06-01)"
dataset_PA_WW = sqlQuery(db, query)
odbcClose(db)

#Replace the missing values 
dataset_PA_WW$prefix_id  [which(is.na(dataset_PA_WW$prefix_id)) ] =  tail(names(sort(table(dataset_PA_WW$prefix_id))), 1)
dataset_PA_WW$zip_code  [which(is.na(dataset_PA_WW$zip_code)) ] =  tail(names(sort(table(dataset_PA_WW$zip_code))), 1)
dataset_PA_WW$code_geo  [which(is.na(dataset_PA_WW$code_geo)) ] =  tail(names(sort(table(dataset_PA_WW$code_geo))), 1)

#Add a variable "Gender" based on the prefix_id
dataset_PA_WW$gender [which (dataset_PA_WW$prefix_id == "MR")] = 0
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "DR")] = 0
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "ME")] = 0
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "MME")] = 1
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "MLLE")] = 1
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "MMME")] = 1
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "AU")] = 3
dataset_PA_WW$gender [ which (dataset_PA_WW$prefix_id == "NA")] = 3

#Prepare to merge with Communes
df_PA_WW <- data.frame("COMMUNE" = dataset_PA_WW$code_geo, "amount" = dataset_PA_WW$amount)
df_PA_WW <- aggregate(df_PA_WW$amount, by=list(Category=df_PA_WW$COMMUNE), FUN=sum)
df_PA_WW <- data.frame("COMMUNE" = df_PA_WW$Category, "amount" = df_PA_WW$x)

# Loading communes data
communes_paww <- merge(communes, df_PA_WW, by.x="INSEE_COM", by.y="COMMUNE")
communes_paww$amount[is.na(communes_paww$amount)] <- 0

# Setting the colors
col <- findColours(classIntervals(
  communes_paww$amount, 100, style="fixed", fixedBreaks=c(0,120,1000,1891515)),
  smoothColors("#FFFFD7",98,"#F3674C"))

leg <- findColours(classIntervals(
  round(communes_paww$amount,0), 4, style="fixed", fixedBreaks=c(0,120,1000,1891515)),
  smoothColors("#FFFFD7",2,"#F3674C"),
  under="<", over=">", between="–",
  cutlabels=FALSE)

# Plotting
cairo_pdf('PA_WW.pdf',width=6,height=4.7)
par(mar=c(0,0,0,0),family="Myriad Pro",ps=8)

plot(bounderies, col="#FFFFFF")
plot(bounderies, col="#D8D6D4", lwd=6, add=TRUE)
plot(communes_paww,   col=col, border=col, lwd=.1, add=TRUE)
plot(bounderies, col="#666666", lwd=1, add=TRUE)

dev.off()

