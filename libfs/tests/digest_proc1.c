#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <ctype.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <mlfs/mlfs_interface.h>

#define NUM 4096 * 50
#define BLK_SIZE 4096
#define N_BLK 4
#define BUFFER_SIZE N_BLK * 4096
#define KGRN  "\x1B[32m"
#define KRED  "\x1B[31m"
#define KNRM  "\x1B[0m"

int main(int argc, char ** argv) {
    int fd, i, j, cnt, bytes, sum;
    char buffer[BLK_SIZE], read_buffer[2*BLK_SIZE];
    for (i = 0; i < BLK_SIZE; i++) {
        buffer[i] = 2;
    }

    fd = creat("/mlfs/partial_update", 0600);
    if (fd < 0) {
        perror("creat");
        return 1;
    }
    close(fd);

    fd = open("/mlfs/partial_update", O_RDWR, 0600);
    cnt = 0;
    while(cnt < NUM) {
        lseek(fd, 0, SEEK_SET);
        bytes = write(fd, buffer, BLK_SIZE);
        ++cnt;
    }
    close(fd);

    fd = open("/mlfs/partial_update", O_RDWR, 0600);
    if (fd < 0) {
        perror("write: open without O_CREAT");
        return 1;
    }
    bytes = read(fd, read_buffer, BLK_SIZE);
    if (bytes != BLK_SIZE) {
		printf("read %d - expect %d\n", bytes, BLK_SIZE);
		exit(-1);
	}
    printf("verifying buffer.. ");
    sum = 0;
    for (i = 0; i < 1 ; i++) {
        size_t sum_blk = 0;
		for(j = 0; j < 4096 ; j++)  {
            sum += read_buffer[i * 4096 + j];
            sum_blk += read_buffer[i * 4096 + j];
        }
        printf("sum_blk: %ld\n", sum_blk);
	}
    if (sum == 2 * 1 * 4096) {
        printf(KGRN "OK\n" KNRM);
    } else {
        printf(KRED "data is corrupted : sum %lu - expect %u\n" KNRM, sum, (2 * 1 * 4096));
    }
    close(fd);

    return 0;
}