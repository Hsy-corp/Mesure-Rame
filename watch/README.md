# Version Apple Watch

App watchOS autonome (marche sans l'iPhone). Même saisie que l'app web : halle → wagons → bobines → largeurs gauche/droite.

## Installation (sur un Mac avec Xcode 15+)
1. Xcode → File → New → Project → watchOS → **App**, cocher *Watch-only App*. Nom : MesureRame.
2. Supprimer les fichiers `.swift` générés, glisser les 3 fichiers de ce dossier dans le projet.
3. Brancher l'iPhone (la montre doit être jumelée), choisir la montre comme cible, Run.
   Un compte Apple gratuit suffit pour tester (l'app expire après 7 jours ; 99 €/an pour une installation durable).

## Limites
- Pas d'export PDF ni de récap détaillé : les données restent sur la montre.
- Pas de choix du sens de saisie (dernier wagon en premier) : liste dans l'ordre 1 → n.
