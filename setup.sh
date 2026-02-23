#!/bin/bash

echo "=== Configurando ambiente Haxe/hxpkg ==="

# Atualiza haxelib
haxelib --global update haxelib

# Instala hxpkg
echo "Instalando hxpkg..."
haxelib install hxpkg --always

# Verifica instalação
echo "=== Pacotes instalados ==="
haxelib list

# Instala dependências do projeto
if [ -f "hxpkg.json" ]; then
    echo "=== Instalando dependências do projeto ==="
    haxelib run hxpkg install
else
    echo "Arquivo hxpkg.json não encontrado"
fi

echo "=== Setup concluído ==="