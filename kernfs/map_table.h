#ifndef _MAP_TABLE_H
#define _MAP_TABLE_H

#define KERNFS_ID 0

#include "extents.h"
#include "global/global.h"
#include "storage/storage.h"
// g_libfs_num + 1

extern struct mlfs_map_blocks** map_tables;  // = malloc(sizeof(struct mlfs_map_blocks) * (1 << (dev_size[dev]>> g_block_size_bytes))));
extern size_t map_table_size; // size of 1 map_table

void map_table_init(uint8_t dev);
void read_map_table(uint8_t dev);
void write_map_table(uint8_t dev);
void update_map_table(uint8_t dev, addr_t kernfs_lblk, addr_t libfs_lblk, int libfs_id);
struct mlfs_map_blocks* get_map_table_entry(uint8_t dev, addr_t lblk, int libfs_id);
void set_map_table_entry(uint8_t dev, addr_t lblk, int libfs_id, struct mlfs_map_blocks* data);
void map_table_shutdown(uint8_t dev);
addr_t lblk2pblk(uint8_t dev, addr_t lblk, int libfs_id);
int get_block_sum(uint8_t dev, struct mlfs_map_blocks* map_blk);
int get_block_sum_pblk(uint8_t dev, addr_t pblk);
void print_map_table(uint8_t dev);


#endif