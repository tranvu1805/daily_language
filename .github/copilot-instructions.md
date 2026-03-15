Project overview

This project is a Flutter application using Clean Architecture.

Architecture layers:
- presentation
- domain
- data

State management:
- Bloc is used for UI state management.

Navigation:
- GoRouter is used for routing.

General coding rules

- Follow Dart and Flutter best practices.
- Prefer const constructors whenever possible.
- Avoid unnecessary rebuilds.
- Keep code readable and maintainable.

Flutter UI rules

- Do NOT create helper functions that return Widget.
- Extract UI parts into separate StatelessWidget classes.
- If a widget tree becomes longer than ~20 lines, split it into smaller widgets.
- Widgets must represent UI components, not helper methods.

Example of bad pattern:
Widget buildHeader()

Preferred pattern:
class HeaderWidget extends StatelessWidget

Widget structure

- Keep build() methods short.
- Prefer composition over deeply nested widgets.
- Each widget should have a single responsibility.

Bloc usage

- UI should not contain business logic.
- Business logic must stay in Bloc or UseCase.
- UI interacts with Bloc through events.

Architecture constraints

- Presentation layer depends on domain layer.
- Data layer implements domain repositories.
- Do not mix layers.

Modification rules

When modifying existing code:

- Do not change unrelated files.
- Do not break architecture boundaries.
- Prefer minimal and safe changes.
