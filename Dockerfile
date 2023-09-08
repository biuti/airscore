# ==================================== BASE ====================================
ARG INSTALL_PYTHON_VERSION=${INSTALL_PYTHON_VERSION:-3.8}
FROM python:${INSTALL_PYTHON_VERSION}-slim-buster AS base

RUN apt update -y && apt upgrade -y
RUN apt install -y \
    curl \
    openssh-server \
    gcc \
    git

# Node JS
ARG INSTALL_NODE_VERSION=${INSTALL_NODE_VERSION:-12}
RUN curl -sL https://deb.nodesource.com/setup_${INSTALL_NODE_VERSION}.x | bash -
RUN apt install -y nodejs

# Library needed for shapely python library
RUN apt install -y libgeos-dev

# cleanup
RUN apt --purge autoremove -y && apt clean -y && apt autoclean -y

WORKDIR /app
COPY requirements requirements

COPY . .

RUN useradd -m sid --shell /bin/bash
RUN chown -R sid:sid /app
USER sid
ENV PATH="/home/sid/.local/bin:${PATH}"
ENV PYTHONPATH="${PYTHONPATH}:/app/airscore/core:/app"

RUN npm install
RUN pip install --upgrade pip

# ================================= PRODUCTION =================================
FROM base AS production
RUN pip install --user -r requirements/prod.txt
EXPOSE 5000
EXPOSE 1220

# run entrypoint script
COPY shell_scripts/entrypoint.sh /etc/docker-entrypoint.d/entrypoint.sh
ENTRYPOINT ["/bin/bash", "/etc/docker-entrypoint.d/entrypoint.sh"]
