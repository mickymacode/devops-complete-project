FROM openjdk:11-jre
# 将本地目录中的 JAR 文件添加到 Docker 镜像中。
# 具体来说，将 demo-java-app-2.1.2.jar 复制到镜像中，并重命名为 complete-project.jar
COPY jarstaging/com/example/demo-java-app/2.1.2/demo-java-app-2.1.2.jar complete.jar

ENTRYPOINT ["java", "-jar", "complete.jar"]