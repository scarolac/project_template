# 
# ## Move notification reminder if using external libs
# TODO: Move `libXXX.a` to /usr/local/lib so this can work on production servers
#
 
NAME := # Project name needed

SRCDIR := src
BINDIR := bin
BUILDDIR := build
TESTDIR := test

TARGET := $(BINDIR)/$(NAME)
 
SRCEXT := cpp
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))

TESTS := $(shell find $(TESTDIR) -type f -name *.$(SRCEXT))

CPPFLAGS := -std=c++17 -O3 

# Error/Warning checking, comment out if no errors
CPPFLAGS += -Wall -Wextra -Wcast-align -Wcast-qual -Wdisabled-optimization \
-Wdiv-by-zero -Wendif-labels -Wformat-extra-args -Wformat-nonliteral \
-Wformat-security -Wformat-y2k -Wimport -Winit-self -Winvalid-pch \
-Wlogical-op -Werror=missing-braces -Wno-missing-format-attribute \
-Wmissing-include-dirs -Wmultichar -Wpacked -Wpointer-arith -Wreturn-type \
-Wsequence-point -Wsign-compare -Wstrict-aliasing -Wstrict-aliasing=2 \
-Wswitch -Wswitch-default -Wno-unused -Wvariadic-macros -Wwrite-strings

LIB := -pthread -lmongoclient -L lib -lboost_thread-mt -lboost_filesystem-mt -lboost_system-mt
INC := -I include

.PHONY: all test clean
all: $(TARGET) test

$(TARGET): $(OBJECTS)
	# Linking...
	@mkdir -p $(BINDIR)
	$(CXX) $^ -o $(TARGET) $(LIB)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)	
	@mkdir -p $(BUILDDIR)
	$(CXX) $(CPPFLAGS) $(INC) -c -o $@ $<

test: $(basename $(TESTS))
  ./$(basename $(TESTS))

$(TESTDIR)/%.test: $(TESTDIR)/%.test.$(SRCEXT) $(BUILDDIR)/%.o
	$(CXX) $(CPPFLAGS) $(INC) -o $@ $^ $(LIB) 

clean:
	# Cleaning...
	$(RM) -r $(BUILDDIR) $(BINDIR) $(TESTDIR)/*.test