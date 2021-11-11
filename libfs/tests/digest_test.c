/**
 * Test correctness of log digest
 * If correct, sum should be correct
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <ctype.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <assert.h>
#include <mlfs/mlfs_interface.h>

#define BUF_SIZE 128
#define N_UPDATES 1
#define N_BLOCKS 2
#define LARGE_BUF_SIZE (4096 * N_BLOCKS)
#define KGRN  "\x1B[32m"
#define KRED  "\x1B[31m"
#define KNRM  "\x1B[0m"

#define HEXDUMP_COLS 8
static void hexdump(void *mem, unsigned int len)
{
	unsigned int i, j;

	for(i = 0; i < len + ((len % HEXDUMP_COLS) ?
				(HEXDUMP_COLS - len % HEXDUMP_COLS) : 0); i++) {
		/* print offset */
		if(i % HEXDUMP_COLS == 0) {
			printf("0x%06x: ", i);
		}

		/* print hex data */
		if(i < len) {
			printf("%02x ", 0xFF & ((char*)mem)[i]);
		} else {/* end of block, just aligning for ASCII dump */
			printf("	");
		}

		/* print ASCII dump */
		if(i % HEXDUMP_COLS == (HEXDUMP_COLS - 1)) {
			for(j = i - (HEXDUMP_COLS - 1); j <= i; j++) {
				if(j >= len) { /* end of block, not really printing */
					printf(" ");
				} else if(isprint(((char*)mem)[j])) { /* printable char */
					printf("%c",(0xFF & ((char*)mem)[j]));
				} else {/* other char */
					printf(".");
				}
			}
			printf("\n");
		}
	}
}

int main(int argc, char ** argv)
{
    int fd, i, j;
    int bytes, ret;
    char small_buffer[BUF_SIZE], large_buffer[LARGE_BUF_SIZE];
    int write_count;
    unsigned long sum;

    //init_fs();

    ret = mkdir("/mlfs/", 0600);

    fd = creat("/mlfs/partial_update", 0600);

    if (fd < 0) {
        perror("creat");
        return 1;
    }

	// 128 Byte
    close(fd);

	for (i = 0; i < BUF_SIZE; i++)
		small_buffer[i] = '0' + 4;

	// 4096 * 2 Byte
	for (i = 0; i < LARGE_BUF_SIZE; i++)
		large_buffer[i] = '2';

    printf("--- Write initial data \n");

    fd = open("/mlfs/partial_update", O_RDWR| O_CREAT, 0600);

    if (fd < 0) {
        perror("write: open without O_CREAT");
        return 1;
    }

	// write large_buffer to /mlfs/partial_update
	bytes = write(fd, large_buffer, LARGE_BUF_SIZE);

	make_digest_request_async(100);
	wait_on_digesting();

	// Assume log size is less than 5 GB.
	// Write 5 GB to log. Previous data of large_buffer is digested
	// and log address of the data is overwritten with zeros by this write.

	// clear large_buffer to 0
	memset(large_buffer, 0, LARGE_BUF_SIZE);
	// Write 0.5 GB into file
	for (i = 0; i < ((1UL << 29) / 4096) ; i++) {
		bytes = write(fd, large_buffer, 4096);
	}

	close(fd);

	// This will test whether libfs can currently invalidate digest entries.
	// The data  must be from read-only NVM, not from log.
	printf("--- verify large buffer (after digest)\n");

    fd = open("/mlfs/partial_update", O_RDONLY, 0600);
    if (fd < 0) {
        perror("read: open without O_CREAT");
        return 1;
    }

	memset(large_buffer, 0, LARGE_BUF_SIZE);

	// read first 2 * 4096 Byte to large_buffer
	bytes = read(fd, large_buffer, LARGE_BUF_SIZE);
	if (bytes != LARGE_BUF_SIZE) {
		printf("read %d - expect %d\n", bytes, LARGE_BUF_SIZE);
		exit(-1);
	}

	printf("verifying buffer.. ");

	sum = 0;

	// verify data: #2 * 4096 of '2'
	for (i = 0; i < N_BLOCKS ; i++) {
		for(j = 0; j < 4096 ; j++) 
			sum += large_buffer[i * 4096 + j] - '0';
	}

	if (sum != 2 * LARGE_BUF_SIZE) {
		printf(KRED "data is corrupted : sum %lu - expect %u\n" KNRM, 
				sum, (2 * LARGE_BUF_SIZE));
		exit(-1);
	}

	printf(KGRN "OK\n" KNRM);

	close(fd);

    printf("--- Update data partially\n");

	assert(N_UPDATES < N_BLOCKS);

    fd = open("/mlfs/partial_update", O_RDWR, 0600);
	// N_UPDATES = 1
	// update beginning 128 B data for each 4 KB blocks
	// change from [0, 128) to '4'
	for (i = 0; i < N_UPDATES; i++) {
		lseek(fd, i * 4096, SEEK_SET);
		bytes = write(fd, small_buffer, BUF_SIZE);
	}

	memset(large_buffer, 0, LARGE_BUF_SIZE);

	lseek(fd, LARGE_BUF_SIZE, SEEK_SET);

	// make libfs digest the updated blocks by writing large files.
	// for (i = 0; i < ((5UL << 30) / 4096) ; i++)
	// 	bytes = write(fd, large_buffer, 4096);
	// start from 4096 * 2B, Write 0.5 GB into file
	for (i = 0; i < ((1UL << 29) / 4096) ; i++)
		bytes = write(fd, large_buffer, 4096);
	close(fd);

	printf("--- verify updated buffer (after digest)\n");

    fd = open("/mlfs/partial_update", O_RDONLY, 0600);
    if (fd < 0) {
        perror("read: open without O_CREAT");
        return 1;
    }

	memset(large_buffer, 0, LARGE_BUF_SIZE);

	bytes = read(fd, large_buffer, LARGE_BUF_SIZE);
	if (bytes != LARGE_BUF_SIZE) {
		printf("read %d - expect %d\n", bytes, LARGE_BUF_SIZE);
		exit(-1);
	}

	printf("verifying buffer.. ");

	sum = 0;

	// verify data 
	for (i = 0; i < N_BLOCKS ; i++) {
		for(j = 0; j < 4096 ; j++) 
			sum += large_buffer[i * 4096 + j] - '0';
	}

	if (sum != (2 * LARGE_BUF_SIZE) + (2 * BUF_SIZE * N_UPDATES)) {
		printf(KRED "data is corrupted : sum %lu - expect %u\n" KNRM, 
				sum, (2 * LARGE_BUF_SIZE));
		exit(-1);
	}

	printf(KGRN "OK\n" KNRM);

	close(fd);

    return 0;
}
