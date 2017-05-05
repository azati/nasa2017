FROM tschaffter/theano-gpu
RUN pip install jupyter
RUN pip install --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip
RUN mkdir /notebooks
RUN pip install sklearn matplotlib
RUN pip install --upgrade numpy scipy
RUN pip install Pillow
RUN pip install tqdm
RUN echo -e "[global]\ndevice=gpu\nfloatX=float32\noptimizer_including=cudnn\n[lib]\ncnmem=0.8\n[nvcc]\nfastmath=True" > /root/.theanorc
RUN pip install scikit-image
RUN pip install keras
RUN pip install xgboost
RUN pip install geopandas
RUN pip install pandas
RUN yum install -y geos-devel

