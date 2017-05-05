#!/bin/bash
nvidia-docker run --rm -it -p 8888:8888 -v $PWD:/notebooks theano_gpu jupyter notebook --no-browser --ip="0.0.0.0" --notebook-dir="/notebooks" --allow-root
