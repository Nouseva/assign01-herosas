#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
  if (argc < 2) {
    fprintf(stderr, "Usage: %s <file_name> ...\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  for (int i = 1; i < argc; ++i) {
    FILE* current   = fopen(argv[i], "rb");

    if (current == NULL) {
      fprintf(stderr, "%s: %s: No such file\n", argv[0], argv[i]);
      continue;
    }

    int   to_print  = fgetc(current);
    while (to_print != EOF) {
      fputc(to_print, stdout);
      to_print = fgetc(current);
    }

    fclose(current);
  }
  return 0;
}
