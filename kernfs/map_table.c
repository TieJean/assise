#include <stdio.h>
#include <stdlib.h>
#include "map_table.h"
#include "io/block_io.h"
#include "io/buffer_head.h"
#include "filesystem/shared.h" //change dist_superblock
#include "extents.h"

struct mlfs_map_blocks** map_tables;  // = malloc(sizeof(struct mlfs_map_blocks) * (1 << (dev_size[dev]>> g_block_size_bytes))));
size_t map_table_size;

void get_map_entry_helper(uint8_t dev, uint32_t blkno, uint32_t offset_in_blk, struct mlfs_map_blocks* data);
void set_map_entry_helper(uint8_t dev, uint32_t blkno, uint32_t offset_in_blk, struct mlfs_map_blocks* data);
struct mlfs_map_blocks* print_map_table_helper(uint8_t dev, addr_t lblk, int libfs_id);


void map_table_init(uint8_t dev) {
    map_tables = malloc(sizeof(struct mlfs_map_blocks*) * disk_sb[dev].nmap);
    map_table_size = sizeof(struct mlfs_map_blocks) * disk_sb[dev].nmapentry;
    for(int i = 0; i < disk_sb[dev].nmap/*g_n_max_libfs + 1*/; ++i) {
        map_tables[i] = malloc(sizeof(struct mlfs_map_blocks) * disk_sb[dev].nmapentry);
    }
    read_map_table(dev);
}

// TODO:  not a good idea to read into RAM, should use mmap
void read_map_table(uint8_t dev) {
    int ret;
	struct buffer_head *bh;
    addr_t cur_map_start_blk = disk_sb[dev].map_table_start;
    for(int i = 0; i < disk_sb[dev].nmap/*g_n_max_libfs + 1*/; ++i) {
        bh = bh_get_sync_IO(dev, cur_map_start_blk, BH_NO_DATA_ALLOC);
        bh->b_size = map_table_size;
        bh->b_data = map_tables[i];
        bh_submit_read_sync_IO(bh);
	    mlfs_io_wait(dev, 1);
        bh_release(bh);
        cur_map_start_blk = cur_map_start_blk + disk_sb[dev].nmapblocks;
    }
}


void write_map_table(uint8_t dev) {
    int ret;
	struct buffer_head *bh; 
    addr_t cur_map_start_blk = disk_sb[dev].map_table_start;
    for(int i = 0; i < disk_sb[dev].nmap; ++i) {
        bh = bh_get_sync_IO(dev, cur_map_start_blk, BH_NO_DATA_ALLOC);
        bh->b_size = map_table_size;
        bh->b_data = map_tables[i];
        mlfs_write(bh);
	    mlfs_io_wait(dev, 0);
        bh_release(bh);
        cur_map_start_blk = ((cur_map_start_blk << g_block_size_shift) + map_table_size + (g_block_size_bytes >> 1)) >> g_block_size_shift;
    }
}

void map_table_shutdown(uint8_t dev) {
    write_map_table(dev);
    for (int i = 0; i < disk_sb[dev].nmap; ++i) {
        if (map_tables[i] != NULL) free(map_tables[i]);
    }
    if (map_tables != NULL) free(map_tables);
}


