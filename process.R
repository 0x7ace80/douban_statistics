record = read.csv("~/result.txt", header=F, colClasses="character");
record = as.Date(record$V1);
record_month = months(record);
record_week = weekdays(record);

# setup some consts
monthname=c("一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月" , "十二月");
weekname=c("星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日");
weekname_eng = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun");

month_bar = c();
for (mon in monthname) month_bar = c(month_bar, length(which(record_month == mon)));

week_bar = c();
for(week in weekname) week_bar = c(week_bar, length(which(record_week == week)));

record_len = length(record);
interval = record[1:(record_len-1)] - record[2:record_len];
interval = as.numeric(interval[which(interval < 40)]);

## Processing record of 2014 ##
record_2014 = record[which(record > as.Date("2014-01-01"))];
record_month_2014 = months(record_2014);
record_week_2014 = weekdays(record_2014);
month_bar_2014 = c();
for (mon in monthname) month_bar_2014 = c(month_bar_2014, length(which(record_month_2014 == mon)));

week_bar_2014 = c();
for(week in weekname) week_bar_2014 = c(week_bar_2014, length(which(record_week_2014 == week)));

record_len = length(record_2014);
interval_2014 = record_2014[1:record_len-1] - record_2014[2:record_len];
interval_2014 = as.numeric(interval_2014[which(interval_2014 < 40)]);

## Plot ##
par(mfrow=c(2,3))
# first column is overall stat
hist(interval, breaks=seq(0, 41, 3));
barplot(month_bar, names.arg=month.name);
barplot(week_bar, names.arg=weekname_eng);

# second column is 2014 stat
hist(interval_2014, breaks=seq(0,41, 3));
barplot(month_bar_2014, names.arg=month.name);
barplot(week_bar_2014, names.arg=weekname_eng);

