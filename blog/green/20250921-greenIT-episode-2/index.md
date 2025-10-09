 spo---
slug: green-consommation-energie
title: "Le Green IT, épisode 2 : Pas coule !"
authors: [eperu]
date: 2025-09-21
tags: 
  - "green"
  - "tech"
---

IMAGE datacenter

On aimerait tous que ce ne soit qu'une goutte d'eau dans l'océan, malheureusement la réalité se compte en centaines de milliards
de litres. Je veux biensur parler ici de la consommation d'eau des datacenters, ceux qui calculent pour vous des itinéraires, vous permettent de chiller
devant la dernière série et qui héberge aussi cette page web...
ans le premier épisode de cette série, nous avons exploré l'impact environnemental de l'extraction des matières premières nécessaires à nos appareils personnels, mais aussi aux serveurs de nos datacenters....
Poursuivons notre thématique de l'impact du numérique en nous penchant sur un autre aspect crucial : la consommation d'eau. En termes d'impact
on pense souvent aux gazs produits, mais nous allons nous attarder sur la consommation d'eau.

<!-- truncate -->

## Introduction

C'est bien connu l'eau c'est la vie, elle est majoritaire à la surface de notre "planète bleue", dans nos contrées occidentales nous y avons accès aussi facilement
qu'en tournant un robinet et pourtant elle est plus que jamais souillée, pompée à tout va et tout simplement gaspillée. Le numérique, comme toutes les secteurs économique
n'echappe pas à cette consommation déraisonnée. Mais au fait, quand on pense datacenter on pense électricité, et c'est pourquoi on n'aurait pas idée de les arroser d'eau.
C'est à la fois un peu plus compliqué que ça, mais simple à comprendre. 

## Du front au moteur, l’eau garde la fraîcheur !

Dans notre quotidien, on se rend facilement compte de l'intérêt de l'eau. Quelques minutes en plein soleil, ou pendant le sport, on remarque vite les effets de la transpiration.
De l'eau est "produite" sur notre peau et cette eau en s'évaporant va absorber de l'énergie thermique et donc réduire la température (pour faire simple).
C'est la même chose pour nos bon vieux moteurs thermiques de voiture, dans lesquels un liquide va circuler, s'échauffer en érécupérant" de la chaleur qu'il va venir dissiper au travers d'un radiateur.
Là vous commencez bien à visualiser l'intérêt d'utiliser l'eau pour refroidir tout système. Ça coule de source et vous ne m'avez pas attendu pour comprendre ça, mais un petit rappel s'imposait quand même.

## Un datacenter ça a soif
Vous le constatez quand vous faites travailler votre laptop, ça chauffe sous les doigts et parfois le ventilateur se fait entendre, mais cette dissipation par air a ses limites.
Peut-êter faisiez-vous partis de ces bidouilleur qui faisait du "watercooling" dans des bécanes montées à la main avec amour pour programmer ou jouer.

Alors on visualise bien ce que ça peut représenter à l'échelle d'un datacenter. Pour rester opérationnels, ils ont donc besoin de systèmes de refroidissement.
Et beaucoup de ces systèmes de refroidissement (tours d’évaporation, échangeurs eau/air, [évaporateurs adiabatiques](https://fr.wikipedia.org/wiki/Refroidisseur_par_%C3%A9vaporation)) utilisent ou consomment de l’eau.

Encore plus depuis l’explosion des projets "hyperscale"  pour l’IA, la question de la consommation d’eau est sortie des rapports techniques pour rejoindre les débats publics. 
Parlons un peu chiffre. 

- Un datacenter peut consommer jusqu'à 5 millions de litres d'eau par jour, soit l'équivalent de la consommation d'une ville de 30 000 habitants. 
- "In 2023, Meta consumed 813 million gallons of water globally (3.1 billion liters) — 95% of which, 776 million gallons (2.9 billion liters), was used by data centers. [Source](https://insights.globalspec.com/article/24145/data-centers-consume-massive-amounts-of-water-companies-rarely-tell-the-public-exactly-how-much?utm_source=chatgpt.com)
- En Europe, cet [autre rapport](https://www.scrd.eu/index.php/scrd/article/download/477/439/866) nous parle de 43,2 milliards de litres d’eau consommés annuellement.
- Selon un [rapport du Berkeley Lab](https://escholarship.org/uc/item/32d6m0d1) sur l'utilisation de l'énergie aux états-unis cette tendance ne fait que grandir.
![Utilisation de l'eau par type de datacenter](datacenter-water-consumption.png)
- Avec 2,5 millions de litres par piscines olympiques, on pourrait en faire nager des champions et championnes !

Certaines études ne sont pas aussi catégoriques dans les chiffres, les méthodes de comptage diffèrent parfois, 
certaines prennent en compte la consommation directe (eau prélevée et évaporée ou rejetée par le datacenter lui-même) et indirecte
(eau utilisée pour produire l’électricité qui alimente ces mêmes centres, par exemple eau évaporée dans des centrales thermiques ou hydroélectriques). 
En tout cas les échelles sont là et on note surtout que la tendance est à la hausse.

Comme si ça ne suffisait pas, saviez-vous que 40 % de l’énergie consommée par certains datacenters vient de son système de refroidissement...


Source : 
Le "greenwashing" à la sauce numérique
Face à ces critiques, les géants du numérique déploient des trésors d'ingéniosité... en communication. On nous parle de "water positivity", de "compensation hydrique", de "WUE" (Water Usage Effectiveness). Des termes bien techniques pour noyer le poisson.

La réalité, c'est que l'explosion de l'intelligence artificielle et de nos usages numériques ne fait qu'aggraver la situation. Les promesses de "datacenters verts" qui réutilisent la chaleur fatale pour chauffer des piscines ou des logements ne sont que l'arbre qui cache la forêt.

Quelques pistes pour un numérique moins assoiffé :

La sobriété numérique : avons-nous vraiment besoin de stocker des milliers de photos de chats dans le cloud ?

Des technologies de refroidissement plus économes : le "free cooling" (refroidissement par l'air extérieur) ou le refroidissement liquide direct sont des alternatives intéressantes.

Plus de transparence de la part des acteurs du numérique : il est temps que les GAFAM et consorts publient des chiffres clairs et vérifiables sur leur consommation d'eau.

Mesurer pour mieux gérer : le rôle du WUE

La filière utilise la métrique WUE (Water Usage Effectiveness) — développée par The Green Grid — pour comparer l’efficacité hydrique des datacenters (litres d’eau consommés par kWh IT ou par unité d’énergie IT). WUE aide à normaliser et à comparer, mais beaucoup d’opérateurs ne publient pas ces métriques et les définitions (direct vs indirect) varient. D’où la demande croissante pour des obligations de reporting plus strictes (réglementaires et de marché).
thegreengrid.org
+1

8) Solutions et leviers (ce qu’on voit en pratique)

Réduire l’usage d’eau : privilégier le refroidissement par air, systèmes clos, refroidissement liquide interne (moins évaporatif), réutilisation des eaux grises et recyclage interne.
Informatique News

Compter et publier : rendre obligatoire la publication des WUE et des prélèvements d’eau (mesure et transparence). Plusieurs rapports d’ingénierie demandent plus de transparence dans les entreprises tech.
The Guardian
+1

Conception locale responsable : éviter les prélèvements dans les bassins à stress hydrique, négocier des mesures de remise en eau (objectifs « water-positive ») et utiliser des eaux alternatives (recyclées, pluviales).
Informatique News
+1

Plus les sources du bon pote.
