# Window Resize — Manual de usuario

## Tabla de contenidos

1. [Configuracion inicial](#configuracion-inicial)
2. [Redimensionamiento por ajuste automatico](#redimensionamiento-por-ajuste-automatico)
3. [Atajos de teclado](#atajos-de-teclado)
4. [Ajustes](#ajustes)
5. [Solucion de problemas](#solucion-de-problemas)

---

## Configuracion inicial

### Conceder permiso de accesibilidad

Window Resize utiliza la API de accesibilidad de macOS para detectar y redimensionar ventanas. Debe conceder el permiso la primera vez que inicie la aplicacion.

1. Inicie **Window Resize**. Aparecera un dialogo del sistema solicitando acceso de accesibilidad.
2. Haga clic en **"Abrir Ajustes del Sistema"** (o vaya manualmente a **Ajustes del Sistema > Privacidad y seguridad > Accesibilidad**).
3. Busque **"Window Resize"** en la lista y active el interruptor.
4. Vuelva a la aplicacion: el icono de la barra de menus aparecera y la aplicacion estara lista para usar.

> **Nota:** Si el dialogo no aparece, puede abrir los ajustes de accesibilidad directamente desde la ventana de Ajustes de la aplicacion (consulte [Estado de accesibilidad](#estado-de-accesibilidad)).

---

## Redimensionamiento por ajuste automatico

### Como funciona

Window Resize monitoriza las operaciones de redimensionamiento de ventanas en tiempo real. Cuando arrastra el borde o la esquina de una ventana para redimensionarla, la aplicacion detecta la proximidad de las dimensiones de la ventana a cualquier tamano predefinido.

1. **Comience a redimensionar** — arrastre el borde o la esquina de cualquier ventana como lo haria normalmente.
2. **Aparece la superposicion** — cuando el tamano de la ventana se aproxima a un tamano predefinido (a menos de 50 pixeles de distancia), aparece una superposicion con un borde de color alrededor de la ventana que muestra el tamano de destino.
3. **Suelte para ajustar** — suelte el raton y la ventana se ajustara con precision al tamano predefinido.
4. **Cancelar** — si aleja el tamano de la ventana del valor predefinido antes de soltar, la superposicion desaparece y no se realiza ningun ajuste.

### Visualizacion de la relacion de aspecto

Durante el redimensionamiento, la relacion de aspecto actual se muestra en la superposicion. Cuando la relacion coincide con una proporcion conocida, se muestra su nombre:

- **√2** (1.414:1)
- **Proporción áurea** (1.618:1)
- **Proporción de plata** (2.414:1)
- **Número plástico** (1.325:1)
- **Proporción de bronce** (3.303:1)

Otras relaciones se muestran como fracciones simplificadas (por ejemplo, "16:9", "4:3").

> Esta funcion se puede desactivar en Ajustes (consulte [Pestana Apariencia](#pestana-apariencia)).

### Shift para bloquear la relacion de aspecto

Mantenga presionada la tecla **Shift** mientras redimensiona para bloquear la relacion de aspecto. La ventana mantendra sus proporciones actuales mientras arrastra.

> Esta funcion se puede desactivar en Ajustes (consulte [Pestana General](#pestana-general)).

---

## Atajos de teclado

Todos los atajos de teclado son completamente personalizables en la pestana Atajos de Ajustes. Valores predeterminados:

### Presets rapidos

Pulse **Control+Option+1** a **Control+Option+9** para redimensionar instantaneamente la ventana activa a un tamano predefinido con nombre. Un HUD centrado muestra brevemente el nombre del preset y el tamano.

| Atajo | Preset predeterminado |
|-------|----------------------|
| Control+Option+1 | Writing (1280 x 800) |
| Control+Option+2 | Reading (900 x 1200) |
| Control+Option+3 | Browsing (1440 x 900) |
| Control+Option+4 | Sidebar (720 x 900) |
| Control+Option+5 | Preview (1920 x 1080) |

Los Presets rapidos se pueden editar (nombre, tamano y atajo) en la pestana General de Ajustes. Se admiten hasta 9 presets.

### Redimensionamiento incremental

Redimensione la ventana activa en 10 pixeles por pulsacion de tecla, manteniendo la ventana centrada:

| Atajo | Accion |
|-------|--------|
| Control+Option+Right | Aumentar ancho (+10px) |
| Control+Option+Left | Reducir ancho (-10px) |
| Control+Option+Up | Aumentar altura (+10px) |
| Control+Option+Down | Reducir altura (-10px) |

### Modo de precision

Mantenga Shift para ajustes de 1 pixel:

| Atajo | Accion |
|-------|--------|
| Control+Option+Shift+Right | Aumentar ancho (+1px) |
| Control+Option+Shift+Left | Reducir ancho (-1px) |
| Control+Option+Shift+Up | Aumentar altura (+1px) |
| Control+Option+Shift+Down | Reducir altura (-1px) |

### Deshacer / Rehacer

| Atajo | Accion |
|-------|--------|
| Control+Option+Z | Deshacer ultimo redimensionamiento |
| Control+Option+Shift+Z | Rehacer |

Cada ventana mantiene su propio historial de deshacer/rehacer.

### Retroalimentacion HUD

Cuando utiliza un atajo de teclado, aparece un HUD centrado en la ventana de destino:

- **Preset rapido:** muestra el nombre del preset (por ejemplo, "Writing") con el tamano debajo (por ejemplo, "1280 x 800")
- **Redimensionamiento incremental:** muestra el tamano actual (por ejemplo, "1290 x 800")
- **Deshacer:** muestra "Restored" con el tamano restaurado

El HUD se muestra durante 0,8 segundos y luego se desvanece.

---

## Ajustes

Abra los Ajustes desde la barra de menus: haga clic en el icono de Window Resize y seleccione **"Ajustes..."**.

Los Ajustes estan organizados en 4 pestanas: **General**, **Apariencia**, **Atajos** y **Presets**.

### Pestana General

#### Presets rapidos

Configure hasta 9 Presets rapidos que se pueden aplicar mediante atajos de teclado (Control+Option+1-9). Cada preset tiene:

- **Atajo** — haga clic en el campo de atajo para registrar una nueva combinacion de teclas
- **Nombre** — un nombre descriptivo (por ejemplo, "Writing", "Coding")
- **Tamano** — ancho y alto en pixeles

Para agregar un preset, complete los campos de nombre, ancho y alto en la parte inferior y haga clic en **"Anadir"**. Para eliminar un preset, haga clic en el boton X junto a el.

#### Iniciar sesion automaticamente

Active **"Iniciar sesion automaticamente"** para que Window Resize se inicie automaticamente cuando inicie sesion en macOS.

#### Shift para bloquear relacion

Activa o desactiva la restriccion de relacion de aspecto al mantener presionada la tecla Shift durante el redimensionamiento. Predeterminado: activado.

#### Estado de accesibilidad

Un indicador de estado muestra el estado actual del permiso de accesibilidad:

| Indicador | Significado |
|-----------|-------------|
| Verde | El permiso esta activo y funciona correctamente. |
| Naranja | El permiso fue concedido pero ya no es valido (consulte [Corregir permisos obsoletos](#corregir-permisos-obsoletos)). |
| Rojo | El permiso no ha sido concedido. |

### Pestana Apariencia

Configure el estilo visual de la superposicion de ajuste:

- **Borde de redimensionamiento** — el color y el estilo de linea del borde mostrado al redimensionar. Elija entre 9 colores (rojo, naranja, amarillo, verde, cian, azul, morado, blanco, gris) y 4 estilos (ninguno, solida, discontinua, animada). Predeterminado: naranja, animada.
- **Borde de ajuste** — el borde mostrado cuando la ventana se ajusta a un tamano predefinido. Predeterminado: naranja, solida.
- **Mostrar relacion de aspecto** — activa o desactiva la etiqueta de relacion de aspecto en la superposicion. Predeterminado: activado.

### Pestana Atajos

Todos los atajos de teclado se muestran en una cuadricula de 2 columnas y se pueden personalizar individualmente:

1. Haga clic en el campo de atajo junto a cualquier accion.
2. Pulse la combinacion de teclas deseada (debe incluir al menos una tecla modificadora).
3. Pulse **Escape** para cancelar la grabacion.

Si registra un atajo que entra en conflicto con otra accion de la aplicacion, aparece un dialogo de alerta con las opciones **Reemplazar** (reasignar el atajo) o **Cancelar**.

Aparece un icono de advertencia junto a los atajos que entran en conflicto con atajos del sistema conocidos (Mission Control, Spotlight, etc.).

Haga clic en **"Restablecer valores predeterminados"** para restaurar todos los atajos a sus asignaciones originales.

### Pestana Presets

La pestana Presets muestra 18 tamanos predefinidos integrados ordenados por area de pixeles (de menor a mayor). Cada preset tiene un interruptor de activar/desactivar:

- **Activado** — el preset se utiliza para la deteccion de ajuste durante el redimensionamiento
- **Desactivado** — el preset se excluye de la deteccion de ajuste (se muestra con 50% de opacidad)

Los presets integrados no se pueden eliminar, solo desactivar. Por defecto, 6 presets especificos de Mac (tamanos de pantalla de MacBook Air/Pro) estan desactivados, y 12 presets de uso general estan activados.

El encabezado muestra cuantos presets estan habilitados actualmente (por ejemplo, "12 of 18 enabled").

---

## Solucion de problemas

### Corregir permisos obsoletos

Si ve un indicador de estado naranja o el mensaje "Accesibilidad: necesita actualizarse", el permiso se ha vuelto obsoleto. Esto puede ocurrir despues de actualizar o recompilar la aplicacion.

**Para corregirlo:**

1. Abra **Ajustes del Sistema > Privacidad y seguridad > Accesibilidad**.
2. Busque **"Window Resize"** en la lista.
3. Desactive el interruptor y vuelva a **activarlo**.
4. Alternativamente, eliminelo de la lista completamente y vuelva a iniciar la aplicacion para agregarlo de nuevo.

### El ajuste no funciona

Si la superposicion no aparece durante el redimensionamiento:

- Compruebe que el permiso de accesibilidad este activo (indicador verde en Ajustes).
- Asegurese de que la ventana que esta redimensionando admita el redimensionamiento estandar (algunas aplicaciones restringen el tamano de sus ventanas).
- Las ventanas en modo de pantalla completa no se pueden redimensionar — salga del modo de pantalla completa primero.
- Compruebe la pestana Presets — el tamano de destino puede estar desactivado.

### Problemas de renderizado tras el ajuste

En casos excepcionales, la ventana de destino puede no redibujarse correctamente despues del ajuste. La aplicacion fuerza automaticamente un redibujado, pero si los artefactos visuales persisten, intente minimizar y restaurar la ventana.
