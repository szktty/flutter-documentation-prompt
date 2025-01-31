# Dart/Flutter Documentation Prompt

A prompt template for AI assistants to generate API documentation (compatible with `dart doc`) for Dart/Flutter code.
This project aims to document code intentions and usage patterns in a standardized style.

## Key Components

- `prompt/documentation.xml`: The main prompt template for documentation generation.
- `example/flutter_value_validators`: Sample code with documentation generated using this prompt.

## How to Use

1. Load the `prompt/documentation.xml` content into your AI assistant.
2. Provide the code you want to document.
3. The assistant will generate documentation following the defined standards.

Feel free to customize the prompt according to your project requirements. You can also use the AI assistant to help
modify the prompt itself.

## Prompt Structure

The prompt template includes:

- Version information: For tracking which prompt version was used for documentation generation.
- File patterns:
    - Includes all Dart files by default
    - Excludes test files and generated files (`*.g.dart`, `*.freezed.dart`)
- Documentation levels: Specifies content requirements based on API importance
- Themes:
    - Required topics: widget constraints, API relationships
    - Excluded topics: performance optimizations, implementation details
- Templates:
    - Class documentation structure
    - Property documentation format
    - Method documentation guidelines
- Content constraints:
    - Special handling for `@freezed` classes
    - Rules for documenting default values
- Format constraints: Ensures compatibility with `dart doc`
- AI behavior constraints: Prevents modification of non-documentation code

## Sample Output

Check the `example/flutter_value_validators` directory for a practical example of documentation generated using this
prompt.

## Note

This is a sample implementation intended to demonstrate documentation generation concepts. While it provides a good
starting point, you should adapt it to your specific needs.

## License

Apache License 2.0