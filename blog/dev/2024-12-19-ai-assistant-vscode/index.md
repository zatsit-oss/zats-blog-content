---
slug: local-ai-assistant-in-vscode
title: Coder plus facilement avec votre propre assistant IA en local sur VSCode
authors: [nfourre]
tags: [dev, web]
---

# Coder plus facilement avec votre propre assistant IA en local sur VSCode

Vous rêvez d'un assistant intelligent comme GitHub Copilot, mais en utilisant les ressources de votre machine pour éviter l’impact  des serveurs Microsoft et le coût associé à l’abonnement ? Vous êtes au bon endroit.

<!-- truncate -->

Dans cet article, nous allons vous guider, étape par étape, pour créer votre propre assistant IA local et le déployer dans votre environnement de développement VSCode à l’aide de LM Studio et de l’extension CodeGPT.

# Disclaimer

Les modèles d'IA nécessitent beaucoup de ressources. Un processeur performant, une carte graphique puissante (GPU) et une grande quantité de RAM sont recommandés. LM Studio permet de choisir l’utilisation du CPU et/ou GPU.

# Prérequis

Avant de commencer, assurez-vous d’avoir NodeJS d’installé en version 18+ et Visual Studio Code (VSCode).

# Installation de LM Studio

Allez sur le site de LM Studio ([https://lmstudio.ai/download](https://lmstudio.ai/download)) et téléchargez la version adaptée à votre matériel.

Une fois installée, il est temps de choisir le modèle le plus adapté, dans notre cas le modèle de Mistral AI Codestral est un bon choix. Il existe des modèles alternatifs pour des assistants de code comme Code llama ou StarCoder.

Ouvrez LM Studio et sélectionnez la loupe (screen 01) afin de rechercher le modèle Codestral grâce à la barre de recherche.

![lm-studio-1.webp](lm-studio-1.webp)

![lm-studio-2.webp](lm-studio-2.webp)

Une fois le modèle trouvé, cliquer sur le bouton “Use in New Chat”, cette action va télécharger le modèle.

Patientez quelques instants, le temps de télécharger le modèle qui pèse un peu plus de 13 GB.

Une fois téléchargé, accédez au menu “Developer” (icône “Terminal” sur la sidebar de gauche). puis sélectionnez le modèle à charger dans la barre du haut.

![lm-studio-3.webp](lm-studio-3.webp)

Chargez le modèle “Codestral” que vous venez de télécharger. Patienter quelques instants, le modèle se charge en mémoire. Une fois le chargement terminé, il ne vous reste plus qu’à cliquer sur “Start Server” et le tour est joué.

![lm-studio-4.webp](lm-studio-4.webp)

La configuration de LM Studio est maintenant terminée.

# Intégration dans Visual Studio Code

La première étape est de télécharger l’extension CodeGPT qui permet, en s’inscrivant sur leur site, d’accéder aux APIs de différentes IAs comme ChatGPT, ClaudeAI, … Toutefois, ce n’est pas ce que l’on souhaite ici. On cherche à utiliser la puissance de nos machines plutôt que des serveurs distants, alimentés avec une énergie à la provenance inconnue et dans un datacenter sûrement pas tout proche. Essayons d’être un peu plus “green” en réduisant notre empreinte.

![vscode-1.webp](vscode-1.webp)

Une fois l’extension installée, cliquez sur l’icône ChatGPT dans la “sidebar” de gauche. Puis sélectionnez l’assistant à utiliser.

![vscode-2.webp](vscode-2.webp)

À la place d’utiliser CodeGPT Plus, qui vous incite à utiliser les API des grands géants de l’IA, choisissez “LM Studio” comme “Provider Local”.

![vscode-3.webp](vscode-3.webp)

Et voilà ! Le tour est joué, vous avez à présent votre assistant d’aide à la programmation qui utilise directement vos ressources locales pour fonctionner. Pas de serveurs à interroger, pas d’abonnement à payer.

# Utiliser mon nouvel assistant

Pour vérifier que l’assistant fonctionne bien, nous allons lui demander de créer un composant “Product Card” en ReactJS avec une image, le nom du produit, une courte description, le prix et un bouton d’ajout au panier, en interagissant directement avec la fenêtre de chat.

![vscode-4.webp](vscode-4.webp)

Une fois le prompt envoyé, l’IA générative utilise le modèle “Codestral” de LM Studio pour répondre. Si vous vérifiez la fenêtre de LM Studio, vous voyez bien le prompt et la réponse dans les logs.

# Conclusion

Le code généré par l’assistant n’est peut-être pas encore au niveau de ce que peut produire [Bolt.new](http://Bolt.new) de StackBlitz ou [v0.dev](http://v0.dev) de Vercel, mais c’est déjà une première approche d’utilisation de l’IA beaucoup plus responsable et économique. 
Cet assistant se révèle toutefois plus efficace pour générer des tests unitaires à partir de votre code ou d’optimiser ce dernier.

Maintenant la balle est dans votre camp, à vous d’explorer les possibilités que vous offrent cet assistant et de tester d’autres modèles d’IA plus adapter à vos besoins. À vous de choisir des tâches avec moins de valeur ajoutée, qui valent le coup d'être automatisées ou générées versus un réel apprentissage avec la documentation comme allié.