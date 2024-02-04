# This Makefile launches compilation inside of Docker.

# symbolic targets:
HEX = grbl.hex
all: $(HEX)

$(HEX): 
	docker run --rm -it -v "${PWD}":/source tiryoh/grbl-builder:latest make --makefile Makefile.compilation

clean:
	rm -f $(HEX) $(BUILDDIR)/*.o $(BUILDDIR)/*.d $(BUILDDIR)/*.elf

PROGRAMMER_TYPE ?= arduino
DEVICE ?= atmega328p

require-env-PORT:
ifndef PORT
	$(error PORT env is undefined)
endif

flash: $(HEX) require-env-PORT
	avrdude -c $(PROGRAMMER_TYPE) -P $(PORT) -p $(DEVICE) -U flash:w:$(HEX):i
