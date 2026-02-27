# Window Resize — Manuel d'utilisation

## Table des matières

1. [Configuration initiale](#configuration-initiale)
2. [Redimensionner une fenêtre](#redimensionner-une-fenêtre)
3. [Paramètres](#paramètres)
4. [Dépannage](#dépannage)

---

## Configuration initiale

### Accorder l'autorisation d'accessibilité

Window Resize utilise l'API d'accessibilité de macOS pour redimensionner les fenêtres. Vous devez accorder l'autorisation lors du premier lancement de l'application.

1. Lancez **Window Resize**. Une boîte de dialogue système apparaîtra pour vous demander d'accorder l'accès à l'accessibilité.
2. Cliquez sur **"Ouvrir les réglages"** (ou accédez manuellement à **Réglages du système > Confidentialité et sécurité > Accessibilité**).
3. Recherchez **"Window Resize"** dans la liste et activez l'interrupteur.
4. Revenez à l'application — l'icône dans la barre des menus apparaîtra et l'application sera prête à être utilisée.

> **Remarque :** Si la boîte de dialogue n'apparaît pas, vous pouvez ouvrir les réglages d'accessibilité directement depuis la fenêtre des Paramètres de l'application (voir [État de l'accessibilité](#état-de-laccessibilité)).

---

## Redimensionner une fenêtre

### Étape par étape

1. Cliquez sur l'**icône de Window Resize** dans la barre des menus.
2. Survolez **"Redimensionner"** pour ouvrir la liste des fenêtres.
3. Toutes les fenêtres ouvertes sont affichées avec leur **icône d'application** et leur nom sous la forme **[Nom de l'app] Titre de la fenêtre**. Les titres longs sont automatiquement tronqués pour garder le menu lisible.
4. Survolez une fenêtre pour voir les tailles prédéfinies disponibles.
5. Cliquez sur une taille pour redimensionner la fenêtre immédiatement.

### Affichage des tailles

Chaque entrée de taille dans le menu affiche :

```
1920 x 1080          Full HD
```

- **Gauche :** Largeur x Hauteur (en pixels)
- **Droite :** Étiquette (nom de l'appareil ou nom standard), affichée en gris

### Tailles dépassant l'écran

Si une taille prédéfinie est plus grande que l'écran où se trouve la fenêtre, cette taille sera **grisée et non sélectionnable**. Cela vous empêche de redimensionner une fenêtre au-delà des limites de l'écran.

> **Multi-écran :** L'application détecte sur quel écran se trouve chaque fenêtre et ajuste les tailles disponibles en conséquence.

---

## Paramètres

Ouvrez les Paramètres depuis la barre des menus : cliquez sur l'icône de Window Resize, puis sélectionnez **"Paramètres..."** (raccourci : **⌘,**).

### Tailles intégrées

L'application comprend 12 tailles prédéfinies intégrées :

| Taille | Étiquette |
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

Les tailles intégrées ne peuvent être ni supprimées ni modifiées.

### Tailles personnalisées

Vous pouvez ajouter vos propres tailles à la liste :

1. Dans la section **"Personnalisées"**, saisissez la **Largeur** et la **Hauteur** en pixels.
2. Cliquez sur **"Ajouter"**.
3. La nouvelle taille apparaît dans la liste personnalisée et est immédiatement disponible dans le menu de redimensionnement.

Pour supprimer une taille personnalisée, cliquez sur le bouton rouge **"Supprimer"** à côté.

> Les tailles personnalisées apparaissent dans le menu de redimensionnement après les tailles intégrées.

### Lancer au démarrage

Activez **"Lancer au démarrage"** pour que Window Resize se lance automatiquement lorsque vous vous connectez à macOS.

### Capture d'écran

Activez **"Capturer après le redimensionnement"** pour capturer automatiquement la fenêtre après le redimensionnement.

Lorsque cette option est activée, les options suivantes sont disponibles :

- **Enregistrer dans un fichier** — Enregistre la capture en tant que fichier PNG. Lorsque cette option est activée, choisissez l'emplacement d'enregistrement :
  > **Format du nom de fichier :** `MMddHHmmss_NomApp_TitreFenêtre.png` (ex. `0227193012_Safari_Apple.png`). Les symboles sont supprimés ; seuls les lettres, chiffres et tirets bas sont utilisés.
  - **Bureau** — Enregistrer dans le dossier Bureau.
  - **Images** — Enregistrer dans le dossier Images.
- **Copier dans le presse-papiers** — Copie la capture dans le presse-papiers pour la coller dans d'autres applications.

Les deux options peuvent être activées indépendamment. Par exemple, vous pouvez copier dans le presse-papiers sans enregistrer dans un fichier.

> **Remarque :** La fonction de capture d'écran nécessite l'autorisation d'**Enregistrement d'écran**. Lorsque vous utilisez cette fonction pour la première fois, macOS vous demandera d'accorder l'autorisation dans **Réglages du système > Confidentialité et sécurité > Enregistrement d'écran**.

### État de l'accessibilité

En bas de la fenêtre des Paramètres, un indicateur d'état montre l'état actuel de l'autorisation d'accessibilité :

| Indicateur | Signification |
|------------|---------------|
| 🟢 **Accessibilité : activée** | L'autorisation est active et fonctionne correctement. |
| 🟠 **Accessibilité : actualisation requise** | Le système indique que l'autorisation a été accordée, mais elle n'est plus valide (voir [Corriger les autorisations obsolètes](#corriger-les-autorisations-obsolètes)). Un bouton **"Ouvrir les réglages"** est affiché. |
| 🔴 **Accessibilité : désactivée** | L'autorisation n'a pas été accordée. Un bouton **"Ouvrir les réglages"** est affiché. |

---

## Dépannage

### Corriger les autorisations obsolètes

Si vous voyez un indicateur de statut orange ou le message "Accessibilité : actualisation requise", l'autorisation est devenue obsolète. Cela peut se produire après une mise à jour ou une recompilation de l'application.

**Pour corriger :**

1. Ouvrez **Réglages du système > Confidentialité et sécurité > Accessibilité**.
2. Recherchez **"Window Resize"** dans la liste.
3. Désactivez l'interrupteur, puis **réactivez-le**.
4. Alternativement, supprimez-le de la liste entièrement, puis relancez l'application pour le rajouter.

### Échec du redimensionnement

Si vous voyez une alerte « Échec du redimensionnement », les causes possibles incluent :

- L'application cible ne prend pas en charge le redimensionnement par accessibilité.
- La fenêtre est en **mode plein écran** (quittez d'abord le mode plein écran).
- L'autorisation d'accessibilité n'est pas active (vérifiez l'état dans les Paramètres).

### La fenêtre n'apparaît pas dans la liste

Le menu de redimensionnement n'affiche que les fenêtres qui :

- Sont actuellement visibles à l'écran
- Ne font pas partie du bureau (par exemple, le bureau du Finder est exclu)
- Ne sont pas les propres fenêtres de Window Resize

Si une fenêtre est minimisée dans le Dock, elle n'apparaîtra pas dans la liste.

### La capture d'écran ne fonctionne pas

Si les captures d'écran ne sont pas effectuées :

- Accordez l'autorisation d'**Enregistrement d'écran** dans **Réglages du système > Confidentialité et sécurité > Enregistrement d'écran**.
- Assurez-vous qu'au moins une des options **"Enregistrer dans un fichier"** ou **"Copier dans le presse-papiers"** est activée.
