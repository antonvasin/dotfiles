youtube-gif() {
  ID=$1
  START=$2
  LENGTH=$3

  ffmpeg -i $(youtube-dl -f 18 --get-url https://www.youtube.com/watch?v=$ID) -ss $START -t $LENGTH -c:v copy -c:a copy $ID.mp4
  ffmpeg -i $ID.mp4 -pix_fmt rgb8 -r 10 -ss $START -t $LENGTH $ID-unopt.gif
  convert -layers Optimise $ID-unopt.gif $ID.gif
  rm $ID-unopt.gif $ID.mp4
}
