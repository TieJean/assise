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

#define BLK_SIZE 4096
#define BUFFER_SIZE 2*4096
#define KGRN  "\x1B[32m"
#define KRED  "\x1B[31m"
#define KNRM  "\x1B[0m"

int main(int argc, char ** argv) {
    int fd, i, j, bytes, sum;
    char buffer[BUFFER_SIZE];
    fd = creat("/mlfs/partial_update", 0600);
    if (fd < 0) {
        perror("creat");
        return 1;
    }
    close(fd);
    
    // write 2 * 4096 2
    for (i = 0; i < BUFFER_SIZE; i++) {
        buffer[i] = 2;
    }
		
    fd = open("/mlfs/partial_update", O_RDWR| O_CREAT, 0600);
    if (fd < 0) {
        perror("write: open without O_CREAT");
        return 1;
    }
    bytes = write(fd, buffer, BUFFER_SIZE);
    make_digest_request_async(100);
	wait_on_digesting();
    close(fd);
    
    fd = open("/mlfs/partial_update", O_RDWR, 0600);
    if (fd < 0) {
        perror("write: open without O_CREAT");
        return 1;
    }
    memset(buffer, 0, BUFFER_SIZE);
    // write 1 * 4096 0
    for (i = 0; i < 1; i++) {
		bytes = write(fd, buffer, BLK_SIZE);
	}
    close(fd);

    fd = open("/mlfs/partial_update", O_RDWR, 0600);
    if (fd < 0) {
        perror("write: open without O_CREAT");
        return 1;
    }
    bytes = read(fd, buffer, BUFFER_SIZE);
    if (bytes != BUFFER_SIZE) {
		printf("read %d - expect %d\n", bytes, BUFFER_SIZE);
		exit(-1);
	}

    printf("verifying buffer.. ");
    sum = 0;
    for (i = 0; i < 2 ; i++) {
		for(j = 0; j < 4096 ; j++) 
			sum += buffer[i * 4096 + j];
	}
    if (sum == 4096 * 2) {
        printf(KGRN "OK\n" KNRM);
    } else {
        printf(KRED "data is corrupted : sum %lu - expect %u\n" KNRM, sum, (2 * BLK_SIZE));
    }

    return 0;
}