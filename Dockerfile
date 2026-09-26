# Stage 1: Build Java WAR package using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Production Tomcat Container for SpanV Studios
FROM tomcat:9.0-jdk17-temurin

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR file from builder stage to Tomcat ROOT.war
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose HTTP Port
EXPOSE 8080

# Run Tomcat Catalina Server
CMD ["catalina.sh", "run"]
