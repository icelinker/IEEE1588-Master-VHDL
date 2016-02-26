#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const unsigned int ram_depth = 512;
const unsigned int bit_length = 16;

int main(int argc, char *argv[])
{
	int ret, i;
	FILE *fp, *fp2;
	unsigned int count, data;
	char comment[256];

	if(argc < 3) {
		fprintf(stderr, "Usage: ./coe_file_gen <input file> <output file>\n");

		return -1;
	}

	fp = fopen(argv[1], "r");
	if(fp == NULL) {
		fprintf(stderr, "Unable to open input file: %s\n", argv[1]);

		return -1;
	}
	fp2 = fopen(argv[2], "w");
	if(fp == NULL) {
		fprintf(stderr, "Unable to open output file: %s\n", argv[2]);

		return -1;
	}

	count = 0;
	while(1) {
		ret = fscanf(fp, "%x %[^\t\n]", &data, comment);
		if (ret != EOF) {
			for (i = (bit_length-1); i >= 0; i--) {
				if((0x01<<i) & data) {
					fprintf(fp2, "1");
				} else {
					fprintf(fp2, "0");
				}
			}
			fprintf(fp2, "\n");
		} else {
			for (i = (bit_length-1); i >= 0; i--) {
				fprintf(fp2, "0");
			}
			fprintf(fp2, "\n");
		}

		count++;
		if ((count % 10) == 0)
			fprintf(stderr, "\rWriting data to coe file..%u %%", (unsigned int)(100.0*((float)count/(float)ram_depth)));
		if (count == ram_depth)
			break;
	}

	fprintf(stderr, "\nComplete\n");
	fclose(fp);
	fclose(fp2);

	return 0;
}
