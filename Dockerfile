FROM openjdk:8-alpine

RUN apk update \
   && apk add --no-cache tzdata \
   && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
   && apk del tzdata \
   && rm -rf /var/lib/apt/lists/* \
   && rm /var/cache/apk/*

COPY broker.properties /opt/broker.properties
COPY Entrypoint.sh /Entrypoint.sh

EXPOSE 9876 10909 10911 10912

ENV ROCKETMQ_VERSION 4.5.2

RUN wget https://archive.apache.org/dist/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip -O /opt/rocketmq.zip \
   && unzip /opt/rocketmq.zip -d /opt \
   && mv /opt/rocketmq-all-${ROCKETMQ_VERSION}-bin-release /opt/rocketmq \
   && rm -f /opt/rocketmq.zip \
   && chmod +x Entrypoint.sh

ENTRYPOINT ["/Entrypoint.sh"]
CMD ["mqnamesrv"]
