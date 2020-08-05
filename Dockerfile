FROM  confluentinc/cp-enterprise-kafka:5.3.1

# Jolokia envs
ENV VERSION 1.6.2
ENV JAR jolokia-jvm-$VERSION-agent.jar
ENV MAVEN_REPOSITORY https://repo1.maven.org/maven2

# Add Jolokia for exposing JMX metrics
RUN mkdir -p /opt/jolokia/
RUN curl -L $MAVEN_REPOSITORY/org/jolokia/jolokia-jvm/$VERSION/$JAR -o /opt/jolokia/$JAR

# Set up a user to run Kafka
RUN groupadd kafka && \
  useradd -d /kafka -g kafka -s /bin/false kafka && \
  mkdir -p /opt/kafka && \
  chown -R kafka:kafka /usr/bin/ /var/log/kafka /var/log/confluent /var/lib/kafka /opt/kafka /opt/jolokia

USER kafka
ENV PATH /usr/bin:$PATH
RUN mkdir -p /opt/kafka/data

WORKDIR /usr/bin