# -------- Stage 1: Build --------
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy only pom.xml first and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Now copy rest of the code and package
COPY . .
RUN mvn clean package -DskipTests

# -------- Stage 2: Runtime --------
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy built JAR from builder stage
COPY --from=builder /app/target/springboot-postgres-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]