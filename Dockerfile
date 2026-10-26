# ---- Build stage: 从源码编译出 jar ----
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -q -B dependency:go-offline
COPY src ./src
RUN mvn -q -B package -DskipTests

# ---- Runtime stage: 只打包运行所需的 JRE 和 jar ----
FROM eclipse-temurin:17-jre

# 维护者信息
LABEL maintainer="youlai <youlaitech@163.com>"

# 设置时区（Debian直接使用环境变量）
ENV TZ=Asia/Shanghai

# 在运行时自动挂载 /tmp 目录为匿名卷
VOLUME /tmp

# 添加应用
COPY --from=build /build/target/youlai-boot.jar app.jar

# 启动命令
CMD java \
    -Xms512m -Xmx512m \
    -Djava.security.egd=file:/dev/./urandom \
    -jar /app.jar

# 暴露端口
EXPOSE 8000
