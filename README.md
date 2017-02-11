#TP Polytech Tours DI-4


## TP 4

### Docker-Compose + Traefik = HA

Prérequis : TP 3

#### Opérations :

1. git clone https://github.com/hlepesant/tppolytech.git
1. cd tppolytech
1. git checkout TP4
1. ./run.sh
1. docker-compose ps
1. Open : [tp4.polytech.fr](http://tp4.polytech.fr:8080/){:target="_blank"}  

1. Open : [Console Traefik](http://tp4.polytech.fr:8090/){:target="_blank"}
1. docker-compose scale web=2
1. docker-compose scale web=4
1. docker-compose scale web=1
1. docker-compose stop
1. docker-compose rm -f
