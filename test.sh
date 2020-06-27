#!/bin/sh

rake build;
gem install pkg/*.gem ;
cd ../../Writing/pms-series
# basename `git rev-parse --show-toplevel`
basename -s .git `git config --get remote.origin.url`
verkilo wordcount --delta #--offset=-08:00
cd ../../Verkilo/verkilo-gem
