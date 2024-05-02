# Use a imagem base do Nginx
FROM nginx:latest

# Remova o arquivo de configuração padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copie o arquivo de configuração do Nginx personalizado
COPY nginx.conf /etc/nginx/nginx.conf