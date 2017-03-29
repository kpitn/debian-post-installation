#!/bin/bash
# Post installation script debian 8
#
# Kpitn - 03/2017
# GPL
#
# Syntaxe: # su - -c "./debian-post-install.sh"
# Syntaxe: or # sudo ./debian-post-install.sh
VERSION="0.1"

#=============================================================================
# Application list to install
LISTE="fail2ban vim curl ntp htop unzip"
#=============================================================================

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo -e "\nScript must be launch in sudo: # sudo $0" 1>&2
  exit 1
fi

# Update packages
#-----------------------------------

# Update
echo -e "\n### Update Packages\n"
apt update

# Upgrade
echo -e "\n### Update system\n"
apt -y upgrade

# Installation
echo -e "\n### Installation: $LISTE\n"
apt -y install $LISTE

# Configuration
#--------------

echo -e "\n### Configure VIM \n"
cd /tmp
wget https://raw.githubusercontent.com/kpitn/debian-post-installation/master/conf/vimrc
cp vimrc /etc/vim/

if ! grep -Fxq "[magento]" /etc/fail2ban/jail.conf
then
    wget https://raw.githubusercontent.com/kpitn/debian-post-installation/master/fail2ban/jail.conf
    wget https://raw.githubusercontent.com/kpitn/debian-post-installation/master/fail2ban/magento.conf
    cat jail.conf >> /etc/fail2ban/jail.conf
    mv magento.conf /etc/fail2ban/filter.d/magento.conf
fi

echo -e -n "\n### Entrez l'adresse mail pour les rapports de securite: "
read MAIL

# fail2ban
sed -i 's/destemail = root@localhost/destemail = '$MAIL'/g' /etc/fail2ban/jail.conf

# Fin du script