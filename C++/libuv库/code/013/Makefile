CC=gcc
SRC = $(wildcard *.c */*.c)
OBJS = $(patsubst %.c, %.o, $(SRC))
DEP_FILES := $(patsubst %, .%.d,$(OBJS))
DEP_FILES := $(wildcard $(DEP_FILES))
FLAG = -g -Werror -I. -Iinclude -lpthread -luv -lcurl
TARGET = targets

$(TARGET):$(OBJS)
	$(CC) -o $@ $^ $(FLAG)

ifneq ($(DEP_FILES),)
include $(DEP_FILES)
endif

%.o:%.c
	$(CC) -o $@ -c $(FLAG) $< -g -MD -MF .$@.d

clean:
	rm -rf $(TARGET) $(OBJS)

distclean:
	rm -rf $(DEP_FILES)

.PHONY:clean
