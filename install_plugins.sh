#!/bin/bash

# Verifica se o arquivo plugins.txt existe
if [ ! -f /usr/share/jenkins/ref/plugins.txt ]; then
    echo "Arquivo plugins.txt não encontrado."
    exit 1
fi

# Diretório onde os plugins serão instalados
PLUGINS_DIR=/usr/share/jenkins/ref/plugins

# Itera sobre cada linha do arquivo plugins.txt
while IFS= read -r plugin; do
    # Extrai o nome do plugin
    plugin_name=$(echo "$plugin" | cut -d ':' -f 1)
    # Extrai a versão do plugin
    plugin_version=$(echo "$plugin" | cut -d ':' -f 2)

    # Verifica se o plugin já está instalado
    if [ -d "$PLUGINS_DIR/$plugin_name" ]; then
        echo "Plugin $plugin_name já está instalado. Pulando a instalação."
    else
        # Baixa o plugin
        echo "Baixando e instalando $plugin_name:$plugin_version ..."
        curl -sSL "https://updates.jenkins.io/download/plugins/$plugin_name/$plugin_version/${plugin_name}.hpi" -o "$PLUGINS_DIR/$plugin_name.jpi"
        # Verifica se o download foi bem-sucedido
        if [ $? -ne 0 ]; then
            echo "Falha ao baixar o plugin $plugin_name:$plugin_version"
            exit 1
        fi
        echo "Plugin $plugin_name:$plugin_version instalado com sucesso."
    fi
done < /usr/share/jenkins/ref/plugins.txt

echo "Todos os plugins foram instalados com sucesso."
