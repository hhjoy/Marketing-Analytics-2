library (RODBC)
library(knitr)

###########################DO MA ####################
# Transition Matrix

db=odbcConnect("mysql_server_64", uid="root", pwd="7193")
sqlQuery(db, "USE ma_charity_full")

# Transition Matrix

query <- "SELECT old.segment AS old_seg , new.segment AS new_seg, COUNT(new.segment) AS count
FROM segments old,
segments new
WHERE (old.contact_id = new.contact_id) AND
(old.period_id = 1) AND
(new.period_id = 0)
AND new.segment LIKE '%DO MA%'
GROUP BY 1, 2
ORDER BY 1, 2;"

trans_df=sqlQuery(db, query)

query <- "SELECT segment AS old_seg, COUNT(segment) AS oldseg_count
FROM segments 
WHERE period_id = 1
AND segment LIKE '%DO MA%'
GROUP BY 1;"

oldseg_count=sqlQuery(db,query)

trans_df=merge.data.frame(trans_df, oldseg_count,by = "old_seg")
trans_df$trans_ratio = with(trans_df, trans_df$count / trans_df$oldseg_count)
trans_df$trans_ratio[is.na(trans_df$trans_ratio)] = 0


library(reshape2)
trans_mat = acast(trans_df, old_seg~new_seg, value.var="trans_ratio")
trans_mat[is.na(trans_mat)] = 0

trans_mat <- cbind(trans_mat, c(0))
trans_mat  <- trans_mat[c(6,4,3,2,7,1,5),c(7,4,3,2,6,1,5)] #run for DO

#trans_mat <- trans_mat[c(3,6,5,4,7,1,2), c(3,6,5,4,7,1,2)] #run for PA

write.table(trans_mat, file = "desktop/results_doma.csv", sep=",")

#----------------------------------------------------------------------------------
###########Compute for each channel ####################
#LTV 

# Constants
num_periods = 20
discount_rate = .15


# Init the segments
segments = matrix(nrow = 7, ncol = num_periods)
rownames(segments)= rownames(trans_mat)

#segments population at period 0
query="SELECT segment AS new_seg, COUNT(segment) AS seg_count
      FROM segments
      WHERE period_id = 0
      AND segment LIKE '%DO MA%'
      GROUP BY 1"

segcount=sqlQuery(db,query)
segcount$new_seg[is.na(segcount$new_seg)] = 0
rownames(segcount) = segcount$new_seg

#reorder segcount according to the order of the transition matrix
segcount = segcount[c(6,4,3,2,7,1,5),] #DO
#segcount = segcount[c(3,6,5,4,7,1,2),] #PA

# Number of new customers
segments[1:7, 1] = segcount[,2]

#Force the absorption rate 
trans_mat[7,7] = 1

#Force the 'NEW' to be subdivided between TOP/MIDDLE/BOTTOM
#trans_mat[1,1] = 0
#trans_mat[1,2] = 0.2
#trans_mat[1,3] = 0.2
#trans_mat[1,4] = 0.6
#trans_mat[1,5] = 0

# Compute for each an every period (and round output for clarity)
for (i in 2:num_periods) {
   segments[, i] = segments[, i-1] %*% trans_mat
}

print(round(segments))

write.table(segments, file = "desktop/results_doma.csv", col.names=TRUE, sep=",", append=TRUE)

# Yearly revenue per segment
# Report the financial contribution of each segment
query="SELECT
s.segment,
COUNT(DISTINCT(s.contact_id)) AS 'numdonors',
COUNT(a.amount)              AS 'numdonations',
CEILING(AVG(a.amount))       AS 'avgamount',
CEILING(SUM(a.amount))       AS 'totalgenerosity'
FROM
segments s,
periods p,
acts a
WHERE
(s.contact_id = a.contact_id) AND
(s.period_id = 0 OR s.period_id = 1 ) AND
(p.period_id = 0 OR p.period_id = 1 ) AND
(s.segment LIKE '%DO MA%') AND
(a.act_date >= p.FirstDay) AND
(a.act_date <= p.LastDay)
GROUP BY 1
ORDER BY totalgenerosity DESC"

revenues=sqlQuery(db,query)

