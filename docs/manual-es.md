# Window Resize — Manual de usuario

## Tabla de contenidos

1. [Configuración inicial](#configuración-inicial)
2. [Redimensionamiento por ajuste automático](#redimensionamiento-por-ajuste-automático)
3. [Ajustes](#ajustes)
4. [Solución de problemas](#solución-de-problemas)

---

## Configuración inicial

### Conceder permiso de accesibilidad

Window Resize utiliza la API de accesibilidad de macOS para detectar y redimensionar ventanas. Debe conceder el permiso la primera vez que inicie la aplicación.

1. Inicie **Window Resize**. Aparecerá un diálogo del sistema solicitando acceso de accesibilidad.
2. Haga clic en **"Abrir Ajustes del Sistema"** (o vaya manualmente a **Ajustes del Sistema > Privacidad y seguridad > Accesibilidad**).
3. Busque **"Window Resize"** en la lista y active el interruptor.
4. Vuelva a la aplicación: el icono de la barra de menús aparecerá y la aplicación estará lista para usar.

> **Nota:** Si el diálogo no aparece, puede abrir los ajustes de accesibilidad directamente desde la ventana de Ajustes de la aplicación (consulte [Estado de accesibilidad](#estado-de-accesibilidad)).

---

## Redimensionamiento por ajuste automático

### Cómo funciona

Window Resize monitoriza las operaciones de redimensionamiento de ventanas en tiempo real. Cuando arrastra el borde o la esquina de una ventana para redimensionarla, la aplicación detecta la proximidad de las dimensiones de la ventana a cualquier tamaño predefinido.

1. **Comience a redimensionar** — arrastre el borde o la esquina de cualquier ventana como lo haría normalmente.
2. **Aparece la superposición** — cuando el tamaño de la ventana se aproxima a un tamaño predefinido (a menos de 30 píxeles de distancia), aparece una superposición con un borde de color alrededor de la ventana que muestra el tamaño de destino.
3. **Suelte para ajustar** — suelte el ratón y la ventana se ajustará con precisión al tamaño predefinido.
4. **Cancelar** — si aleja el tamaño de la ventana del valor predefinido antes de soltar, la superposición desaparece y no se realiza ningún ajuste.

### Visualización de la relación de aspecto

Durante el redimensionamiento, la relación de aspecto actual se muestra en la superposición. Cuando la relación coincide con una proporción conocida, se muestra su nombre:

- **Proporción áurea** (1,618:1)
- **Proporción de plata** (2,414:1)
- **Proporción de platino** (1,325:1)
- **Proporción de bronce** (3,303:1)

Otras relaciones se muestran como fracciones simplificadas (por ejemplo, "16:9", "4:3").

> Esta función se puede desactivar en Ajustes (consulte [Mostrar relación de aspecto](#apariencia-de-la-superposición)).

### Shift para bloquear la relación de aspecto

Mantenga presionada la tecla **Shift** mientras redimensiona para bloquear la relación de aspecto. La ventana mantendrá sus proporciones actuales mientras arrastra.

> Esta función se puede desactivar en Ajustes (consulte [Shift para bloquear relación](#apariencia-de-la-superposición)).

---

## Ajustes

Abra los Ajustes desde la barra de menús: haga clic en el icono de Window Resize y seleccione **"Ajustes..."** (atajo: **Cmd+,**).

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
3. El nuevo tamaño estará disponible de inmediato para la detección de ajuste durante el redimensionamiento.

Para eliminar un tamaño personalizado, haga clic en el botón rojo **"Eliminar"** junto a él.

### Apariencia de la superposición

Configure el estilo visual de la superposición de ajuste:

- **Borde de redimensionamiento** — el color y el estilo de línea (sólida o discontinua) del borde que se muestra al redimensionar cerca de un tamaño predefinido. Predeterminado: naranja, discontinua.
- **Borde de ajuste** — el color y el estilo de línea del borde que se muestra cuando la ventana se ajusta a un tamaño predefinido. Predeterminado: naranja, sólida.
- **Mostrar relación de aspecto** — activa o desactiva la etiqueta de relación de aspecto en la superposición. Predeterminado: activado.
- **Shift para bloquear relación** — activa o desactiva la restricción de relación de aspecto al mantener presionada la tecla Shift durante el redimensionamiento. Predeterminado: activado.

Colores de borde disponibles: Naranja, Azul, Verde, Rojo, Morado, Blanco.

### Iniciar sesión automáticamente

Active **"Iniciar sesión automáticamente"** para que Window Resize se inicie automáticamente cuando inicie sesión en macOS.

### Idioma

Seleccione el idioma de la aplicación en el menú desplegable **Idioma**. Puede elegir entre 16 idiomas o **"Idioma del sistema"** para seguir el idioma configurado en macOS. Para que el cambio de idioma surta efecto es necesario reiniciar la aplicación.

### Estado de accesibilidad

En la parte inferior de la ventana de Ajustes, un indicador de estado muestra el estado actual del permiso de accesibilidad:

| Indicador | Significado |
|-----------|-------------|
| Verde | El permiso está activo y funciona correctamente. |
| Naranja | El sistema informa que el permiso fue concedido, pero ya no es válido (consulte [Corregir permisos obsoletos](#corregir-permisos-obsoletos)). Se muestra un botón "Abrir Ajustes". |
| Rojo | El permiso no ha sido concedido. Se muestra un botón "Abrir Ajustes". |

---

## Solución de problemas

### Corregir permisos obsoletos

Si ve un indicador de estado naranja o el mensaje "Accesibilidad: necesita actualizarse", el permiso se ha vuelto obsoleto. Esto puede ocurrir después de actualizar o recompilar la aplicación.

**Para corregirlo:**

1. Abra **Ajustes del Sistema > Privacidad y seguridad > Accesibilidad**.
2. Busque **"Window Resize"** en la lista.
3. Desactive el interruptor y vuelva a **activarlo**.
4. Alternativamente, elimínelo de la lista completamente y vuelva a iniciar la aplicación para agregarlo de nuevo.

### El ajuste no funciona

Si la superposición no aparece durante el redimensionamiento:

- Compruebe que el permiso de accesibilidad esté activo (indicador verde en Ajustes).
- Asegúrese de que la ventana que está redimensionando admita el redimensionamiento estándar (algunas aplicaciones restringen el tamaño de sus ventanas).
- Las ventanas en modo de pantalla completa no se pueden redimensionar — salga del modo de pantalla completa primero.

### Problemas de renderizado tras el ajuste

En casos excepcionales, la ventana de destino puede no redibujarse correctamente después del ajuste. La aplicación fuerza automáticamente un redibujado, pero si los artefactos visuales persisten, intente minimizar y restaurar la ventana.
