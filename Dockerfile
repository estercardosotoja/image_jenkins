# Use uma base de imagem Ubuntu
FROM debian:stable

# Instale o Jenkins e as dependências
RUN apt-get update && \
    apt-get install -y wget gnupg2 && \
    rm -rf /var/lib/apt/lists/*

# Adicione a chave GPG do repositório Jenkins diretamente ao keyring do sistema
RUN wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | gpg --dearmor > /usr/share/keyrings/jenkins-archive-keyring.gpg

# Adicione o repositório Jenkins ao sources.list
RUN echo "deb [signed-by=/usr/share/keyrings/jenkins-archive-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list

# Atualize e instale o Java e o Jenkins
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk jenkins && \
    rm -rf /var/lib/apt/lists/*
    
# Defina o diretório de trabalho
WORKDIR /usr/share/jenkins/ref/plugins

# Baixe e instale os plugins do arquivo de lista de plugins para o diretório de trabalho
COPY plugins.txt /usr/share/jenkins/ref/plugins/plugins.txt

# Instale os plugins usando o script de instalação de plugins do Jenkins
RUN install-plugins.sh < /usr/share/jenkins/plugins/plugins.txt

# Copie o script para configurar o usuário do administrador
COPY set_admin_user.groovy /usr/share/jenkins/ref/init.groovy.d/set_admin_user.groovy

# Exponha a porta 8080 para acessar o Jenkins
EXPOSE 8080

# Comando para iniciar o Jenkins quando o contêiner for executado
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]