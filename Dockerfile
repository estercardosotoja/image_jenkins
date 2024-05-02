# Use uma base de imagem Ubuntu
FROM ubuntu:latest

# Instale o Jenkins e as dependências
RUN apt-get update && \
    apt-get install -y wget gnupg2 && \
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add - && \
    sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && \
    apt-get update && \
    apt-get install -y openjdk-11-jdk jenkins

# Defina o diretório de trabalho
WORKDIR /usr/share/jenkins/ref/plugins

# Baixe e instale os plugins desejados
RUN wget -O git.hpi https://updates.jenkins.io/download/plugins/git/latest/git.hpi && \
    wget -O docker-plugin.hpi https://updates.jenkins.io/download/plugins/docker-plugin/latest/docker-plugin.hpi

# Copie o script para configurar o usuário do administrador
COPY set_admin_user.groovy /usr/share/jenkins/ref/init.groovy.d/set_admin_user.groovy

# Exponha a porta 8080 para acessar o Jenkins
EXPOSE 8080

# Comando para iniciar o Jenkins quando o contêiner for executado
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]