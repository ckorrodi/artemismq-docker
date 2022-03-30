FROM centos:7

# Install system requirements
RUN yum install -y epel-release wget htop vim net-tools

# 
# Artemis Installation and Setup
# 

# Install ActiveMQ Requirements
RUN yum install -y which java-11-openjdk libaio-devel

# Wget ActiveMQ Artemis
RUN wget "https://www.apache.org/dyn/closer.cgi?filename=activemq/activemq-artemis/2.11.0/apache-artemis-2.11.0-bin.tar.gz&action=download" -O /opt/artemis-2.11.tar.gz --no-check-certificate

# Extract installation on /opt/
RUN tar -xzf /opt/artemis-2.11.tar.gz -C /opt/

# Create symlink into installation directory and executable symlink
RUN ln -s /opt/apache-artemis-2.11.0/ /opt/apache-artemis
RUN ln -s /opt/apache-artemis/bin/artemis /usr/local/bin/artemis

# Create artemis instance
RUN cd /var/lib/ ; \
    artemis create artemis \
        --user admin \
        --password admin \
        --allow-anonymous \
        --no-hornetq-acceptor \
        --no-mqtt-acceptor \
        --aio

# Change listening interface
RUN sed -i -e's/localhost:/0.0.0.0:/' /var/lib/artemis/etc/bootstrap.xml

# Make all addresses ANYCAST by default
RUN sed -i -e's|<address-setting match="#">|<address-setting match="#">\n            <default-address-routing-type>ANYCAST</default-address-routing-type>|' /var/lib/artemis/etc/broker.xml

#
# Nginx Installation and Configuration
# 

EXPOSE 80 8161 61613 61616

# Start Artemis and sleep infinity to keep container running
CMD /var/lib/artemis/bin/artemis-service start ; \
    sleep infinity
