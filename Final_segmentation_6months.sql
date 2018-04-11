# Use the charity database
USE ma_charity_full;


# Clean tables for the exercise
DROP TABLE periods;
DROP TABLE segments;


# We're going to divide the past in periods
# Create a table to store period information
CREATE TABLE periods (
  period_id INTEGER NOT NULL,
  FirstDay DATE NOT NULL,
  LastDay DATE NOT NULL,
  PRIMARY KEY (period_id)
)
ENGINE = MyISAM;


# Define 11 periods - every 6 months
# Period 0 = the most recent ('today')
INSERT INTO periods
VALUES ( 0, 20160626, 20170625),
       ( 1, 20151226, 20161225),
       ( 2, 20150626, 20160625),
       ( 3, 20141226, 20151225),
       ( 4, 20140626, 20150625),
       ( 5, 20131226, 20141225),
       ( 6, 20130626, 20140625),
       ( 7, 20121226, 20131225),
       ( 8, 20120626, 20130625),
       ( 9, 20111226, 20121225),
       (10, 20110626, 20120625);


# Create a segment table
# It will store to which segment each donor belonged
# in each period
CREATE TABLE segments (
  Sq INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  contact_id INTEGER UNSIGNED NOT NULL,
  period_id INTEGER NOT NULL,
  segment VARCHAR(12),
  PRIMARY KEY (Sq),
  INDEX Idxcontact_id(contact_id),
  INDEX Idxperiod_id(period_id)
)
ENGINE = MyISAM;


# This will create a placeholder for all
# contact-by-period possible combinations
INSERT INTO segments (contact_id, period_id)
SELECT a.contact_id, p.period_id
FROM acts a,
     periods p
GROUP BY 1, 2;

SET SQL_SAFE_UPDATES = 0;


# Create the PA segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   acts a, periods p
   WHERE  (a.act_date <= p.LastDay) AND
          (a.act_date >= p.FirstDay) AND
          (a.act_type_id LIKE 'PA')) AS d
SET
  s.segment = 'PA'
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id);
  
#Subdivise the PA WW segment into PA WW Top, PA WW Mid, PA WW Bottom
UPDATE
  segments s,
  (SELECT contact_id, period_id, SUM(amount) AS generosity
   FROM   acts a, periods p
   WHERE  (a.act_date <= p.LastDay) AND
          (a.act_date >= p.FirstDay) AND
          (a.act_type_id LIKE 'PA') AND
          (a.channel_id LIKE 'WW')
   GROUP BY 1, 2) AS d
SET  s.segment =
(

CASE
	WHEN (generosity<=40) THEN 'PA WW BOTTOM'
    WHEN (100 < generosity) THEN 'PA WW TOP'
    ELSE 'PA WW MIDDLE'
END
)
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id) AND
  (s.segment LIKE 'PA');
  
#Subdivise the PA MA segment into PA MA Top, PA WW Mid, PA WW Bottom
UPDATE
  segments s,
  (SELECT contact_id, period_id, SUM(amount) AS generosity
   FROM   acts a, periods p
   WHERE  (a.act_date <= p.LastDay) AND
          (a.act_date >= p.FirstDay) AND
          (a.act_type_id LIKE 'PA') AND
          (a.channel_id LIKE 'MA')
   GROUP BY 1, 2) AS d
SET  s.segment =
(

CASE
	WHEN (generosity<=40) THEN 'PA MA BOTTOM'
    WHEN (100 < generosity) THEN 'PA MA TOP'
    ELSE 'PA MA MIDDLE'
END
)
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id) AND
  (s.segment LIKE 'PA');
  
#CREATE DO segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   acts a, periods p
   WHERE  (a.act_date <= p.LastDay) AND
          (a.act_date >= p.FirstDay) AND
          (a.act_type_id LIKE 'DO')) AS d
SET
  s.segment = 'DO'
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id);

#Subdivise the DO WW segment into DO Top WW, DO Mid WW, DO Bottom WW'
UPDATE
  segments s,
  (SELECT contact_id, period_id, SUM(amount) AS generosity
   FROM   acts a, periods p
   WHERE  (a.act_date <= p.LastDay) AND
          (a.act_date >= p.FirstDay) AND
          (a.act_type_id LIKE 'DO') AND
          (a.channel_id LIKE 'WW')
   GROUP BY 1, 2) AS d
SET  s.segment =
(
CASE
	WHEN (generosity<=40) THEN 'DO WW BOTTOM'
    WHEN (100 < generosity) THEN 'DO WW TOP'
    ELSE 'DO WW MIDDLE' 
END
)
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id) AND
  (s.segment LIKE 'DO');
  
#Subdivise the DO MA segment into DO Top MA, DO Mid MA, DO Bottom MA'
UPDATE
  segments s,
  (SELECT contact_id, period_id, SUM(amount) AS generosity
   FROM   acts a, periods p
   WHERE  (a.act_date <= p.LastDay) AND
          (a.act_date >= p.FirstDay) AND
          (a.act_type_id LIKE 'DO') AND
          (a.channel_id LIKE 'MA')
   GROUP BY 1, 2) AS d
SET  s.segment =
(
CASE
	WHEN (generosity<=40) THEN 'DO MA BOTTOM'
    WHEN (100 < generosity) THEN 'DO MA TOP'
    ELSE 'DO MA MIDDLE'
END
)
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id) AND
  (s.segment LIKE 'DO');
  
# Create the NEW DO-MA segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM periods p,
        (SELECT contact_id, MIN(act_date) AS FirstAct
         FROM acts
         GROUP BY 1) AS f
   WHERE (f.FirstAct <= p.LastDay) AND
         (f.FirstAct >= p.FirstDay)) AS d
