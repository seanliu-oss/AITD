FROM python:3.10.6-slim-bullseye

ENV USER=user \
    UID=1000 \
    HOME=/home/user
RUN adduser \
        --disabled-password \
        --gecos "Default user" \
        --uid ${UID} \
        --home ${HOME} \
        --force-badname \
        ${USER}

COPY requirements.txt end_to_end.py ${HOME}/

RUN mkdir ${HOME}/logs \
    && apt-get update -y && apt-get install -y \
    && apt-get install openjdk-17-jdk -y \
    && pip3 install -r ${HOME}/requirements.txt \
    && rm -rf /usr/local/src/*

ENV PYTHONPATH=${HOME}

WORKDIR ${HOME}
USER ${NB_USER}

# see src/backend/setup.txt to download the models
# run in powershell:
# docker run -it -v ${PWD}/models:/home/user/models <imagename> bash
#COPY models ./models
COPY data ./data
COPY src ./src
