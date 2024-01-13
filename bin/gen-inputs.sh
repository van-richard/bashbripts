#!/bin/bash
#
# Script to generate input files for umbrella sampling on user-selected option
# need to figure out how to get number of windows or cvs.... hmmmmmm

source logging.sh

TESTING=true
echo "Script for generating Umbrella Sampling Windows"
echo "Choose an option:"
echo "1. Provide a range of windows"
echo "2. Provide a range of CVs"
read -p "Enter your choice (1 or 2): " option

case $option in
    1)
        # Option 1: Provide a range of windows
        read -p "Enter the start value for windows: " start
        read -p "Enter the step value for windows: " step
        read -p "Enter the end value for windows: " end

        for window_value in $(seq -f "%02g" $start $step $end); do
            log "Processing window $window_value"
            if [ "$TESTING" = true ]; then
                log "Testing Mode: Simulating window operation."
            else
                for i in $(seq -f "%02g" 1 42); do
                    mkdir -p "$i"
                    cd "$i" || exit
                    ln -sf ../input/step3_pbcsetup.parm7 .
                    ln -sf ../input/step5.00_equilibration.mdin .
                    ln -sf ../input/qmhub.ini .
                    cp ../input/step6.00_equilibration.mdin .
                    cd ..
                done
                n=-1.90
                for i in `seq -f"%02g" 0 42`
                do
                    nn=$(printf "%.2f" "$n")
                    sed "s/__REST__/${nn}/g" input/cv.rst > ${i}/cv.rst
                    n=`echo $n + 0.10 | bc`
                done
            fi
        done
        ;;

    2)
        # Option 2: Provide a range of CVs
        read -p "Enter the initial value for n: " initial_n
        read -p "Enter the increment for n: " increment
        read -p "Enter the stop value for n: " stop_n

        while [ "$(echo "$initial_n <= $stop_n" | bc)" -eq 1 ]; do
            nn=$(printf "%.2f" "$initial_n")
            log "Processing CV $nn"
            if [ "$TESTING" = true ]; then
                log "Testing Mode: Simulating CV operation."
            else
                for i in $(seq -f "%02g" 1 42); do
                    mkdir -p "$i"
                    cd "$i" || exit
                    ln -sf ../input/step3_pbcsetup.parm7 .
                    ln -sf ../input/step5.00_equilibration.mdin .
                    ln -sf ../input/qmhub.ini .
                    cp ../input/step6*mdin .
                    cd ..
                done

                n=-1.90
                for i in $(seq -f "%02g" 0 42); do
                    nn=$(printf "%.2f" "$n")
                    sed "s/__REST__/${nn}/g" input/cv.rst > "${i}/cv.rst"
                    n=$(echo "$n + 0.10" | bc)
                done
            fi
            initial_n=$(echo "$initial_n + $increment" | bc)
        done
        ;;

    *)
        log "Invalid choice. Exiting."
        exit 1
        ;;
esac

log "Script completed."

