# C++ Definition Generator Plugin

## Project Goal
Create a custom Neovim plugin that communicates with clangd LSP to generate C++ function/method definitions from declarations.

## Why Custom Plugin?
- **Direct clangd integration**: Leverage existing LSP connection instead of separate parsing
- **Accurate type information**: Use clangd's semantic analysis for precise generation
- **Project-aware**: Understand compilation context and project structure
- **Modern approach**: Built specifically for our clangd + Neovim workflow

## Plugin Features

### Core Functionality
- Generate function/method implementations from declarations in header files
- Support for template functions and class methods
- Namespace-aware generation (automatically include proper scope)
- Parameter name preservation from declarations

### LSP Integration
- Use existing clangd LSP connection
- Query symbol information for accurate type resolution
- Respect project's compilation database (compile_commands.json)
- Handle template instantiation and type deduction

### Smart Generation
- Detect if definition already exists (avoid duplicates)
- Choose appropriate target file (.cpp/.cc/.cxx)
- Insert at proper location in implementation file
- Maintain consistent formatting with project style

### User Interface
- Command: `:GenerateDefinition` - generate for function under cursor
- Keybinding integration with existing LSP mappings
- Preview window showing generated code before insertion
- Batch generation for multiple functions

## Technical Architecture

### LSP Communication
- Use `vim.lsp.buf_request()` to query clangd for symbol information
- Leverage `textDocument/definition` and `textDocument/hover` requests
- Parse LSP responses to extract function signatures and types

### Code Generation
- Build function skeleton from LSP symbol data
- Apply proper namespace scoping and class qualification
- Generate appropriate return statements and parameter handling
- Respect clang-format configuration for styling

### File Management
- Automatically determine corresponding .cpp file from .h file
- Create implementation files if they don't exist
- Handle project directory structures and conventions

## Implementation Plan

### Phase 1: Basic Generation
1. LSP symbol query functionality
2. Simple function signature extraction
3. Basic definition generation for standalone functions

### Phase 2: Class Methods
1. Class method detection and qualification
2. Constructor/destructor handling
3. Template method support

### Phase 3: Advanced Features
1. Smart file detection and creation
2. Duplicate definition checking
3. Batch generation capabilities

### Phase 4: Integration
1. pcfg integration for project-specific settings
2. Custom keybindings and commands
3. Configuration options for generation style

## Plugin Structure
```
lua/cpp-defgen/
├── init.lua           # Main plugin interface
├── lsp.lua           # LSP communication layer
├── parser.lua        # Symbol parsing and analysis
├── generator.lua     # Code generation logic
├── files.lua         # File detection and management
└── config.lua        # Configuration and settings
```

## Configuration Options
- Target file naming conventions
- Code style preferences
- Default parameter names for unknown types
- Integration with existing LSP keybindings

## Integration with Current Setup
- Use existing clangd LSP configuration
- Integrate with pcfg for per-project settings
- Work alongside our C++ snippets system
- Complement rather than replace existing tools

---

**Status**: Planned for separate implementation
**Priority**: High - would significantly improve C++ development workflow
**Dependencies**: clangd LSP, Neovim >=0.8.0, plenary.nvim