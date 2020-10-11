# 베이스 이미지 + 이미지 별칭
FROM adoptopenjdk:8-jdk-hotspot AS builder

#ENV http_proxy 'http://172.17.0.1:3128'
#ENV https_proxy 'http://172.17.0.1:3128'
#ENV ftp_proxy 'http://172.17.0.1:3128'

# gradlew 복사
COPY gradlew .
# gradle 복사
COPY gradle gradle
# build.gradle 복사
COPY build.gradle .
# settings.gradle 복사
COPY settings.gradle .
# 웹 어플리케이션 소스 복사
COPY src src
# gradlew 실행권한 부여
RUN chmod +x ./gradlew
# gradlew를 사용하여 실행 가능한 jar 파일 생성
RUN ./gradlew bootJar

# 베이스 이미지
FROM adoptopenjdk:8-jdk-hotspot

#ENV http_proxy 'http://172.17.0.1:3128'
#ENV https_proxy 'http://172.17.0.1:3128'
#ENV ftp_proxy 'http://172.17.0.1:3128'

# builder 이미지에서 build/libs/*.jar 파일을 app.jar로 복사
COPY --from=builder build/libs/*.jar app.jar

# 컨테이너 Port 노출
EXPOSE 8900
# jar 파일 실행
ENTRYPOINT ["java","-jar","/app.jar"]