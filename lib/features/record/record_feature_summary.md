# Record Feature Summary

The **Record** feature is a core component of the daily language learning application, designed to help users document their thoughts, emotions, and linguistic progress through multimedia entries.

## 🏰 Architecture Overview
The feature follows Clean Architecture principles, organized into three main layers: **Domain**, **Data**, and **Presentation**.

### 1. Domain Layer
Defines the business logic and core entities.
- **Entity (`Record`)**:
  - `id`: Unique identifier (String).
  - `emotion`: The user's mood associated with the record (e.g., Happy, Sad).
  - `type`: The category of the record (e.g., Diary, Practice).
  - `content`: The text content of the record.
  - `imageUrls`: A list of associated image URLs.
  - `voiceUrl`: URL to an audio recording.
  - `createdAt` / `updatedAt`: Timestamps.
- **Use Cases**:
  - `CreateRecordUseCase`: Adds a new record to Firestore.
  - `GetRecordUseCase`: Fetches a single record by ID.
  - `GetRecordsUseCase`: Fetches a paginated list of records for a specific user.
  - `UpdateRecordUseCase`: Updates an existing record.
  - `DeleteRecordUseCase`: (Planned/Implemented) Removes a record.
  - `TranslateVietnameseToEnglishUseCase`: Leverages external APIs to translate content.

### 2. Data Layer
Handles data persistence and external integrations.
- **`RecordModel`**: Extends the `Record` entity with `fromJson`, `toJson`, and factory methods for creation/updates.
- **`RecordRemoteDataSource`**: 
  - **Firestore**: Stores records under the `/records/{userId}/records/` collection.
  - **Translation**: Uses the Google Translate `gtx` endpoint (`translate.googleapis.com`) to translate Vietnamese to English.
- **`RecordReposImpl`**: Connects the domain layer to the data source, using `ApiService.handle` for consistent error handling.

### 3. Presentation Layer
Manages the user interface and state.
- **State Management (BLoC)**:
  - `RecordsBloc`: Handles fetching and pagination of the record list.
  - `RecordBloc`: Manages the state of individual record operations (add, edit, translate).
- **Pages**:
  - `RecordPage`: Displays a list of user records using `RecordCard` widgets.
  - `RecordAddPage`: Interface for creating a new record, including voice input support.
  - `RecordEditPage`: Interface for modifying existing records.
- **Core Widgets**:
  - `RecordCard`: Visual representation of a record in the list.
  - `EmotionChip` / `TypeChip`: UI components for selecting categories and emotions.
  - `MicListeningWidget`: Visual feedback for voice recording/translation.

## 🚀 Key Features
- **Multimedia Support**: Integration of text, images, and voice recordings.
- **Real-time Translation**: Integrated Vietnamese-to-English translation for learning assistance.
- **Pagination**: Efficiently loads records using Firestore's `startAfterDocument`.
- **Clean UI**: Uses a custom design system with `ColorApp` and modern Flutter widgets.
