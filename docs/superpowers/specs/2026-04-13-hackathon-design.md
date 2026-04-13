# Spec: Multi-Agent Hackathon — Design Library Plugin Improvement
**Date:** 2026-04-13  
**Branch:** `hackathon/improvements`  
**Status:** Approved

---

## Objetivo

Mejorar el design-library-plugin usando un flujo orquestado de subagentes: investigación con acceso a internet, hackathon paralelo con agentes Gemma locales, revisión cruzada y debate final.

---

## Arquitectura del flujo

```
Branch creation
    │
    ▼
Fase 1: Research (subagente general-purpose con WebSearch)
    │   → Lista priorizada de nuevas librerías/repos candidatos
    ▼
Fase 2: Hackathon paralelo (5 agentes Gemma especializados)
    ├── G-A: inject-context.sh
    ├── G-B: detect-project.sh
    ├── G-C: Skills (SKILL.md files)
    ├── G-D: sync.sh + repos externos
    └── G-E: Docs (README, CLAUDE.md)
    │   → Cada agente produce propuestas/diffs específicos
    ▼
Fase 2b: Revisor cruzado (1 agente Gemma)
    │   → Lee todos los outputs, detecta contradicciones, emite veredicto
    ▼
Claude aplica los cambios aprobados por el revisor
    ▼
Fase 3: Panel de debate (2 agentes Gemma)
    ├── G-Debate-1: Abogado del diablo (riesgos, regressions, complejidad)
    └── G-Debate-2: Defensor (valor aportado, coherencia, mejoras reales)
    │   → Claude sintetiza debate y decide qué commitear
    ▼
Commit + resumen de sesión con conteo de tokens
```

---

## Fase 1 — Research de nuevas librerías

**Ejecutor:** subagente general-purpose (Claude, con WebSearch)  
**Objetivo:** Encontrar repos/recursos no incluidos actualmente que aporten valor real al plugin.

**Criterios de búsqueda:**
- Design systems documentados en Markdown/JSON (integrable via sync.sh)
- Skills de web/UI interesantes con buena documentación
- Conectores de diseño: Figma Tokens, Style Dictionary, design token standards
- Repos con alta actividad y ≥500 ⭐
- Evitar duplicados con lo ya integrado (awesome-design-md, ui-ux-pro-max, etc.)

**Output esperado:** lista con nombre, URL, stars, categoría y justificación de integración.

---

## Fase 2 — Hackathon Paralelo (Gemma)

Todos los agentes Gemma reciben como contexto el archivo fuente relevante + instrucciones específicas. Claude lee su output y aplica con Edit/Write si el revisor lo aprueba.

### G-A — `inject-context.sh`
**Objetivo:** Mejorar detección de keywords y reducir falsos positivos.
- Revisar cada categoría de keywords (motion, a11y, guidelines, uiux, process, brand)
- Proponer keywords adicionales o más precisas
- Detectar posibles falsos positivos en KW_BRAND_TRIGGER
- Revisar edge cases en la lógica de matching
- Output: archivo mejorado completo

### G-B — `detect-project.sh`
**Objetivo:** Detectar más tipos de proyectos y hacer mejor matching de skills.
- Añadir detección de más frameworks (Remix, SvelteKit, Qwik, Nuxt, etc.)
- Mejorar heurísticas del Level 2 (solo README)
- Revisar el Level 3 (directorio vacío) — ¿las 3 preguntas son las correctas?
- Output: archivo mejorado completo

### G-C — Skills SKILL.md
**Objetivo:** Mejorar instrucciones de prompt engineering en cada skill.
- Revisar cada SKILL.md: `design-library`, `ui-ux`, `a11y`, `motion`, `guidelines`, `design-process`
- Hacer instrucciones más accionables y específicas
- Añadir ejemplos concretos donde falten
- Output: mejoras por archivo

### G-D — `sync.sh` + nuevos repos
**Objetivo:** Integrar nuevas librerías encontradas en Fase 1, mejorar el proceso de sync.
- Añadir nuevos repos de la Fase 1 al sync
- Revisar robustez del proceso de clonado/actualización
- Mejorar el mensaje de progreso/estado
- Output: sync.sh mejorado

### G-E — Documentación
**Objetivo:** Mejorar README.md y CLAUDE.md para onboarding más claro.
- Hacer más claro el quickstart
- Añadir ejemplos de uso de cada comando
- Actualizar tabla de skills con los nuevos repos de Fase 1
- Output: docs mejorados

---

## Fase 2b — Revisor Cruzado (Gemma)

**Input:** todos los outputs de G-A hasta G-E  
**Tarea:**
1. Detectar contradicciones entre propuestas
2. Identificar cambios que podrían romper el plugin
3. Detectar redundancias o mejoras que se pisen entre sí
4. Emitir veredicto: `APLICAR / APLICAR CON AJUSTE / DESCARTAR` para cada propuesta
5. Redactar resumen ejecutivo de qué aplicar y por qué

---

## Fase 3 — Panel de Debate (2 agentes Gemma)

### G-Debate-1: Abogado del Diablo
- ¿Qué cambios añaden complejidad sin valor proporcional?
- ¿Hay regressions potenciales en el hook UserPromptSubmit?
- ¿Los nuevos repos de Fase 1 tienen licencias compatibles?
- ¿Algún cambio rompe la compatibilidad con Claude Code plugin system?

### G-Debate-2: Defensor
- ¿Qué mejoras tienen mayor impacto en experiencia de usuario?
- ¿Los cambios son coherentes con la filosofía del plugin?
- ¿La complejidad añadida está justificada?

Claude sintetiza ambas posturas y toma la decisión final antes del commit.

---

## Token Tracking

| Modelo | Método |
|--------|--------|
| **Gemma** | `~/.gemma-usage.log` — automático por llamada. Timestamp de inicio de sesión: `2026-04-13T09:36:26+02:00`. Sumar todas las entradas posteriores al finalizar. |
| **Claude** | No accesible programáticamente dentro de Claude Code. Consultar en `claude.ai/settings/billing` o historial de API. |

Al finalizar la sesión, Claude ejecutará:
```bash
awk -F'"' '/timestamp.*2026-04-13T0[9-9]|2026-04-13T[1-9]/ {
  # sumar total_tokens
}' ~/.gemma-usage.log
```
Y reportará el total de tokens Gemma consumidos en esta sesión.

---

## Criterios de éxito

- Al menos 3 nuevas fuentes de diseño identificadas y añadidas al sync
- Los 5 agentes producen propuestas sustanciales (no triviales)
- El revisor cruzado detecta al menos 1 contradicción o riesgo
- El debate añade perspectiva que cambia al menos 1 decisión
- El plugin sigue funcionando: hook responde correctamente, sync.sh ejecuta sin error
