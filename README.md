# VIC-CONNECT

Application Android du **Lycée technique et moderne VIC-INTELLIGENTSIA**.

## Connexion Supabase

Le projet est déjà configuré avec :

- URL : `https://dcxfshorvdaypqyugeil.supabase.co`
- Clé : clé Publishable Supabase fournie pour l'application.

Cette clé est destinée à être utilisée côté application cliente. **Ne mettez jamais une clé `service_role` ou une clé secrète dans l'application ou GitHub.**

## Compilation GitHub automatique

Le fichier `.github/workflows/android.yml` lance automatiquement la compilation dès qu'un commit est envoyé sur la branche `main`.

Après l'ajout du projet sur GitHub :

1. Créez un dépôt GitHub vide.
2. Importez/décompressez tout le contenu de ce ZIP dans le dépôt.
3. Faites le premier commit sur `main`.
4. GitHub lance automatiquement **Actions → Build VIC-CONNECT Android**.
5. À la fin, l'APK est disponible dans l'artefact **VIC-CONNECT-debug-apk**.

Aucun secret GitHub n'est nécessaire pour cette première version car la clé Publishable n'est pas une clé serveur secrète et l'URL/la clé sont déjà configurées dans le projet.

## Matières du collège

La base comprend notamment Français, Anglais, Mathématiques, Sciences Physiques, SVT, Histoire-Géographie, Informatique, EPS, Technologie et Éducation Civique. Le ministère du Togo décrit le collège comme le Cycle secondaire 1 (6e à 3e) et ses ressources pédagogiques récentes couvrent notamment mathématiques, français, physique-chimie, technologie et SVT. Les programmes rénovés mentionnent aussi les TIC et les valeurs citoyennes.

## Important

Le fichier `supabase/schema-corrige.sql` est la version complète du schéma SQL corrigé déjà exécutée dans Supabase. Il est conservé dans le projet comme référence.

## Correctif du 17/09/2026
- `supabase/schema-corrige.sql` contient maintenant la correction définitive de `digest()` en utilisant `extensions.digest()`.
- `supabase/migration-fix-codes.sql` est une migration NON DESTRUCTIVE à exécuter si la base VIC-CONNECT existe déjà. Elle corrige les codes sans supprimer les données et ajoute `admin_create_parent()`.
- L'interface Web utilise désormais `admin_create_parent()` pour créer les parents seuls.
- Le menu Super Admin met clairement en évidence la rubrique active en temps réel.
