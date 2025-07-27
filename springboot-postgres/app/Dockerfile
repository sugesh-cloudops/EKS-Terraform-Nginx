FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Ensure mvnw is Unix-formatted and executable
RUN apt-get update && apt-get install -y dos2unix && \
    dos2unix mvnw && chmod +x mvnw && ./mvnw dependency:go-offline

COPY src ./src

# Do not override entrypoint unless needed
CMD ["./mvnw", "spring-boot:run"]