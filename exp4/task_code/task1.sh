#!/usr/bin/env bash

#显示帮助信息
function help_information {
	echo "Usage:  bash task1.sh [dir] [-options] "
	echo "options:"
	echo "  -c [quality]  对jpeg格式图片进行图片质量压缩"
	echo "  -r [width]    对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率"
   	echo "  -w [text]     对图片批量添加自定义文本水印"	
	echo "  -t            将png/svg图片统一转换为jpg格式图片"
	echo "  -p [text]     统一添加文件名前缀"
	echo "  -s [text]     统一添加文件名后缀"

}
# 对jpeg格式图像进行图片质量压缩
function jpeg_compression {
        [ -d "result_compression" ] || mkdir "result_compression"
	for img in *.jpg;
	do
                convert "$img" -quality "$1" ./result_compression/"$img"
		echo "Compression successful!"
	done
}


# 对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function jpeg_png_svg_resize {
	[ -d "result_resize" ] || mkdir "result_resize"
        selected_img=($(find . -maxdepth 1 -name "*.jpg" -o -name "*.svg" -o -name "*.png"))
	for img in "${selected_img[@]}";
	do
         	convert "$img" -resize "$2" ./result_resize/"$img"
                echo "Resize successful!"
        done
}


#支持对图片批量添加自定义文本水印
function watermarking {
	[ -d "result_watermarking" ] || mkdir "result_watermarking"
        selected_img=($(find . -maxdepth 1 -name "*.jpg" -o -name "*.svg" -o -name "*.png"))
        for img in "${selected_img[@]}";
        do
                convert "$img" -fill blue -pointsize 30 -draw "text 200,200 '$1' " ./result_watermarking/"$img"
      	        echo "watermarking successful!"
        done
}


#将png/svg图片统一转换为jpg格式图片
function transfer_to_jpg  {

	[ -d "result_transfer2jpg" ] || mkdir "result_transfer2jpg"
        selected_img=($(find . -maxdepth 1 -name "*.svg"  -o -name "*.png"))
        for img in "${selected_img[@]}";
        do
                convert "$img" ./result_transfer2jpg/"${img%.*}.jpg"
                echo "transfer2jpg finished!"
        done
}
#批量重命名（统一添加文件名前缀
function prefix {

[ -d "result_prefix" ] || mkdir "result_prefix"
       selected_img=($(find . -maxdepth 1 -name "*.jpg" -o -name "*.svg" -o -name "*.png"))
      for img in "${selected_img[@]}";
        do
        	filename=${img##*/}
		cp -- "$img" ./result_prefix/"$1$filename"
                echo "prefix finished!"
        done
}



#批量重命名（统一添加文件名后缀
function suffix {

[ -d "result_suffix" ] || mkdir "result_suffix"
       selected_img=($(find . -maxdepth 1 -name "*.jpg" -o -name "*.svg" -o -name "*.png"))
      for img in "${selected_img[@]}";
        do
                filename=${img##*/}
		file_name=${filename%.*}
		extension=${img##*.}
                cp -- "$img" ./result_suffix/"$file_name$1"."$extension"
                echo "suffix finished!"
        done
}


#main function

dir="$1"
 cd "$dir"|| exit
  shift 1
 while [[ "$#" -ne 0 ]];

  do
    case "$1" in
      "-c")
	 jpeg_compression "$2" 
	 exit 0 ;;
      "-r")
         jpeg_png_svg_resize "$dir" "$2"
         exit 0 ;;
      "-w")
  	 watermarking "$2"
       	 exit 0 ;;
      "-t")
	 transfer_to_jpg
	 exit 0 ;;
      "-p")
         prefix "$2"
	 exit 0 ;;
      "-s")
         suffix "$2"
	 exit 0 ;;
      "-h")
	 help_information
	 exit 0 ;;
	 esac
 done
