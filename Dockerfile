ARG BASEIMAGE=ontresearch/base-workflow-image:v0.2.0
FROM $BASEIMAGE
ARG ENVFILE=environment.yaml

COPY $ENVFILE $HOME/environment.yaml

# RUN bash $CONDA_DIR/etc/profile.d/micromamba.sh
# RUN micromamba activate

RUN \
    . $CONDA_DIR/etc/profile.d/micromamba.sh \
    && micromamba activate \
    && micromamba install -n base --file $HOME/environment.yaml \
# RUN \
    && micromamba clean --all --yes \
    && fix-permissions $CONDA_DIR \
    && fix-permissions $HOME \
    && rm -rf $CONDA_DIR/conda-meta \
    && rm -rf $CONDA_DIR/include \
    && rm -rf $CONDA_DIR/lib/python3.*/site-packages/pip \
    && find $CONDA_DIR -name '__pycache__' -type d -exec rm -rf '{}' '+'

USER $WF_UID
WORKDIR $HOME

# Install JAFFA
ADD subworkflows $HOME/subworkflows
RUN /bin/sh -c $HOME/subworkflows/JAFFAL/install_jaffa.sh


