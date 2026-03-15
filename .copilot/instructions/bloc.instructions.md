Bloc architecture rules

Bloc responsibilities

- Handle business logic.
- Transform events into states.

UI responsibilities

- Dispatch events.
- Render states.

Rules

- UI must not contain business logic.
- Bloc must not depend on UI.

Structure

presentation/
  bloc/
  pages/
  widgets/

domain/
  entities/
  repositories/
  usecases/

data/
  models/
  datasources/
  repositories/

