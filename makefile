ASM_SOURCES := $(wildcard *.asm)
C_TEST_SOURCES := $(wildcard *.c)
OBJ_DIR := obj
BIN_DIR := bin
EXECUTABLE := $(BIN_DIR)/test
ASM_OBJECTS := $(addprefix $(OBJ_DIR)/, $(notdir $(ASM_SOURCES:.asm=.o)))
C_TEST_OBJECTS := $(addprefix $(OBJ_DIR)/, $(notdir $(C_TEST_SOURCES:.c=.o)))
VPATH := src:src/helpers:test

all: $(OBJ_DIR) $(BIN_DIR) $(EXECUTABLE)

# Ensure bin directory exists before linking
$(EXECUTABLE): $(ASM_OBJECTS) $(C_TEST_OBJECTS) | $(BIN_DIR)
	gcc -no-pie -g -m64 -o $@ $^

# Ensure obj directory exists before creating object files
$(OBJ_DIR)/%.o: %.asm | $(OBJ_DIR)
	yasm -f elf64 -g dwarf2 $< -o $@

$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	gcc -g -m64 -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

run: $(EXECUTABLE)
	@./$(EXECUTABLE)

debug: $(EXECUTABLE)
	gdb $(EXECUTABLE)

clean:
	rm -f $(ASM_OBJECTS) $(C_TEST_OBJECTS) $(EXECUTABLE)

fresh: clean all
