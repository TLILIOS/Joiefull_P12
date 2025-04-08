# Joiefull - Application de Mode Élégante

Une application de mode intuitive et élégante développée en SwiftUI pour présenter un catalogue de vêtements organisés par catégories.

## Fonctionnalités

- **Catalogue de Vêtements**: Affichage des articles par catégories (Hauts, Bas, Sacs)
- **Filtres par Catégorie**: Navigation facile entre les différentes catégories
- **Recherche**: Barre de recherche pour trouver rapidement des articles
- **Affichage détaillé**: Vue détaillée de chaque article avec descriptions et notations
- **Gestion des favoris**: Possibilité d'ajouter/retirer des articles aux favoris
- **Compteur de Likes**: Chaque article affiche le nombre de likes reçus

## Architecture

L'application est construite avec une architecture MVVM (Model-View-ViewModel) pour une meilleure séparation des responsabilités:

- **Models**: Définition des structures de données (ClothingItem)
- **Views**: Composants d'interface utilisateur (HomeView, ClothingItemView, ClothingDetailView)
- **Services**: Gestion des données (MockDataService)

## Captures d'écran

- Page d'accueil/Catalogue avec navigation par catégories
- Vue détaillée des articles avec possibilité de partage
- Gestion des favoris et notations

## Utilisation

L'application permet aux utilisateurs de:
- Parcourir les vêtements par catégories
- Rechercher des articles spécifiques
- Voir les détails de chaque article
- Ajouter/retirer des articles aux favoris
- Consulter les notations des autres utilisateurs
- Partager leurs impressions sur les articles

## Développement

Développé en SwiftUI pour iOS 16+.

Pour lancer le projet:
1. Ouvrir le fichier `Joiefull.xcodeproj` dans Xcode
2. Sélectionner un simulateur ou un appareil
3. Appuyer sur le bouton "Run"