#Sort revenues same order as segments/trans_mat
revenues = revenues[c(6,4,3,2,7,1,5),]

yearly_revenue= revenues$avgamount

#put warm, cold, lost as 0
yearly_revenue[5:7]=0

write.table(yearly_revenue, file = "desktop/results_doma.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute revenue per segment per year
revenue_per_segment = (yearly_revenue) * segments
print("Revenue per segment:")
print(revenue_per_segment)


write.table(revenue_per_segment, "desktop/results_doma.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute yearly revenue
yearly_revenue = colSums(revenue_per_segment)
print("Yearly revenue:")
print(yearly_revenue)
plot(yearly_revenue)
lines(yearly_revenue)

write.table(t(yearly_revenue), "desktop/results_doma.csv", col.names=TRUE, sep=",", append=TRUE)
# Compute cumulated revenue
cumulated_revenue = cumsum(yearly_revenue)
print("Cumulated revenue:")
print(cumulated_revenue)
plot(cumulated_revenue)
lines(cumulated_revenue)

write.table(t(cumulated_revenue), "desktop/results_doma.csv", col.names=TRUE, sep=",", append=TRUE)
# Create a discount factor
# Other version: discount = (1 - discount_rate) ^ (1:num_periods)
discount = 1 / ((1 + discount_rate) ^ ((1:num_periods) - 1))
print(discount)

# Compute discounted yearly revenue
disc_yearly_revenue = yearly_revenue * discount
print("Discounted yearly_revenue:")
print(disc_yearly_revenue)
plot(yearly_revenue)
lines(yearly_revenue)
lines(disc_yearly_revenue)

write.table(t(disc_yearly_revenue), "desktop/results_doma.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute discounted cumulated revenue
disc_cumulated_revenue = cumsum(disc_yearly_revenue)
print("Discounted cumulated revenue:")
print(cumulated_revenue)
plot(cumulated_revenue)
lines(disc_cumulated_revenue)

write.table(t(disc_cumulated_revenue), "desktop/results_doma.csv", col.names=TRUE, sep=",", append=TRUE)

# What is the database worth?
worth_channel = disc_cumulated_revenue[num_periods] - yearly_revenue[1]
print(worth-channel)

write.table(worth_channel, "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)


###############################DO WW ###############################################

# Transition Matrix

db=odbcConnect("mysql_server_64", uid="root", pwd="7193")
sqlQuery(db, "USE ma_charity_full")

# Transition Matrix

query <- "SELECT old.segment AS old_seg , new.segment AS new_seg, COUNT(new.segment) AS count
FROM segments old,
segments new
WHERE (old.contact_id = new.contact_id) AND
(old.period_id = 1) AND
(new.period_id = 0)
AND new.segment LIKE '%DO WW%'
GROUP BY 1, 2
ORDER BY 1, 2;"

trans_df=sqlQuery(db, query)

query <- "SELECT segment AS old_seg, COUNT(segment) AS oldseg_count
FROM segments 
WHERE period_id = 1
AND segment LIKE '%DO WW%'
GROUP BY 1;"

oldseg_count=sqlQuery(db,query)

trans_df=merge.data.frame(trans_df, oldseg_count,by = "old_seg")
trans_df$trans_ratio = with(trans_df, trans_df$count / trans_df$oldseg_count)
trans_df$trans_ratio[is.na(trans_df$trans_ratio)] = 0


library(reshape2)
trans_mat = acast(trans_df, old_seg~new_seg, value.var="trans_ratio")
trans_mat[is.na(trans_mat)] = 0

trans_mat <- cbind(trans_mat, c(0))
trans_mat <- rbind(trans_mat, c(0))
trans_mat  <- trans_mat[c(5,4,3,2,6,1,7),c(7,4,3,2,6,1,5)] #run for DO
#trans_mat <- trans_mat[c(3,6,5,4,7,1,2), c(3,6,5,4,7,1,2)] #run for PA

write.table(trans_mat, file = "desktop/results_doww.csv", sep=",")

#----------------------------------------------------------------------------------
###########Compute for each channel ####################
#LTV 

# Constants
num_periods = 20
discount_rate = .15


# Init the segments
segments = matrix(nrow = 7, ncol = num_periods)
rownames(segments)= rownames(trans_mat)

#segments population at period 0
query="SELECT segment AS new_seg, COUNT(segment) AS seg_count
FROM segments
WHERE period_id = 0
AND segment LIKE '%DO WW%'
GROUP BY 1"

segcount=sqlQuery(db,query)
segcount$new_seg[is.na(segcount$new_seg)] = 0
rownames(segcount) = segcount$new_seg

#reorder segcount according to the order of the transition matrix
#segcount = segcount[c(3,6,5,4,7,1,2),] #PA
segcount = segcount[c(6,4,3,2,7,1,5),] #DO

# Number of new customers
segments[1:7, 1] = segcount[,2]

#Force the absorption rate 
trans_mat[7,7] = 1

#Force the 'NEW' to be subdivided between TOP/MIDDLE/BOTTOM
#trans_mat[1,1] = 0
#trans_mat[1,2] = 0.2
#trans_mat[1,3] = 0.2
#trans_mat[1,4] = 0.6
#trans_mat[1,5] = 0

# Compute for each an every period (and round output for clarity)
for (i in 2:num_periods) {
  segments[, i] = segments[, i-1] %*% trans_mat
}

print(round(segments))

write.table(segments, file = "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)

# Yearly revenue per segment
# Report the financial contribution of each segment
query="SELECT
s.segment,
COUNT(DISTINCT(s.contact_id)) AS 'numdonors',
COUNT(a.amount)              AS 'numdonations',
CEILING(AVG(a.amount))       AS 'avgamount',
CEILING(SUM(a.amount))       AS 'totalgenerosity'
FROM
segments s,
periods p,
acts a
WHERE
(s.contact_id = a.contact_id) AND
(s.period_id = 0 OR s.period_id = 1 ) AND
(p.period_id = 0 OR p.period_id = 1 ) AND
(s.segment LIKE '%DO WW%') AND
(a.act_date >= p.FirstDay) AND
(a.act_date <= p.LastDay)
GROUP BY 1
ORDER BY totalgenerosity DESC"

revenues=sqlQuery(db,query)

#Sort revenues same order as segments/trans_mat
revenues = revenues[c(3,1,2,4,5,6),]

yearly_revenue= revenues$avgamount

#put warm, cold, lost as 0
yearly_revenue[5:7]=0

write.table(yearly_revenue, file = "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute revenue per segment per year
revenue_per_segment = (yearly_revenue) * segments
print("Revenue per segment:")
print(revenue_per_segment)


write.table(revenue_per_segment, "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute yearly revenue
yearly_revenue = colSums(revenue_per_segment)
print("Yearly revenue:")
print(yearly_revenue)
plot(yearly_revenue)
lines(yearly_revenue)

write.table(t(yearly_revenue), "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)
# Compute cumulated revenue
cumulated_revenue = cumsum(yearly_revenue)
print("Cumulated revenue:")
print(cumulated_revenue)
plot(cumulated_revenue)
lines(cumulated_revenue)

write.table(t(cumulated_revenue), "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)
# Create a discount factor
# Other version: discount = (1 - discount_rate) ^ (1:num_periods)
discount = 1 / ((1 + discount_rate) ^ ((1:num_periods) - 1))
print(discount)

# Compute discounted yearly revenue
disc_yearly_revenue = yearly_revenue * discount
print("Discounted yearly_revenue:")
print(disc_yearly_revenue)
plot(yearly_revenue)
lines(yearly_revenue)
lines(disc_yearly_revenue)

write.table(t(disc_yearly_revenue), "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute discounted cumulated revenue
disc_cumulated_revenue = cumsum(disc_yearly_revenue)
print("Discounted cumulated revenue:")
print(cumulated_revenue)
plot(cumulated_revenue)
lines(disc_cumulated_revenue)

write.table(t(disc_cumulated_revenue), "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)

# What is the database worth?
worth_channel = disc_cumulated_revenue[num_periods] - yearly_revenue[1]
print(worth-channel)

write.table(worth_channel, "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)

library (RODBC)
library(knitr)
#########################################################################################################
###########################PA MA ###############################################
# Transition Matrix

db=odbcConnect("mysql_server_64", uid="root", pwd="7193")
sqlQuery(db, "USE ma_charity_full")

# Transition Matrix

query <- "SELECT old.segment AS old_seg , new.segment AS new_seg, COUNT(new.segment) AS count
FROM segments old,
segments new
WHERE (old.contact_id = new.contact_id) AND
(old.period_id = 1) AND
(new.period_id = 0)
AND new.segment LIKE '%PA MA%'
GROUP BY 1, 2
ORDER BY 1, 2;"

trans_df=sqlQuery(db, query)

query <- "SELECT segment AS old_seg, COUNT(segment) AS oldseg_count
FROM segments 
WHERE period_id = 1
AND segment LIKE '%PA MA%'
GROUP BY 1;"

oldseg_count=sqlQuery(db,query)

trans_df=merge.data.frame(trans_df, oldseg_count,by = "old_seg")
trans_df$trans_ratio = with(trans_df, trans_df$count / trans_df$oldseg_count)
trans_df$trans_ratio[is.na(trans_df$trans_ratio)] = 0


library(reshape2)
trans_mat = acast(trans_df, old_seg~new_seg, value.var="trans_ratio")
trans_mat[is.na(trans_mat)] = 0

trans_mat <- cbind(trans_mat, c(0))
#trans_mat  <- trans_mat[c(6,4,3,2,7,1,5),c(7,4,3,2,6,1,5)] #run for DO
trans_mat <- trans_mat[c(3,6,5,4,7,1,2), c(7,5,4,3,6,1,2)] #run for PA

write.table(trans_mat, file = "desktop/results_pama.csv", sep=",")

#----------------------------------------------------------------------------------
###########Compute for each channel ####################
#LTV 

# Constants
num_periods = 20
discount_rate = .15


# Init the segments
segments = matrix(nrow = 7, ncol = num_periods)
rownames(segments)= rownames(trans_mat)

#segments population at period 0
query="SELECT segment AS new_seg, COUNT(segment) AS seg_count
FROM segments
WHERE period_id = 0
AND segment LIKE '%PA MA%'
GROUP BY 1"

segcount=sqlQuery(db,query)
segcount$new_seg[is.na(segcount$new_seg)] = 0
rownames(segcount) = segcount$new_seg

#reorder segcount according to the order of the transition matrix
#segcount = segcount[c(6,4,3,2,7,1,5),] #DO
segcount = segcount[c(3,6,5,4,7,1,2),] #PA

# Number of new customers
segments[1:7, 1] = segcount[,2]

#Force the absorption rate 
trans_mat[7,7] = 1

#Force the 'NEW' to be subdivided between TOP/MIDDLE/BOTTOM
#trans_mat[1,1] = 0
#trans_mat[1,2] = 0.2
#trans_mat[1,3] = 0.2
#trans_mat[1,4] = 0.6
#trans_mat[1,5] = 0

# Compute for each an every period (and round output for clarity)
for (i in 2:num_periods) {
  segments[, i] = segments[, i-1] %*% trans_mat
}

print(round(segments))

write.table(segments, file = "desktop/results_pama.csv", col.names=TRUE, sep=",", append=TRUE)

# Yearly revenue per segment
# Report the financial contribution of each segment
query="SELECT
s.segment,
COUNT(DISTINCT(s.contact_id)) AS 'numdonors',
COUNT(a.amount)              AS 'numdonations',
CEILING(AVG(a.amount))       AS 'avgamount',
CEILING(SUM(a.amount))       AS 'totalgenerosity'
FROM
segments s,
periods p,
acts a
WHERE
(s.contact_id = a.contact_id) AND
(s.period_id = 0 OR s.period_id = 1 ) AND
(p.period_id = 0 OR p.period_id = 1 ) AND
(s.segment LIKE '%PA MA%') AND
(a.act_date >= p.FirstDay) AND
(a.act_date <= p.LastDay)
GROUP BY 1
ORDER BY totalgenerosity DESC"

revenues=sqlQuery(db,query)

#Sort revenues same order as segments/trans_mat
revenues = revenues[c(3,1,2,4,5,6,7),]

yearly_revenue= revenues$avgamount

#put warm, cold, lost as 0
yearly_revenue[5:7]=0

write.table(yearly_revenue, file = "desktop/results_pama.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute revenue per segment per year
revenue_per_segment = (yearly_revenue) * segments
print("Revenue per segment:")
print(revenue_per_segment)


write.table(revenue_per_segment, "desktop/results_pama.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute yearly revenue
yearly_revenue = colSums(revenue_per_segment)
print("Yearly revenue:")
print(yearly_revenue)
plot(yearly_revenue)
lines(yearly_revenue)

write.table(t(yearly_revenue), "desktop/results_pama.csv", col.names=TRUE, sep=",", append=TRUE)
# Compute cumulated revenue
cumulated_revenue = cumsum(yearly_revenue)
print("Cumulated revenue:")
print(cumulated_revenue)
plot(cumulated_revenue)
lines(cumulated_revenue)

write.table(t(cumulated_revenue), "desktop/results_pama.csv", col.names=TRUE, sep=",", append=TRUE)
# Create a discount factor
# Other version: discount = (1 - discount_rate) ^ (1:num_periods)
discount = 1 / ((1 + discount_rate) ^ ((1:num_periods) - 1))
print(discount)

# Compute discounted yearly revenue
disc_yearly_revenue = yearly_revenue * discount
print("Discounted yearly_revenue:")
print(disc_yearly_revenue)
plot(yearly_revenue)
lines(yearly_revenue)
lines(disc_yearly_revenue)

write.table(t(disc_yearly_revenue), "desktop/results_pama.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute discounted cumulated revenue
disc_cumulated_revenue = cumsum(disc_yearly_revenue)
print("Discounted cumulated revenue:")
print(cumulated_revenue)
plot(cumulated_revenue)
lines(disc_cumulated_revenue)

write.table(t(disc_cumulated_revenue), "desktop/results_pama.csv", col.names=TRUE, sep=",", append=TRUE)

# What is the database worth?
worth_channel = disc_cumulated_revenue[num_periods] - yearly_revenue[1]
print(worth-channel)

write.table(worth_channel, "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)


###############################PA WW ###############################################

# Transition Matrix

db=odbcConnect("mysql_server_64", uid="root", pwd="7193")
sqlQuery(db, "USE ma_charity_full")

# Transition Matrix

query <- "SELECT old.segment AS old_seg , new.segment AS new_seg, COUNT(new.segment) AS count
FROM segments old,
segments new
WHERE (old.contact_id = new.contact_id) AND
(old.period_id = 1) AND
(new.period_id = 0)
AND new.segment LIKE '%PA WW%'
GROUP BY 1, 2
ORDER BY 1, 2;"

trans_df=sqlQuery(db, query)

query <- "SELECT segment AS old_seg, COUNT(segment) AS oldseg_count
FROM segments 
WHERE period_id = 1
AND segment LIKE '%PA WW%'
GROUP BY 1;"

oldseg_count=sqlQuery(db,query)

trans_df=merge.data.frame(trans_df, oldseg_count,by = "old_seg")
trans_df$trans_ratio = with(trans_df, trans_df$count / trans_df$oldseg_count)
trans_df$trans_ratio[is.na(trans_df$trans_ratio)] = 0


library(reshape2)
trans_mat = acast(trans_df, old_seg~new_seg, value.var="trans_ratio")
trans_mat[is.na(trans_mat)] = 0

trans_mat <- cbind(trans_mat, c(0))
trans_mat <- rbind(trans_mat, c(0))
#trans_mat  <- trans_mat[c(5,4,3,2,6,1,7),c(7,4,3,2,6,1,5)] #run for DO
trans_mat <- trans_mat[c(2,5,4,3,6,1,7), c(7,5,4,3,6,1,2)] #run for PA

write.table(trans_mat, file = "desktop/results_paww.csv", sep=",")

#----------------------------------------------------------------------------------
###########Compute for each channel ####################
#LTV 

# Constants
num_periods = 20
discount_rate = .15


# Init the segments
segments = matrix(nrow = 7, ncol = num_periods)
rownames(segments)= rownames(trans_mat)

#segments population at period 0
query="SELECT segment AS new_seg, COUNT(segment) AS seg_count
FROM segments
WHERE period_id = 0
AND segment LIKE '%PA WW%'
GROUP BY 1"

segcount=sqlQuery(db,query)
segcount$new_seg[is.na(segcount$new_seg)] = 0
rownames(segcount) = segcount$new_seg

#reorder segcount according to the order of the transition matrix
segcount = segcount[c(3,6,5,4,7,1,2),] #PA
#segcount = segcount[c(6,4,3,2,7,1,5),] #DO

# Number of new customers
segments[1:7, 1] = segcount[,2]

#Force the absorption rate 
trans_mat[7,7] = 1

#Force the 'NEW' to be subdivided between TOP/MIDDLE/BOTTOM
#trans_mat[1,1] = 0
#trans_mat[1,2] = 0.2
#trans_mat[1,3] = 0.2
#trans_mat[1,4] = 0.6
#trans_mat[1,5] = 0

# Compute for each an every period (and round output for clarity)
for (i in 2:num_periods) {
  segments[, i] = segments[, i-1] %*% trans_mat
}

print(round(segments))

write.table(segments, file = "desktop/results_paww.csv", col.names=TRUE, sep=",", append=TRUE)

# Yearly revenue per segment
# Report the financial contribution of each segment
query="SELECT
s.segment,
COUNT(DISTINCT(s.contact_id)) AS 'numdonors',
COUNT(a.amount)              AS 'numdonations',
CEILING(AVG(a.amount))       AS 'avgamount',
CEILING(SUM(a.amount))       AS 'totalgenerosity'
FROM
segments s,
periods p,
acts a
WHERE
(s.contact_id = a.contact_id) AND
(s.period_id = 0 OR s.period_id = 1 ) AND
(p.period_id = 0 OR p.period_id = 1 ) AND
(s.segment LIKE '%PA WW%') AND
(a.act_date >= p.FirstDay) AND
(a.act_date <= p.LastDay)
GROUP BY 1
ORDER BY totalgenerosity DESC"

revenues=sqlQuery(db,query)

#Sort revenues same order as segments/trans_mat
revenues = revenues[c(2,1,3,4,5,6),]

yearly_revenue= revenues$avgamount

#put warm, cold, lost as 0
yearly_revenue[5:7]=0

write.table(yearly_revenue, file = "desktop/results_paww.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute revenue per segment per year
revenue_per_segment = (yearly_revenue) * segments
print("Revenue per segment:")
print(revenue_per_segment)


write.table(revenue_per_segment, "desktop/results_paww.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute yearly revenue
yearly_revenue = colSums(revenue_per_segment)
print("Yearly revenue:")
print(yearly_revenue)
plot(yearly_revenue)
lines(yearly_revenue)

write.table(t(yearly_revenue), "desktop/results_paww.csv", col.names=TRUE, sep=",", append=TRUE)
# Compute cumulated revenue
cumulated_revenue = cumsum(yearly_revenue)
print("Cumulated revenue:")
print(cumulated_revenue)
plot(cumulated_revenue)
lines(cumulated_revenue)

write.table(t(cumulated_revenue), "desktop/results_paww.csv", col.names=TRUE, sep=",", append=TRUE)
# Create a discount factor
# Other version: discount = (1 - discount_rate) ^ (1:num_periods)
discount = 1 / ((1 + discount_rate) ^ ((1:num_periods) - 1))
print(discount)

# Compute discounted yearly revenue
disc_yearly_revenue = yearly_revenue * discount
print("Discounted yearly_revenue:")
print(disc_yearly_revenue)
plot(yearly_revenue)
lines(yearly_revenue)
lines(disc_yearly_revenue)

write.table(t(disc_yearly_revenue), "desktop/results_paww.csv", col.names=TRUE, sep=",", append=TRUE)

# Compute discounted cumulated revenue
disc_cumulated_revenue = cumsum(disc_yearly_revenue)
print("Discounted cumulated revenue:")
print(cumulated_revenue)
plot(cumulated_revenue)
lines(disc_cumulated_revenue)

write.table(t(disc_cumulated_revenue), "desktop/results_paww.csv", col.names=TRUE, sep=",", append=TRUE)

# What is the database worth?
worth_channel = disc_cumulated_revenue[num_periods] - yearly_revenue[1]
print(worth-channel)

write.table(worth_channel, "desktop/results_doww.csv", col.names=TRUE, sep=",", append=TRUE)

