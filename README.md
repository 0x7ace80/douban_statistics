# douban_statistics
A Statistics Research of A Blogger at Douban.

“These are lies, damned lies and statistics" -- Mark Twain

本文写作于 2015-01-08

豆瓣上的张佳玮
`http://www.douban.com/people/zhangjiawei`

他的豆瓣日记从2008年到现在一直保持了一个较高的更新频率。日记内容是相当棒的，颇值一读。而且几乎每篇的内容都相对独立。看起来作者都是兴致所至提笔写成一篇日记。卤煮突然醒悟：这不就是统计学上典型的“独立同分布”么？处理这样的样本好处就是“贝叶斯”老师和“马尔可夫”老师都不用请了。他们最近在Google，Apple这些公司很忙的。整天战斗在反垃圾邮件和Siri语音识别的第一线。

对作者发表日记时间进行统计分析给了我们一个独特的视角来了解作者的写作的变化。今天就让卤煮拿张公子的日记记录来试一下。打算研究一下张公子发表文章的频率，以及以周和月为视角的行为分析。看看有没有什么有趣的现象。

首先解决数据获取的问题，观察了豆瓣日记的URL格式可以发现URL的格式非常固定

`http://www.douban.com/people/zhangjiawei/notes?start=10&type=note`

只要改变start的数值就可以获得日记列表，索引从Start的值开始。卤煮毫不犹豫点开Terminal窗口写下几行Bash（什么是Terminal 什么是Bash ？啊哈！  *nix 上才有的挨踢工具啊～）

```bash
for index in $(seq 0 51)
do
  start=$((index*10))
  URL="http://wwww.douban.com/people/zhangjiawei/notes?start=${start}&type=note"
  echo ${URL}
  
  curl -o test.txt {URL}
  grep "201*" test.txt >> report.txt
done
```

这里我们用到了curl来获得html文件内容然后把日期信息grep出来并且添加到result.txt中。
跑完这个bash得到的result.txt里面还有点脏。。。有些无关内容也被grep粗来鸟～不过没关系，随手删了吧，然后把无关的内容去掉就可以得到纯净的日期列表了。
最后在result.txt中可以看到倒序的日记发表日期列表。

张公子从2008年到现在总共发表了511篇日志，笔耕不辍。
处理统计信息当然应该用 R 工具包。在处理时间序列方面尤为方便。
代码如下：

```R
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

```

如代码所示，我们首先分析了张公子发表日志的时间的间隔分布，然后分析了以周和月为视角的分布。代码运行的结果如下。

![Result](http://github.com/0x7ace80/douban_statistics/raw/master/001PI1gJty6P19nrYjJef&690.jpg)

第一行是对全体收集到的数据的分析结果。第二行是2014年数据分析的结果。
第一列是频率分析图，统计了相邻两篇日记之间间隔的时间的分布。每一个bar的时间是三天。也就是说第一个bar 的意思是 “有多少相邻的两篇日记的发表时间间隔小于三天”，第二个bar的意思是“有多少相邻的两篇日记的发表时间间隔大于等于三天但是小于六天”，然后以此类推。

从第一行的第一个图中可以看出张公子的511篇日志中大约有一半的日记的发表时间间隔小于三天。
第二行的第一个图可以看出3-6天的数量有所增加。可见从整体上说2014年作者不如往年这么勤奋在豆瓣po日记了。

如果仔细观察第一行的第一个图，其轮廓呈现出较为完美的曲线，这点暗示我们作者发表日记的随机性是较高的。卤煮没有特别求证，但是看起来颇为拟合一个landa较小的柏松分布


![Poission](http://github.com/0x7ace80/douban_statistics/raw/master/001PI1gJty6P19pFzfT4d&690.jpg)


再看看第二列。以月份为基点，作者po日记的节奏比较平稳，按月差别不是很大，总的来说夏天还是比较活跃。

第三列以周为单位就非常有特点了，基本上作者不喜欢在周末po上新。周五也少，果然是法国风格啊，周一到周四上班。。。各种嫉妒～

好了，简单的挖掘就这里了。其实还可以接着分析，不同的月份下每周的频率等。这样就可以通过贝叶斯定律分析作者接下来某天发文章的概率了。

这里预测张公子在本周四和下周一po新文的概率很高。
拭目以待。
