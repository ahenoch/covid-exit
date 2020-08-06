#!/bin/bash

usage() { 
	echo "Usage: $0 [-i <Startdate> (e.g. 2020-05-01) [default 2020-01-29]] [-e <Enddate> (e.g. 2020-05-01) [default today]] [-o <Stepsize (e.g. 4) [default 7]] [-u <no range> [default off]]" 1>&2; exit 1; 
}


check_date () {
    d="$1"
    [[ "$(date +%Y-%m-%d -d "$d" 2>/dev/null)" == "$d" ]]
}

while getopts ":i:e:o:u" option ; do
        case ${option} in
        i) start=${OPTARG} ;;
        e) end=${OPTARG} ;;
        o) step=${OPTARG} ;;
        u) range=1;;
        *) usage ;;
        esac
done
shift $((OPTIND -1))

if [ -z "$start" ]; then
	start='2020-01-29'
fi

if check_date "$start"; then
	echo "Start format valid."
else
	echo "Start format not valid."
	usage
fi

if [ -z "$range" ]; then
	if [ -z "$end" ]; then
		end=$(date +%Y-%m-%d)
	fi

	if [ -z "$step" ]; then
		step=1
	fi

	if check_date "$end"; then
		echo "End format valid."
	else
		echo "End format not valid."
		usage
	fi

	if [[ "$start" < "$end" ]]; then
		echo "Range valid."
	else	
		echo "Range not valid."
		usage
	fi

	re='^[0-9]+$'
	if [[ $step =~ $re ]] ; then
		echo "Stepsize valid."
	else
		echo "Stepsize not valid" 
		usage
	fi
fi

covid="../../../covid-19"

git -C $covid pull

file=$covid"/data/countries-aggregated.csv"

if [ -f "$file" ]; then
	echo "Table exists."
else
	echo "Table doesn't exist, maybe file structure changed. Exit."
	1>&2; exit 1
fi

if [ -z "$range" ]; then
	echo "Running R Script with range "$start" to "$end" in steps of "$step" days."
	Rscript covid-exit.R $start $end $step
else
	echo "Running R Script with "$start"."
	Rscript covid-exit.R $start
fi

#pdfunite ../Plots/trajectory_of_confirmed_cases_* ../Plots/trajectory_of_confirmed_cases.pdf
#rm ../Plots/trajectory_of_confirmed_cases_*

echo "Finished."
