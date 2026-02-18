# BudgetManager

Sistema de gestión de presupuesto personal desarrollado como proyecto académico para la asignatura **Teoría de Base de Datos I**.  
El proyecto implementa un modelo relacional completo y lógica de negocio en base de datos para la planificación, control y análisis de finanzas personales.

---

## Descripción

BudgetManager permite a un usuario administrar su presupuesto mediante la definición de categorías financieras, asignación de montos presupuestados y registro de transacciones reales.  
El sistema calcula la ejecución presupuestaria mensual y facilita el análisis de ingresos, gastos y ahorros dentro de períodos definidos.

La lógica principal del sistema se implementa en la base de datos mediante procedimientos almacenados, funciones y triggers, cumpliendo los lineamientos del curso.

---

## Objetivos

### Objetivo general
Aplicar los conocimientos de bases de datos relacionales mediante el diseño e implementación de un sistema funcional de gestión de presupuesto personal.

### Objetivos específicos
- Diseñar un modelo entidad–relación normalizado.
- Implementar el modelo relacional en Oracle Database.
- Desarrollar procedimientos almacenados CRUD y de lógica de negocio.
- Implementar triggers para automatización y validación de reglas.
- Gestionar presupuestos, categorías, subcategorías y transacciones.
- Calcular ejecución y balance presupuestario mensual.
- Integrar la base de datos con una aplicación Java.
- Generar reportes financieros a partir de los datos almacenados.

---

## Tecnologías

- **Base de datos:** Oracle Database  
- **Herramienta SQL:** Oracle SQL Developer  
- **Lenguaje backend:** Java  
- **Control de versiones:** Git / GitHub  

---

## Estructura del repositorio

proyecto-presupuesto-personal/
├── README.md # Descripción del proyecto
├── docs/
│ ├── ERD.png # Diagrama Entidad-Relación
│ ├── ModeloRelacional.pdf # Modelo Relacional documentado
│ ├── DiccionarioDatos.xlsx # Diccionario de datos
│ └── Reportes.pdf # Documentación de reportes con SQL
├── database/
│ ├── DDL/
│ │ └── 01_crear_tablas.sql
│ ├── procedimientos/
│ │ ├── crud_usuario.sql
│ │ ├── crud_categoria.sql
│ │ └── ... (otros procedimientos)
│ ├── funciones/
│ │ └── funciones.sql
│ ├── triggers/
│ │ └── triggers.sql
│ └── datos_prueba/
│ └── insertar_datos.sql
├── backend/
│ ├── src/
│ ├── package.json (o equivalente)
│ └── README.md
├── frontend/
│ ├── src/
│ ├── assets/
│ └── README.md
└── metabase/
└── metabase_backup.zip


---

## Estado del proyecto

Proyecto académico en desarrollo.  
Actualmente incluye el diseño del modelo de datos, scripts SQL y la integración inicial con una aplicación Java en consola.

---

## Autor

Omar Romero  
Estudiante de Ingeniería en Sistemas  
