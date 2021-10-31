# Assise E2-path

To run `digest_test.c`, in kernfs/tests:

```
sudo ./run.sh kernfs
```

In libfs/tests:

```
sudo ./run.sh digest_test
```

To run `digest_test.c` with gdb:

```
sudo gdb digest_test
```

Note we only have 4GB NVM in total. Therefore, all writes plus logs cannot be larger than 4GB. We can modify this file for future benchmarks.

## Libfs

### add to update log

When a userprocess calls `read/write`, etc. (e.g. libfs/tests/digest_test.c:92), Libfs would intercept these syscalls and call `mlfs_file_write`,`mlfs_file_read`,`dir_change_entry`,`dir_remove_entry`, `dir_add_entry`,`dir_add_links` (I believe these are all places that trigger log update.)

In libfs/src/filesystem/file.c:

```c
ssize_t mlfs_file_read(struct file *f, struct mlfs_reply *reply, size_t n);
int mlfs_file_write(struct file *f, uint8_t *buf, size_t n, offset_t offset)
```

In libfs/src/filesystem/dirent.c:

```c
struct mlfs_dirent *dir_add_links(struct inode *dir_inode, uint32_t inum, uint32_t parent_inum);
struct mlfs_dirent *dir_add_entry(struct inode *dir_inode, char *name, struct inode *ip);
struct mlfs_dirent *dir_add_entry(struct inode *dir_inode, char *name, struct inode *ip);
struct mlfs_dirent *dir_change_entry(struct inode *dir_inode, char *oldname, char *newname);
```

All of them calls `add_to_log`, which is defined in  libfs/src/filesystem/fs.c:

```c
int add_to_log(struct inode *ip, uint8_t *data, offset_t off, uint32_t size, uint8_t ltype);
```

In this function, I noticed following lines (**question**: how/where does loghdr_meta become persistent?):

```c
loghdr_meta = get_loghdr_meta(); // get header

nr_iovec = loghdr_meta->nr_iovec;
loghdr_meta->io_vec[nr_iovec].base = data; // save log data

add_to_loghdr(ltype, ip, off, size, NULL, 0); // add to header
```

- `get_loghdr_meta()` is defined in libfs/src/concurrency/thread.c:

```c
__thread struct logheader_meta tls_loghdr_meta;

struct logheader_meta *get_loghdr_meta(void)
{
	return &tls_loghdr_meta;
}
```

- This function also calls `add_to_loghdr`defined in libfs/src/log/log.c, so we don't need to worry about metadata information after calling it.

```c
/* FIXME: Use of parameter and name of that are very confusing.
 * data: 
 *	file_inode - offset in file
 *	dir_inode - parent inode number
 * length: 
 *	file_inode - file size 
 *	dir_inode - offset in directory
 */
void add_to_loghdr(uint8_t type, struct inode *inode, offset_t data, 
		uint32_t length, void *extra, uint16_t extra_len);
```

### digest log

To trigger log digestion, we want to use (e.g.,libfs/tests/digest_test.c:94-95) :

```c
make_digest_request_async(100);
wait_on_digesting();
```

From gdb, we know it goes through 4 functions:

In libfs/src/log/log.h:

```c
static inline void set_digesting(); 
static inline void clear_digesting();
```

In libfs/src/log/log.c:

```c
uint32_t make_digest_request_sync(int percent);
void signal_callback(struct app_context *msg); // calls handle_digest_response(msg->data) if local
void handle_digest_response(char *ack_cmd);
```

Some of the important lines in `make_digest_request_sync`:

```c
write_log_superblock((struct log_superblock *)g_log_sb); // line:1575
rpc_forward_msg(g_kernfs_peers[g_kernfs_id]->sockfd[SOCK_BG], cmd); // line:1620
mlfs_do_rdigest(g_fs_log->n_digest_req); // line:1622
```

`write_log_superblock` writes using `mlfs_write`, which is defined in libfs/src/io/block_io.c (**question**: which storage engine is this? can we avoid copying by changing storage engine?):

```c
int mlfs_write(struct buffer_head *b); // write to storage_engine = g_bdev[b->b_dev]->storage_engine
```

`rpc_forward_msg` is defined in libfs/src/distributed/rpc_interface.c:

```c
int rpc_forward_msg(int sockfd, char* data); // calls MP_SEND_MSG_ASYNC; 
```

`MP_SEND_MSG_ASYNC` is defined in libfs/lib/rdma/rpc.c. It sets `ctx->msg_send[buffer_id]->header.control.ready = 1` so that receiver will pull data sent:

```c
uint32_t MP_SEND_MSG_ASYNC(int sockfd, int buffer_id, int solicit); // ctx->ch_type == CH_TYPE_LOCAL;
```



