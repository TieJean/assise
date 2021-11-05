dev-dax engine is initialized: dev_path /dev/dax0.0 size 4096 MB
fetching node's IP address..
Process pid is 127119
ip address on interface 'lo' is 127.0.0.1
cluster settings:
--- node 0 - ip:127.0.0.1
Connecting to KernFS instance 0 [ip: 127.0.0.1]
[Local-Client] Creating connection (pid:127119, app_type:0, status:pending) to 127.0.0.1:12345 on sockfd 0
In thread
In thread
[Local-Client] Creating connection (pid:127119, app_type:1, status:pending) to 127.0.0.1:12345 on sockfd 1
In thread
[Local-Client] Creating connection (pid:127119, app_type:2, status:pending) to 127.0.0.1:12345 on sockfd 2
SEND --> MSG_INIT [pid 0|127119]
RECV <-- MSG_SHM [paths: /shm_recv_0|/shm_send_0]
SEND --> MSG_INIT [pid 1|127119]
[add_peer_socket():97] Established connection with 127.0.0.1 on sock:0 of type:0 and peer:0x555555559f90
start shmem_poll_loop for sockfd 0
RECV <-- MSG_SHM [paths: /shm_recv_1|/shm_send_1]
[add_peer_socket():97] Established connection with 127.0.0.1 on sock:1 of type:1 and peer:0x555555559f90
start shmem_poll_loop for sockfd 1
SEND --> MSG_INIT [pid 2|127119]
RECV <-- MSG_SHM [paths: /shm_recv_2|/shm_send_2]
[add_peer_socket():97] Established connection with 127.0.0.1 on sock:2 of type:2 and peer:0x555555559f90
start shmem_poll_loop for sockfd 2
[signal_callback():1373] Assigned LibFS ID=1
MLFS cluster initialized
init log dev 1 start_blk 916481 end 949248
--- Write initial data 
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4|916481|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4|916490|0|0|
[handle_digest_response():1653] |complete |1|1|4|916490|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|916490|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|926322|0|0|
[handle_digest_response():1653] |complete |1|1|4916|926322|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|926322|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|936154|0|0|
[handle_digest_response():1653] |complete |1|1|4916|936154|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|936154|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|945986|0|0|
[handle_digest_response():1653] |complete |1|1|4916|945986|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|945986|916481|949247
[signal_callback():1432] peer recv: |complete |1|1|4915|923049|1|0|
[handle_digest_response():1653] |complete |1|1|4915|923049|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 933167 new end 949247 start_version 1 avail_version 1
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5059|923049|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5059|933167|0|0|
[handle_digest_response():1653] |complete |1|1|5059|933167|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|8048|933167|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|8048|916497|1|0|
[handle_digest_response():1653] |complete |1|1|8048|916497|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 926615 new end 949246 start_version 2 avail_version 2
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5059|916497|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5059|926615|0|0|
[handle_digest_response():1653] |complete |1|1|5059|926615|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5565|926615|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5565|937745|0|0|
[handle_digest_response():1653] |complete |1|1|5565|937745|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|7542|937745|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|7542|920063|1|0|
[handle_digest_response():1653] |complete |1|1|7542|920063|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 931193 new end 949246 start_version 3 avail_version 3
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5565|920063|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5565|931193|0|0|
[handle_digest_response():1653] |complete |1|1|5565|931193|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|931193|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|941025|0|0|
[handle_digest_response():1653] |complete |1|1|4916|941025|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|8191|941025|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|8191|924641|1|0|
[handle_digest_response():1653] |complete |1|1|8191|924641|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 925753 new end 949246 start_version 4 avail_version 4
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|924641|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|934473|0|0|
[handle_digest_response():1653] |complete |1|1|4916|934473|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|934473|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|944305|0|0|
[handle_digest_response():1653] |complete |1|1|4916|944305|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|8191|944305|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|8191|927921|1|0|
[handle_digest_response():1653] |complete |1|1|8191|927921|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 937753 new end 949246 start_version 5 avail_version 5
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|927921|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|937753|0|0|
[handle_digest_response():1653] |complete |1|1|4916|937753|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|937753|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|947585|0|0|
[handle_digest_response():1653] |complete |1|1|4916|947585|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|947585|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|924649|1|0|
[handle_digest_response():1653] |complete |1|1|4915|924649|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 930829 new end 949246 start_version 6 avail_version 6
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|924649|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|934481|0|0|
[handle_digest_response():1653] |complete |1|1|4916|934481|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|934481|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|944313|0|0|
[handle_digest_response():1653] |complete |1|1|4916|944313|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|944313|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|921377|1|0|
[handle_digest_response():1653] |complete |1|1|4915|921377|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 929649 new end 949246 start_version 7 avail_version 7
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|921377|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|931209|0|0|
[handle_digest_response():1653] |complete |1|1|4916|931209|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|931209|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|941041|0|0|
[handle_digest_response():1653] |complete |1|1|4916|941041|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|941041|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|918105|1|0|
[handle_digest_response():1653] |complete |1|1|4915|918105|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 920327 new end 949246 start_version 8 avail_version 8
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|918105|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|927937|0|0|
[handle_digest_response():1653] |complete |1|1|4916|927937|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|927937|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|937769|0|0|
[handle_digest_response():1653] |complete |1|1|4916|937769|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|6291|937769|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|6291|917585|1|0|
[handle_digest_response():1653] |complete |1|1|6291|917585|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 928165 new end 949246 start_version 9 avail_version 9
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5290|917585|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5290|928165|0|0|
[handle_digest_response():1653] |complete |1|1|5290|928165|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|928165|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|937997|0|0|
[handle_digest_response():1653] |complete |1|1|4916|937997|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|6994|937997|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|6994|919219|1|0|
[handle_digest_response():1653] |complete |1|1|6994|919219|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 927195 new end 949246 start_version 10 avail_version 10
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|919219|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|929051|0|0|
[handle_digest_response():1653] |complete |1|1|4916|929051|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|929051|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|938883|0|0|
[handle_digest_response():1653] |complete |1|1|4916|938883|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|8191|938883|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|8191|922499|1|0|
[handle_digest_response():1653] |complete |1|1|8191|922499|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 932331 new end 949246 start_version 11 avail_version 11
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|922499|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|932331|0|0|
[handle_digest_response():1653] |complete |1|1|4916|932331|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|7563|932331|916481|0
[signal_callback():1432] peer recv: |complete |1|1|7563|947457|0|0|
[handle_digest_response():1653] |complete |1|1|7563|947457|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5544|947457|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|5544|925779|1|0|
[handle_digest_response():1653] |complete |1|1|5544|925779|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 929431 new end 949246 start_version 12 avail_version 12
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|925779|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|935611|0|0|
[handle_digest_response():1653] |complete |1|1|4916|935611|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|935611|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|945443|0|0|
[handle_digest_response():1653] |complete |1|1|4916|945443|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|945443|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|922507|1|0|
[handle_digest_response():1653] |complete |1|1|4915|922507|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 922507 new end 949246 start_version 13 avail_version 13
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|922507|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|932339|0|0|
[handle_digest_response():1653] |complete |1|1|4916|932339|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|932339|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|942171|0|0|
[handle_digest_response():1653] |complete |1|1|4916|942171|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|942171|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|919235|1|0|
[handle_digest_response():1653] |complete |1|1|4915|919235|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 921107 new end 949246 start_version 14 avail_version 14
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|919235|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|929067|0|0|
[handle_digest_response():1653] |complete |1|1|4916|929067|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|929067|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|938899|0|0|
[handle_digest_response():1653] |complete |1|1|4916|938899|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|938899|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|948731|0|0|
[handle_digest_response():1653] |complete |1|1|4916|948731|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|948731|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|925795|1|0|
[handle_digest_response():1653] |complete |1|1|4915|925795|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 934209 new end 949246 start_version 15 avail_version 15
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|925795|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|935627|0|0|
[handle_digest_response():1653] |complete |1|1|4916|935627|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|935627|916481|0
--- verify large buffer (after digest)
verifying buffer.. [32mOK
[0m--- Update data partially
[signal_callback():1432] peer recv: |complete |1|1|4916|945459|0|0|
[handle_digest_response():1653] |complete |1|1|4916|945459|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|945459|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|922523|1|0|
[handle_digest_response():1653] |complete |1|1|4915|922523|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 932439 new end 949246 start_version 16 avail_version 16
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4962|922523|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4962|932447|0|0|
[handle_digest_response():1653] |complete |1|1|4962|932447|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|932447|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|942279|0|0|
[handle_digest_response():1653] |complete |1|1|4916|942279|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5040|942279|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|5040|919593|1|0|
[handle_digest_response():1653] |complete |1|1|5040|919593|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 920209 new end 949246 start_version 17 avail_version 17
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|919593|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|929425|0|0|
[handle_digest_response():1653] |complete |1|1|4916|929425|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|9912|929425|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|9912|916483|1|0|
[handle_digest_response():1653] |complete |1|1|9912|916483|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 922873 new end 949246 start_version 18 avail_version 18
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|916483|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|926315|0|0|
[handle_digest_response():1653] |complete |1|1|4916|926315|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|8131|926315|916481|0
[signal_callback():1432] peer recv: |complete |1|1|8131|942577|0|0|
[handle_digest_response():1653] |complete |1|1|8131|942577|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4976|942577|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4976|919763|1|0|
[handle_digest_response():1653] |complete |1|1|4976|919763|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 936025 new end 949246 start_version 19 avail_version 19
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|8131|919763|916481|0
[signal_callback():1432] peer recv: |complete |1|1|8131|936025|0|0|
[handle_digest_response():1653] |complete |1|1|8131|936025|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|6612|936025|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|6612|916483|1|0|
[handle_digest_response():1653] |complete |1|1|6612|916483|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 929473 new end 949246 start_version 20 avail_version 20
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|6495|916483|916481|0
[signal_callback():1432] peer recv: |complete |1|1|6495|929473|0|0|
[handle_digest_response():1653] |complete |1|1|6495|929473|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|9888|929473|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|9888|916483|1|0|
[handle_digest_response():1653] |complete |1|1|9888|916483|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 922921 new end 949246 start_version 21 avail_version 21
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|916483|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|926315|0|0|
[handle_digest_response():1653] |complete |1|1|4916|926315|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|8193|926315|916481|0
[signal_callback():1432] peer recv: |complete |1|1|8193|942701|0|0|
[handle_digest_response():1653] |complete |1|1|8193|942701|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|942701|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|919765|1|0|
[handle_digest_response():1653] |complete |1|1|4915|919765|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 936149 new end 949246 start_version 22 avail_version 22
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|8192|919765|916481|0
[signal_callback():1432] peer recv: |complete |1|1|8192|936149|0|0|
[handle_digest_response():1653] |complete |1|1|8192|936149|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5663|936149|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5663|947475|0|0|
[handle_digest_response():1653] |complete |1|1|5663|947475|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|7444|947475|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|7444|929597|1|0|
[handle_digest_response():1653] |complete |1|1|7444|929597|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 940923 new end 949246 start_version 23 avail_version 23
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5663|929597|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5663|940923|0|0|
[handle_digest_response():1653] |complete |1|1|5663|940923|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|940923|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|917987|1|0|
[handle_digest_response():1653] |complete |1|1|4915|917987|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 928645 new end 949246 start_version 24 avail_version 24
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5329|917987|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5329|928645|0|0|
[handle_digest_response():1653] |complete |1|1|5329|928645|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5467|928645|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5467|939579|0|0|
[handle_digest_response():1653] |complete |1|1|5467|939579|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|939579|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|916643|1|0|
[handle_digest_response():1653] |complete |1|1|4915|916643|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 926975 new end 949246 start_version 25 avail_version 25
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5174|916643|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5174|926991|0|0|
[handle_digest_response():1653] |complete |1|1|5174|926991|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|926991|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|936823|0|0|
[handle_digest_response():1653] |complete |1|1|4916|936823|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5039|936823|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5039|946901|0|0|
[handle_digest_response():1653] |complete |1|1|5039|946901|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|946901|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|923965|1|0|
[handle_digest_response():1653] |complete |1|1|4915|923965|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 933629 new end 949246 start_version 26 avail_version 26
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|923965|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|933797|0|0|
[handle_digest_response():1653] |complete |1|1|4916|933797|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5370|933797|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5370|944537|0|0|
[handle_digest_response():1653] |complete |1|1|5370|944537|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4915|944537|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|4915|921601|1|0|
[handle_digest_response():1653] |complete |1|1|4915|921601|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 931397 new end 949246 start_version 27 avail_version 27
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|921601|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|931433|0|0|
[handle_digest_response():1653] |complete |1|1|4916|931433|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|931433|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|941265|0|0|
[handle_digest_response():1653] |complete |1|1|4916|941265|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5378|941265|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|5378|919255|1|0|
[handle_digest_response():1653] |complete |1|1|5378|919255|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 930217 new end 949246 start_version 28 avail_version 28
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5485|919255|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5485|930225|0|0|
[handle_digest_response():1653] |complete |1|1|5485|930225|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|9512|930225|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|9512|916483|1|0|
[handle_digest_response():1653] |complete |1|1|9512|916483|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 923673 new end 949246 start_version 29 avail_version 29
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|916483|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|926315|0|0|
[handle_digest_response():1653] |complete |1|1|4916|926315|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5570|926315|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5570|937455|0|0|
[handle_digest_response():1653] |complete |1|1|5570|937455|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|7537|937455|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|7537|919763|1|0|
[handle_digest_response():1653] |complete |1|1|7537|919763|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 930903 new end 949246 start_version 30 avail_version 30
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|5570|919763|916481|0
[signal_callback():1432] peer recv: |complete |1|1|5570|930903|0|0|
[handle_digest_response():1653] |complete |1|1|5570|930903|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|9173|930903|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|9173|916483|1|0|
[handle_digest_response():1653] |complete |1|1|9173|916483|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 924351 new end 949246 start_version 31 avail_version 31
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|4916|916483|916481|0
[signal_callback():1432] peer recv: |complete |1|1|4916|926315|0|0|
[handle_digest_response():1653] |complete |1|1|4916|926315|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|10268|926315|916481|0
--- verify updated buffer (after digest)
verifying buffer.. [32mOK
[0m[signal_callback():1432] peer recv: |complete |1|1|10268|946851|0|0|
[handle_digest_response():1653] |complete |1|1|10268|946851|0|0|
[clear_digesting():108] clear log digesting state
[set_digesting():94] set log digesting state
[make_digest_request_sync():1618] |digest |1|1|1235|946851|916481|949246
[signal_callback():1432] peer recv: |complete |1|1|1235|916555|1|0|
[handle_digest_response():1653] |complete |1|1|1235|916555|1|0|
[handle_digest_response():1671] -- log head is rotated: new start 916555 new end 949246 start_version 32 avail_version 32
[clear_digesting():108] clear log digesting state
