FROM openjdk:11-jre
# 将本地目录中的 JAR 文件添加到 Docker 镜像中。
# 具体来说，将 demo-java-app-2.1.2.jar 复制到镜像中，并重命名为complete-project.jar
COPY target/demo-java-app-2.1.2.jar complete-project.jar

ENTRYPOINT ["java", "-jar", "complete-project.jar"]