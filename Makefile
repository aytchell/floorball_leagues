.PHONY: generate watch clean build run

# Generate code once
generate:
	flutter pub run build_runner build --delete-conflicting-outputs
	dart run flutter_launcher_icons

# Watch for changes and regenerate automatically
watch:
	flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files
clean:
	flutter pub run build_runner clean

# Build the app (with code generation first)
build: generate
	flutter build apk

# Run the app (with code generation first)
run: generate
	flutter run
