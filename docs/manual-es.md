# Window Resize — Manual de usuario

## Tabla de contenidos

1. [Configuración inicial](#configuración-inicial)
2. [Redimensionar una ventana](#redimensionar-una-ventana)
3. [Ajustes](#ajustes)
4. [Solución de problemas](#solución-de-problemas)

---

## Configuración inicial

### Conceder permiso de accesibilidad

Window Resize utiliza la API de accesibilidad de macOS para redimensionar ventanas. Debe conceder el permiso la primera vez que inicie la aplicación.

1. Inicie **Window Resize**. Aparecerá un diálogo del sistema solicitando acceso de accesibilidad.
2. Haga clic en **"Abrir Ajustes"** (o vaya manualmente a **Ajustes del Sistema > Privacidad y seguridad > Accesibilidad**).
3. Busque **"Window Resize"** en la lista y active el interruptor.
4. Vuelva a la aplicación: el icono de la barra de menús aparecerá y la aplicación estará lista para usar.

> **Nota:** Si el diálogo no aparece, puede abrir los ajustes de accesibilidad directamente desde la ventana de Ajustes de la aplicación (consulte [Estado de accesibilidad](#estado-de-accesibilidad)).

---

## Redimensionar una ventana

### Paso a paso

1. Haga clic en el **icono de Window Resize** en la barra de menús.
2. Pase el cursor sobre **"Redimensionar"** para abrir la lista de ventanas.
3. Todas las ventanas abiertas se muestran como **[Nombre de la app] Título de la ventana**.
4. Pase el cursor sobre una ventana para ver los tamaños predefinidos disponibles.
5. Haga clic en un tamaño para redimensionar la ventana inmediatamente.

### Cómo se muestran los tamaños

Cada entrada de tamaño en el menú muestra:

```
1920 x 1080          Full HD
```

- **Izquierda:** Ancho x Alto (en píxeles)
- **Derecha:** Etiqueta (nombre del dispositivo o nombre estándar), mostrada en gris

### Tamaños que exceden la pantalla

Si un tamaño predefinido es mayor que la pantalla donde se encuentra la ventana, ese tamaño aparecerá **atenuado y no será seleccionable**. Esto evita que redimensione una ventana más allá de los límites de la pantalla.

> **Múltiples pantallas:** La aplicación detecta en qué pantalla se encuentra cada ventana y ajusta los tamaños disponibles en consecuencia.

---

## Ajustes

Abra los Ajustes desde la barra de menús: haga clic en el icono de Window Resize y seleccione **"Ajustes..."** (atajo: **⌘,**).

### Tamaños integrados

La aplicación incluye 12 tamaños predefinidos integrados:

| Tamaño | Etiqueta |
|--------|----------|
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

Los tamaños integrados no se pueden eliminar ni editar.

### Tamaños personalizados

Puede agregar sus propios tamaños a la lista:

1. En la sección **"Personalizados"**, introduzca el **Ancho** y el **Alto** en píxeles.
2. Haga clic en **"Añadir"**.
3. El nuevo tamaño aparecerá en la lista personalizada y estará disponible de inmediato en el menú de redimensionamiento.

Para eliminar un tamaño personalizado, haga clic en el botón rojo **"Eliminar"** junto a él.

> Los tamaños personalizados aparecen en el menú de redimensionamiento después de los tamaños integrados.

### Iniciar sesión automáticamente

Active **"Iniciar sesión automáticamente"** para que Window Resize se inicie automáticamente cuando inicie sesión en macOS.

### Captura de pantalla

Active **"Tomar captura después de redimensionar"** para capturar automáticamente la ventana después de redimensionarla.

Cuando está activada, las siguientes opciones están disponibles:

- **Guardar en archivo** — Guarda la captura como un archivo PNG. Cuando está activada, elija la ubicación de guardado:
  - **Escritorio** — Guardar en la carpeta Escritorio.
  - **Imágenes** — Guardar en la carpeta Imágenes.
- **Copiar al portapapeles** — Copia la captura al portapapeles para pegarla en otras aplicaciones.

Ambas opciones se pueden activar de forma independiente. Por ejemplo, puede copiar al portapapeles sin guardar en un archivo.

> **Nota:** La función de captura de pantalla requiere el permiso de **Grabación de pantalla**. Cuando utilice esta función por primera vez, macOS le pedirá que conceda el permiso en **Ajustes del Sistema > Privacidad y Seguridad > Grabación de pantalla**.

### Estado de accesibilidad

En la parte inferior de la ventana de Ajustes, un indicador de estado muestra el estado actual del permiso de accesibilidad:

| Indicador | Significado |
|-----------|-------------|
| 🟢 **Accesibilidad: activada** | El permiso está activo y funciona correctamente. |
| 🟠 **Accesibilidad: necesita actualizarse** | El sistema informa que el permiso fue concedido, pero ya no es válido (consulte [Corregir permisos obsoletos](#corregir-permisos-obsoletos)). Se muestra un botón **"Abrir Ajustes"**. |
| 🔴 **Accesibilidad: no activada** | El permiso no ha sido concedido. Se muestra un botón **"Abrir Ajustes"**. |

---

## Solución de problemas

### Corregir permisos obsoletos

Si ve un indicador de estado naranja o el mensaje "Accesibilidad: necesita actualizarse", el permiso se ha vuelto obsoleto. Esto puede ocurrir después de actualizar o recompilar la aplicación.

**Para corregirlo:**

1. Abra **Ajustes del Sistema > Privacidad y seguridad > Accesibilidad**.
2. Busque **"Window Resize"** en la lista.
3. Desactive el interruptor y vuelva a **activarlo**.
4. Alternativamente, elimínelo de la lista completamente y vuelva a iniciar la aplicación para agregarlo de nuevo.

### Error al redimensionar

Si ve una alerta de "Error al redimensionar", las posibles causas incluyen:

- La aplicación de destino no admite el redimensionamiento basado en accesibilidad.
- La ventana está en **modo de pantalla completa** (salga del modo de pantalla completa primero).
- El permiso de accesibilidad no está activo (compruebe el estado en Ajustes).

### La ventana no aparece en la lista

El menú de redimensionamiento solo muestra ventanas que:

- Están actualmente visibles en la pantalla
- No forman parte del escritorio (por ejemplo, el escritorio del Finder se excluye)
- No son las propias ventanas de Window Resize

Si una ventana está minimizada en el Dock, no aparecerá en la lista.

### La captura de pantalla no funciona

Si las capturas de pantalla no se están realizando:

- Conceda el permiso de **Grabación de pantalla** en **Ajustes del Sistema > Privacidad y Seguridad > Grabación de pantalla**.
- Asegúrese de que al menos una de las opciones **"Guardar en archivo"** o **"Copiar al portapapeles"** esté activada.
