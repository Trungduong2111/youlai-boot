# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests -B && ls -la target/

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-jammy
LABEL maintainer="youlai <youlaitech@163.com>"
ENV TZ=Asia/Shanghai
VOLUME /tmp
COPY --from=builder /app/target/youlai-boot-4.1.0.jar app.jar
EXPOSE 8000
CMD java \
    -Xms512m -Xmx512m \
    -Djava.security.egd=file:/dev/./urandom \
    -Dserver.port=${PORT:-8000} \
    -jar /app.jar
