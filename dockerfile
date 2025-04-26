# === Stage 1: Build the app with Maven ===
FROM maven:3.9.5-eclipse-temurin-17 AS builder

# Set workdir
WORKDIR /app

# Copy pom.xml and download dependencies first (cache layers)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the WAR file
RUN mvn clean package

# === Stage 2: Deploy the WAR to Tomcat ===
FROM tomcat:9.0-jdk17

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR from the builder stage
COPY --from=builder /app/target/simple-webapp.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
