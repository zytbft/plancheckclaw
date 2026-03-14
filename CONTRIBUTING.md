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

## Development Setup

### Prerequisites

- macOS 15.0+
- Xcode 16.0+
- Git

### Setting Up Your Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/zytbft/plancheckclaw.git
   cd plancheckclaw
   ```

3. Open in Xcode:
   ```bash
   open plancheck/plancheck.xcodeproj
   ```

4. Build and run:
   - Select your development team in Xcode
   - Press Cmd+B to build
   - Press Cmd+R to run

### Building from Command Line

```bash
cd /path/to/plancheckclaw
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
* Add comments for complex logic

### File Organization

* One class/struct per file
* Group related functionality into extensions
* Separate UI code from business logic
* Use consistent naming conventions

### Testing

* Write unit tests for business logic
* Add UI tests for critical user flows
* Ensure all tests pass before submitting PR
* Aim for high code coverage

## Documentation

* Update README.md for user-facing changes
* Add inline comments for complex code
* Update API documentation if needed
* Include migration guides for breaking changes

## Release Process

1. Create release branch
2. Update version numbers
3. Generate changelog
4. Create GitHub release
5. Build and distribute binaries

---

Thank you for your contribution to PlanCheck!
