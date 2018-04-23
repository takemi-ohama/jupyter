from jupyter/scipy-notebook

MAINTAINER "takemi.ohama" <takemi.ohama@gmail.com>

USER root

RUN apt-get update && apt-get install -yq --no-install-recommends \
    wget curl ssh libreadline-dev vim \
    lsb-release \ 
    libxrender1 \
    mysql-client \
    libav-tools 

RUN apt-get clean

RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -yq google-cloud-sdk 
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    echo "export TERM=xterm" >> /etc/profile && \
    echo "jovyan ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jovyan


# Install Python 3 packages
RUN conda install --quiet --yes \
    'conda-build' \
    'readline' \
    'mysql-connector-python' \
    'pymysql' \
    'gensim' \ 
    'pivottablejs' \
    'jupyterlab' \ 
    && conda clean -tipsy

USER $NB_USER

RUN /opt/conda/bin/pip install --upgrade pip oauthenticator


RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