// add flags for mlfs_map_blocks in extents.h
// TODO-assise: write to NVM 
void update_map_table(uint8_t dev, addr_t kernfs_lblk, addr_t libfs_lblk, int libfs_id) {
    int ret;
    struct buffer_head *bh_kernfs, *bh_libfs; 
    struct mlfs_map_blocks* kernfs_map = get_map_table_entry(dev, kernfs_lblk, libfs_id);
    struct mlfs_map_blocks* libfs_map = get_map_table_entry(dev, libfs_lblk, libfs_id);
    addr_t kernfs_pblk = kernfs_map->m_pblk; 
    addr_t libfs_pblk = libfs_map->m_pblk;


    if(((kernfs_map->m_flags) & MLFS_MAP_INIT) == MLFS_MAP_INIT) {
        libfs_map->m_pblk = kernfs_pblk;
        kernfs_map->m_lblk = kernfs_pblk; // previous pblk
    } else {
        libfs_map->m_pblk = kernfs_lblk;
        kernfs_map->m_lblk = kernfs_lblk;
    }

    if(((libfs_map->m_flags) & MLFS_MAP_INIT)  == MLFS_MAP_INIT) {
        // printf("update_map_table case1 (before): %ld\n", kernfs_map->m_pblk);
        kernfs_map->m_pblk = libfs_pblk;
        // printf("update_map_table case1 (after): %ld\n", kernfs_map->m_pblk);
        libfs_map->m_lblk = libfs_pblk;
    } else {
        // printf("update_map_table case2 (before): %ld\n", kernfs_map->m_pblk);
        kernfs_map->m_pblk = libfs_lblk;
        // printf("update_map_table case2 (after): %ld\n", kernfs_map->m_pblk);
        libfs_map->m_lblk = libfs_lblk;
    }
    // update_map_table_entry
    kernfs_map->m_flags = kernfs_map->m_flags | MLFS_MAP_INIT;
    libfs_map->m_flags = kernfs_map->m_flags | MLFS_MAP_INIT;
    kernfs_map->m_flags = kernfs_map->m_flags | MLFS_MAP_CACHE;
    libfs_map->m_flags = kernfs_map->m_flags | MLFS_MAP_CACHE;

    set_map_table_entry(dev, kernfs_lblk, libfs_id, kernfs_map);
    set_map_table_entry(dev, libfs_lblk, libfs_id, libfs_map);
    free_map_table_entry(kernfs_map);
    free_map_table_entry(libfs_map);
    // debug
    kernfs_map = get_map_table_entry(dev, kernfs_lblk, libfs_id);
    libfs_map = get_map_table_entry(dev, libfs_lblk, libfs_id);
    printf("update_map_table: %ld | %ld | %ld | %ld | %ld | %ld\n", kernfs_lblk, kernfs_map->m_lblk, kernfs_map->m_pblk, libfs_lblk, libfs_map->m_lblk, libfs_map->m_pblk);
    
}
void unset_map_table_entry_cache_bit(uint8_t dev, addr_t lblk, int libfs_id) {
    struct mlfs_map_blocks* data = get_map_table_entry(dev, lblk, libfs_id);
    printf("unset_map_table_entry_cache_bit: %ld, %ld\n", ((data->m_flags & MLFS_MAP_UNCACHE) & data->m_flags), (data->m_flags & MLFS_MAP_CACHE) ^ MLFS_MAP_CACHE);
    data->m_flags = ((data->m_flags & MLFS_MAP_UNCACHE) & data->m_flags);
    set_map_table_entry(dev, lblk, libfs_id, data);
}

// TODO-assise: write
struct mlfs_map_blocks* get_map_table_entry(uint8_t dev, addr_t lblk, int libfs_id) {
    struct mlfs_map_blocks* data = NULL;
    data = malloc(sizeof(struct mlfs_map_blocks));
    uint32_t blkno;
    uint32_t offset_in_blk;
    get_blkno_and_offset(dev, libfs_id, lblk, &blkno, &offset_in_blk);
    get_map_entry_helper(dev, blkno, offset_in_blk, data);
    // map entry invalid
    if (((data->m_flags & MLFS_MAP_INIT)) == MLFS_MAP_UNINIT) {
        data->m_lblk = lblk;
        data->m_pblk = lblk;
        data->m_len = g_block_size_bytes;
        data->m_flags = data->m_flags | MLFS_MAP_INIT;
        set_map_entry_helper(dev, blkno, offset_in_blk, data);
    }
    return data;
}

void free_map_table_entry(struct mlfs_map_blocks* blk) {
    if(blk == NULL) return;
    free(blk);
}

void get_blkno_and_offset(uint8_t dev, int libfs_id, addr_t lblk, uint32_t *blkno, uint32_t* offset_in_blk) {
    uint32_t addr = disk_sb[dev].map_table_start * g_block_size_bytes 
                  + libfs_id * disk_sb[dev].nmapblocks * g_block_size_bytes 
                  + lblk * sizeof(struct mlfs_map_blocks);
    *blkno = (addr >> g_block_size_shift);
    *offset_in_blk = addr % g_block_size_bytes;
}

