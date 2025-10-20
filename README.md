# InfoNow

InfoNow est une application iOS développée en **SwiftUI**, permettant d’afficher les actualités en français à partir de l’API [NewsAPI.org](https://newsapi.org/docs).  
Elle a été conçue dans le cadre d’un test technique afin de démontrer une approche professionnelle du développement mobile : architecture claire (MVVM), code lisible, testable et **évolutif**.

---
<img width="1000" height="1000" alt="Illustration_sans_titre" src="https://github.com/user-attachments/assets/da2619e0-0c20-40f2-9441-405164ecb584" />

---

## Fonctionnalités principales

**Affichage :**  
  La structure de l’affichage de l’application est conçue pour s’adapter aux différents appareils (iPhone ou iPad) ainsi qu’aux orientations (portrait/paysage).  
  Une navigation personnalisée a été mise en place pour permettre une **évolution flexible de l’interface**.

**Liste des actualités :**  
  Affiche toutes les news francophones disponibles via NewsAPI, avec :
  - le **titre de l’article**
  - la **source**
  - l’**auteur**
  - la **date de publication**
  - l’**image associée** (si disponible)  

  Le menu :
  - d’afficher toutes les news francophones
  - d’afficher les **top headlines** francophones
  - de rechercher un article par mot-clé
  
  Champ de recherche (mode recherche) :
  - icône visuelle indiquant clairement à l’utilisateur qu’il s’agit d’un champ destiné à la recherche.
  - Bouton de réinitialisation permettant de supprimer le texte saisi dans le champ

**Détail d’une actualité :**  
  En cliquant sur une news, l’utilisateur accède à une vue détaillée présentant :
  - le **titre complet**
  - l’**image principale**
  - la **description**
  - un **lien** vers l’article complet (ouverture dans l’application ou Safari)
  - la **WebView** pour permettre à l’utilisateur de consulter l’article complet directement dans l’application, sans avoir à ouvrir Safari

**Actualisation des données :**  
  Un rafraîchissement par action *pull-to-refresh* permet de récupérer les dernières publications.

- **Testabilité :**  
  - Un menu **Mock** est mis en place via `#if DEBUG` pour faciliter les tests manuels et automatisés.

---

## Architecture et Choix techniques

### MVVM (Model - View - ViewModel)

L’application suit une architecture **MVVM**, garantissant :  
- une séparation claire entre la logique métier, la logique de présentation et la couche d’affichage  
- un code facilement testable et maintenable  
- la possibilité d’évoluer vers d’autres sources de données ou frameworks UI sans impacter la logique principale

### SwiftUI

- SwiftUI est le framework déclaratif d’Apple pour créer des interfaces utilisateur, utilisé depuis sa sortie en 2019.  
- L’application est compatible avec **iOS 17** et ultérieur.  
- Avec cette version, les ViewModels marqués `@Observable` n’ont plus besoin d’utiliser `@Published` pour mettre à jour les vues.  
- Pour afficher du contenu web directement dans l’application, j’utilise `UIViewRepresentable` afin d’intégrer un **WebView**.  
- Gestion des images URL:** chargement asynchrone avec cache simple (via `AsyncImage`) 
- Malgré la simplicité apparente de l’interface, des choix techniques stratégiques ont été faits pour optimiser la performance, la lisibilité du code et la gestion des cycles de vie des vues SwiftUI. 

### Communication avec l’API REST

- Un **ApiClient** universel et modulable a été mis en place, permettant de configurer facilement les appels réseau et de gérer le décodage générique des données.  
- Possibilité d’intercepter les appels pour utiliser des réponses Mock et tester différents cas (succès, vide, erreur).  
- ApiClient prend comme paramètres :  
  - `APIOperation` préconfiguré  
  - une structure `Codable` correspondant à l’opération  
  - un `URLRequest` conforme au protocole `APITransport`  
- `NetworkService` sert de passerelle pour la configuration des appels réseau et la communication avec le ViewModel.  

> Ce choix permet de configurer non seulement les appels à NewsAPI, mais également d’autres API sans modifier la structure existante du code.

---

## Problèmes et améliorations possibles

- Initialement, il était prévu de charger plus d’articles via un bouton « Charger la page suivante », mais le compte développeur de l’API limite les résultats à 100 articles.  
- La requête `top-headlines` avec `country=fr` retourne 0 article, mais j’ai implémenté ce cas pour gérer l’affichage de manière cohérente.  
- Il est possible d’ajouter Core Data pour sauvegarder les articles favoris. Cependant, comme les articles ne possèdent pas d’ID unique, il faudrait utiliser le titre comme identifiant, en supposant qu’il n’est pas dupliqué.
- Evolution possible pour la gestion et actualisation automatique des données L’application: 
            lorsque le mode hors ligne est activé ou lorsque la connexion est rétablie.
            Lors du passage de l’application en arrière-plan puis en premier plan
 > Avec une limite d’une heure minimu depuis la dernière requête, afin de permettre à l’utilisateur de consulter les derniers articles **sans surcharger l’API**
---

###**NB** : La réalisation de ce projet a pris environ 10 heures.

