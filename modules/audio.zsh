wav2alac() {
  ffmpeg -i $1 -acodec alac ${1:r}.m4a
}