void get_map_entry_helper(uint8_t dev, uint32_t blkno, uint32_t offset_in_blk, struct mlfs_map_blocks* data) {
    struct buffer_head* bh;
    bh = bh_get_sync_IO(dev, blkno, BH_NO_DATA_ALLOC);
    bh->b_data = data;
    bh->b_size = sizeof(struct mlfs_map_blocks);
    bh->b_offset = offset_in_blk;
    bh_submit_read_sync_IO(bh);
    mlfs_io_wait(dev, 1);
    bh_release(bh);
}

void set_map_entry_helper(uint8_t dev, uint32_t blkno, uint32_t offset_in_blk, struct mlfs_map_blocks* data) {
    // printf("set_map_entry_helper: %ld|%ld\n", blkno, data->m_pblk);
    struct buffer_head* bh;
    bh = bh_get_sync_IO(dev, blkno, BH_NO_DATA_ALLOC);
    bh->b_data = data;
    bh->b_size = sizeof(struct mlfs_map_blocks);
    bh->b_offset = offset_in_blk;
    int ret = mlfs_write_opt(bh);
    mlfs_assert(!ret);
    mlfs_io_wait(dev, 0);
    bh_release(bh);
}

void set_map_table_entry(uint8_t dev, addr_t lblk, int libfs_id, struct mlfs_map_blocks* data) {
    uint32_t blkno;
    uint32_t offset_in_blk;
    get_blkno_and_offset(dev, libfs_id, lblk, &blkno, &offset_in_blk);
    set_map_entry_helper(dev, blkno, offset_in_blk, data);
}

addr_t lblk2pblk(uint8_t dev, addr_t lblk, int libfs_id) {
    struct mlfs_map_blocks* data = get_map_table_entry(dev, lblk, libfs_id);
    addr_t pblk = data->m_pblk; // cur mapping block
    // if(((data->m_flags) & MLFS_MAP_CACHE) == MLFS_MAP_CACHE) {
    //     pblk = data->m_lblk; // previous mapping block
    // }
    free_map_table_entry(data);
    return pblk;
}
int get_block_sum_pblk(uint8_t dev, addr_t pblk) {
    int sum = 0;
    uint8_t* addr = g_bdev[dev]->map_base_addr + (pblk << g_block_size_shift);
    for(int i = 0; i < g_block_size_bytes; i++) {
        sum += *(addr + i);
    }
    return sum;
}

int get_block_sum(uint8_t dev, struct mlfs_map_blocks* map_blk) {
    int sum = 0;
    uint8_t* addr = g_bdev[dev]->map_base_addr + (map_blk->m_pblk << g_block_size_shift);
    for(int i = 0; i < g_block_size_bytes; i++) {
        sum += *(addr + i);
    }
    return sum;
}

void print_map_table(uint8_t dev) {
    struct mlfs_map_blocks* map_blk;
    printf("----print map table------\n");
    for (size_t i = 0; i < disk_sb[dev].nmapentry; ++i) {
        map_blk = print_map_table_helper(dev, i, KERNFS_ID);
        if ( (map_blk->m_flags & MLFS_MAP_INIT) == MLFS_MAP_INIT ) {
            printf("%ld: %ld | %ld | blk sum: %d \n", i, map_blk->m_lblk, map_blk->m_pblk, get_block_sum(dev, map_blk));
        }
        free_map_table_entry(map_blk);
    }
}



struct mlfs_map_blocks* print_map_table_helper(uint8_t dev, addr_t lblk, int libfs_id) {
    struct mlfs_map_blocks* data = NULL;
    data = malloc(sizeof(struct mlfs_map_blocks));
    uint32_t blkno;
    uint32_t offset_in_blk;
    get_blkno_and_offset(dev, libfs_id, lblk, &blkno, &offset_in_blk);
    get_map_entry_helper(dev, blkno, offset_in_blk, data);
    return data;
}