# Window Resize — Manuel d'utilisation

## Table des matieres

1. [Configuration initiale](#configuration-initiale)
2. [Redimensionnement par snap](#redimensionnement-par-snap)
3. [Raccourcis clavier](#raccourcis-clavier)
4. [Parametres](#parametres)
5. [Depannage](#depannage)

---

## Configuration initiale

### Accorder l'autorisation d'accessibilite

Window Resize utilise l'API d'accessibilite de macOS pour detecter et redimensionner les fenetres. Vous devez accorder l'autorisation lors du premier lancement de l'application.

1. Lancez **Window Resize**. Une boite de dialogue systeme apparaitra pour vous demander d'accorder l'acces a l'accessibilite.
2. Cliquez sur **"Ouvrir les reglages"** (ou accedez manuellement a **Reglages du systeme > Confidentialite et securite > Accessibilite**).
3. Recherchez **"Window Resize"** dans la liste et activez l'interrupteur.
4. Revenez a l'application — l'icone dans la barre des menus apparaitra et l'application sera prete a etre utilisee.

> **Remarque :** Si la boite de dialogue n'apparait pas, vous pouvez ouvrir les reglages d'accessibilite directement depuis la fenetre des Parametres de l'application (voir [Etat de l'accessibilite](#etat-de-laccessibilite)).

---

## Redimensionnement par snap

### Fonctionnement

Window Resize surveille les operations de redimensionnement des fenetres en temps reel. Lorsque vous faites glisser le bord ou le coin d'une fenetre pour la redimensionner, l'application detecte a quel point les dimensions de la fenetre sont proches d'une taille predefinie.

1. **Commencez a redimensionner** — faites glisser le bord ou le coin d'une fenetre comme vous le feriez normalement.
2. **L'overlay apparait** — lorsque la taille de la fenetre s'approche d'une taille predefinie (a moins de 30 pixels), une bordure coloree apparait autour de la fenetre indiquant la taille predefinie cible.
3. **Relachez pour snapper** — lachez le bouton de la souris et la fenetre s'ajuste precisement a la taille predefinie.
4. **Annuler** — si vous eloignez la taille de la fenetre de la taille predefinie avant de relacher, l'overlay disparait et aucun snap ne se produit.

### Snap par deplacement

Faites glisser une fenetre vers un bord ou un coin de l'ecran pour la positionner automatiquement :

- **Snap de bord** (gauche/droite) — remplit la hauteur, conserve la largeur
- **Snap de bord** (haut/bas) — remplit la largeur, conserve la hauteur
- **Snap de coin** — positionne la fenetre dans le coin, conserve les deux dimensions

### Affichage du rapport d'aspect

Pendant le redimensionnement, le rapport d'aspect actuel est affiche dans l'overlay. Lorsque le rapport correspond a une proportion connue, son nom est indique :

- **Nombre d'or** (1.618:1)
- **Nombre d'argent** (2.414:1)
- **Nombre de platine** (1.325:1)
- **Nombre de bronze** (3.303:1)

Les autres rapports sont affiches sous forme de fractions simplifiees (par ex. "16:9", "4:3").

> Cette fonction peut etre desactivee dans les Parametres (voir [Onglet Apparence](#onglet-apparence)).

### Shift pour verrouiller le rapport d'aspect

Maintenez la touche **Shift** enfoncee pendant le redimensionnement pour verrouiller le rapport d'aspect. La fenetre conservera ses proportions actuelles pendant que vous faites glisser.

> Cette fonction peut etre desactivee dans les Parametres (voir [Onglet Apparence](#onglet-apparence)).

---

## Raccourcis clavier

Tous les raccourcis clavier sont entierement personnalisables dans l'onglet Raccourcis des Parametres. Valeurs par defaut :

### Preselections rapides

Appuyez sur **Control+Option+1** a **Control+Option+9** pour redimensionner instantanement la fenetre au premier plan selon une preselection nommee. Un HUD centre affiche brievement le nom et la taille de la preselection.

| Raccourci | Preselection par defaut |
|-----------|------------------------|
| Control+Option+1 | Writing (1280 x 800) |
| Control+Option+2 | Reading (900 x 1200) |
| Control+Option+3 | Browsing (1440 x 900) |
| Control+Option+4 | Sidebar (720 x 900) |
| Control+Option+5 | Preview (1920 x 1080) |

Les preselections rapides peuvent etre modifiees (nom, taille et raccourci) dans l'onglet General des Parametres. Jusqu'a 9 preselections sont prises en charge.

### Redimensionnement incremental

Redimensionnez la fenetre au premier plan de 10 pixels par touche, en gardant la fenetre centree :

| Raccourci | Action |
|-----------|--------|
| Control+Option+Right | Augmenter la largeur (+10px) |
| Control+Option+Left | Reduire la largeur (-10px) |
| Control+Option+Up | Augmenter la hauteur (+10px) |
| Control+Option+Down | Reduire la hauteur (-10px) |

### Mode precision

Maintenez Shift pour des ajustements de 1 pixel :

| Raccourci | Action |
|-----------|--------|
| Control+Option+Shift+Right | Augmenter la largeur (+1px) |
| Control+Option+Shift+Left | Reduire la largeur (-1px) |
| Control+Option+Shift+Up | Augmenter la hauteur (+1px) |
| Control+Option+Shift+Down | Reduire la hauteur (-1px) |

### Annuler / Retablir

| Raccourci | Action |
|-----------|--------|
| Control+Option+Z | Annuler le dernier redimensionnement |
| Control+Option+Shift+Z | Retablir |

Chaque fenetre conserve son propre historique d'annulation/retablissement.

### Retour HUD

Lorsque vous utilisez un raccourci clavier, un HUD centre apparait sur la fenetre cible :

- **Preselection rapide :** affiche le nom de la preselection (par ex. "Writing") avec la taille en dessous (par ex. "1280 x 800")
- **Redimensionnement incremental :** affiche la taille actuelle (par ex. "1290 x 800")
- **Annuler :** affiche "Restored" avec la taille restauree

Le HUD s'affiche pendant 0,8 seconde puis disparait progressivement.

---

## Parametres

Ouvrez les Parametres depuis la barre des menus : cliquez sur l'icone de Window Resize, puis selectionnez **"Parametres..."**.

Les Parametres sont organises en 4 onglets : **General**, **Apparence**, **Raccourcis** et **Preselections**.

### Onglet General

#### Preselections rapides

Configurez jusqu'a 9 preselections rapides applicables via des raccourcis clavier (Control+Option+1-9). Chaque preselection comprend :

- **Raccourci** — cliquez sur le champ de raccourci pour enregistrer une nouvelle combinaison de touches
- **Nom** — un nom descriptif (par ex. "Writing", "Coding")
- **Taille** — largeur et hauteur en pixels

Pour ajouter une preselection, remplissez les champs de nom, largeur et hauteur en bas et cliquez sur **"Ajouter"**. Pour supprimer une preselection, cliquez sur le bouton X a cote.

#### Lancer au demarrage

Activez **"Lancer au demarrage"** pour que Window Resize se lance automatiquement lorsque vous vous connectez a macOS.

#### Langue

Selectionnez la langue d'affichage de l'application dans le menu deroulant. Vous pouvez choisir parmi 16 langues ou selectionner **"Langue du systeme"** pour suivre la langue definie dans macOS. Un redemarrage de l'application est necessaire pour appliquer le changement.

#### Etat de l'accessibilite

Un indicateur d'etat montre l'etat actuel de l'autorisation d'accessibilite :

| Indicateur | Signification |
|------------|---------------|
| Vert | L'autorisation est active et fonctionne correctement. |
| Orange | L'autorisation a ete accordee mais n'est plus valide (voir [Corriger les autorisations obsoletes](#corriger-les-autorisations-obsoletes)). |
| Rouge | L'autorisation n'a pas ete accordee. |

### Onglet Apparence

Configurez le style visuel de l'overlay de snap :

- **Bordure de redimensionnement** — la couleur et le style de ligne de la bordure affichee pendant le redimensionnement. Choisissez parmi 9 couleurs (rouge, orange, jaune, vert, cyan, bleu, violet, blanc, gris) et 4 styles (aucun, continu, pointille, anime). Par defaut : blanc, anime.
- **Bordure de snap** — la bordure affichee lorsque la fenetre s'ajuste a une taille predefinie. Par defaut : blanc, continu.
- **Afficher le rapport d'aspect** — activer ou desactiver l'affichage du rapport d'aspect dans l'overlay. Par defaut : active.
- **Shift pour verrouiller le rapport** — activer ou desactiver le verrouillage du rapport d'aspect en maintenant Shift. Par defaut : active.

### Onglet Raccourcis

Tous les raccourcis clavier sont affiches dans une grille a 2 colonnes et peuvent etre personnalises individuellement :

1. Cliquez sur le champ de raccourci a cote d'une action.
2. Appuyez sur la combinaison de touches souhaitee (doit inclure au moins une touche de modification).
3. Appuyez sur **Escape** pour annuler l'enregistrement.

Si vous enregistrez un raccourci qui entre en conflit avec une autre action de l'application, une boite de dialogue d'alerte propose de **Remplacer** (reassigner le raccourci) ou **Annuler**.

Une icone d'avertissement apparait a cote des raccourcis qui entrent en conflit avec des raccourcis systeme connus (Mission Control, Spotlight, etc.).

Cliquez sur **"Reinitialiser les valeurs par defaut"** pour restaurer tous les raccourcis a leurs affectations d'origine.

### Onglet Preselections

L'onglet Preselections affiche 18 tailles predefinies integrees triees par surface en pixels (de la plus petite a la plus grande). Chaque preselection dispose d'un interrupteur activer/desactiver :

- **Activee** — la preselection est utilisee pour la detection de snap pendant le redimensionnement
- **Desactivee** — la preselection est exclue de la detection de snap (affichee a 50% d'opacite)

Les preselections integrees ne peuvent pas etre supprimees, seulement desactivees. Par defaut, 6 preselections specifiques aux Mac (tailles d'ecran MacBook Air/Pro) sont desactivees et 12 preselections a usage general sont activees.

L'en-tete indique le nombre de preselections actuellement activees (par ex. "12 of 18 enabled").

---

## Depannage

### Corriger les autorisations obsoletes

Si vous voyez un indicateur orange ou le message "Accessibilite : actualisation requise", l'autorisation est devenue obsolete. Cela peut se produire apres une mise a jour ou une recompilation de l'application.

**Pour corriger :**

1. Ouvrez **Reglages du systeme > Confidentialite et securite > Accessibilite**.
2. Recherchez **"Window Resize"** dans la liste.
3. Desactivez l'interrupteur, puis **reactivez-le**.
4. Alternativement, supprimez-le de la liste entierement, puis relancez l'application pour le rajouter.

### Le snap ne fonctionne pas

Si l'overlay n'apparait pas pendant le redimensionnement :

- Verifiez que l'autorisation d'accessibilite est active (indicateur vert dans les Parametres).
- Assurez-vous que la fenetre que vous redimensionnez prend en charge le redimensionnement standard (certaines applications restreignent la taille des fenetres).
- Les fenetres en plein ecran ne peuvent pas etre redimensionnees — quittez d'abord le mode plein ecran.
- Verifiez l'onglet Preselections — la taille cible pourrait etre desactivee.

### Problemes d'affichage apres un snap

Dans de rares cas, la fenetre cible peut ne pas se redessiner correctement apres un snap. L'application force automatiquement un rafraichissement, mais si des artefacts visuels persistent, essayez de minimiser puis de restaurer la fenetre.
