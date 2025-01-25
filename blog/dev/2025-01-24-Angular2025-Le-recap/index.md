---
slug: angular-2025-le-recap
title: Angular 2025 le récap
authors: [nlefebvre]
date: 2025-01-24
tags:
  - "web"
---

# Article angular 2025 : le récap

![image.png](image.png)

[https://x.com/DanielGlejzner/status/1862568911482626328/photo/1](https://x.com/DanielGlejzner/status/1862568911482626328/photo/1)

# Introduction

Pour cet article à propos d’Angular, je vais essayer de montrer un aperçu de la dynamique d’évolution du Framework ces derniers temps, et la direction prise par l’équipe de développement.
<!-- truncate -->
En effet, avec des avancées majeures dans les dernières versions via le lancement des composants standalone en expérimental en V14, l’arrivée des Signals en V16 ou encore la nouvelle syntaxe de control flow en v17, Angular progresse bien dans ses objectifs d’améliorer les performances, l’expérience des développeurs, la stabilité et la fiabilité (cf Vidéo "State of Angular"** by Minko Gechev, Google Core Team [https://www.youtube.com/live/C9fiw4XoeC0?si=bLB3d0ppm7veu3Lg&t=5320](https://www.youtube.com/live/C9fiw4XoeC0?si=bLB3d0ppm7veu3Lg&t=5320) )

![chrome_fStCsGnV1G.png](chrome_fStCsGnV1G.png)

# Aperçu des changements majeurs depuis 2022

## Standalone component ( stable en V15)

L’un des changements les plus anciens maintenant et l’introduction des standalone component, permettant de se passer des ngModule. Ce changement permet des améliorations de performance avec une mise en place de chargement à la demande (lazy loading) de composant bien plus facilement. La contrepartie principale au quotidien étant de prendre l’automatisme d’importer dans chaque composant les éléments externes utiles (Pipe, Directives, Composants…). 

Bien sûr l’équipe d’Angular s’efforce de garder la rétrocompatibilité des versions et fonctionnalités, et les ngModules ne sont pas encore prévus d’être dépréciés de sitôt.

Depuis la version 19 les composants sont d’ailleurs considérés par défaut comme standalone, et un warning pour les imports inutilisé à été ajouté ( [https://angular.dev/extended-diagnostics/NG8113](https://angular.dev/extended-diagnostics/NG8113) )

## Les signals

### Le présent

L’autre changement qui a fait beaucoup parlé de lui est l’introduction des Signals (stable en v17), un nouveau type de données, mix entre les variables classiques et des observables. Une erreur souvent commise est de penser que les Signals remplacent les Observables, alors qu’ils viennent en combinaison comme l’illustre ce schéma issu de [https://www.angularspace.com/18-interview-questions-answered-by-angular-experts-live-post/](https://www.angularspace.com/18-interview-questions-answered-by-angular-experts-live-post/)  “Q14: Signals, Observables, Promises - tell me all about differences and when to use which.”: 

![image.png](image%201.png)

Je vois personnellement les Signals comme des variables réactives, permettant de gérer l’état d’un composant, tout en optimisant la détection de changement en étant compatible avec la ChangeDetectionStrategy OnPush et Angular sans zone.js. Voici ici un rappel sur la manière dont Angular gère cela, notamment avec les signals : [https://www.angularspace.com/how-angular-keeps-your-ui-in-sync/](https://www.angularspace.com/how-angular-keeps-your-ui-in-sync/) 

L’écosystème des Signals s’est étoffé dans la version 19 avec les input/output/model de composant remplaçant les @Input, @Output. Et aussi les Signals query offrant de nouvelles possibilités aux @ViewChild et consorts.

### Amélioration en cours de l’écosystème des Signals

Pour combiner au mieux les RxJS et les Signals, le package rxjs-interop (encore expérimental à l’heure actuelle) [https://angular.dev/ecosystem/rxjs-interop](https://angular.dev/ecosystem/rxjs-interop) permet d’utiliser le meilleur des 2 mondes en permettant de transformer un Observable en Signals et inversement.

![image.png](image%202.png)

Un autre aspect de la réactivité des Signals passe par les opérateurs permettant de réagir aux changements de valeurs des Signals. Ainsi, en plus du computed qui est stable depuis plusieurs versions et [l’Effect](https://angular.dev/api/core/effect) qui est toujours en developer Preview, Angular s’attaque maintenant a faciliter le travail pour la gestion de l’asynchronisme via l’opérateur `resource` , dont le cas d’usage principal est de permettre des récupérer des données via une API et de les utiliser comme Signals. 

Une bonne illustration faite par un membre de l’équipe d’Angular des différents outils liés aux Signals ([https://x.com/Jean__Meche/status/1866857244106584575/photo/1](https://x.com/Jean__Meche/status/1866857244106584575/photo/1) )

![image.png](image%203.png)

Un chantier qui débute est celui d’utiliser les signals au sein des formulaires, avec comme objectif, encore une fois, de facilité l’expérience de développeur. ( [https://github.com/angular/angular/tree/prototype/signal-forms/packages/forms/experimental](https://github.com/angular/angular/tree/prototype/signal-forms/packages/forms/experimental) )

### Les signals en dehors d’Angular

La venue de signals permet aussi l’amélioration des librairies connues qui gravitent autour d’Angular.

Le premier exemple qui me vient à l’esprit est la librairie Ngrx qui propose des outils pour gérer l’état de l’application ou de composant. Ils ont ainsi intégré des sélecteurs de type signal dans leur store et component store, mais ils proposent aussi une librairie dédiée pour avoir un [store directement en signal](https://ngrx.io/guide/signals). Si le sujet vous intéresse, une [série d’articles a été sortie Angular Architects](https://www.angulararchitects.io/en/blog/the-new-ngrx-signal-store-for-angular-2-1-flavors/).

## Nouveau control flow ( stable en v18)

La version 18 a permis de murir les nouvelles fonctionnalités liées aux signals, mais a aussi introduit de nouvelles syntaxes dans les templates de composants, autrement appelées Control Flow, permettant de sortir les conditions des balises html et d’améliorer la lisibilité des templates.

![image.png](image%204.png)

Via l’ajout de cette syntaxe, l’équipe d’Angular a aussi ajouté le bloc @defer qui permet de charger paresseusement les composants/directives/pipe qui sont inclus dans le bloc.

En version 19 une nouvelle balise a fait son apparition, le @let permettant de définir une variable directement dans le template.

```tsx
@let user = user$ | async;
@if (user) {
  <h1>Hello, {{user.name}}</h1>
}
```

## L’hydratation incrémentale

Un point moins mis en avant et le rendu côté serveur (Server side rendering, SSR), qui permet de générer une partie de la vue sur le serveur, permettant une amélioration des performances pour l’utilisateur, ou encore un meilleur référencement SEO. 

Pour améliorer les performances au niveau de la réactivité du SSR, l’hydratation permet de réutiliser une partie du code généré côté serveur.

L’hydratation incrémentale vient optimiser l’hydratation en ciblant les parties à hydrater, cela fonctionne via le bloc @defer et permet d’hydrater le contenu du bloc uniquement lorsque l’évènement déclencheur du @defer est activé.

## Angular sans zone.js

Avec une disponibilité en mode expérimentale depuis la version 18, il est maintenant possible d’utiliser Angular sans zone.js avec à la clé une amélioration des performances de rafraichissement des vues. Pour refléter ce changement, l’équipe envisage d’ailleurs d’utiliser le terme “synchronisation” en remplacement de la “détection de changement” ( [https://youtu.be/rRWPSvoVSGk?si=SOeFQZLSz_Knt6T1&t=271](https://youtu.be/rRWPSvoVSGk?si=SOeFQZLSz_Knt6T1&t=271) ).

Se passer de zone.js permettra : 

- d’améliorer les performances en supprimant une libraire supplémentaire au bundle et toute la surcharge que ça implique, tout en optimisant la détection de changement et évitant certains bugs liés à zone.js.
- Un meilleur débogage avec un suivi simplifié de l’état de l’application et de ses mises à jour.
- De s’aligner sur l’architecture moderne d’Angular avec les Signals pour une réactivité propre et efficiente.

## Nouveau format des composants (authoring format)

Un autre point, est la recherche sur le nouveau format des composants (authoring format), avec pour objectif par exemple d’éviter la duplication d’import entre l’import JavaScript et l’import standalone ([https://blog.angular.dev/angular-2025-strategy-9ca333dfc334](https://blog.angular.dev/angular-2025-strategy-9ca333dfc334)) : 

```tsx
import { Checkbox } from 'component-library';

@Component({
  selector: 'my-app',
  imports: [Checkbox], // <-- an extra import
  template: `<my-checkbox/>`
})
export class App {...}
```

Les réflexions sont à leurs débuts, Plus d’infos sur ce sujet par ici : [https://x.com/Jean__Meche/status/1849545173920825606?t=W8kwcXGMeJ6yh-I3esjj-g&s=19](https://x.com/Jean__Meche/status/1849545173920825606?t=W8kwcXGMeJ6yh-I3esjj-g&s=19) 

Un peu dans la même veine, une communication récente fait mention de recommandation visant les noms de fichiers, le guide de style omettra le fait de suffixer les noms avec “component”, “directe” ou “service”. Et à la place, pour permettre aux différents outils de mieux supporter Angular, de mettre le préfixe “ng” (ng.html, ng.ts…) [https://github.com/angular/angular/discussions/59522](https://github.com/angular/angular/discussions/59522)

## Feedbacks de la communauté

Parmi les derniers changements, les Signals et Control flow sont les 2 améliorations qui ont le plus d’impact positif pour les développeurs d’après l’enquête menée par l’équipe Angular ([https://blog.angular.dev/angular-2025-strategy-9ca333dfc334](https://blog.angular.dev/angular-2025-strategy-9ca333dfc334) ) 

![image.png](image%205.png)

# Tips pour suivre les nouveautés

## Mise à jour de la documentation

Sortie en même temps que la version 17, une nouvelle version de la documentation a été mise à disposition sur [https://angular.dev/](https://angular.dev/) .

Dans les apports notables, je trouve que l’intégration d’un bac à sable intégré est très pratique pour suivre le tutoriel, ou simplement pour faire des tests rapides dans le [playground](https://angular.dev/playground) ( et c’est toujours possible sur [Stackblitz](https://stackblitz.com/edit/angular)). 

## Contenu des versions

Vous pouvez bien sûr retrouver ces sujets listés sur la roadmap officielle d’Angular : [https://angular.dev/roadmap](https://angular.dev/roadmap) . Permettant d’avoir un aperçu de l’ensemble des chantiers passés et en cours.

Mais avec le rythme de sortie de 2 versions majeures par an, avec dans chacune des versions des fonctionnalités en expérimentation ou en avant-première, il est parfois facile d’oublier ce que l’on peut utiliser sereinement pour son application en production. Il est bien sûr possible d’aller directement sur la documentation officielle pour voir si la fonctionnalité est stable, mais un Français porte un projet permettant de visualiser rapidement le statut des principales fonctionnalités sur [https://www.angular.courses/caniuse](https://www.angular.courses/caniuse) .

![image.png](image%206.png)

## Mise à jour de vos applications

Depuis quelque temps, pour simplifier la vie des développeurs lors des mises à jour, des “schematics” sont disponibles via l’outil de ligne de commande. 

Il est ainsi possible de facilement passer ses composants en standalone, utiliser la nouvelle syntaxe de control flow ou encore passe les @Input des composants en signal en une commande.

Vous pouvez retrouver tous les schematics disponibles dans la documentation officielle : [https://angular.dev/reference/migrations](https://angular.dev/reference/migrations) .

Et pour certains l’action est directement proposée dans VSCode, par exemple la conversion des @Input : [https://angular.dev/reference/migrations/signal-inputs#vscode-extension](https://angular.dev/reference/migrations/signal-inputs#vscode-extension)

# Conclusion

L’ensemble du travail fourni par l’équipe et la communauté Angular a apporté un vent de fraîcheur sur ce framework qui regagne en popularité par rapport à React et VueJS, s’inspirant du meilleur de ces derniers pour essayer d’être encore mieux au niveau des performances et de l’expérience des développeurs. 

Je trouve d’ailleurs intéressant le [feedback d’Alex Rickabaugh](https://x.com/synalx/status/1882879962547659078) à ce sujet, et j’ai l’impression que les efforts faits portent leurs fruits 🙂 

> Pour être honnête, l'un des plus grands moteurs de la « Renaissance Angular » a été un changement de culture de l'équipe au fil des ans, passant d'une vision des problèmes comme des problèmes de **compétences** à une vision des problèmes comme des problèmes de **conception** [du framework].
>