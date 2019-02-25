########################################
# Pip Install
########################################
apt-get install -y curl \
&& curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
&& python get-pip.py \
&& rm -rf get-pip.py


########################################
# Pip Wheel Install
########################################
#TF 1.8 need mock to build
#TF 1.12 need keras_applications,keras_preprocessing
#ImportError: No module named mock
pip install --upgrade pip \
&& pip install --upgrade setuptools \
&& pip install --upgrade numpy \
&& pip install --upgrade matplotlib \
&& pip install --upgrade futures \
&& pip install --upgrade Pillow \
&& pip install --upgrade cython \
&& pip install --upgrade scikit-image==0.14.0 \
&& pip install --upgrade pyyaml \
&& pip install --upgrade mock \
&& pip install --upgrade keras_applications \
&& pip install --upgrade keras_preprocessing \
&& pip install --upgrade h5py \
&& pip install --upgrade protobuf
#RUN pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
