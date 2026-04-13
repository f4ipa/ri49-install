#!/bin/bash

# Installation de Svxlink et configuration pour le réseau RI49 / FMP
# La configuration est prévu pour un fonctionnement CM108 (R1, SHARI)
# Script réalisé par Guillaume F4IPA


echo "Téléchargement et installation de svxlink..."
sudo apt update
sudo apt install svxlink-server -y


echo "Installation des voix française..."
sudo cp -r fr_FR /usr/share/svxlink/sounds
sudo mkdir -p /usr/share/svxlink/sounds/fr_FR/Custom


echo "Configuration des permissions udev de la carte son CM108"
sudo cp 99-svxlink.rules /etc/udev/rules.d
sudo udevadm control --reload-rules
sudo udevadm trigger


echo "Configuration des niveaux audio..."
CARD_NAME=$(cat /proc/asound/cards |grep "USB-Audio" |awk -F'[' '{print $2}' |awk -F']' '{print $1}' | xargs)
sudo amixer -c "$CARD_NAME" sset 'PCM' 60%
sudo amixer -c "$CARD_NAME" sset 'Auto Gain Control' off
sudo amixer -c "$CARD_NAME" sset 'Mic' 0%
sudo alsactl store


echo "Configuration de svxlink..."
read -p "Entrez votre indicatif : " INDICATIF
INDICATIF=${INDICATIF^^}
sed -i "s/F7ABC/$INDICATIF/g" svxlink.conf
sed -i "s/hw:0/hw:$CARD_NAME/g" svxlink.conf
sudo sed -i "s/#send_short_ident/send_short_ident/" /usr/share/svxlink/events.d/Logic.tcl

read -p "Activer l'APRS (vous devez avoir le locator) ? (o/n) : " APRS
if [[ "$APRS" == "o" || "$APRS" == "O" ]]; then
    bash ./aprs.sh
fi

sudo cp svxlink.conf /etc/svxlink

echo "Redémarrage de svxlink..."
sudo systemctl enable svxlink
sudo systemctl restart svxlink
