for index in $(seq 0 51)
do
    start=$((index*10))
    URL="http://www.douban.com/people/zhangjiawei/notes?start=${start}&type=note"
    echo $URL

    curl -o test.txt ${URL}
    grep ">201*" test.txt >> result.txt
done
