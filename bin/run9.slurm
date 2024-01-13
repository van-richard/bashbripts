#!/bin/bash
#SBATCH -p batch
#SBATCH -t 5-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=k866a9
#SBATCH --array=6,22

date
module load intel/2021.2.0
module load impi/2021.2.0
source /home/van/.Programs/amber21/amber.sh
source /home/van/.Programs/qchem/trunk2/setqc.sh
export MKLROOT=/opt/intel/oneapi/mkl/2021.2.0
export LD_PRELOAD=$MKLROOT/lib/intel64/libmkl_core.so:$MKLROOT/lib/intel64/libmkl_sequential.so

eval "$(/home/van/.Programs/miniforge3/bin/conda shell.bash hook)"
conda activate

export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so
export I_MPI_THREAD_YIELD=3
export I_MPI_THREAD_SLEEP=200

export MKL_NUM_THREADS=16
export OMP_NUM_THREADS=16

SANDER="srun -n 16 sander.MPI"

echo $SLURM_ARRAY_TASK_ID
hostname

LINE=$(sed -n "$SLURM_ARRAY_TASK_ID"p listt)
echo "window $LINE"


p="step6.08"
i="step6.09"
pstep="${p}_equilibration"
istep="${i}_equilibration"

cd $LINE

sed "s/${p}/${i}/" ${pstep}.mdin > ${istep}.mdin

$SANDER -O -i ${istep}.mdin -p step3_pbcsetup.parm7 -c ${pstep}.ncrst -o ${istep}.mdout -r ${istep}.ncrst -x ${istep}.nc -inf ${istep}.mdinfo

date
