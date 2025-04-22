# task_app

This is a Flutter app that integrates with Supabase using its REST API to manage tasks. The app allows you to create, read, update, and delete tasks stored in a Supabase database. The tasks have a description, due date, and completion status.


## Features

- **Task CRUD Operations**: Add, update, delete, and fetch tasks.
- **Date Picker**: Select a due date for tasks.
- **Responsive UI**: Built with Flutter, providing a clean and responsive UI.

## Tech Stack

- **Flutter**: A UI toolkit for building natively compiled applications for mobile from a single codebase.

- **Supabase**: An open-source backend-as-a-service that provides database, authentication, and storage features.

- **UUID**: Used for generating unique identifiers for tasks.

- **DatePicker**: A widget for selecting dates to assign due dates to tasks.

- **bloc**: A state management library for managing app state in a clean, scalable way.

## Hot Reload and Hot Restart

**Hot Reload**
- instantly appy the code changes without restarting the app.

- its best for UI update and small changes.

- it keeps the current state of the app.

**Hot Restart**
-Hot Restart is like restarting your app from the beginning.

- it rebuild the entire app and clear all the current state.

-its apply the code changes and reset everything.