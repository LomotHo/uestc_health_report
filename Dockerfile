FROM python:3.6-slim

# config app
ENV APP_HOME="/app" \
  APP_PATH="/app/server"

# install packages & config docker
RUN apt-get update && \
  apt-get -y install wget firefox-esr && \
  apt-get -y autoremove && \
  apt-get clean

RUN pip install selenium

RUN mkdir -p $APP_PATH && \
  wget -nv https://github.com/mozilla/geckodriver/releases/download/v0.29.1/geckodriver-v0.29.1-linux64.tar.gz -O /tmp/geckodriver.tgz && \
  tar -zxf /tmp/geckodriver.tgz -C $APP_PATH && \
  rm /tmp/geckodriver.tgz

### configure apt/pip source, timezone
# RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
# RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY ./ $APP_PATH

RUN cd $APP_PATH && pip install -r requirements.txt

WORKDIR ${APP_PATH}

# RUN main.py
CMD ["/usr/local/bin/python", "/app/server/main.py"]
