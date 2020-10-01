FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

RUN apt-get update && apt-get --yes --no-install-recommends install --allow-unauthenticated \
    supervisor \
	build-essential \
	locales \
	procps \
    psmisc \
	&& \
	rm -rf /var/cache/apt/* && \
	rm -rf /var/lib/apt/lists/*

# Set locale (and generate)
RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

# Upgrade pip and install core packages
RUN pip3 install --no-cache-dir --disable-pip-version-check setuptools wheel

# because of python package 'click':
# http://click.pocoo.org/5/python3/
# http://jaredmarkell.com/docker-and-locales/
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# create a new user and group (to not run docker as a root user)
ENV USER app
ENV USER_HOME /home/$USER
RUN groupadd -g 999 $USER && useradd -r -u 999 -g $USER $USER

RUN mkdir -p $USER_HOME && chown $USER:$USER -R $USER_HOME
WORKDIR $USER_HOME

# Install requirements
COPY requirements.txt $USER_HOME/
RUN pip install -r requirements.txt

# Custom Supervisord config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy start.sh script that will check for a /godrej/prestart.sh script and run it before starting other stuff
COPY start.sh /start.sh
RUN chmod +x /start.sh

# docker at Jenkins server does not supports chown, version lower than v17.09.0-ce
USER $USER
COPY --chown=999 . $USER_HOME


# Start gunicorn
CMD ["/start.sh"]
