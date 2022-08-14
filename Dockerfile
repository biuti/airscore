# ==================================== BASE ====================================
ARG INSTALL_PYTHON_VERSION=${INSTALL_PYTHON_VERSION:-3.8}
FROM python:${INSTALL_PYTHON_VERSION}-slim-buster AS base

RUN apt-get update
RUN apt-get install -y \
    curl \
    openssh-server \
    gcc \
    git

RUN service ssh start

ARG INSTALL_NODE_VERSION=${INSTALL_NODE_VERSION:-12}
RUN curl -sL https://deb.nodesource.com/setup_${INSTALL_NODE_VERSION}.x | bash -
RUN apt-get install -y \
    nodejs \
    && apt-get -y autoclean

RUN sed -i '/motd/d' /etc/pam.d/sshd

# Library needed for shapely python library
RUN apt-get install -y libgeos-dev

WORKDIR /app
COPY requirements requirements

COPY . .

RUN useradd -m sid --shell /bin/bash
RUN chown -R sid:sid /app
USER sid
ENV PATH="/home/sid/.local/bin:${PATH}"
ENV PYTHONPATH="${PYTHONPATH}:/app/airscore/core:/app"
RUN mkdir /home/sid/.ssh

RUN npm install

RUN pip install --upgrade pip

# ================================= PRODUCTION =================================
FROM base AS production
RUN pip install --user -r requirements/prod.txt
#COPY supervisord.conf /etc/supervisor/supervisord.conf
#COPY supervisord_programs /etc/supervisor/conf.d
EXPOSE 5000
EXPOSE 1220
ENTRYPOINT ["/bin/bash", "shell_scripts/supervisord_entrypoint.sh"]
#CMD ["-c", "/etc/supervisor/supervisord.conf"]
