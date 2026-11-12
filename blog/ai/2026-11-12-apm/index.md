---
slug: apm
title: "Un manifeste pour les gouverner tous"
description: "Découvrez APM (Agent Package Manager), qui gère skills, hooks et règles de vos agents IA comme des dépendances versionnées."
authors: [jvasseur]
tags:
  - "ai"
  - "dev"
date: 2026-11-12
---

Skills, hooks, règles, agents : à force de les copier d'un projet à l'autre, on ne sait plus quelle version est la bonne. **APM (Agent Package Manager)** propose de les traiter comme de simples dépendances, déclarées, versionnées et installées en une commande.

<!-- truncate -->

## Configurer un agent, puis une flotte

Un outil comme Claude Code se configure avec des fichiers : des skills pour lui apprendre des procédures, des hooks pour bloquer certaines actions, des règles pour cadrer son comportement. Sur un seul projet, tout va bien.

Chez nous, le besoin va plus loin. Nous construisons un toolkit : une flotte d'agents spécialisés, chacun avec son rôle, ses skills et ses hooks de garde-fous. Ils coopèrent pour mener une tâche de bout en bout, avec des points de validation humaine entre les étapes.

Reste à les mettre entre les mains des projets : **comment livrer les mêmes agents, dans la même version, à plusieurs projets, et les faire évoluer sans repartir de zéro ?** À la main, on copie les fichiers, on corrige un hook dans un dépôt mais pas dans les autres, et chacun finit avec sa propre variante.

## APM peut nous aider

