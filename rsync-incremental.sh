#!/bin/bash
# backups diarios rsync, vhosts, mailnames y mysqldump

destino=/var/lib/psa/dumps/BackupRsync
destinoCorreo=/var/lib/psa/dumps/BackupRsync/Correo/
vhosts=/var/www/vhosts/
mailnames=/var/qmail/mailnames/

if [ ! -d $destino ];
        then
                echo -n "Directorios destinos no existen"
                echo -n "Creando"
                mkdir -p $destino/Correo && echo -n "[OK]"
fi

if [ -f /var/log/rsyncbackup.log ];
        then
                gzip -9 /var/log/rsyncbackup.log
                mv /var/log/rsyncbackup.log.gz /var/log/rsyncbackup.log.`date "+%m%d%y"`.gz
                touch /var/log/rsyncbackup.log
fi

if [ ! -f /usr/bin/rsync ];
        then
                echo -n "Rsync en $HOSTNAME no instalado"
                echo -n "Instalando Rsync"
                yum -y install rsync && echo -n "[OK]"
fi

echo -n "Iniciando Rsync sobre VHOSTS"
rsync --log-file=/var/log/rsyncbackup.log -avz --no-links --exclude='bin' --exclude='logs' --exclude='statistics' --exclude='private' --exclude='usr' --exclude='error_docs' $vhosts $destino
echo -n "Iniciando Rsync sobre MAILNAMES"
rsync --log-file=/var/log/rsyncbackup.log -avz $mailnames $destinoCorreo


# TO DO
# Proxima version .sql si contador > 2 borrar el ultimo con time 

mysqldump -uadmin -p$(cat /etc/psa/.psa.shadow) --all-databases > $destino/mysqldump-`date "+%m%d%y"`.sql
