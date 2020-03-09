apt update
apt install -y r-base libcurl4-openssl-dev git wget libxml2-dev cmake
Rscript -e "install.packages(c('littler', 'docopt'))"
ln -s /usr/local/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r
ln -s /usr/local/lib/R/site-library/littler/bin/r /usr/local/bin/r

cd
wget https://s3.amazonaws.com/benchm-ml--main/train-0.1m.csv
wget https://s3.amazonaws.com/benchm-ml--main/train-1m.csv
wget https://s3.amazonaws.com/benchm-ml--main/train-10m.csv
wget https://s3.amazonaws.com/benchm-ml--main/test.csv

R -e "install.packages('roxygen2', dependencies=TRUE, INSTALL_opts = c('--no-lock'))"
R -e "install.packages('rversions', dependencies=TRUE, INSTALL_opts = c('--no-lock'))"
install2.r ROCR data.table magrittr stringi devtools RCurl jsonlite
install2.r -r http://h2o-release.s3.amazonaws.com/h2o/latest_stable_R h2o

git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && git submodule init && git submodule update && \
    cd R-package && R CMD INSTALL .

R -e 'devtools::install_github("Laurae2/lgbdl"); lgbdl::lgb.dl()'
R -e 'devtools::install_github("catboost/catboost", subdir = "catboost/R-package")'

cd; git clone https://github.com/szilard/GBM-perf.git

export R_CMD="taskset -c 0-15 R --slave"

cd GBM-perf/cpu/run && \
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
