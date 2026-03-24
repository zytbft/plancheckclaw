# Contributing to PlanCheck

First off, thank you for considering contributing to PlanCheck! It's people like you that make PlanCheck such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps which reproduce the problem**
* **Provide specific examples to demonstrate the steps**
* **Describe the behavior you observed after following the steps**
* **Explain which behavior you expected to see instead and why**
* **Include screenshots if possible**
* **Include details about your configuration and environment**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

* **Use a clear and descriptive title**
* **Provide a detailed description of the suggested enhancement**
* **List some examples of how this enhancement would be used**
* **Explain why this enhancement would be useful to most PlanCheck users**

### Pull Requests

* Fill in the required template
* Follow the Swift style guide
* Include comments in your code where necessary
* Update documentation as needed
* Test your changes thoroughly
* **Use MCP GitHub tool for commits**: This project uses the MCP GitHub tool (`mcp_github_push_files`) to submit code changes instead of traditional Git commands

## Development Setup

### Prerequisites

- macOS 15.0+
- Xcode 16.0+
- Git

### Setting Up Your Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/plancheck.git
   cd plancheck
   ```

3. Open in Xcode:
   ```bash
   open plancheck/plancheck.xcodeproj
   ```

4. Build and run:
   - Select your development team in Xcode
   - Press Cmd+B to build
   - Press Cmd+R to run

### Code Submission Workflow

**Important**: This project uses the MCP GitHub tool for all code submissions.

#### Using MCP GitHub Tool (Required)

All code changes must be submitted using the `mcp_github_push_files` function:

```typescript
// Example usage in AI assistant context
await mcp_github_push_files({
  owner: "zytbft",
  repo: "plancheckclaw",
  branch: "main",
  files: [
    {
      path: "plancheck/plancheck/YourFile.swift",
      content: "// Your code here"
    }
  ],
  message: "feat: description of your changes"
});
```

**Why MCP GitHub Tool?**
- ✅ Ensures consistent commit history
- ✅ Automated validation and testing
- ✅ Integrated with AI assistant workflow
- ✅ Proper file tracking and diff management

#### Traditional Git Commands (Not Recommended)

For emergency situations or when MCP tool is unavailable:

```bash
# Only use when MCP tool fails
git add <files>
git commit -m "description"
git push origin main
```

### Building from Command Line

```bash
cd /path/to/plancheck
./build_tools/final_build.sh
```

## Coding Guidelines

### Swift Style Guide

* Follow Apple's Swift API Design Guidelines
* Use Swift 5 syntax and features
* Prefer `let` over `var` for immutability
* Use type inference where appropriate
* Keep functions small and focused
* Use meaningful variable and function names

### Code Organization

* Group related functionality together
* Use extensions to organize code
* Keep files under 500 lines when possible
* Use MARK comments to organize sections

### Documentation

* Comment complex logic
* Update README.md if adding new features
* Document public APIs
* Include usage examples

## Testing

* Write tests for new features
* Ensure existing tests pass
* Test edge cases
* Manual testing is also important

### Running Tests

```bash
xcodebuild test -project plancheck/plancheck.xcodeproj -scheme plancheck
```

## Release Process

1. Version numbers follow semantic versioning (MAJOR.MINOR.PATCH)
2. Update version number in Info.plist
3. Update CHANGELOG.md
4. Create a git tag
5. Build release version
6. Publish on GitHub Releases

## Questions?

Feel free to open an issue with the "question" label if you have any questions about contributing.

## Thank You!

Your contributions to open source, large or small, make projects like this possible. Thank you for taking the time to contribute.
