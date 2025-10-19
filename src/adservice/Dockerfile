# 🏗️ Build stage
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /usr/src/app
COPY . .
RUN chmod +x gradlew
ENV GRADLE_OPTS="-Xmx512m -Dorg.gradle.daemon=false"
RUN ./gradlew clean build -x test -x verifyGoogleJavaFormat

# 🚀 Runtime stage
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /usr/src/app/build/libs/*.jar app.jar
EXPOSE 9555
CMD ["java", "-jar", "app.jar"]
