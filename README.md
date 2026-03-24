# BudgetManager

Sistema de gestión de presupuesto personal desarrollado como proyecto académico para la asignatura **Fundamentos de Sistemas de Bases de Datos**.  
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
- Integrar la base de datos con una aplicación en C#.
- Generar reportes financieros a partir de los datos almacenados.

---

## Tecnologías

- **Base de datos:** Oracle Database
- **Herramienta SQL:** DBeaver
- **Lenguaje backend:** C# (.NET)
- **Control de versiones:** Git / GitHub

---

## Estructura del repositorio

```
BudgetManager/
├── README.md
├── Docs/
│   ├── BudgetManager.dbml          # Modelo entidad-relación (dbdiagram.io)
│   ├── BudgetManager.sql           # Modelo relacional exportado
│   └── README.ME
├── Database/
│   ├── tables.sql                  # DDL — creación de tablas y secuencias
│   ├── auth.sql                    # Procedimientos de login y registro
│   ├── crud.sql                    # Procedimientos CRUD de todas las entidades
│   ├── procedures.sql              # Procedimientos de lógica de negocio
│   ├── functions.sql               # Funciones de cálculo y utilidad
│   ├── triggers.sql                # Triggers obligatorios y de auditoría
│   ├── script.sql                  # Datos de prueba (2 meses completos)
│   └── readme.md
└── Backend/
    ├── Program.cs                  # Punto de entrada y menús de consola
    ├── Session.cs                  # Manejo de sesión del usuario activo
    ├── Database/
    │   └── Dbconnection.cs         # Configuración de conexión a Oracle
    └── Repositories/
        ├── Authrepository.cs       # Login y registro
        ├── Userrepository.cs       # CRUD de usuarios
        ├── Categoryrepository.cs   # CRUD de categorías y subcategorías
        ├── Budgetrepository.cs     # CRUD de presupuestos y detalles
        ├── Transactionrepository.cs# CRUD de transacciones
        └── Fixedexpenserepository.cs # CRUD de obligaciones fijas
```

---

## Autor

Omar Romero  
Estudiante de Ingeniería en Sistemas
