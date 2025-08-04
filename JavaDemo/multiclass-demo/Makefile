# Makefile for multiclass-demo Java project

# Java compiler and options
JAVAC = javac
JAVA = java
JFLAGS = -g

# Source and build directories
SRC_DIR = src
BUILD_DIR = build

# Find all Java source files
SOURCES = $(shell find $(SRC_DIR) -name "*.java")
CLASSES = $(SOURCES:$(SRC_DIR)/%.java=$(BUILD_DIR)/%.class)

# Main class
MAIN_CLASS = com.example.Application

# Default target
.PHONY: all
all: compile

# Compile all Java source files
.PHONY: compile
compile:
	@mkdir -p $(BUILD_DIR)
	$(JAVAC) $(JFLAGS) -sourcepath $(SRC_DIR) -d $(BUILD_DIR) $(SOURCES)
	@echo "Compilation completed successfully!"

# Run the application
.PHONY: run
run: compile
	$(JAVA) -cp $(BUILD_DIR) $(MAIN_CLASS)

# Clean compiled classes
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)/*
	@echo "Clean completed!"

# Rebuild the project
.PHONY: rebuild
rebuild: clean compile

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all      - Compile all source files (default)"
	@echo "  compile  - Compile all source files"
	@echo "  run      - Compile and run the application"
	@echo "  clean    - Remove all compiled classes"
	@echo "  rebuild  - Clean and compile all source files"
	@echo "  help     - Display this help message"