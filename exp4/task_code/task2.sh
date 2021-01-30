#!/usr/bin/env bash

#显示帮助信息
function help_information {
        echo "Usage:  bash task2.sh [dir] [-options] "
        echo "options:"
        echo "  -r       不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比"
        echo "  -p       统计不同场上位置的球员数量、百分比"
        echo "  -n       名字最长和最短的球员"
        echo "  -m       年龄最大和最小的球员"
        echo "  -h       获取帮助信息"

}

declare -A a

#统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
function age_range {
	i=2
	age_lt20=0
	age_bw20to30=0
	age_gt30=0
      	row=$(sed -n "$i"p "$1")
    while [[ "$row" != '' ]];do
	IFS='	'
	read -r -a info<<<"$row"
	sum=$(($sum+1))
	age=${info[5]}
	name=${info[8]}
	if [[ "$age" -lt 20 ]];then
		age_lt20=$((age_lt20+1))
	elif [[ "$age" -gt 30 ]];then
		age_gt30=$((age_gt30+1))
	else
		age_bw20to30=$((age_bw20to30+1))
	fi
	  i=$(($i+1))
          row=$(sed -n "$i"p "$1")

done
	echo "小于20岁的球员数量有$age_lt20个，所占百分比为$(printf "%.4f" $(echo "$age_lt20/$sum*100" | bc -l))%"
	 echo "大于20岁小于30岁的球员数量有$age_bw20to30个，所占百分比为$(printf "%.4f" $(echo "$age_bw20to30/$sum*100" | bc -l))%"
	  echo "大于30岁球员数量有$age_gt30个，所占百分比为$(printf "%.4f" $(echo "$age_gt30/$sum*100" | bc -l))%"

}
#年纪最大和最小的球员
function age_maxmin {
	i=2
	min=1000
	max=0
	youngest_name=()
	oldest_name=()
       row=$(sed -n "$i"p "$1")
    while [[ "$row" != '' ]];do
        IFS='	'
        read -r -a info<<<"$row"
        age=${info[5]}
	name=${info[8]}
	if [[ "$age" -lt "$min" ]];then
	  	min="$age"
      youngest_name=("$name")
    elif [[ "$age" == "$min" ]];then
	youngest_name=("${youngest_name[@]}" "$name")
    fi

    if [[ "$age" -gt "$max" ]];then
      max="$age"
      oldest_name=("$name")
    elif [[ "$age" == "$max" ]];then
      oldest_name=("${oldest_name[@]}" "$name")
    fi
	 i=$(($i+1))
         row=$(sed -n "$i"p "$1")

done
	echo "年纪最大的球员是"
	for p in "${oldest_name[@]}"; do echo "$p"; done
	echo "他们的年纪为 $max 岁"
	echo -e "\n"	

	echo "年纪最小的球员是"
        for p in "${youngest_name[@]}"; do echo "$p"; done
        echo "他们的年纪为 $min 岁"
        echo -e "\n"


}

#统计不同场上位置的球员数量、百分比
function position {
	i=2
	sum=0
	row=$(sed -n "$i"p "$1")
  while [[ "$row" != '' ]];do
        read -r -a info<<<"$row"
        IFS='	'
	sum=$(($sum+1))
	pos=${info[4]}
	 flag=0
    for j in "${!a[@]}"; do
      if [[ "$pos" == "$j" ]];then
	a["$j"]=$(( ${a["$j"]}+1 ))
	flag=1
	break
      fi
    done
    if [[ "$flag" -eq 0 ]];then
      a["$pos"]=1
    fi
     i=$(($i+1))
     row=$(sed -n "$i"p "$1")
done
        for pos in "${!a[@]}"; do 
	echo "位于位置$pos上的球员有${a[$pos]}个，所占百分比为$(printf "%.4f" $(echo "${a[$pos]}/$sum*100" | bc -l))%"
		printf "\n" 
	done
}

#最长的名字与最短的名字
function name {
	i=2
	min_len=100
	max_len=0
	shortest_name=()
	longest_name=()
	row=$(sed -n "$i"p "$1")
    while [[ "$row" != '' ]];do
        IFS='	'
        read -r -a info<<<"$row"
        name=${info[8]}
        len=${#name}
    #求最短名字
    if [[ "$len" -lt "$min_len" ]];then
      min_len=$len
      shortest_name=("$name")
    elif [[ "$len" -eq "$min_len" ]];then
      shortest_name=("${shortest_name[@]}" "$name")
    fi

    #求最长名字
    if [[ "$len" -gt "$max_len" ]];then
      max_len="$len"
      longest_name=("$name")
    elif [[ "$len" -eq "$max_len" ]];then
      longest_name=("${longest_name[@]}" "$name")
    fi
	i=$(($i+1))
	  row=$(sed -n "$i"p "$1")
  done

	echo "名字最长的球员是"
	for j in "${longest_name[@]}"; do echo "$j";
	done	
	echo -e "\n"	
	
	echo "名字最短的球员是"
	for j in "${shortest_name[@]}"; do echo "$j";
 	done	
	echo -e "\n"
	


}


while [[ "$#" -ne 0 ]];  
 do
    case "$2" in
      "-r")
             age_range $1
	      exit 0 ;;
      "-m")
         age_maxmin $1
         exit 0 ;;
      "-p")
	 position $1
	 exit 0;;
      "-n")
      	name $1
	exit 0;;
      "-h")
	  help_information
	  exit 0;;
	 esac
 done
