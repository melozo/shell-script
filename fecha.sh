#!/bin/bash
ls -l /var/lib/psa/dumps/*.xml | tail -n1 | cut -d'_' -f3 | sed -e 's/\.xml//g' > /var/tmp/.fecha
