FROM eclipse-temurin:17-jdk-jammy as build
WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn -q -e -DskipTests=false clean package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

COPY --from=build /app/target/devops-demo-app-1.0.0.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