[APM](https://github.com/microsoft/apm) est un gestionnaire de paquets pour les agents IA. Comme `npm` ou `maven` le font pour du code, il permet de déclarer ce dont un projet a besoin et de l'installer au bon endroit.

Il manipule ce qu'il appelle des *primitives* : agents, skills, règles et hooks. Un paquet APM est un dossier qui contient un fichier `apm.yml`.

## Comment ça marche

APM fonctionne comme `package.json` ou `requirements.txt`, mais pour la configuration des agents : on déclare ce dont le projet a besoin, et une commande reproduit la même configuration chez tout le monde.

### Un manifeste pour tout déclarer

Le point d'entrée est un fichier `apm.yml`, versionné avec le projet :

```yaml
# apm.yml
name: your-project
version: 1.0.0
targets:
  - claude
dependencies:
  apm:
    # des skills depuis n'importe quel dépôt
    - anthropics/skills/skills/frontend-design
    # un paquet APM complet (instructions, skills, hooks…), épinglé sur un tag
    - microsoft/apm-sample-package#v1.0.0
  mcp:
    # un serveur MCP, installé pour chaque cible
    - name: io.github.github/github-mcp-server
      transport: http
```

Ce manifeste regroupe des **skills**, des **paquets complets** et même des **serveurs MCP**. Les dépendances peuvent venir de GitHub, GitLab, Bitbucket ou de tout autre hébergeur git, et un paquet peut lui-même dépendre d'autres paquets : APM résout l'arbre complet.

### Une commande pour tout installer

Un nouveau venu n'a plus qu'à cloner le dépôt et lancer :

```bash
git clone <org/repo> && cd <repo>
apm install
```

APM déploie les primitives aux emplacements attendus par chaque cible déclarée dans `targets`. Pour ajouter une dépendance sans éditer le fichier à la main, on peut aussi l'installer directement :

```bash
apm install microsoft/apm-sample-package#v1.0.0
```

Le fichier `apm.lock.yaml` fige l'arbre résolu, comme le fait `package-lock.json` pour npm : tout le monde obtient exactement la même configuration.

### Aller plus loin

Quelques fonctions complètent ce socle, d'après la documentation :

- **Les marketplaces** : `apm marketplace add github/awesome-copilot` puis `apm install azure-cloud-development@awesome-copilot` installent un plugin depuis un registre.
- **La sécurité** : chaque installation analyse les contenus à la recherche de caractères Unicode cachés pouvant détourner un agent, et `apm audit` refait ces contrôles à la demande.
- **La gouvernance** : un fichier `apm-policy.yml` permet à une organisation de limiter les sources et types de primitives autorisés.

## Mise en pratique

Dans un projet, on déclare les dépendances dans `apm.yml`, puis on installe avec `apm install`. Les skills et hooks apparaissent dans `.claude/`. Pour mettre à jour, on change le tag dans `apm.yml` et on relance la commande : la version change partout de la même façon. <!-- À COMPLÉTER : ce que vous avez constaté, par exemple le contenu de .claude/ après installation. -->

Si le paquet est dans un dépôt privé, APM s'appuie sur un `git` ou un `gh` authentifié (voir `apm auth`).

## Un seul manifeste, plusieurs agents

APM sait aussi cibler d'autres outils que Claude Code. Selon sa documentation, GitHub Copilot, Cursor, Codex, OpenCode, Gemini, Windsurf, Kiro ou Grok Build peuvent être ajoutés dans `targets`, et le même paquet est alors déployé pour chacun. Je ne l'ai pas testé : mon retour d'expérience porte sur Claude Code.

## Bilan

Ce que j'en retiens :

- **La cohérence** : les mêmes skills et hooks, dans la même version, sur tous les projets.
- **Une mise à jour centralisée** : on change un tag, pas dix dépôts.
- **Des pratiques partagées** : un paquet devient un moyen de diffuser un savoir-faire.

### Dans notre cas

Pour notre toolkit, APM répond à la question de la distribution. Chaque rôle est un paquet, et plusieurs paquets se regroupent en bundle : un projet installe un seul rôle ou tout un ensemble, avec la même commande. Les hooks de garde-fous sont livrés dans le même paquet que l'agent, et les skills tiers ne sont ajoutés qu'après validation, puis épinglés sur un commit. Tous les paquets partagent une seule version : mettre à jour un projet revient à changer un tag.

### Points de vigilance

L'outil est récent : son dépôt date de septembre 2025, le recul est donc limité. Autre contrainte : APM n'accepte pas un fichier isolé comme dépendance, il faut un petit `apm.yml` dans chaque dossier d'agent, de règle ou de profil de hook, ce qui ajoute un peu de structure.

## Pour un petit projet : pollen

APM est complet, et c'est parfois trop pour un besoin simple. Si vous n'avez que des skills à distribuer, [pollen](https://github.com/groupbees/pollen), développé par GroupBees, est une alternative plus légère. Je ne l'ai pas testé : je l'ai découvert à Cloud Nord 2026 à Lille, dans la [présentation de Guillaume Leroy et Mazlum Tosun](https://www.youtube.com/watch?v=86H9euEp95g).

Selon son README, pollen est un petit outil en ligne de commande qui lit un fichier `pollen.yaml`, construit sur le modèle de celui de `pre-commit` : une liste de dépôts git, chacun avec une révision et les chemins à récupérer.

```yaml
repos:
  - repo: https://github.com/toto/tata
    revision: 1.2.3
    paths:
      - path: mydir/
```

Une seule commande, `pollen update`, installe ce qui est déclaré, rafraîchit ce qui a changé et supprime ce que vous avez retiré.

Son périmètre est volontairement limité aux skills. Dès que vous avez aussi des agents, des hooks ou des serveurs MCP à distribuer, APM reste le bon choix.

## Conclusion

APM ne change pas la façon dont vous utilisez votre agent. Il change la façon dont vous distribuez sa configuration. À vous de juger si ce besoin est le vôtre : le [dépôt officiel d'APM](https://github.com/microsoft/apm) est le meilleur point de départ pour vous faire votre avis. Et si vos besoins se limitent à quelques skills, [pollen](https://github.com/groupbees/pollen) peut suffire.
