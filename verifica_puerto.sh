#!/bin/bash
# Verifica puerto y alerta con mail si esta abierto
dominio=.ejemplo.com
for i in web  web100 smtp01 smtp02 smtp03 smtp04 server2 bd5 bd7; 
	do
		timeout 2 nc -z $i$dominio 22 && echo " " | mail -s "ALERTA PUERTO SSH abierto $i$dominio"  email@ejemplo.com
done
