# UniLogger

**UniLogger** is a unified logging package for Flutter and Dart projects. It provides a consistent and beautiful logging experience for **console logging**, **Dio HTTP requests**, **HTTP requests**, and **GraphQL operations**, all with pretty formatting, color output, and emojis. No need to manually integrate multiple logging tools — UniLogger handles it all in one place.

---

## Features

- ✅ **Console Logging**: Log messages, success, warnings, errors, and debug output with colors and emojis.
- 🌐 **HTTP Logging**: Automatically logs HTTP requests and responses made via Dart's `http` package.
- ⚡ **Dio Logging**: Pretty logs for Dio requests and responses, including headers, body, and errors.
- 📡 **GraphQL Logging**: Logs GraphQL queries, variables, responses, and errors with elapsed time.
- 🎨 **Color & Emoji Support**: Makes logs readable and visually appealing.
- 🔒 **Debug Mode Awareness**: Automatically disables logs in release builds.

---

## Getting Started

Add UniLogger to your `pubspec.yaml`:

```yaml
dependencies:
  unilogger:
    git:
      url: https://github.com/yourusername/unilogger.git
      ref: main
