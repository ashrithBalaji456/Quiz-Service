# ---------- Build Stage ----------
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom first to leverage Docker layer caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

# ---------- Runtime Stage ----------
FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

# Render injects PORT automatically
ENTRYPOINT ["java", "-jar", "app.jar"]