## Communication btw Libfs & Kernfs

Here's the order how different functions are called. Note that there's one `signal_callback` in libfs/src/filesystem/fs.c and one in kernfs/src/fs.h. I'm not 100% sure which one is used, so these are my guesses.

1. **libfs/src/filesystem/fs.c:** 

**question**: what is this port?? (I know it's hardcoded)

```c
void init_fs(void);
	// mlfs_rpc_init();
static void mlfs_rpc_init(void);
	// char *port = getenv("PORTNO");
	// init_rpc(mrs, n_regions, port, signal_callback); --> I believe this is signal_callback in libfs/src/log/log.c ???
```

2. **libfs/src/distributed/rpc_interface.c:**

```c
int init_rpc(struct mr_context *regions, int n_regions, char *listen_port, signal_cb_fn signal_callback);
	// add_connection((char*)g_kernfs_peers[i]->ip, listen_port, SOCK_IO, pid, chan_type, always_poll);
	// add_connection((char*)g_kernfs_peers[i]->ip, listen_port, SOCK_BG, pid, chan_type, always_poll);
	// add_connection((char*)g_kernfs_peers[i]->ip, listen_port, SOCK_LS, pid, chan_type, always_poll);

```

I noticed the folloing lines from line 96-103:

```c
#ifdef KERNFS
	g_self_id = g_kernfs_id;
	init_rdma_agent(listen_port, regions, n_regions, RPC_MSG_BYTES, chan_type, add_peer_socket, remove_peer_socket,
			signal_callback);
#else
	init_rdma_agent(NULL, regions, n_regions, RPC_MSG_BYTES, chan_type, add_peer_socket, remove_peer_socket,
			signal_callback);
```

3. **libfs/lib/rdma/agent.c:**

```C
void init_rdma_agent(char *listen_port, struct mr_context *regions,
		int region_count, uint16_t buffer_size, int ch_type,
		app_conn_cb_fn app_connect,
		app_disc_cb_fn app_disconnect,
		app_recv_cb_fn app_receive);
	// if(ch_type == CH_TYPE_LOCAL || ch_type == CH_TYPE_ALL)
			// pthread_create(&comm_thread, NULL, local_server_loop, port);
int add_connection(char* ip, char *port, int app_type, pid_t pid, int ch_type, int polling_loop);
	// f(pthread_create(&ctx->cq_poller_thread, NULL, local_client_thread, arg) != 0)
			// mp_die("Failed to create client_thread");
```

4. **libfs/lib/rdma/shmeme_ch.c**:

```c
void * local_server_loop(void *port);
	// if(pthread_create(&ctx->cq_poller_thread, NULL, local_server_thread, sock_arg) != 0 )
			// mp_die("Failed to create thread");
void * local_server_thread(void *arg);
	// shmem_chan_setup(sockfd, send_addr, recv_addr);
	// shmem_poll_loop(sockfd);
void * local_client_thread(void *arg);
	// shmem_chan_setup(sockfd, send_addr, recv_addr);
	// shmem_poll_loop(sockfd);
void shmem_poll_loop(int sockfd);
```

## Kernfs

In kernfs/fs.c:

```c
void init_fs(void);
	// init_rpc(mrs, n_regions, port, signal_callback); --> this is kernfs signal_callback
void signal_callback(struct app_context *msg);
	// handle_digest_request(digest_arg);
static void handle_digest_request(void *arg);
	// digest_count = digest_logs(dev_id, log_id, digest_count, start_blkno, end_blkno, &digest_blkno, &rotated);
int digest_logs(uint8_t from_dev, int libfs_id, int n_hdrs, addr_t start_blkno, addr_t end_blkno, addr_t *loghdr_to_digest, int *rotated);
	// digest_replay_and_optimize(from_dev, loghdr_meta, &replay_list);
	// digest_each_log_entries(from_dev, libfs_id, loghdr_meta);
	// digest_log_from_replay_list(from_dev, libfs_id, &replay_list);
static void digest_each_log_entries(uint8_t from_dev, int libfs_id, loghdr_meta_t *loghdr_meta);
	// ret = digest_file(from_dev, dest_dev, libfs_id, loghdr->inode_no[i], loghdr->data[i], loghdr->length[i], loghdr->blocks[i] + loghdr_meta->hdr_blkno);
int digest_file(uint8_t from_dev, uint8_t to_dev, int libfs_id, uint32_t file_inum, offset_t offset, uint32_t length, addr_t blknr);
```



## Misc

In libfs/filesystem/fs.c:

```c
static void cache_init(void); 
```

