# Configuration svxlink pour le RI49 / FMP

Ce script permet d'installer et de configurer svxlink pour le RI49 France Multiprotocole.

La configuration est prévu pour fonctionner avec les interfaces équipé d'une carte son CM108 comme par exemple : la R1 ou le hotspot SHARI.


## Prérequis

- un raspberry Pi (1/2/3/4/5)
- une interface équipé d'une carte son CM108
- une carte sd de 8 Go minimum
- debian 13 (trixie) fraichement installé et à jour


## Installation

```Bash
sudo apt update && sudo apt install git -y
git clone https://github.com/f4ipa/ri49-install.git
cd ri49-install
./install.sh
```

## APRS

Svxlink vous donne la possibilité de faire apparaitre votre équipement sur la carte aprs.fi.
Pour cela vous devez au préalable connaitre la position exacte au format DMM.

