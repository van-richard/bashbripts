module load intel/2020a
source /home/panxl/qchem/trunk2/setqc.sh
source /home/panxl/amber20/amber.sh
export UCX_TLS=all

# For QMHub only
eval "$(/home/panxl/.local/opt/miniforge3/bin/conda shell.bash hook)"
conda activate

export I_MPI_PIN=0
export I_MPI_THREAD_YIELD=3
export I_MPI_THREAD_SLEEP=200
export I_MPI_OFI_PROVIDER=verbs

# For QMHub only
export MKL_NUM_THREADS=16
export OMP_NUM_THREADS=16
