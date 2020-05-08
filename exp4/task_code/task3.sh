#!/bin/bash/env bash

#显示帮助信息
function help_information
{
	echo "usage: bash task3.sh [dir] [-options] [-h]"
	echo " options:"

	echo "  -H        统计访问来源主机TOP 100和分别对应出现的总次数"
	echo "  -i        统计访问来源主机TOP 100 IP和分别对应出现的总次数"
	echo "  -u        统计最频繁被访问的URL TOP 100"
	echo "  -s        统计不同响应状态码的出现次数和对应百分比"
	echo "  -c        统计不同4XX状态码对应的TOP 10 URL和对应出现的次数"
	echo "  -U [url]  给定URL输出TOP 100访问来源主机"
	echo "  -h        查看帮助信息"
}


#统计访问来源主机TOP 100和分别对应出现的总次数
function top100host
{
	sed -n '2,$p' "$1" \
        | awk -F '\t' ' {host[$1]++}
	END {
	for(i in host) printf("%-40s %-10d\n",i,host[i])}' \
	| sort -r -n -k 2| sed -n '1,100p'
}


#统计访问来源主机TOP 100 IP和分别对应出现的总次数
function top100ip
{
         sed -n '2,$p' "$1" \
	| awk -F '\t' '$1 ~!/[a-zA-Z]/{ip[$1]++}
	 END {
	 for(i in ip) print("%-40s%-30d\n",i,ip[i])}' \
         | sort -n -r -k 2 | sed -n '1,100p'
}


#统计最频繁被访问的URL TOP 100
function top100url
{
         sed -n '2,$p' "$1" \
         | awk -F '\t' '{url[$5]++}
	 END {for(i in url) printf("%-40s%-10d\n",i,url[i])}' \
         | sort -r -n -k 2 | sed -n '1,100p'
}


#统计不同响应状态码的出现次数和对应百分比
function statuscode
{
         sed -n '2,$p' "$1" \
         | awk -F '\t' '{statuscodes[$6]++}
	 END {for(i in statuscodes) printf("%-4s%-10d%-4.6f%%\n",i,statuscodes[i],statuscodes[i]*100/NR)}' \
         | sort -r -n -k 2 | sed -n '1,$p'
} 


#分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function code4xx
{      

         code=$(sed -n '2,$p' "$1" | awk -F '\t' '{if($6~/^4/) {print $6} }' | sort -u) 
         for c in $code; do
                 echo "$c"
                 sed -n '2,$p' "$1" | awk -F '\t' '{if($6=="'$c'") {code4[$5]++}           }
	 END {for(i in code4)printf("%-40s %-10d\n",i,code4[i])}' | sort  -r -n -k 2 | sed -n '1,10p'
         done
}


#给定URL输出TOP 100访问来源主机
function urltophost
{

         sed -n '2,$p' "$1"| \
         awk -F '\t' '{if($5=="'$2'") u[$1]++} END {for(i in u) printf("%-40s%-10d\n",i,u[i])}' \
         | sort -r -n -k 2 | sed -n '1,100p'  
}





	file="$1"
	shift
	#until [ "$#" -eq 0 ]
	while [[ "$#" -ne 0 ]];

	do
		case "$1" in
			"-H")
				top100host "$file"
				exit 0;;

			"-i")
				top100ip "$file"
				exit 0;;

			"-u")
				top100url "$file"
				exit 0;;

			"-s")
				statuscode "$file"
				exit 0;;
			"-c")
				code4xx "$file"
				exit 0;;
			"-U")
				urltophost "$file" "$2"
				exit 0;;
			"-h")
				help_information
				exit 0;;
		esac
	done

