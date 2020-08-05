#!/bin/bash

usage() { 
	echo "Usage: $0 [-i <Startdate> (e.g. 2020-05-01)] [-o <Stepsize]" 1>&2; exit 1; 
}

check_end () {

	if grep -q $day "$file"; then
		echo "Enddate exists."
	else
		echo "Enddate not exists, try again with day before."
		day=$(date -d "$day - 1 days" +%Y-%m-%d)
		check_end
	fi

}

check_start () {

	if grep -q $start "$file"; then
		echo "Startdate exists."
	else
		echo "Startdate not exists, try again with day after."
		start=$(date -d "$start + 1 days" +%Y-%m-%d)
		check_start
	fi

}

check_date () {
    d="$1"
    [[ "$(date +%Y-%m-%d -d "$d" 2>/dev/null)" == "$d" ]]
}

while getopts ":i:o:" option ; do
        case ${option} in
        i) start=${OPTARG} ;;
        o) step=${OPTARG} ;;
        *) usage ;;
        esac
done
shift $((OPTIND -1))

if check_date "$start"; then
	echo "Startdate valid. Checking Stepsize."
else
	echo "Startdate not valid."
	usage
fi

re='^[0-9]+$'
if ! [[ $step =~ $re ]] ; then
	echo "Stepsize not valid" 1>&2; exit 1
else
	echo "Stepsize valid. Checking Table."
fi

covid="../../covid-19"

git -C $covid pull

file=$covid"/data/countries-aggregated.csv"

if [ -f "$file" ]; then
	echo "Table exists. Checking if dates in range."
else
	echo "Table doesn't exist, maybe file structure changed. Exit."
	1>&2; exit 1
fi

day=$(date +%Y-%m-%d)

check_end
check_start

echo "Generating Plots."

while [[ "$start" < "$day" ]]; do
	Rscript covid-exit.R $start
	start=$(date -d "$start + $step days" +%Y-%m-%d)
done

if [ "$start" != "$day" ]; then 
	Rscript covid-exit.R $day
fi

echo "Finished."
