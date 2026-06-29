IGNORED_SRC := $(wildcard *_rules.lp)
SRC := $(filter-out $(IGNORED_SRC),$(wildcard *.lp))
OBJ := $(SRC:%.lp=%.lpo)
IGNORED_OBJ := $(IGNORED_SRC:%.lp=%.lpo)

default: $(OBJ)

$(OBJ)&: $(SRC)
	lambdapi check -c $^

clean:
	rm -f $(OBJ) $(IGNORED_OBJ)

install: $(OBJ)
	lambdapi install lambdapi.pkg $(SRC) $(OBJ)

uninstall:
	lambdapi uninstall lambdapi.pkg
