Flutter development guidelines

Widgets

- Prefer StatelessWidget whenever possible.
- Extract UI sections into separate widgets.
- Avoid helper methods returning Widget.

Build method

- Keep build() under ~30 lines when possible.
- Break large UI trees into smaller widgets.

Performance

- Use const constructors.
- Avoid unnecessary rebuilds.

Naming conventions

Widgets:
UserAvatarWidget
RecordItemWidget
ChapterCardWidget

Bloc:

Events: LoadRecordsEvent
States: RecordsLoadedState

Navigation

Use GoRouter for navigation.
Avoid Navigator.push unless necessary.

