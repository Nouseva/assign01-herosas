#------------------------------------------------------------------------------
#	Assignment:
#		Assign 00
#		CSE 130, dog
#
#.PHONY: all test clean check submit checkSubmission format lex
#	Description:
#		make							makes cat
#		make clean						removes all binaries
#		make testGraph					makes GraphTest
#		make testList					makes ListTest
#		make memcheck					runs MatrixClient under valgrind
#		make memcheck TGT=<BINARY>		runs BINARY under valgrind
#		make format						formats sources and headers
#		make submit						submits files (when on unix timeshare)
#		make checkSubmission			checks which files were submitted
#
#
#
#	Created
#	By:	Rosas, Hector
#		herosas
#	On:	30 March 2020
#
#	Original makefile from unbuntu forum
#------------------------------------------------------------------------------

APP      = dog

SRCEXT   = c
SRCDIR   = lib
OBJDIR   = obj
BINDIR   = bin

SRCS    := $(shell find $(SRCDIR) -name '*.$(SRCEXT)')
SRCDIRS := $(shell find . -name '*.$(SRCEXT)' -exec dirname {} \; | uniq)
OBJS    := $(patsubst %.$(SRCEXT),$(OBJDIR)/%.o,$(SRCS))

DEBUG    = -g
INCLUDES = -I./inc
CFLAGS   = -Wall -Wextra -Wpedantic -Wshadow -ansi -c $(DEBUG) $(INCLUDES)
LDFLAGS  =

ifeq ($(SRCEXT), cpp)
CC       = $(CXX)
else
CFLAGS  += -std=gnu99
endif

.PHONY: all clean distclean


all: $(BINDIR)/$(APP)

$(BINDIR)/$(APP): buildrepo $(OBJS)
	@mkdir -p `dirname $@`
	@echo "Linking $@..."
	@$(CC) $(OBJS) $(LDFLAGS) -o $@

$(OBJDIR)/%.o: %.$(SRCEXT)
	@echo "Generating dependencies for $<..."
	@$(call make-depend,$<,$@,$(subst .o,.d,$@))
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

clean:
	$(RM) -r $(OBJDIR)

distclean: clean
	$(RM) -r $(BINDIR)

buildrepo:
	@$(call make-repo)

define make-repo
   for dir in $(SRCDIRS); \
   do \
	mkdir -p $(OBJDIR)/$$dir; \
   done
endef


# usage: $(call make-depend,source-file,object-file,depend-file)
define make-depend
  $(CC) -MM       \
        -MF $3    \
        -MP       \
        -MT $2    \
        $(CFLAGS) \
        $1
endef
