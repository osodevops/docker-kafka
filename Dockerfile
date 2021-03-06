FROM  confluentinc/cp-enterprise-kafka:5.3.1

# Jolokia envs
ENV VERSION 1.6.2
ENV JAR jolokia-jvm-$VERSION-agent.jar
ENV MAVEN_REPOSITORY https://repo1.maven.org/maven2

# Log4j envs
ENV CONFLUENT_PLATFORM_VERSION 5.3.1
ENV LOG4J_EXTENSIONS_JAR confluent-log4j-extensions-$CONFLUENT_PLATFORM_VERSION.jar
ENV LOGGING_COMMONS_JAR common-logging-$CONFLUENT_PLATFORM_VERSION.jar
ENV CONFLUENT_MAVEN_REPO https://packages.confluent.io/maven

# Add Confluent log4j extensions - used to push JSON formatted logs to Elastic
RUN curl -L $CONFLUENT_MAVEN_REPO/io/confluent/confluent-log4j-extensions/$CONFLUENT_PLATFORM_VERSION/$LOG4J_EXTENSIONS_JAR -o /usr/share/java/kafka/$LOG4J_EXTENSIONS_JAR
RUN curl -L $CONFLUENT_MAVEN_REPO/io/confluent/common-logging/$CONFLUENT_PLATFORM_VERSION/$LOGGING_COMMONS_JAR -o /usr/share/java/kafka/$LOGGING_COMMONS_JAR

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