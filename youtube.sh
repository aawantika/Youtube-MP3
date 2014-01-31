#!/bin/bash  

youTubeUser=$1
mkdir -p $1
cd $1

i=0
totalVideo=0
wget -O channelid "http://www.youtube.com/user/$youTubeUser/videos"
channelID=$(cat channelid | grep -o '.\channel_id.\{0,25\}' | cut -d'=' -f2)
echo "CHANNEL ID: "$channelID

while [  $totalVideo -lt 300 ]
do
count=1
lynx -dump -source "http://www.youtube.com/c4_browse_ajax?action_load_more_videos=1&live_view=500&flow=list&paging=$i&channel_id=$channelID&sort=dd&view=0" > file$i
#Gets JUST the url
cat file$i | sed 's/\/watch/\n\n\n\/watch/g' | sed "s/\\\u0026#39;/'/g" | sed "s/\\\u0026amp;/and/g" | grep ^"/watch"| cut -d'\' -f1 | awk 'NR % 2 == 0' > url$i
#Gets the url and the file name
#cat file$i | sed 's/\/watch/\n\n\n\/watch/g' | sed "s/\\\u0026#39;/'/g" | sed "s/\\\u0026amp;/and/g" | grep ^"/watch"| cut -d'\' -f1,5 | awk 'NR % 2 == 0' | sed 's/\\n       /\n/g' > url$i

#download video in mp4 highest quality format WITH TITLE
while read line
do
url=$(echo $line | awk '{ print  "http://www.youtube.com"  $0}')
echo "STARTING VIDEO NUMBER "$count
youtube-dl -t $url --max-quality mp4
echo "VIDEO NUMBER "$count" IS COMPLETE"
(( count++ ))
done  < url$i

rm file$i
rm url$i
i=$(($i+1))
totalVideo=$(($totalVideo+30))
done

#rename files to remove the excess filename and then convert to mp3
for f in *.mp4
do
    name=$(echo "$f" | sed -e "s/.mp4$//g"| cut -d')' -f1| awk '{ print $0 ")"}')
    ffmpeg -i "$f" -f mp3 -ab 320000 -vn "$name.mp3"
done

rm *.mp4
mv *.mp3 $1"/"
rm channelid
cd ..

#***************************************************************************************************************#
# This downloads the file with the original name and renames it (still in work for korean characters in title)
# count=0
# while read line
# do
# if [ $(( $count % 2 )) -eq 0 ]; then 
# file_name=$(echo $line |cut -d' ' -f1 | cut -d'=' -f2)
# url=$(echo $line | cut -d' ' -f1 | awk '{ print  "http://www.youtube.com"  $0}')
# echo "STARTING VIDEO NUMBER "$count
# echo "FILE NAME: "$file_name
# echo "URL: "$url
# youtube-dl $url --max-quality mp4
# fi
# if [ $(( $count % 2 )) -eq 1 ]; then 
# title=$(echo $line | grep -v "watch" | sed 's/^ //')
# echo "TITLE: "$title
# mv "$file_name".mp4 "$title".mp4
# #mv "$title".mp4 $1
# echo "VIDEO NUMBER "$count" IS COMPLETE"
# fi
# (( count++ ))
# done  < url0
