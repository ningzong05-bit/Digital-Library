FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app
COPY . .
RUN mvn -pl zsc-admin -am -DskipTests package

FROM eclipse-temurin:17-jre

WORKDIR /app
COPY --from=build /app/zsc-admin/target/zsc-admin.jar app.jar
COPY docker-entrypoint.sh /app/docker-entrypoint.sh

ENV JAVA_OPTS=""
EXPOSE 8081

ENTRYPOINT ["sh", "/app/docker-entrypoint.sh"]
