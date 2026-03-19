# Window Resize — Manuel d'utilisation

## Table des matieres

1. [Configuration initiale](#configuration-initiale)
2. [Redimensionnement par snap](#redimensionnement-par-snap)
3. [Parametres](#parametres)
4. [Depannage](#depannage)

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

### Affichage du rapport d'aspect

Pendant le redimensionnement, le rapport d'aspect actuel est affiche dans l'overlay. Lorsque le rapport correspond a une proportion connue, son nom est indique :

- **Nombre d'or** (1.618:1)
- **Nombre d'argent** (2.414:1)
- **Nombre de platine** (1.325:1)
- **Nombre de bronze** (3.303:1)

Les autres rapports sont affiches sous forme de fractions simplifiees (par ex. "16:9", "4:3").

> Cette fonction peut etre desactivee dans les Parametres (voir [Apparence de l'overlay](#apparence-de-loverlay)).

### Shift pour verrouiller le rapport d'aspect

Maintenez la touche **Shift** enfoncee pendant le redimensionnement pour verrouiller le rapport d'aspect. La fenetre conservera ses proportions actuelles pendant que vous faites glisser.

> Cette fonction peut etre desactivee dans les Parametres (voir [Shift pour verrouiller le rapport](#apparence-de-loverlay)).

---

## Parametres

Ouvrez les Parametres depuis la barre des menus : cliquez sur l'icone de Window Resize, puis selectionnez **"Parametres..."** (raccourci : **Cmd+,**).

### Tailles integrees

L'application comprend 12 tailles predefinies integrees :

| Taille | Etiquette |
|--------|-----------|
| 2560 x 1600 | MacBook Pro 16" |
| 2560 x 1440 | QHD / iMac |
| 1728 x 1117 | MacBook Pro 14" |
| 1512 x 982 | MacBook Air 15" |
| 1470 x 956 | MacBook Air 13" M3 |
| 1440 x 900 | MacBook Air 13" |
| 1920 x 1080 | Full HD |
| 1680 x 1050 | WSXGA+ |
| 1280 x 800 | WXGA |
| 1280 x 720 | HD |
| 1024 x 768 | XGA |
| 800 x 600 | SVGA |

Les tailles integrees ne peuvent etre ni supprimees ni modifiees.

### Tailles personnalisees

Vous pouvez ajouter vos propres tailles a la liste :

1. Dans la section **"Personnalisees"**, saisissez la **Largeur** et la **Hauteur** en pixels.
2. Cliquez sur **"Ajouter"**.
3. La nouvelle taille est immediatement disponible pour la detection de snap pendant le redimensionnement.

Pour supprimer une taille personnalisee, cliquez sur le bouton rouge **"Supprimer"** a cote.

### Apparence de l'overlay

Configurez le style visuel de l'overlay de snap :

- **Bordure de redimensionnement** — la couleur et le style de ligne (continu ou pointille) de la bordure affichee lorsque la fenetre est proche d'une taille predefinie pendant le redimensionnement. Par defaut : orange, pointille.
- **Bordure de snap** — la couleur et le style de ligne de la bordure affichee lorsque la fenetre s'ajuste a une taille predefinie. Par defaut : orange, continu.
- **Afficher le rapport d'aspect** — activer ou desactiver l'affichage du rapport d'aspect dans l'overlay. Par defaut : active.
- **Shift pour verrouiller le rapport** — activer ou desactiver le verrouillage du rapport d'aspect en maintenant Shift pendant le redimensionnement. Par defaut : active.

Couleurs de bordure disponibles : Orange, Bleu, Vert, Rouge, Violet, Blanc.

### Lancer au demarrage

Activez **"Lancer au demarrage"** pour que Window Resize se lance automatiquement lorsque vous vous connectez a macOS.

### Langue

Selectionnez la langue d'affichage de l'application dans le menu deroulant **Langue**. Vous pouvez choisir parmi 16 langues ou selectionner **"Langue du systeme"** pour suivre la langue definie dans macOS. Un redemarrage de l'application est necessaire pour appliquer le changement.

### Etat de l'accessibilite

En bas de la fenetre des Parametres, un indicateur d'etat montre l'etat actuel de l'autorisation d'accessibilite :

| Indicateur | Signification |
|------------|---------------|
| Vert | L'autorisation est active et fonctionne correctement. |
| Orange | Le systeme indique que l'autorisation a ete accordee, mais elle n'est plus valide (voir [Corriger les autorisations obsoletes](#corriger-les-autorisations-obsoletes)). Un bouton "Ouvrir les reglages" est affiche. |
| Rouge | L'autorisation n'a pas ete accordee. Un bouton "Ouvrir les reglages" est affiche. |

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

### Problemes d'affichage apres un snap

Dans de rares cas, la fenetre cible peut ne pas se redessiner correctement apres un snap. L'application force automatiquement un rafraichissement, mais si des artefacts visuels persistent, essayez de minimiser puis de restaurer la fenetre.
