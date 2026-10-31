# Spec: Nebulosa

## requirements.md — QUÉ

### Visión General
Una nebulosa espiral generativa: una imagen estática de N estrellas dispuestas
en una espiral logarítmica con dispersión gaussiana, fundidas aditivamente para
producir resplandor.

### Objetivos
- Producir una imagen reconocible como espiral nebulosa.
- Explorar funciones de Processing no usadas antes en el libro.

### Alcance Negativo
- No es animada (no usa `draw()` en bucle).
- No es interactiva (no usa ratón ni teclado).
- No carga imágenes, fuentes ni recursos externos.

### Requisitos Funcionales (EARS)
- FR-001: La imagen SHALL disponer N=1500 estrellas en una espiral logarítmica
  de 4 vueltas, con radio máximo 360.
- FR-002: La dispersión de cada estrella SHALL seguir una distribución gaussiana
  de amplitud σ=18.
- FR-003: El color de cada estrella SHALL interpolar linealmente de RGB(255,210,120)
  a RGB(80,90,200) en función de su distancia normalizada al centro.
- FR-004: El radio de cada estrella SHALL interpolar de 5 a 1 en función de la
  misma distancia.
- FR-005: Las estrellas SHALL fundirse aditivamente (blendMode ADD) sobre fondo
  negro.
- FR-006: Un trazo curvo SHALL recorrer el brazo de la espiral.

### Restricciones
- Lienzo 800×800. Processing (Java). Imagen estática (`noLoop()`).

### Métricas de Éxito
- La imagen resultante se reconoce como espiral nebulosa.
- Ninguna estrella queda fuera del lienzo.

## design.md — CÓMO

### Resumen Ejecutivo
Un primer bucle genera los puntos de la espiral con jitter gaussiano y los guarda
en un array `PVector`; un trazo `curveVertex` recorre el brazo; un segundo bucle
dibuja las estrellas con color y radio interpolados por distancia.

### Mapeo de Requisitos
| FR | Diseño |
|----|--------|
| FR-001 | bucle de generación: `theta`, `r`, `pow` |
| FR-002 | `randomGaussian()` |
| FR-003 | `dist()` + `lerpColor()` |
| FR-004 | `lerp()` |
| FR-005 | `blendMode(ADD)` |
| FR-006 | `curveVertex()` |

## tasks.md — CUÁNTO

### T-001 — Implementar el sketch
- Cobertura: FR-001…FR-006.
- Estimación: 2–4 h (proyecto pequeño).
- Archivo: `sketch_nebulosa.pde`.
- Criterio de aceptación: ejecuta y guarda `nebulosa.png` con la espiral gaussiana
  y el resplandor aditivo.
