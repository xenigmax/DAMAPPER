#!/bin/bash
# written by Jongkyu Kim (j.kim@fu-berlin)
# Based on https://github.com/gt1/lastools
# Usage : run.sh [ref_dam] [ref_fasta] [read_fasta] [out_dir]

############## Configuration ################################
# from DAMAPPER
BIN_DAMAPPER=/ABSOLUTE_PATH/damapper
BIN_HPC_DAMAPPER=/ABSOLUTE_PATH/HPC.damapper

# from DALIGNER
DIR_DALIGNER=/ABOSOLUTE_PATH_TO_DALIGNER/DALIGNER/

# from DAZZ_DB
BIN_DBSPLIT=/ABSOLUTE_PATH/DBsplit
BIN_FASTA2DAM=/ABSOLUTE_PATH/fasta2DAM

# from LASTOOLS
BIN_LASCHAINSORT=/ABOSOLUTE_PATH/laschainsort
BIN_LAS2BAM=/ABSOLUTE_PATH/lastobam
###############################################################

IN_REF_DAM=$1
IN_REF_FASTA=$2
IN_READ_FASTA=$3
OUT_DIR=$4

# 1. Fasta to DAM
IN_BASENAME=$(basename "${IN_READ_FASTA%.*}")
REF_BASENAME=$(basename "${IN_REF_DAM%.*}")
IN_READ_DAM="${OUT_DIR}/${IN_BASENAME}.dam"
CMD="${BIN_FASTA2DAM} ${IN_READ_DAM} ${IN_READ_FASTA}"
echo $CMD
eval $CMD

# 2. DBsplit for DAM
CMD="${BIN_DBSPLIT} -s250 -x0 -f ${IN_READ_DAM}"
echo $CMD
eval $CMD

# 3. Damapper run
mkdir $OUT_DIR 
#CMD="${BIN_HPC_DAMAPPER} -v -C -N -T16 -o${OUT_DIR} -l${DIR_DALIGNER} ${IN_REF_DAM} ${IN_READ_DAM}"
CMD=$(${BIN_HPC_DAMAPPER} -v -C -N -T16 ${IN_REF_DAM} ${IN_READ_DAM} |grep ^damapper | sed "s#^damapper#${BIN_DAMAPPER} -o${OUT_DIR} -l${DIR_DALIGNER}#g")
echo "$CMD"
eval "$CMD"

# 4. Laschainsort
SORTED_LAS="${OUT_DIR}/sorted.${REF_BASENAME}.${IN_BASENAME}.las"
CMD="${BIN_LASCHAINSORT} -sba ${SORTED_LAS} "
for f in $(ls -al ${OUT_DIR}/${REF_BASENAME}.${IN_BASENAME}.*.las | tr -s ' ' |  cut -d ' ' -f9); do
    CMD="${CMD} ${f}"
done
echo $CMD
eval $CMD

# 5. Las2Bam
OUT_BAM="${OUT_DIR}/${REF_BASENAME}.${IN_BASENAME}.bam"
CMD="${BIN_LAS2BAM} -snone ${IN_REF_DAM} ${IN_REF_FASTA} ${IN_READ_DAM} ${IN_READ_FASTA} ${SORTED_LAS} > ${OUT_BAM}"
echo $CMD
eval $CMD
