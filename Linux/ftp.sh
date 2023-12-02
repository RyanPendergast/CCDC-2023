#!/bin/zsh

# Verifica si el usuario es root
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ser ejecutado como root" 
   exit 1
fi

# Instala vsftpd si no está instalado
if ! dpkg -s vsftpd >/dev/null 2>&1; then
    apt-get update
    apt-get install -y vsftpd
fi

# Habilite la escritura local
sed -i 's/write_enable=NO/write_enable=YES/' /etc/vsftpd.conf

# Reinicia el servicio vsftpd
service vsftpd restart

echo "Servidor FTP configurado exitosamente."