SET
  s.segment = 'NEW DO MA'
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id) AND
  (s.segment LIKE 'DO MA%');
  
# Create the NEW DO-WW segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM periods p,
        (SELECT contact_id, MIN(act_date) AS FirstAct
         FROM acts
         GROUP BY 1) AS f
   WHERE (f.FirstAct <= p.LastDay) AND
         (f.FirstAct >= p.FirstDay)) AS d
SET
  s.segment = 'NEW DO WW'
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id) AND
  (s.segment LIKE 'DO WW%');
  
  
# Create the NEW PA-MA segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM periods p,
        (SELECT contact_id, MIN(act_date) AS FirstAct
         FROM acts
         GROUP BY 1) AS f
   WHERE (f.FirstAct <= p.LastDay) AND
         (f.FirstAct >= p.FirstDay)) AS d
SET
  s.segment = 'NEW PA MA'
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id) AND
  (s.segment LIKE 'PA MA%');
  
# Create the NEW PA-WW segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM periods p,
        (SELECT contact_id, MIN(act_date) AS FirstAct
         FROM acts
         GROUP BY 1) AS f
   WHERE (f.FirstAct <= p.LastDay) AND
         (f.FirstAct >= p.FirstDay)) AS d
SET
  s.segment = 'NEW PA WW'
WHERE
  (s.contact_id = d.contact_id) AND
  (s.period_id = d.period_id) AND
  (s.segment LIKE 'PA WW%');


# Create the WARM WW PA segment 
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'NEW PA WW')OR
          (segment LIKE 'PA WW TOP') OR
          (segment LIKE 'PA WW MIDDLE') OR
          (segment LIKE 'PA WW BOTTOM')) AS a
SET
  s.segment = 'WARM PA WW'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
# Create the WARM MA PA segment 
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'NEW PA MA')OR
          (segment LIKE 'PA MA TOP') OR
          (segment LIKE 'PA MA MIDDLE') OR
          (segment LIKE 'PA MA BOTTOM')) AS a 
SET
  s.segment = 'WARM PA MA'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
# Create the WARM WW DO segment 
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'NEW DO WW')OR
          (segment LIKE 'DO WW TOP') OR
          (segment LIKE 'DO WW MIDDLE') OR
          (segment LIKE 'DO WW BOTTOM')) AS a
SET
  s.segment = 'WARM DO WW'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
# Create the WARM MA DO segment 
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'NEW DO MA')OR
          (segment LIKE 'DO MA TOP') OR
          (segment LIKE 'DO MA MIDDLE') OR
          (segment LIKE 'DO MA BOTTOM')) AS a 
SET
  s.segment = 'WARM DO MA'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);


#Create the COLD PA MA segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'WARM PA MA')) AS a
SET
  s.segment = 'COLD PA MA'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
#Create the COLD PA WW segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'WARM PA WW')) AS a
SET
  s.segment = 'COLD PA WW'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
#Create the COLD DO MA segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'WARM DO MA')) AS a
SET
  s.segment = 'COLD DO MA'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
#Create the COLD DO WW segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'WARM DO WW')) AS a
SET
  s.segment = 'COLD DO WW'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);


# Create the LOST DO MA segment

UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'COLD DO MA')) AS a
SET
  s.segment = 'LOST DO MA'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);	
  
# Create the LOST DO WW segment

UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'COLD DO WW')) AS a
SET
  s.segment = 'LOST DO WW'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
 
# Create the LOST PA MA segment
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'COLD PA MA')) AS a
SET
  s.segment = 'LOST PA MA'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);	
  
# Create the LOST PA WW segment

UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'COLD PA WW')) AS a
SET
  s.segment = 'LOST PA WW'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
#####################################################################################
#################### FROM HERE, RUN QUERIES UNTIL ROW AFFECTED = 0 #################
#####################################################################################

#Still LOST Segment - Request must be applied multiple times
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'LOST PA WW')) AS a
SET
  s.segment = 'LOST PA WW'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'LOST PA MA')) AS a
SET
  s.segment = 'LOST PA MA'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'LOST DO MA')) AS a
SET
  s.segment = 'LOST DO MA'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);

UPDATE
  segments s,
  (SELECT contact_id, period_id
   FROM   segments
   WHERE  (segment LIKE 'LOST DO WW')) AS a
SET
  s.segment = 'LOST DO WW'
WHERE
  (s.contact_id = a.contact_id) AND
  (s.period_id = a.period_id - 1) AND
  (s.segment IS NULL);
  
#####################################################################################  
##################### Computations #############################################
#####################################################################################
# Count segment members per period
SELECT count(s.contact_id), s.segment
FROM segments s, acts a
WHERE s.period_id = 0
AND s.contact_id = a.contact_id
group by 2;


# In which segments were donors last period,
# and where are they now?
SELECT old.segment, new.segment, COUNT(new.segment)
FROM segments old,
     segments new
WHERE (old.contact_id = new.contact_id) AND
      (old.period_id = 1) AND
      (new.period_id = 0)
GROUP BY 1, 2
ORDER BY 1, 2;


# Report the financial contribution of each segment
SELECT
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
  (a.act_date >= p.FirstDay) AND
  (a.act_date <= p.LastDay)
GROUP BY 1
ORDER BY totalgenerosity DESC;


# Report the financial contribution in "period 0"
# (last 6 months) of each segment in period 1 (6 months before)
SELECT
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
  (s.period_id = 2 OR s.period_id = 3) AND
  (p.period_id = 0 OR p.period_id = 1) AND
  (a.act_date >= p.FirstDay) AND
  (a.act_date <= p.LastDay)
GROUP BY 1
ORDER BY totalgenerosity DESC;