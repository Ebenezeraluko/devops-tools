# Stage 1: Maven build stage
FROM maven:3.9.9-eclipse-temurin-21-alpine AS builder

# Set working directory
WORKDIR /build

# Copy only pom.xml first to leverage Docker cache for dependencies
COPY pom.xml .

# Download dependencies only (this layer will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline

# Copy source files
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Final WildFly stage with minimal dependencies
FROM quay.io/wildfly/wildfly:latest

# Define ARGs for build-time variables
ARG JNDI_NAME
ARG POOL_NAME
ARG CONNECTION_URL
ARG DRIVER_CLASS
ARG DRIVER
ARG DB_USER
ARG DB_PASSWORD

# Print build-time variables
RUN echo "Build-time variables:" && \
    echo "JNDI_NAME: $JNDI_NAME" && \
    echo "POOL_NAME: $POOL_NAME" && \
    echo "CONNECTION_URL: $CONNECTION_URL" && \
    echo "DRIVER_CLASS: $DRIVER_CLASS" && \
    echo "DRIVER: $DRIVER" && \
    echo "DB_USER: $DB_USER" && \
    echo "DB_PASSWORD: $DB_PASSWORD"

# Create directory for the application (using single RUN to reduce layers)
RUN mkdir -p /opt/jboss/wildfly/standalone/deployments/stavigoportal

# Copy only necessary files from builder stage
COPY --from=builder /build/target/stavigoportal.war /opt/jboss/wildfly/standalone/deployments/stavigoportal.war
COPY ds-maker.sh .
COPY src/main/resources/log4j2.xml /opt/jboss/wildfly/standalone/configuration/log4j2.xml

# Execute configuration in a single layer
RUN /bin/sh ./ds-maker.sh /opt/jboss/wildfly/standalone/configuration/ && \
    cat /opt/jboss/wildfly/standalone/configuration/wildfly-ds.xml && \
    rm -f ds-maker.sh

# Expose the default WildFly port
EXPOSE 8080

# Set the default command to run WildFly
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
