#!/bin/bash

set -eou pipefail

mkdir -p swda_results

for MODEL in longformer xlnet; do
  for LABEL in segmentation basic; do
    for CASE in lower nolower; do
      for RECONSTRUCTION in default begin_based; do
        CASE_OPT=
        if [[ $CASE == lower ]]; then CASE_OPT="-p"; fi
        RECONSTRUCTION_OPT=
        if [[ $RECONSTRUCTION == begin_based ]]; then RECONSTRUCTION_OPT='--begin-determines-act'; fi
        WINDOW=4096
        if [[ $MODEL -eq xlnet ]]; then WINDOW=512; fi

        RESULTS_NAME=swda_results/${LABEL}_${MODEL}_${CASE}_${RECONSTRUCTION}

        dasg evaluate \
          --dataset-path deps/swda/swda \
          --batch_size 1 \
          --window_len $WINDOW \
          --device cpu \
          --tagset ${LABEL} \
          -o ${RESULTS_NAME}.pkl \
          ${CASE_OPT} \
          ${RECONSTRUCTION_OPT} \
          /export/c12/pzelasko/daseg/daseg/swda_${LABEL}_${MODEL}_${CASE}/${MODEL} \
          &> ${RESULTS_NAME}.txt &
      done
    done
  done
done