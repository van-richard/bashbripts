#!/bin/bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This message is printed when the script is executed, not sourced."
fi

module load intel/2021.2.0
module load impi/2021.2.0
source /home/van/.Programs/amber21/amber.sh
source /home/van/.Programs/qchem/trunk2/setqc.sh
export MKLROOT=/opt/intel/oneapi/mkl/2021.2.0
export LD_PRELOAD=$MKLROOT/lib/intel64/libmkl_core.so:$MKLROOT/lib/intel64/libmkl_sequential.so:$MKLROOT/lib/intel64/libmkl_rt.so

shopt -s expand_aliases
source ~/.bash_aliases
panconda; conda activate torchmd-net

export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so
export I_MPI_THREAD_YIELD=3
export I_MPI_THREAD_SLEEP=200

printf "Did you remembeer to change this? \n\n"
printf "export MKL_NUM_THREADS=4 \n"
printf "export OMP_NUM_THREADS=4 \n\n"
printf "SANDER="srun -n 16 sander.MPI \n"

