# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Setup user and create basic folders.
RUN mkdir /opt/{jira,java}; \
   useradd -u 1001 --shell /bin/bash jira

# Download Jira server.
ADD https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.8.0.tar.gz .

# Copy jdk.
COPY java8.tar.gz ./java8.tar.gz
COPY mysql-connector-java-5.1.45-bin.jar .

# Unpack java and Jira.
RUN tar -xf java8.tar.gz -C /opt/java --strip-components=1; \
    tar -xf atlassian-jira-software-7.8.0.tar.gz -C /opt/jira --strip-components=1; \
    sed -i 's/jira\.home =/jira\.home = \/jira/' /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties; \
    mv mysql-connector-java-5.1.45-bin.jar /opt/jira/lib/; \
    chown -R jira:jira /opt/*
# Run Jira under unpriviledged user.
USER jira

# Setups env
ENV JAVA_HOME "/opt/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"

# Setup persistent storage
VOLUME ["/jira"]

CMD /opt/jira/bin/start-jira.sh -fg
