# Documento de Autoevaluación — BudgetManager
**Asignatura:** Teoria de Base de Datos I
**Proyecto:** Sistema de Presupuesto Personal  
**Autor:** Omar Romero  

---

## 1. Reflexión sobre el proceso de desarrollo

El desarrollo de BudgetManager fue un proceso que requirió planificar con anticipación la estructura de la base de datos antes de escribir una sola línea de código en el backend. La decisión de usar **Oracle Database con DBeaver** surgió de recomendaciones de compañeros con experiencia práctica, lo que facilitó bastante el trabajo con los scripts DDL y la visualización del esquema.

Para el backend, opté por **C# con .NET**, principalmente por la facilidad que ofrece para conectarse a Oracle mediante el paquete `Oracle.ManagedDataAccess`. Esto me permitió mantener el foco en la lógica de base de datos sin batallar demasiado con la capa de presentación.

En cuanto al frontend, aproveché que el proyecto lo permitía para apoyarme en **inteligencia artificial** como herramienta de asistencia. Esto aceleró el proceso en esa capa y me dejó más tiempo para concentrarme en lo que realmente importaba para el curso: la base de datos.

---

## 2. Desafíos enfrentados y soluciones

**Procedimientos almacenados**

La parte más desafiante del proyecto fue sin duda la implementación de los procedimientos almacenados. Acostumbrado a escribir la lógica en el backend, trasladarla completamente a la base de datos requirió cambiar la forma de pensar.

**Funciones con cálculos de tiempo**

Para las funciones que involucran lapsos de tiempo, como `project_end_of_month_expense` y `get_days_until_fixed_expense_due`, me apoyé en inteligencia artificial para validar que la aritmética de fechas en Oracle fuera correcta, contar con una segunda revisión ayudó a evitar errores silenciosos.

**Reportería**

La sección de reportes no fue realizada, preferí no entregar algo incompleto o mal configurado que pudiera afectar negativamente lo que sí estaba funcionando.

---

## 3. Aprendizajes clave

Antes de comenzar el proyecto, los conceptos de triggers, stored procedures y funciones eran en gran parte teóricos. Al finalizar, puedo decir que de eso trataba la clase, y efectivamente al final sí los entiendo y sé aplicarlos.

Algunos aprendizajes concretos que me llevo:

- La diferencia práctica entre un procedimiento y una función, y cuándo usar cada uno.
- El valor de los triggers para automatizar reglas del negocio, como la creación automática de subcategorías al insertar una categoría.
- Que centralizar la lógica en la base de datos hace al sistema más robusto e independiente del lenguaje del backend.

---

## 4. Autoevaluación del desempeño

Considero que mi desempeño en el proyecto fue **bueno, con áreas de mejora**.

Lo que entregué — modelo de datos, DDL, procedimientos CRUD, procedimientos de lógica de negocio, funciones, triggers, datos de prueba y aplicación de consola funcional — representa un esfuerzo real y un sistema que efectivamente opera sobre la base de datos de la manera que el proyecto requería.

Las áreas donde reconozco que quedé corto son la reportería, que no fue implementada, y algunos aspectos de documentación que podrían estar más detallados. En retrospectiva, planificar mejor el tiempo hacia las últimas fases del proyecto habría permitido cerrar esos puntos.