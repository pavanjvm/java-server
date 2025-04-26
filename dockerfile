# Dockerfile
# Build stage
FROM maven:3.8-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Run stage with Tomcat
FROM tomcat:9.0-jdk11-openjdk-slim
COPY --from=build /app/target/helloworld.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]