---
title: "OpenRewrite : Automatiser les montées de version"
slug: "openrewrite"
authors: [ggayot]
tags: ["java", "open-source","refacto"]
---

# OpenRewrite : Automatiser les montées de version

## Le serpent de mer des montées de version

En tant que développeur·euse·s il n'est pas toujours facile de trouver le temps de maintenir à jour les versions des langages et des frameworks que l'on utilise.

Suivre le rythme des releases n'est pas toujours aisé, et on se retrouve souvent dans ce cercle vicieux : les montées de version mineures ne semblent pas suffisamment intéressantes pour que l'on prenne le temps de les faire. Alors on attend les majeures et les LTS...

<!-- truncate -->

Sauf qu'elles sont souvent plus coûteuses en temps et donc plus difficile à intégrer dans nos roadmaps (particulièrement quand elles n'apportent pas de plus value pour nos clients).

Alors on attend. Et généralement, on attend jusqu'à ce que l'on soit obligé de faire cette upgrade (à cause d'une faille de sécurité, de la fin de support, etc...)

Et quand on a attendu bien longtemps, ces montées de version deviennent (parfois) des monstres de complexité, entrainant (parfois) des effets de bords en cascade sur nos dépendances et mobilisant énormément de temps et d'efforts.

Efforts parfois compliqués à justifier face à nos clients :
> "Oui, j'ai passé tout le sprint sur la montée de version. Non, il n'y a aucune nouvelle fonctionnalité ou amélioration visible sur le produit. Non, je ne me fous pas de vous, pourquoi vous dites ça ?"

Comment limiter le temps et les efforts que nous demandent ces montées de versions ? Avec **OpenRewrite**.

## OpenRewrite, c'est quoi ?

Citons [la documentation officielle](https://docs.openrewrite.org/) :

> OpenRewrite est une solution open source de refactorisation automatisée, permettant aux développeurs d'éliminer efficacement la dette technique au sein de leurs dépôts.
> Il se compose d'un moteur de refactorisation automatique qui exécute des recettes de refactorisation préemballées et open source pour les migrations de frameworks courantes, les corrections de sécurité et les tâches de cohérence stylistique – réduisant vos efforts de codage de plusieurs heures ou jours à quelques minutes.
> Bien que l'accent initial ait été mis sur le langage Java, la communauté OpenRewrite ne cesse d'étendre la couverture des langages et des frameworks.

On peut donc retenir que :
1. c'est open source
2. ça refactorise le code en suivant des "**recettes**"
3. on peut utiliser des recettes open source ou écrire les siennes

Développé au départ autour de l'environnement Java, OpenRewrite est compatible avec Maven et Gradle, permettant d'appliquer les recettes en une ligne de commande.

L'initiative propose également un système de "**meta-recette**" : des recettes composées de plusieurs recettes, comme [celle-ci, pour passer à Spring Boot 3.4](https://docs.openrewrite.org/recipes/java/spring/boot3/upgradespringboot_3_4) ou encore [celle-là pour passer en java 21](https://docs.openrewrite.org/recipes/java/migrate/upgradetojava21).

:::tip

Le [plugin Maven OpenRewrite](https://docs.openrewrite.org/running-recipes/getting-started) permet également d'ajouter des recettes ou des meta-recettes les unes à la suite des autres.

:::

## Avec un exemple, c'est plus parlant

Une rapide recherche sur Github nous a permis de trouver [ce dépôt public](https://github.com/sohamkamani/spring-demo) d'une application de démo pour Spring Boot.

Le dernier commit date d'il y a 3 ans, la version de Spring Boot utilisée est la version 2.6.4 et la version de Java est la version 11.

À l'heure où nous écrivons cet article, la dernière version stable de Spring Boot est la 3.5 et la dernière LTS de Java est la version 21.

Nous avons donc une majeure à passer sur Spring Boot et dix versions sur Java !

Comme il s'agit d'un framework et d'un langage très populaires, on trouve de nombreux guides de migration. Mais grâce à OpenRewrite, nous n'avons pas besoin de regarder [une vidéo de plus d'une heure](https://www.youtube.com/watch?v=HrRQExD3xow) avant de nous mettre à l'ouvrage !

En effet, en appliquant à la suite les commandes Maven fournies dans [la recette pour passer à Spring Boot 3.4](https://docs.openrewrite.org/recipes/java/spring/boot3/upgradespringboot_3_4-community-edition) ainsi que [celle pour passer en java 21](https://docs.openrewrite.org/recipes/java/migrate/upgradetojava21), ces deux opérations s'exécutent en quelques secondes.

```
mvn -U org.openrewrite.maven:rewrite-maven-plugin:run -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-spring:RELEASE -Drewrite.activeRecipes=org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_4 -Drewrite.exportDatatables=true
```

```
mvn -U org.openrewrite.maven:rewrite-maven-plugin:run -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-migrate-java:RELEASE -Drewrite.activeRecipes=org.openrewrite.java.migrate.UpgradeToJava21 -Drewrite.exportDatatables=true
```

Comme notre application de démo n'utilise aucune dépendance en dehors de Spring Boot, on peut directement valider que tout s'est bien passé : les tests passent encore, l'application se lance et fonctionne comme prévu !

:::info

On aurait également pu utiliser le plugin maven pour ajouter nos deux recettes l'une à la suite de l'autre :

:::

```xml
<plugin>
    <groupId>org.openrewrite.maven</groupId>
    <artifactId>rewrite-maven-plugin</artifactId>
    <version>6.10.0</version>
    <configuration>
        <exportDatatables>true</exportDatatables>
        <activeRecipes>
            <recipe>org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_4</recipe>
            <recipe>org.openrewrite.java.migrate.UpgradeToJava21</recipe>
        </activeRecipes>
    </configuration>
    <dependencies>
        <dependency>
            <groupId>org.openrewrite.recipe</groupId>
            <artifactId>rewrite-migrate-java</artifactId>
            <version>3.11.0</version>
        </dependency>
        <dependency>
            <groupId>org.openrewrite.recipe</groupId>
            <artifactId>rewrite-spring</artifactId>
            <version>6.8.2</version>
        </dependency>
    </dependencies>
</plugin>
```
Certaines recettes nécessitent des paramètres, comme [cette recette de changement de nom de package](https://docs.openrewrite.org/recipes/java/changepackage) par exemple.

Heureux hasard ! dans notre projet, le fichier `SpringdemoApplicationTests.java` comporte une erreur de nom de package !

Il suffit d'ajouter à la racine de notre projet un fichier de configuration `rewrite.yml` comme celui-ci :

```yaml
---
type: specs.openrewrite.org/v1beta/recipe
name: com.zatsit.ChangePackage
displayName: Rename package name example
recipeList:
  - org.openrewrite.java.ChangePackage:
      oldPackageName: com.sohamkamani.demo
      newPackageName: com.sohamkamani.springdemo
```

Puis d'ajouter la recette dans la liste à appliquer par le plugin :

```xml
<activeRecipes>
    <recipe>org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_4</recipe>
    <recipe>org.openrewrite.java.migrate.UpgradeToJava21</recipe>
    <recipe>com.zatsit.ChangePackage</recipe>
</activeRecipes>
```

Là encore, un simple `mvn rewrite:run` et le tour est joué !

## What else ?

Cet exemple simple vous donne un aperçu de la facilité avec laquelle vous pouvez utiliser, combiner, adapter les recettes OpenRewrite por répondre à vos besoins, souvent spécifiques.

Comme précisé ci-dessus, OpenRewrite s'est d'abord développé autour de l'environnement Java, mais s'est aujourd'hui étoffé de [milliers de recettes](https://docs.openrewrite.org/recipes) pour des technologies, langages et frameworks aussi divers que variés !

Et si jamais vous ne trouvez pas votre bonheur, comme OpenRewrite est open source, vous pouvez tout à fait [écrire votre propre recette](https://docs.openrewrite.org/authoring-recipes), que ce soit pour pouvoir la répliquer facilement sur plusieurs de vos projets, ou pour en faire profiter toute la communauté !

Alors ? Prêt à effectuer vos montées de versions de manière sereine ?