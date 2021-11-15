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


    if(kernfs_map->m_flags == MLFS_MAP_VALID) {
        libfs_map->m_pblk = kernfs_pblk;
    } else {
        libfs_map->m_pblk = kernfs_lblk;
    }

    if(libfs_map->m_flags == MLFS_MAP_VALID) {
        kernfs_map->m_pblk = libfs_pblk;
    } else {
        kernfs_map->m_pblk = libfs_lblk;
    }
    // update_map_table_entry
    kernfs_map->m_flags = MLFS_MAP_VALID;
    libfs_map->m_flags = MLFS_MAP_VALID;
    set_map_table_entry(dev, kernfs_lblk, libfs_id, kernfs_map);
    set_map_table_entry(dev, libfs_lblk, libfs_id, libfs_map);
    
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
    if ((data->m_flags & MLFS_MAP_VALID) != MLFS_MAP_VALID) {
        data->m_lblk = lblk;
        data->m_pblk = lblk;
        data->m_len = g_block_size_bytes;
        data->m_flags = MLFS_MAP_VALID;
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
    addr_t pblk = data->m_pblk;
    free_map_table_entry(data);
    return pblk;
}

void print_map_table(uint8_t dev) {
    read_map_table(dev);
    printf("----print map table------\n");
    for (size_t i = 0; i < disk_sb[dev].nmapentry; ++i) {
        if (map_tables[KERNFS_ID][i].m_flags & MLFS_MAP_VALID != MLFS_MAP_VALID) {
            printf("%ld: %ld | %ld\n", i, map_tables[KERNFS_ID][i].m_lblk, map_tables[KERNFS_ID][i].m_pblk);
        }
    }
}