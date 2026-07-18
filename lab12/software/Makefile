PREFIX ?= riscv-none-elf-

CC      := $(PREFIX)gcc
OBJCOPY := $(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
SIZE    := $(PREFIX)size
PYTHON  ?= python

BUILD := build
ELF   := $(BUILD)/firmware.elf

CFLAGS := -march=rv32i -mabi=ilp32 -O2 \
          -ffreestanding -fno-builtin -fno-pic \
          -msmall-data-limit=0 \
          -ffunction-sections -fdata-sections \
          -Wall -Wextra

LDFLAGS := -march=rv32i -mabi=ilp32 \
           -nostdlib -nostartfiles -static \
           -T sections.ld \
           -Wl,--gc-sections \
           -Wl,-Map,$(BUILD)/firmware.map

HEADERS := sys.h terminal.h command.h
OBJS := $(BUILD)/entry.o \
		$(BUILD)/main.o \
		$(BUILD)/sys.o \
		$(BUILD)/terminal.o \
		$(BUILD)/command.o

.PHONY: all clean

all: $(BUILD)/main.hex \
     $(BUILD)/main_d0.hex $(BUILD)/main_d1.hex \
     $(BUILD)/main_d2.hex $(BUILD)/main_d3.hex \
     $(BUILD)/firmware.dump

$(BUILD):
	powershell.exe -NoProfile -Command "New-Item -ItemType Directory \
	-Path '$(BUILD)' -Force | Out-Null"

$(BUILD)/entry.o: entry.S | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/%.o: %.c $(HEADERS) | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(ELF): $(OBJS) sections.ld
	$(CC) $(LDFLAGS) $(OBJS) -lgcc -o $@
	$(SIZE) $@

$(BUILD)/text.bin: $(ELF)
	$(OBJCOPY) -O binary --only-section=.text $< $@

$(BUILD)/data.bin: $(ELF)
	$(OBJCOPY) -O binary \
	  --only-section=.rodata --only-section=.data \
	  --only-section=.srodata --only-section=.sdata $< $@

$(BUILD)/firmware.dump: $(ELF)
	$(OBJDUMP) -d -S $< > $@

$(BUILD)/main.hex \
$(BUILD)/main_d0.hex $(BUILD)/main_d1.hex \
$(BUILD)/main_d2.hex $(BUILD)/main_d3.hex &: \
$(BUILD)/text.bin $(BUILD)/data.bin bin2hex.py
	$(PYTHON) bin2hex.py $(BUILD)

clean:
	powershell.exe -NoProfile -Command "if (Test-Path -LiteralPath '$(BUILD)') \
	{ Remove-Item -LiteralPath '$(BUILD)' -Recurse -Force }"