# UTN-BasesDeDatosI-TFI
Proyecto Final Integrador de Bases de Datos I (UTN - TUP). Modelado relacional, carga masiva de datos (SQL), consultas avanzadas, seguridad, transacciones y concurrencia.


# Trabajo Final Integrador — Bases de Datos I (UTN)

Este repositorio contiene el desarrollo del **Trabajo Final Integrador (TFI)** de la materia **Bases de Datos I** correspondiente a la *Tecnicatura Universitaria en Programación (UTN)*.

El proyecto abarca el diseño, implementación, optimización y prueba de una base de datos relacional orientada a simular escenarios reales de gestión de datos a gran escala, seguridad y concurrencia.

---

## 👥 Integrantes
* **Gastón Uriel Fernández**
* **Mirko Alexander Stamm**

---

## 🎯 Contenidos y Etapas del Proyecto

- **Etapa 1: Modelado y Constraints**
  - Diseño del Diagrama Entidad-Relación (DER) y Modelo Relacional.
  - Implementación física en SQL con restricciones de integridad (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK` y reglas de dominio).
  - Validaciones y pruebas de fallos de integridad.

- **Etapa 2: Carga Masiva de Datos**
  - Poblado de tablas con volúmenes reales (SQL puro).
  - Garantía de integridad referencial, cardinalidades y coherencia de dominio.

- **Etapa 3: Consultas Avanzadas y Reportes**
  - Consultas complejas con `JOIN`, `GROUP BY`, `HAVING`, subconsultas y Vistas.
  - Análisis comparativo de rendimiento (tiempos de ejecución y planes con `EXPLAIN`) con y sin índices.

- **Etapa 4: Seguridad e Integridad**
  - Creación de usuarios con principio de mínimos privilegios.
  - Vistas de seguridad para la protección de datos sensibles.
  - Prevención y pruebas anti-inyección SQL (vía `PreparedStatement` / Procedimientos Almacenados).

- **Etapa 5: Concurrencia y Transacciones**
  - Simulación de bloqueos, contención y manejo de *deadlocks* con estrategia de *retry*.
  - Evaluación práctica de niveles de aislamiento (`READ COMMITTED`, `REPEATABLE READ`).
  - Control transaccional con `START TRANSACTION`, `COMMIT` y `ROLLBACK`.

---

## 📁 Estructura del Repositorio

```text
├── docs/
│   ├── DER.pdf                     # Diagrama Entidad-Relación
│   └── Anexo_IA_Evidencias.pdf     # Evidencias de tutoría con IA
├── scripts/
│   ├── 01_esquema_constraints.sql  # Creación de tablas y restricciones (Etapa 1)
│   ├── 02_carga_masiva.sql         # Poblado masivo de datos (Etapa 2)
│   ├── 03_consultas_vistas.sql     # Consultas avanzadas e índices (Etapa 3)
│   ├── 04_seguridad_integridad.sql # Usuarios, permisos y vistas (Etapa 4)
│   └── 05_concurrencia.sql         # Pruebas de transacciones y deadlocks (Etapa 5)
└── README.md                       # Presentación general del proyecto
