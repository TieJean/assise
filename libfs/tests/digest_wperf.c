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
#include <time.h>
#include <stdbool.h>

#define BLK_SIZE 4096
#define KGRN  "\x1B[32m"
#define KRED  "\x1B[31m"
#define KNRM  "\x1B[0m"
#define SIZE 5
#define ITER_NUM 100

int verify_write(unsigned int buffer_size);
void write_test(unsigned int buffer_size, int fd, char c);

int verify_write(unsigned int buffer_size) {
    int i, bytes, fd, sum;
    char buffer[buffer_size];
    fd = open("/mlfs/partial_update", O_RDWR, 0600);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    bytes = read(fd, buffer, buffer_size);
    if (bytes != buffer_size) {
        printf("read %d - expect %d\n", bytes, buffer_size);
		exit(-1);
    }
    sum = 0;
    for (i = 0; i < buffer_size; ++i) {
        sum += buffer[i];
    }
    close(fd);
    return sum;
}

void write_test(unsigned int buffer_size, int fd, char c) {
    int i, bytes;
    char buffer[buffer_size];
    for (i = 0; i < buffer_size; i++) {
        buffer[i] = c;
    }
    bytes = write(fd, buffer, buffer_size);
}

int main(int argc, char ** argv) {
    int fd, i, j, bytes, sum;
    clock_t begin, end;
    double runtimes[SIZE];
    int sums[SIZE];
    // unsigned int buffer_sizes[] = {128, BLK_SIZE, 4 * BLK_SIZE, 64 * BLK_SIZE};
    unsigned int buffer_sizes[] = {BLK_SIZE, 2 * BLK_SIZE, 128 * BLK_SIZE, 1000 * BLK_SIZE, 1800 * BLK_SIZE};
    // unsigned int buffer_sizes[] = {BLK_SIZE,  4 * BLK_SIZE, 64 * BLK_SIZE};

    for (i = 0; i < SIZE; ++i) { runtimes[i] = 0; }


    fd = creat("/mlfs/partial_update", 0600);
    if (fd < 0) {
        perror("creat");
        return 1;
    }
    close(fd);
    
    for (i = 0; i < SIZE; ++i) {
        fd = open("/mlfs/partial_update", O_RDWR, 0600);
        if (fd < 0) {
            perror("open");
            return 1;
        }
        for (j = 0; j < ITER_NUM; ++j) {
            lseek(fd, 0, SEEK_SET);
            write_test(buffer_sizes[i], fd, (char)(i + 1));
            begin = clock();
            make_digest_request_async(100);
	        wait_on_digesting();
            end = clock();
            runtimes[i] += (end - begin);
        }
        runtimes[i] /= ITER_NUM;
        close(fd);
        // verify buffer
        sums[i] = verify_write(buffer_sizes[i]);
    }

    printf("----------results------------\n");
    for (i = 0; i < SIZE; ++i) {
        printf("buffer size = %ld, runtime = %.2f, ", buffer_sizes[i], runtimes[i]);
        if (sums[i] == buffer_sizes[i] * (i + 1)) {
            printf(KGRN "OK\n" KNRM);
        } else {
            printf(KRED "data is corrupted : sum %lu - expect %u\n" KNRM, sums[i], buffer_sizes[i]);
        }
    }
    
    return 0;
}