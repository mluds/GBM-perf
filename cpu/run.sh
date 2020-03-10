set -e

export R_CMD="taskset -c 0-15 R --slave"

cd ~/GBM-perf/cpu/run && \
  ln -sf ~/test.csv test.csv && \
  ln -sf ~/train-0.1m.csv train.csv && \
  echo "0.1m:" && \
    echo -n "xgboost " && ${R_CMD} < 2-xgboost.R && \
    echo -n "lightgbm " && ${R_CMD} < 3-lightgbm.R && \
    echo -n "catboost " && ${R_CMD} < 4-catboost.R && \
  ln -sf /train-1m.csv train.csv && \
  echo "1m:" && \
    echo -n "xgboost " && ${R_CMD} < 2-xgboost.R && \
    echo -n "lightgbm " && ${R_CMD} < 3-lightgbm.R && \
    echo -n "catboost " && ${R_CMD} < 4-catboost.R && \
  ln -sf /train-10m.csv train.csv && \
  echo "10m:" && \
    echo -n "xgboost " && ${R_CMD} < 2-xgboost.R && \
    echo -n "lightgbm " && ${R_CMD} < 3-lightgbm.R && \
    echo -n "catboost " && ${R_CMD} < 4-catboost.R
