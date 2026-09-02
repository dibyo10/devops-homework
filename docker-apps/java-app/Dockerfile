FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /src
COPY App.java .
RUN javac --add-modules jdk.httpserver App.java

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=build /src/App.class .

EXPOSE 8080
USER 1000
CMD ["java", "--add-modules", "jdk.httpserver", "App"]

