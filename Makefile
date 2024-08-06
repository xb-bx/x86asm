COLLECTIONS=\
			x86asm=src
COLLECTIONS_FLAGS=$(addprefix -collection:, $(COLLECTIONS))

ODIN_FLAGS ?=\
		   -o:none \
		   -debug \
		   -thread-count:$(shell nproc) \
		   -use-separate-modules
example: src/example/main.odin
	odin build src/example $(COLLECTIONS_FLAGS) $(ODIN_FLAGS) -out:$@

.PHONY: test
test:
	odin test src/tests $(COLLECTIONS_FLAGS) $(ODIN_FLAGS) -define:ODIN_TEST_FANCY=false -define=ODIN_TEST_TRACK_MEMORY=false

