Youtube-MP3
===========

Application that converts youtube videos into mp3 from a single channel

To run the shell, make it executable then use:
./youtube.sh (channel name goes here)

Main issue is that it can only download 300 videos max, so if a channel has more than that, change this line to the right number:
  while [  $totalVideo -lt 300 ]
and it should work.
