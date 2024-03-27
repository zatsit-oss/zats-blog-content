---
slug: testinfra-le-test-unitaire-pour-les-ops
title: Testinfra, le test unitaire pour les ops
authors: [glefebvre]
tags:
  - "ops"
  - "dev"
---

Automatiser les tests unitaires côté infra avec Testinfra devient un jeu d'enfant. C'est simple, rapide et efficace qui devient un incoutournable sur les projets.

![Testinfra logo](./testinfra-logo.svg)

<!-- truncate -->

Tous les développeurs parlent de test unitaires (a.k.a TU). Et nous, les Ops, on en parle pas assez. Pourtant, il existe des outils dantastiques et parfois deviennent indispensable pour valider nos infrastructures. C'est là que Testinfra entre en jeu.

## C'est quoi un Test Unitaire en infrastrucutre ?

Revenons sur la définition du développeur, un test unitaire est un test qui valide le comportement d'une partie de code.

En infra, si on met de coté l'infrastrucutre as code (IaC) et qu'on se concentre sur les serveurs, les tests unitaires vont valider le comportement d'une partie de l'infrastructure. Par exemple, on peut valider que le service `nginx` est bien installé, que le fichier `/etc/nginx/nginx.conf` existe, que le service est bien démarré, etc.

## Testinfra, qu'est-ce que c'est ?

Testinfra est un outil qui permet de faire des tests unitaires sur des serveurs. Il est basé sur [Pytest](https://docs.pytest.org/en/stable/) et permet de valider des états. Un état peut être un fichier, un service, un utilisateur, etc tout ce qui est possible de valider sur un serveur (ou presque). L'avantage avec les serveurs Linux, c'est que tout est fichier, donc tout est testable.

## Utilisation classique

### Comment ça marche ?

Testinfra utilise des modules pour valider des états. Par exemple, pour valider qu'un fichier existe, on utilise le module `File` :

```python
def test_nginx_config_file(host):
    f = host.file('/etc/nginx/nginx.conf')
    assert f.exists
```

### Comment l'installer ?

Testinfra s'installe via pip (directement sur le serveur) ou avec votre gestionnaire d'environnement Python préféré (pipenv, poetry, conda, etc) :

```bash
pip install testinfra
```

### Comment l'utiliser ?

Pour utiliser Testinfra, il faut écrire des tests. Les tests sont des fonctions qui commencent par `test_` et qui prennent en paramètre `host`. `host` est un objet qui représente le serveur sur lequel on fait les tests.

Exemple avec un test qui valide que le service `nginx` est bien démarré et activé :

```python
# Fichier test_nginx.py
def test_nginx_service(host):
    s = host.service('nginx')
    assert s.is_running
    assert s.is_enabled
```

Pour lancer les tests, on utilise `pytest` :

```bash
pytest test_nginx.py
```

### Utilisation avec Ansible

Dans certaines situations, on peut avoir besoin de valider des états sur des serveurs qui sont gérés par Ansible.

Testinfra peut également être utilisé avec Ansible.

**Pourquoi ?** Pour tester une infra qui est gérée par Ansible.

**Comment ?** On génère les fichiers de tests Testinfra au travers d'Ansible pour bénéficier des variables et des templates. Les variables vont nous permettre de déployer des tests spécifiques à l'infra, ce qui est pratique dans le cas de multi-tenants.

#### Cas d'utilisation

* Le projet Ansible permet de déployer une application sur plusieurs serveurs.
* L'application peut prendre plusieurs formes (nombre de serveurs, nombre de services, répartition des services, service en standalone ou en cluster, etc).
* La modularisation de l'application est entièrement gérée au travers d'Ansible, grace aux `variables` (group_vars, host_vars, role_vars, etc).

On souhaite :

* Tester le déploiement de l'application dans plusieurs configurations : standalone, cluster, etc.
* S'assurer que les configurations ne changent pas dans le temps : prévenir les acteurs qui modifient les configurations manuellement sur le serveur.

#### Comment faire ?

On génère les fichiers de tests Testinfra au travers d'Ansible. On utilise les `templates` pour générer les fichiers de tests. On utilise les `variables` pour générer des tests spécifiques à l'infra.

```yaml
# Fichier de template
# templates/test_nginx.py.j2
def test_nginx_service(host):
    s = host.service('nginx')
    assert s.is_running
    assert s.is_enabled
```

```yaml
# Fichier de tâche Ansible
# tasks/main.yml
- name: Générer les fichiers de tests
  template:
    src: test_nginx.py.j2
    dest: /tmp/test_nginx.py
```

```bash
ansible-playbook -i inventory playbook.yml
```

On exécute les tests Testinfra sur les serveurs déployés par Ansible.

```bash
# Sur le serveur distant
pytest /tmp/test_nginx.py
```

On peut ainsi :

* Générer des tests spécifiques à l'applicatif déployé
* Valider que les configurations ne fluctuent pas
* Valider que les différentes configurations de l'application sont bien déployées

## Notre retour d'expérience

Dans un précédent projet, l'application comportait les éléments/contraintes suivantes :

* Un seul projet Ansible pour déployer l'application
* Topologie de l'application :
  * standalone (seul serveur)
  * cluster (plusieurs serveurs avec répartition de charge, allant de 2 à 100 serveurs)
* Plusieurs niveaux de configuration de l'application :
  * Configuration par défaut
  * Configuration spécifique à un client
  * Configuration spécifique à un environnement (dev, preprod, prod)
* Déploiement de 50 composants techniques
* Déploiement modulable des composants techniques sur les serveurs
* Les composants techniques n'ont aucune contrainte d'adhérence à un serveur ou à une topologie.

La multitude de combinaisons possibles entre la topologie de l'application et les niveaux de configuration rendent difficile la validation de l'application. L'implémentation des tests unitaires liés à une topologie est nécessaire pour s'assurer d'une bonne qualité du projet et des livraisons.

Testinfra est devenu notre allié pour valider les déploiements de l'application.

La mise en place de Testinfra s'est fait comme suit :

* Dans chaque role Ansible, on a ajouté un dossier `templates/testinfra/` qui contient les fichiers de tests Testinfra, chaque fichier de test est nommé `test_<nom_du_composant>.py.j2`.
* Chaque fichier de test Testinfra peut utiliser du templating pour générer des tests spécifiques à certaines configurations ou spécifiques à la topologie déployée.

On se retrouve avec une arborescence de fichiers de tests Testinfra qui ressemble à ça :

```raw
roles/
  nginx/
    templates/
      testinfra/
        test_nginx.py.j2
  mysql/
    templates/
      testinfra/
        test_mysql.py.j2
  ...
```

et des tests unitaires qui ressemblent à ceci :

```python
# Fichier test_nginx.py.j2
def test_nginx_service_definition(host):
    f = host.file('/etc/systemd/system/nginx.conf')
    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'
    assert f.mode == 0o644

def test_nginx_service(host):
    s = host.service('nginx')
    assert s.is_running
    assert s.is_enabled
    assert s.user == '{{ nginx_user_name }}'
    assert s.group == '{{ nginx_group_name }}'
    assert s.mode == 0o755

def test_nginx_service_exposed_port(host):
    assert host.socket('tcp://80').is_listening

{% if nginx_cluster %}
def test_nginx_cluster(host):
    # ...
{% endif %}
```

Ces tests ont permis une plus grande sérénité dans les déploiements de l'application et une meilleure qualité des livraisons.

## Conclusion

Tous les projets de déploiement d'infrastructure devraient intégrer des tests unitaires. Testinfra est un outil simple, rapide et efficace pour valider des états sur les serveurs.

Il est possible de l'utiliser avec d'autres outils comme Ansible pour valider les déploiements.

Testinfra est basé sur python, ce qui créé une contrainte pour certains serveurs (où python n'est pas déployé), ou pour certaines équipes qui ne maitrisent pas le langage,
La contrainte du langage Python peut faire peur, mais le peu de code à écrire pour valider des états sur les serveurs est un avantage et son utilisation est assez simple.

Il existe d'autres outils de tests unitaires, comme [goss](https://goss.rocks/) pour n'en citer qu'un, et qui feront l'objet d'un prochain article.

## Bibliographie

* [Testinfra - GitHub](https://github.com/pytest-dev/pytest-testinfra)
* [Testinfra - Documentation officielle](https://testinfra.readthedocs.io/)
